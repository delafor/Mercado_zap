# Arquitetura do Backend

Mergulho em como o backend funciona depois da reescrita. Para subir o projeto e
ver os comandos, veja o [README](./README.md).

---

## 1. Visão geral

O backend é um serviço HTTP que faz a ponte entre o app Flutter e a
[AbacatePay](https://abacatepay.com). Responsabilidades:

1. **Criar cobranças PIX** e persistir cada uma.
2. **Expor o status** de um pagamento para o app consultar.
3. **Receber webhooks** da AbacatePay e atualizar o status de forma assíncrona.

Ele é **stateful** (guarda os pagamentos no PostgreSQL) e usa **Redis + BullMQ**
para processar os webhooks fora do ciclo da requisição.

---

## 2. Camadas

O código em `src/` segue uma separação por responsabilidade. Cada requisição
atravessa as camadas de cima para baixo:

```
HTTP
 │
 ▼
routes/         ── define os caminhos e liga ao controller
 │
 ▼
controller/     ── lê/valida a requisição, monta a resposta HTTP
 │
 ▼
service/        ── regra de negócio (orquestra provider + persistência)
 │
 ├──► lib/abacatepay  ── chamadas à API da AbacatePay (axios + timeout)
 │
 ▼
repository/     ── acesso ao banco (queries com Drizzle)
 │
 ▼
db/             ── conexão (pool) e schema
```

Suporte transversal:

| Pasta                          | Papel                                                          |
| ------------------------------ | -------------------------------------------------------------- |
| `config/env.ts`                | Valida as variáveis de ambiente com Zod no boot (falha rápido) |
| `lib/logger.ts`                | Logger estruturado (Pino)                                      |
| `lib/errors.ts`                | `AppError` e o wrapper `asyncHandler`                          |
| `middlewares/error-handler.ts` | Converte exceções em respostas HTTP                            |
| `queues/`                      | Conexão Redis, fila e worker do BullMQ                         |
| `docs/openapi.ts`              | Especificação OpenAPI servida em `/docs`                       |

**Por que separar assim:** cada camada tem um motivo único para mudar. O
controller não sabe SQL, o service não sabe de HTTP, o repository não sabe de
regra de negócio. Isso deixa o código testável (dá para testar o service com o
repository mockado) e fácil de evoluir.

---

## 3. Ciclo de uma requisição

A `app.ts` monta a pipeline do Express nesta ordem:

```
/docs e /openapi.json     ← documentação (antes do helmet p/ não bater no CSP)
helmet()                  ← headers de segurança
cors()                    ← libera o app a chamar a API
pino-http                 ← loga cada requisição/resposta
express.json()            ← faz parse do corpo JSON
/health                   ← healthcheck
/payments  (rate limit)   ← rotas de pagamento, limitadas a 100 req/min
/webhooks                 ← rotas de webhook (sem rate limit)
errorHandler              ← SEMPRE por último; traduz erros em respostas
```

A ordem importa: o `errorHandler` precisa ser o último `app.use`, e o
`express.json()` precisa vir antes das rotas que leem o corpo.

---

## 4. Fluxo: criar um pagamento PIX

```
App ──POST /payments/pix {items}──► controller
                                        │ valida productId + quantity (Zod)
                                        ▼
                                     service.createCheckout
                                        │ busca preços no catálogo do servidor
                                        │ calcula total em centavos
                                        │ grava order + order_items
                                        ├──► AbacatePay: cria o QR Code PIX
                                        │       (retorna id do provedor + brCode)
                                        ▼
                                     repository.insertPayment ligado ao pedido
                                        │
                                        ▼
App ◄────── 201 { id, amountCents, brCode, status: PENDING, ... } ──────────
```

Pontos-chave:

- **Preço é decisão do servidor**: o app envia somente `productId` e
  `quantity`. O backend busca o catálogo, calcula tudo em centavos inteiros e
  rejeita campos extras como `price`.
- **`id` interno vs `providerId`**: cada pagamento tem um `id` UUID nosso (usado
  na URL `/payments/:id`) e um `providerId` (o id da AbacatePay), usado apenas
  internamente para cruzar o webhook depois.
- O pagamento nasce **`PENDING`**. Quem confirma é o fluxo de webhook.

---

## 5. Fluxo: confirmação via webhook (assíncrono)

Quando o cliente paga, a AbacatePay chama nosso webhook. Em vez de processar na
hora, **respondemos rápido e jogamos o trabalho numa fila**:

```
AbacatePay ──POST /webhooks/abacatepay?webhookSecret=...──► webhook.controller
                                                              │ 1. confere o secret (senão 401)
                                                              │ 2. extrai o providerId do corpo
                                                              │ 3. enfileira um job
                                                              ▼
AbacatePay ◄──────────── 202 { received: true } ─────────  (resposta imediata)

                          BullMQ / Redis  (fila "payment-webhook")
                                       │
                                       ▼
                          payment-webhook.worker
                                       │ reconcilePaymentStatus(providerId)
                                       ├──► AbacatePay: confere o status REAL
                                       ▼
                          repository.updatePaymentStatus → PAID / EXPIRED / ...
```

Por que esse desenho:

- **Responder em 202 e enfileirar**: webhooks devem ser respondidos rápido. Se
  travássemos para processar tudo na hora, a AbacatePay poderia dar timeout e
  reenviar. A fila desacopla o "recebi" do "processei".
- **Não confiamos no corpo do webhook**: o worker chama a AbacatePay de volta
  (`getPixStatus`) para confirmar o status real antes de gravar. Isso protege
  contra payloads forjados ou desatualizados.
- **Resiliência**: se o processamento falhar (ex.: AbacatePay fora do ar), o
  BullMQ **reprocessa com backoff exponencial** — 5 tentativas, começando em 2s.
  Configurado em `queues/payment-webhook.queue.ts`.
- **Idempotência**: `reconcilePaymentStatus` só faz um `UPDATE ... WHERE
provider_id = ?`. Reprocessar o mesmo job leva ao mesmo estado final, sem
  efeito colateral.

> O worker hoje roda **no mesmo processo** do servidor (`server.ts` chama
> `startPaymentWebhookWorker()`). Para escalar, ele pode virar um processo
> separado consumindo a mesma fila, sem mudar a lógica.

---

## 6. Modelo de dados

Tabelas principais (ver `db/schema.ts`):

- `products`: catálogo do servidor, com `price_cents` em centavos.
- `orders`: snapshot do checkout e `total_cents`.
- `order_items`: itens comprados, quantidade, preço unitário e total da linha em
  centavos no momento da compra.

Tabela `payments`:

| Coluna                      | Tipo         | Observação                                              |
| --------------------------- | ------------ | ------------------------------------------------------- |
| `id`                        | uuid (PK)    | id interno, gerado pelo banco                           |
| `order_id`                  | uuid (único) | pedido associado                                        |
| `provider_id`               | text (único) | id da cobrança na AbacatePay                            |
| `amount_cents`              | bigint       | valor em **centavos**                                   |
| `status`                    | enum         | `PENDING` · `PAID` · `EXPIRED` · `CANCELLED` · `FAILED` |
| `br_code`                   | text         | código PIX copia-e-cola                                 |
| `created_at` / `updated_at` | timestamptz  | preenchidos automaticamente                             |

O status começa em `PENDING` e transita conforme o que a AbacatePay reporta. O
mapeamento provedor → nosso enum fica em `payment.service.ts`
(`PROVIDER_STATUS_MAP`); status desconhecidos caem em `PENDING`.

As **migrations** são versionadas em `drizzle/` (geradas com `npm run
db:generate`, aplicadas com `npm run db:migrate`). O schema TypeScript é a fonte
da verdade.

---

## 7. Configuração e segredos

`config/env.ts` valida **todas** as variáveis no boot com Zod. Se faltar alguma
(ex.: `DATABASE_URL`), o processo **não sobe** — falha cedo e com mensagem clara,
em vez de quebrar no meio de uma requisição.

Variáveis (ver `.env.example`): `NODE_ENV`, `PORT`, `LOG_LEVEL`, `DATABASE_URL`,
`REDIS_URL`, `ABACATEPAY_KEY`, `ABACATEPAY_WEBHOOK_SECRET`.

O `.env` nunca é commitado. Em produção, as variáveis vêm do ambiente
(painel do servidor), não de arquivo.

---

## 8. Tratamento de erros

Toda exceção cai no `error-handler.ts`, que traduz por tipo:

| Origem                     | Resposta                                                   |
| -------------------------- | ---------------------------------------------------------- |
| `ZodError` (validação)     | `400` com os campos inválidos                              |
| `AppError` (erro esperado) | o `statusCode` dele (`404`, `401`, `502`...)               |
| Qualquer outra             | `500` genérico (o erro real é logado, não vaza ao cliente) |

Falhas na chamada à AbacatePay são convertidas em `AppError(502)` dentro de
`lib/abacatepay.ts` (com log do motivo real). Assim, "provedor fora do ar" vira
um **502 "Payment provider unavailable"** claro, e não um 500 genérico.

Os controllers usam `asyncHandler`, que captura promises rejeitadas e as
encaminha ao error handler (o Express 4 não faz isso sozinho).

---

## 9. Segurança

- **Helmet**: headers de segurança padrão.
- **Rate limit**: 100 req/min nas rotas `/payments` (webhooks ficam de fora para
  não bloquear o provedor).
- **Webhook com secret compartilhado**: o handler exige o `webhookSecret` que a
  AbacatePay envia; sem ele, `401`.
- **Segredos** só via ambiente, validados no boot.
- **Erros não vazam internals**: o cliente recebe mensagens genéricas; o detalhe
  fica no log.

---

## 10. Observabilidade

Logs estruturados com **Pino**. Em desenvolvimento saem formatados e coloridos
(`pino-pretty`); em produção, como JSON (fácil de ingerir por ferramentas). O
`pino-http` loga cada requisição com método, rota, status e tempo de resposta.

---

## 11. Como rodar (resumo)

```bash
docker compose up -d            # Postgres + Redis
npm run db:migrate              # aplica as migrations
npm run dev                     # API + worker, com hot reload
```

Detalhes e o modo containerizado completo (`--profile full`) estão no
[README](./README.md).

---

## 12. Testes

- **Unitários** (`npm test`): validação (Zod), service (com provider e
  repository mockados), rotas (Supertest com o service mockado) e a tradução de
  erro do cliente AbacatePay. Não precisam de banco nem Redis.
- **Integração** (`npm run test:integration`): rodam migrations e exercitam o
  repository e a rota `GET /payments/:id` contra um **PostgreSQL real**
  (docker-compose). Configuração isolada em `vitest.integration.config.ts`.

O CI (GitHub Actions) roda os dois, subindo Postgres e Redis como service
containers.

---

## 13. Decisões e próximos passos

**Escolhas:** TypeScript (tipagem), Drizzle (migrations versionadas e queries
type-safe sem ORM pesado), BullMQ/Redis (padrão de mercado para jobs com retry),
Zod (validação que casa com os tipos), Pino (logs rápidos e estruturados).

**Pontos de evolução:**

- Extrair o worker para um processo próprio quando o volume justificar.
- Validar a **assinatura** real do webhook da AbacatePay (HMAC), além do secret.
- Guardar um registro de idempotência dos webhooks recebidos (auditoria).
- Endpoint de listagem/admin de pagamentos, se necessário.

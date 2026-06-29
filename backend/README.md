# Mercado Zap — Backend

Backend de pagamentos do Mercado Zap. Cria cobranças PIX via
[AbacatePay](https://abacatepay.com), persiste cada pagamento e reconcilia o
status de forma assíncrona quando o provedor envia um webhook.

## Stack

- **TypeScript** + **Express**
- **PostgreSQL** com **Drizzle ORM** (migrations versionadas)
- **Redis** + **BullMQ** (fila para processar webhooks)
- **Zod** (validação) · **Pino** (logs) · **Helmet** + **rate-limit** (segurança)
- **Vitest** + **Supertest** (testes)

## Arquitetura

```
HTTP  ──> POST /payments/pix ──> cria cobrança na AbacatePay ──> salva (PENDING) no Postgres
                                                                        │
AbacatePay ──> POST /webhooks/abacatepay ──> enfileira job ──> BullMQ/Redis
                                                                        │
                                              worker ──> confere status real na AbacatePay
                                                     └──> atualiza o pagamento no Postgres
```

O webhook responde rápido (`202`) e só enfileira o job; o worker é quem confirma
o status (nunca confiando cegamente no corpo do webhook) e persiste. Falhas são
reprocessadas pelo BullMQ com retry/backoff.

Estrutura em camadas (`src/`):

| Pasta | Responsabilidade |
|-------|------------------|
| `config/` | Validação do ambiente (Zod), falha rápido se faltar variável |
| `db/` | Conexão, schema e migrations (Drizzle) |
| `lib/` | Cliente AbacatePay, logger, erros |
| `queues/` | Conexão Redis, fila e worker do BullMQ |
| `modules/<área>/` | `routes` → `controller` → `service` → `repository` |
| `middlewares/` | Tratamento de erro centralizado |

## Rodando localmente

Pré-requisitos: Node 20+ e Docker.

```bash
cd backend
npm install
cp .env.example .env          # preencha ABACATEPAY_KEY e ABACATEPAY_WEBHOOK_SECRET

docker compose up -d          # sobe Postgres + Redis
npm run db:migrate            # aplica as migrations
npm run dev                   # backend com hot reload
```

Para subir tudo containerizado (API + migrations + infra):

```bash
docker compose --profile full up -d --build
```

## Scripts

| Script | O que faz |
|--------|-----------|
| `npm run dev` | Backend em modo desenvolvimento (hot reload, logs bonitos) |
| `npm run build` | Compila TypeScript para `dist/` |
| `npm start` | Roda o build de produção (`dist/server.js`) |
| `npm run typecheck` | Checagem de tipos sem emitir |
| `npm test` | Testes (Vitest) |
| `npm run lint` / `npm run format` | ESLint / Prettier |
| `npm run db:generate` | Gera uma nova migration a partir do schema |
| `npm run db:migrate` | Aplica as migrations no banco |

## API

Documentação interativa (Swagger UI) em **`/docs`**; spec crua em `/openapi.json`.

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/health` | Healthcheck |
| `GET` | `/docs` | Swagger UI |
| `POST` | `/payments/pix` | Cria uma cobrança PIX. Body: `{ "amount": number }` (em reais) |
| `GET` | `/payments/:id` | Consulta um pagamento e seu status |
| `POST` | `/webhooks/abacatepay?webhookSecret=...` | Recebe a notificação da AbacatePay |

## Variáveis de ambiente

Veja [`.env.example`](./.env.example). Todas são validadas no boot — se faltar
alguma, o servidor não sobe.

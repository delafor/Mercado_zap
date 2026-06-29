# Guia de Contribuição e Boas Práticas

Este documento descreve como trabalhar neste projeto sem que um desenvolvedor
atrapalhe o outro. Vale para quem tem acesso direto ao repositório **e** para
quem contribui via fork.

---

## 1. Rodando o projeto

O projeto tem duas partes: o app **Flutter** (na raiz) e o **backend** Node/Express (`backend/`).

### Backend (`backend/`)

```bash
cd backend
npm install
cp .env.example .env      # preencha ABACATEPAY_KEY com a sua chave

npm run dev               # desenvolvimento: reinicia sozinho a cada alteração
npm start                 # produção: roda uma vez, sem watch
```

- O `.env` **nunca** é commitado (está no `.gitignore`). Cada dev/ambiente tem o seu.
- Em produção, as variáveis de ambiente (`ABACATEPAY_KEY`, `PORT`) são configuradas
  no painel do servidor (ex.: Render), não em arquivo no repositório.

### App Flutter (raiz)

A versão do Flutter é fixada via **FVM** no arquivo `.fvmrc` (`3.29.3`). Use o
prefixo `fvm` para garantir que todos usam a mesma versão:

```bash
fvm install               # instala a versão fixada no .fvmrc
fvm flutter pub get       # baixa as dependências

# Desenvolvimento (hot reload):
fvm flutter run                 # em um device/emulador conectado
fvm flutter run -d chrome       # no navegador

# Build de produção:
fvm flutter build apk --release       # Android
fvm flutter build web --release       # Web
```

- **Dev x Produção do app:** durante o desenvolvimento, ao apontar para o backend,
  use o backend local (ex.: `http://10.0.2.2:3000` no emulador Android) em vez do
  servidor de produção. A URL fica em `lib/services/payment_service.dart`.
- Nunca suba chaves ou URLs sensíveis hardcoded no código do app.

---

## 2. Versionamento (Git)

### O que NÃO entra no Git

Já está no `.gitignore`, mas é bom entender o porquê:

- `node_modules/`, `build/`, `.dart_tool/` → são **gerados**. Quem clonar roda
  `npm install` / `pub get` e recria. Versionar isso incha o repositório (foram
  ~6 mil arquivos removidos neste projeto) e gera conflitos absurdos.
- `.env` e qualquer arquivo com **segredo/chave** → nunca commite.
- `.vscode/`, `.idea/`, `.fvm/` → configuração local da sua máquina.

> ⚠️ **Segredo que vazou continua no histórico.** Se uma chave for commitada por
> engano, removê-la do tracking **não** a apaga do histórico — quem clonar o repo
> ainda a vê. A chave precisa ser **rotacionada** (trocada) no provedor. Limpar o
> histórico (`git filter-repo`) reescreve commits e só deve ser feito em acordo
> com todo o time.

### Commits

- **Pequenos e atômicos:** um commit = uma mudança lógica. Evite o commit gigante
  "várias coisas".
- **Mensagem clara**, de preferência no padrão [Conventional Commits](https://www.conventionalcommits.org/):
  - `feat:` nova funcionalidade · `fix:` correção · `refactor:` reorganização sem
    mudar comportamento · `chore:` infra/configuração · `docs:` documentação.
  - Exemplo: `feat(cart): persiste o carrinho no Hive ao fechar o app`.
- Não commite código comentado/morto ou `print`/`console.log` de depuração.

---

## 3. Branches

**Regra de ouro: ninguém trabalha direto na `main`.** A `main` é sempre estável
e deployável.

- **Uma branch por tarefa**, criada a partir da `main` atualizada:
  ```bash
  git checkout main
  git pull
  git checkout -b feat/tela-de-pedidos
  ```
- **Nomes descritivos com prefixo:** `feat/`, `fix/`, `chore/`, `docs/`.
  Ex.: `fix/erro-no-checkout-pix`.
- **Branch curta e focada.** Quanto mais tempo uma branch vive separada da `main`,
  pior o conflito na hora de juntar. Evite a "branch de 1 mês": prefira quebrar a
  tarefa em entregas menores.
- **Mantenha a branch atualizada** com a `main` enquanto trabalha, para integrar
  conflitos aos poucos em vez de todos de uma vez no final:
  ```bash
  git checkout main && git pull
  git checkout sua-branch
  git merge main          # ou: git rebase main
  ```
- **Apague a branch depois do merge** (local e remota). Branch morta acumulada
  só confunde.

---

## 4. Trabalho em equipe (evitando pisar no outro)

A bagunça típica acontece quando: um faz tudo na `main`, outro fica um mês numa
branch isolada, e um terceiro abre dez branches ao mesmo tempo. Para evitar:

- **Sincronize cedo e sempre.** Comece o dia com `git pull` na `main` antes de
  criar/atualizar sua branch.
- **PRs pequenos e frequentes** integram melhor do que um PR gigante no fim do mês.
- **Não misture assuntos** num PR (ex.: refatoração + nova feature). Um PR, um tema.
- **Avise quando for mexer numa área grande** (renomear pastas, mudar estrutura) —
  isso conflita com o trabalho de todo mundo e deve ser integrado rápido.
- **Resolva conflitos na sua branch**, antes de pedir o merge — não empurre o
  conflito para quem revisa.

---

## 5. Pull Requests (PRs)

Toda mudança entra na `main` via PR, nunca por push direto.

- **Escopo único e claro.** O título e a descrição falam **do que o PR muda**.
- Boa descrição responde: *o que* mudou, *por quê*, e *como foi testado*.
- **Não descreva o projeto nem trabalhos futuros no PR** — isso é documentação,
  não pertence à descrição de um PR específico. O PR fala só do diff dele.
- Espere a revisão. Revisar o código do colega também é parte do trabalho.
- Depois do merge, apague a branch.

---

## 6. Fluxo de Fork

Quando você não tem acesso de escrita ao repositório original (chamado de
**upstream**) e trabalha a partir de um fork.

### Configuração inicial (uma vez)

```bash
# clone o seu fork
git clone git@github.com:SEU_USUARIO/MercadoZap.git
cd MercadoZap

# aponte para o repositório original como "upstream"
git remote add upstream https://github.com/delafor/Mercado_zap.git
git remote -v   # confere: origin = seu fork, upstream = repo original
```

### A confusão a evitar

> ❌ Mandar tudo para a `main` do **seu fork** e depois tentar abrir um PR
> `main do fork → main do upstream`.

Isso vira bagunça porque sua `main` deixa de espelhar a `main` do original: ela
fica cheia dos seus commits e desencontra da upstream, dificultando sincronizar
e gerando PRs poluídos.

### O jeito certo

1. **Mantenha a `main` do fork limpa**, igual à do upstream. Ela serve só para
   sincronizar:
   ```bash
   git checkout main
   git fetch upstream
   git rebase upstream/main      # sua main = main do original
   git push origin main
   ```
2. **Trabalhe sempre numa branch** criada a partir da `main` atualizada — nunca
   na `main`:
   ```bash
   git checkout -b feat/minha-contribuicao
   ```
3. **Faça push da branch para o seu fork** e abra o PR **dessa branch** para a
   `main` do upstream:
   ```bash
   git push -u origin feat/minha-contribuicao
   ```
   No PR: base = `delafor/Mercado_zap:main`, head = `SEU_USUARIO:feat/minha-contribuicao`.

Assim cada contribuição é uma branch isolada, sua `main` continua sincronizada,
e o PR mostra exatamente o que você mudou.

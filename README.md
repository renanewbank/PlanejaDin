Segue um `README.md` prontinho pra colar na raiz do monorepo `PlanejaDin` (onde você tem as pastas `backend/` e `frontend/`):

````markdown
# PlanejaDin

PlanejaDin é um aplicativo de controle financeiro pessoal, desenvolvido como projeto acadêmico.  
Ele permite cadastrar usuários, registrar receitas e despesas, acompanhar saldo, visualizar histórico de transações e receber dicas financeiras de uma IA integrada.

Monorepo com:

- **Backend** em Python/FastAPI + PostgreSQL
- **Frontend** em Flutter (Web / Mobile)

---

## Estrutura do projeto

```bash
PlanejaDin/
  backend/        # API FastAPI + SQLAlchemy + PostgreSQL
    app/
      main.py
      db.py
      models.py
      routers/
        users.py
        categories.py
        transactions.py
        reports.py
        dicas.py
        chat.py       # integração com Gemini (Google Generative AI)
    requirements.txt
    .env.example     # exemplo de configuração (se existir)

  frontend/       # App Flutter (PlanejaDin)
    lib/
      main.dart
      core/
      features/
        auth/
        dashboard/
        transaction/
        dicas/
    pubspec.yaml
    README.md (opcional do app Flutter)
````

---

## Requisitos

### Backend

* Python **3.11+** (recomendado 3.11 ou 3.12)
* PostgreSQL (porta configurada, ex.: `5433`)
* `pip` (gerenciador de pacotes Python)

### Frontend

* Flutter SDK (canal stable)
* Dart SDK (já vem com o Flutter)
* Chrome ou emulador/dispositivo para rodar o app

---

## Configuração do Backend

### 1. Criar banco de dados no PostgreSQL

No seu PostgreSQL, crie um banco e um usuário (ajuste conforme sua realidade).
Exemplo:

```sql
CREATE DATABASE planejadin;
CREATE USER planejadin_user WITH ENCRYPTED PASSWORD 'planejadin_password';
GRANT ALL PRIVILEGES ON DATABASE planejadin TO planejadin_user;
```

> **Importante:** Ajuste usuário/senha de acordo com o que você vai usar na `DATABASE_URL`.

### 2. Configurar variáveis de ambiente (.env)

Dentro da pasta `backend/`, crie um arquivo `.env` (se ainda não existir) com algo como:

```env
# Exemplo de conexão local
DATABASE_URL=postgresql://planejadin_user:planejadin_password@localhost:5433/planejadin

# (Opcional) chave da API do Gemini para o agente de dicas
GEMINI_API_KEY=SEU_TOKEN_AQUI
```

> A porta `5433` é um exemplo (use a porta onde seu Postgres está rodando).

### 3. Criar e ativar o ambiente virtual

Dentro de `backend/`:

```bash
cd backend

python -m venv .venv
source .venv/bin/activate        # macOS / Linux
# .venv\Scripts\activate        # Windows (PowerShell / CMD)
```

### 4. Instalar dependências

Ainda na pasta `backend/` com o venv ativo:

```bash
pip install -r requirements.txt
```

### 5. Rodar a API (FastAPI + Uvicorn)

```bash
uvicorn app.main:app --reload
```

A API estará disponível em:

* Swagger: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
* OpenAPI: [http://127.0.0.1:8000/openapi.json](http://127.0.0.1:8000/openapi.json)

### 6. Endpoints principais (resumo)

* `POST /users/register` – cadastro de usuário
* `POST /users/login` – login e retorno de `user_id`
* `GET  /categories` – listar categorias do usuário
* `POST /transactions` – registrar transação (receita / despesa)
* `GET  /transactions/history` (ou similar) – histórico de transações
* `POST /dicas` – agente simples de dicas (versão antiga)
* `POST /chat/message` – chat com IA (Gemini)
* `POST /chat/demo` – chat demo (sem validar usuário)
* `POST /chat/analyze-transactions` – análise de transações com IA

> Os nomes exatos podem variar levemente conforme os arquivos `routers/*.py`.
> Para confirmar, veja em `/docs`.

---

## Configuração do Frontend (Flutter)

### 1. Entrar na pasta do app Flutter

Na raiz do monorepo:

```bash
cd frontend
```

(Se o seu app estiver em uma subpasta, ex.: `frontend/PlanejaDin-frontend`, ajuste o comando.)

### 2. Instalar dependências Flutter

```bash
flutter pub get
```

### 3. Rodar o app

Para rodar em **Chrome**:

```bash
flutter run -d chrome
```

Ou simplesmente:

```bash
flutter run
```

e escolha o dispositivo na lista.

O app está configurado para consumir a API em `http://127.0.0.1:8000` (ajuste no arquivo de serviço da API se mudar a porta/host).

---

## Fluxo principal da aplicação

1. **Registro / Login**

   * Usuário acessa a tela de boas-vindas, faz cadastro ou login.
   * O frontend recebe o `user_id` retornado pelo backend e armazena para futuras requisições.

2. **Dashboard**

   * Exibe saldo atual, resumo do mês (receitas x despesas) e histórico recente.
   * Consome endpoints de resumo e histórico do backend.

3. **Transações**

   * Tela para registrar **Receita** ou **Despesa**.
   * Permite escolher categoria, data, valor, descrição e método de pagamento.
   * Após registrar, o dashboard é atualizado com os novos valores.

4. **Histórico**

   * Lista de transações com detalhes (categoria, valor, data).
   * Mostra também resumo por categoria (total gasto/recebido).

5. **Dicas (IA)**

   * Tela de chat com a “Din”, assistente financeiro.
   * Envia mensagens para o backend (`/dicas` ou `/chat/message`) e exibe as respostas da IA.

---

## Scripts úteis

### Backend

```bash
# Ativar venv
cd backend
source .venv/bin/activate

# Rodar API
uvicorn app.main:app --reload
```

### Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

---

## Contribuição

Fluxo básico de contribuição:

```bash
# Criar branch
git checkout -b feature/nome-da-feature

# Fazer alterações
git add .
git commit -m "feat: descrição breve da alteração"

# Enviar para o remoto
git push origin feature/nome-da-feature

# Abrir Pull Request no GitHub
```

---

## Arquitetura & responsabilidades do time (Grupo 3)

* **Scrum Master / PO (Kamilla Acioly):** Backlog no Jira, DoR/DoD e cadência de sprints
* **Front-end (Gabriella de Sousa):** Interface web/mobile integrada às APIs e testes
* **Back-end (Heber Kayke):** Microsserviços e documentação via **Swagger** (APIs usadas no front)
* **QA (Luiza Menezes):** Casos de teste, evidências e execução do roteiro de testes
* **SRE (Renan O. Ewbank):** Estruturação do repositório, **branches por dev**, CI/CD, versionamento de imagens/containers e padronização de documentação
* **IA/ML (José Patrick):** Prompts e integração de **IA Generativa** quando aplicável



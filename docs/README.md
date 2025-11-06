# PlanejaDin — Gestão Financeira Pessoal

**PlanejaDin** é um aplicativo de gestão financeira pessoal focado em simplicidade e usabilidade: registre receitas e despesas, crie categorias, acompanhe relatórios e metas, receba alertas e tenha apoio de uma assistente virtual para dicas de economia. 

## Proposta do projeto

Oferecer uma visão clara e consolidada das finanças do usuário — do fluxo de caixa ao progresso de metas — com uma interface web/mobile leve, acessível e preparada para evoluir com integrações e automações.

## Principais funcionalidades (MVP)

* Registro de **transações** (receitas/despesas) com **categorias** personalizadas
* **Relatórios** e gráficos por período, comparação entre meses e histórico
* **Metas financeiras** com acompanhamento de progresso
* **Alertas** de vencimento e de gasto por categoria
* **Assistente “Din”** para sugestões personalizadas
* **Exportação** de dados (PDF/Excel)

## Arquitetura & responsabilidades do time (Grupo 3)

* **Scrum Master / PO (Kamilla Acioly):** Backlog no Jira, DoR/DoD e cadência de sprints
* **Front-end (Gabriella de Sousa):** Interface web/mobile integrada às APIs e testes
* **Back-end (Heber Kayke):** Microsserviços e documentação via **Swagger** (APIs usadas no front)
* **QA (Luiza Menezes):** Casos de teste, evidências e execução do roteiro de testes
* **SRE (Renan O. Ewbank):** Estruturação do repositório, **branches por dev**, CI/CD, versionamento de imagens/containers e padronização de documentação
* **IA/ML (José Patrick):** Prompts e integração de **IA Generativa** quando aplicável

## Padrões de repositório (SRE)

* **Branches por desenvolvedor** durante a sprint; **merge** para uma branch estável ao final
* Pastas previstas: `frontend/`, `backend/`, `infra/` (IaC/containers), `docs/` (Swagger/README)
* **Swagger** publicado a partir do `backend/` (rota `/swagger` ou `/docs`)
* Pipelines de **CI/CD** para lint, testes, build e entrega dos artefatos

## Roadmap de documentação

Quando os serviços estiverem estáveis, este README receberá:

* **Especificação de APIs** (métodos, endpoints, payloads e códigos de resposta)
* **Guia de execução local** (compose/k8s), variáveis de ambiente e dados de exemplo
* **Como testar** (coleções, rotas, ambientes) e **checklists de QA**
* **Observabilidade** (logs, métricas e dashboards)

---
### 05/11/2025

## Stack
- **Backend**: FastAPI + SQLAlchemy
- **DB**: PostgreSQL (Docker)
- **Schema**: `infra/db/init/01_schema.sql`

---

## 1) Subir o banco
Pré-requisito: Docker + Docker Compose.

```bash
make reset && make up        # cria volume e inicializa Postgres
docker compose logs -f db    # aguarde healthcheck OK
````

Seed do usuário (desenv):

```bash
docker exec -it planejadin-db psql -U planejadin_user -d planejadin -c \
"INSERT INTO users (id,name,email,password_hash,created_at,updated_at)
 VALUES ('00000000-0000-0000-0000-000000000001','Dev User','dev@planejadin.local','hash-dev',NOW(),NOW())
 ON CONFLICT (lower(email)) DO NOTHING;"
```

> **DB local:** `postgresql://planejadin_user:planejadin_pass@localhost:5433/planejadin?sslmode=disable`

---

## 2) Rodar o backend

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

* Health: [http://127.0.0.1:8000/healthz](http://127.0.0.1:8000/healthz)


---

## 3) Testes rápidos (cURL)

```bash
USER_ID=00000000-0000-0000-0000-000000000001

# Criar categoria
curl -s -X POST "http://127.0.0.1:8000/categories?user_id=$USER_ID" \
  -H "Content-Type: application/json" \
  -d '{"name":"Alimentação","icon":"utensils","color":"#16A34A"}'

# Listar categorias
curl -s "http://127.0.0.1:8000/categories?user_id=$USER_ID"

# Criar transações
CATEGORY_ID=<cole_o_uuid_da_categoria>
curl -s -X POST "http://127.0.0.1:8000/transactions?user_id=$USER_ID" \
  -H "Content-Type: application/json" \
  -d "{\"type\":\"INCOME\",\"amount\":2500.00,\"date\":\"2025-11-06\",\"description\":\"salário\",\"category_id\":\"$CATEGORY_ID\"}"

curl -s -X POST "http://127.0.0.1:8000/transactions?user_id=$USER_ID" \
  -H "Content-Type: application/json" \
  -d "{\"type\":\"EXPENSE\",\"amount\":120.50,\"date\":\"2025-11-06\",\"description\":\"mercado\",\"category_id\":\"$CATEGORY_ID\"}"

# Listar transações do mês
curl -s "http://127.0.0.1:8000/transactions?user_id=$USER_ID&date_from=2025-11-01&date_to=2025-11-30"

# Relatório mensal
curl -s "http://127.0.0.1:8000/reports/monthly?user_id=$USER_ID&year=2025&month=11"
```

---

## 4) Fluxo Git (mesma branch)

> Objetivo: todo mundo trabalha na **mesma branch** (ex.: `backend`) sem rebase.

```bash
# 1) Garantir que está na branch de trabalho
git switch backend   # ou: git checkout backend

# 2) Trazer o que já está no remoto
git pull origin backend

# 3) Ver o que mudou
git status

# 4) Adicionar, commitar e enviar
git add .
git commit -m "feat(api): CRUD e relatório mensal do MVP"
git push origin backend
```

> Dica: se o push for rejeitado porque alguém subiu antes, faça **apenas**:
>
> ```
> git pull origin backend
> git push origin backend
> ```


---

## 5) Próximos passos do MVP

* Adicionar **PUT/DELETE** para `/categories` e `/transactions`.
* Subir coleção **Postman/Insomnia** em `docs/`.

---




> Este arquivo é um *overview* técnico-conciso para orientar contribuição, evolução e operação do PlanejaDin. As seções de API e testes serão adicionadas conforme os artefatos forem versionados.

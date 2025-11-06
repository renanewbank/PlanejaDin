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

> Este arquivo é um *overview* técnico-conciso para orientar contribuição, evolução e operação do PlanejaDin. As seções de API e testes serão adicionadas conforme os artefatos forem versionados.

# QA Automation Portfolio

![Testes automatizados](https://github.com/nicolecassia/qa-automation-portfolio/actions/workflows/tests.yml/badge.svg)

Projeto de portfólio com automação de testes **Web** e **API**, escrito por **Nicole Cássia**, QA Sênior com mais de 10 anos de experiência em qualidade de software.

## O que este projeto mostra

| Camada | Ferramentas | Aplicação testada |
|---|---|---|
| Web (UI) | Robot Framework + SeleniumLibrary, estilo BDD (Given/When/Then) | [SauceDemo](https://www.saucedemo.com) |
| API (REST) | Python + pytest + requests | [ServeRest](https://serverest.dev) |
| CI | GitHub Actions, com relatórios publicados a cada execução | — |

Boas práticas aplicadas:
- Keywords e localizadores centralizados em um arquivo de *resource* (fácil de manter)
- Cenários escritos em formato BDD, legíveis para quem não programa
- Massa de dados gerada a cada execução (e-mails únicos), sem dependência entre testes
- *Setup* e *teardown* com fixtures: o que o teste cria, o teste apaga
- Testes parametrizados para validar campos obrigatórios
- Tags/markers (`smoke`, `e2e`, `api`, `web`) para rodar só uma parte da suíte

## Estrutura

```
├── api/                     # Testes de API (pytest)
│   ├── conftest.py          # Fixtures: sessão HTTP, usuário, token
│   ├── data_factory.py      # Geração de massa de dados
│   ├── test_usuarios.py
│   ├── test_login.py
│   └── test_produtos.py
├── web/                     # Testes Web (Robot Framework)
│   ├── resources/
│   │   └── saucedemo.resource   # Keywords e localizadores
│   └── tests/
│       ├── login.robot
│       └── checkout.robot
├── .github/workflows/tests.yml  # Pipeline de CI
├── pytest.ini
└── requirements.txt
```

## Cenários cobertos

**Web — SauceDemo**
- Login com sucesso, senha errada, usuário bloqueado e campos vazios
- Adicionar um e dois produtos ao carrinho
- Compra completa de ponta a ponta (login → carrinho → checkout → confirmação)

**API — ServeRest**
- Usuários: cadastro, e-mail duplicado, campos obrigatórios, busca por ID e exclusão
- Login: sucesso, senha errada, e-mail não cadastrado
- Produtos: listagem, cadastro autenticado e cadastro sem token

## Como executar

Pré-requisitos: Python 3.10+ e Google Chrome.

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

**Testes de API**
```bash
pytest                                   # todos
pytest -m smoke                          # só os smoke
pytest --html=reports/api-report.html    # com relatório HTML
```

**Testes Web**
```bash
robot -d results web/tests                          # abre o Chrome
robot -d results -v BROWSER:headlesschrome web/tests  # sem abrir janela
robot -d results -i smoke web/tests                 # só os smoke
```
Depois abra `results/report.html` no navegador.

## Integração contínua

A cada *push* na `main` o GitHub Actions roda as duas suítes. Os relatórios ficam disponíveis na aba **Actions → execução → Artifacts**.

## Contato

[LinkedIn](https://www.linkedin.com/in/SEU_PERFIL)

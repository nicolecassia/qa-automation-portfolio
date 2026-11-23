# QA Automation Portfolio

![Testes automatizados](https://github.com/nicolecassia/qa-automation-portfolio/actions/workflows/tests.yml/badge.svg)
![Testes mobile](https://github.com/nicolecassia/qa-automation-portfolio/actions/workflows/mobile.yml/badge.svg)

Projeto de portfólio com automação de testes **Web**, **API** e **Mobile (Android e iOS)**, escrito por **Nicole Cássia**, QA Sênior com mais de 10 anos de experiência em qualidade de software.

## O que este projeto mostra

| Camada | Ferramentas | Aplicação testada |
|---|---|---|
| Web (UI) | Robot Framework + SeleniumLibrary, estilo BDD (Given/When/Then) | [SauceDemo](https://www.saucedemo.com) |
| API (REST) | Python + pytest + requests | [ServeRest](https://serverest.dev) |
| Mobile | Robot Framework + Appium (AppiumLibrary), uma suíte para Android e iOS | [My Demo App](https://github.com/saucelabs/my-demo-app-rn) (Sauce Labs) |
| CI | GitHub Actions, com relatórios publicados a cada execução | — |

Boas práticas aplicadas:
- Keywords e localizadores centralizados em um arquivo de *resource* (fácil de manter)
- Cenários escritos em formato BDD, legíveis para quem não programa
- Massa de dados gerada a cada execução (e-mails únicos), sem dependência entre testes
- *Setup* e *teardown* com fixtures: o que o teste cria, o teste apaga
- Testes parametrizados para validar campos obrigatórios
- Tags/markers (`smoke`, `e2e`, `api`, `web`, `mobile`) para rodar só uma parte da suíte
- Mobile multiplataforma: os mesmos testes rodam no Android e no iOS; só os localizadores que mudam ficam em arquivos de configuração por plataforma

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
├── mobile/                  # Testes Mobile (Robot Framework + Appium)
│   ├── config/
│   │   ├── android.py       # Capabilities e localizadores do Android
│   │   └── ios.py           # Capabilities e localizadores do iOS
│   ├── resources/
│   │   └── mydemoapp.resource   # Keywords e localizadores comuns
│   ├── tests/
│   │   ├── login.robot
│   │   └── cart.robot
│   └── apps/                # Onde o app baixado é colocado (não versionado)
├── .github/workflows/
│   ├── tests.yml            # CI de Web e API (a cada push)
│   └── mobile.yml           # CI mobile: emulador Android e simulador iOS
├── pytest.ini
└── requirements.txt
```

## Cenários cobertos

**Web — SauceDemo**
- Login com sucesso, senha errada, usuário bloqueado e campos vazios
- Adicionar um e dois produtos ao carrinho
- Compra completa de ponta a ponta (login → carrinho → checkout → confirmação)

**Mobile — My Demo App (Android e iOS)**
- Login com sucesso, usuário bloqueado, credenciais inválidas, sem usuário e sem senha
- Adicionar produto ao carrinho
- Checkout sem login redireciona para a tela de login

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

**Testes Mobile**

Pré-requisitos extras: [Node.js](https://nodejs.org) 22+, Appium e um emulador Android (Android Studio) ou, para iOS, um Mac com Xcode.

```bash
npm install -g appium
appium driver install uiautomator2      # Android
appium driver install xcuitest          # iOS (só no Mac)
```

Baixe o app em [My Demo App - releases](https://github.com/saucelabs/my-demo-app-rn/releases/tag/v1.3.0) e coloque em `mobile/apps/`:
- Android: `Android-MyDemoAppRN.1.3.0.build-244.apk`, renomeado para `MyDemoAppRN.apk`
- iOS: descompacte `iOS-Simulator-MyRNDemoApp.1.3.0-162.zip` dentro da pasta

Com o emulador/simulador aberto, inicie o Appium em um terminal (`appium`) e, em outro:
```bash
robot -d results/android -V mobile/config/android.py mobile/tests   # Android
robot -d results/ios -V mobile/config/ios.py mobile/tests           # iOS
```

## Integração contínua

A cada *push* na `main` o GitHub Actions roda as suítes de Web e API. A suíte mobile roda sob demanda (**Actions → Testes mobile → Run workflow**), em um emulador Android e em um simulador iOS. Os relatórios ficam disponíveis na aba **Actions → execução → Artifacts**.

## Contato

[LinkedIn](https://www.linkedin.com/in/nicole-cassia/)

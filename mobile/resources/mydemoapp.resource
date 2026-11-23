*** Settings ***
Documentation     Keywords e localizadores do My Demo App (Sauce Labs) - Android e iOS.
...               Localizadores comuns às duas plataformas ficam aqui; os específicos
...               (menu e carrinho) vêm do arquivo de configuração de cada plataforma.
Library           AppiumLibrary    timeout=20s


*** Variables ***
${REMOTE_URL}           http://127.0.0.1:4723

${STANDARD_USER}        bob@example.com
${LOCKED_USER}          alice@example.com
${PASSWORD}             10203040

# Telas
${PRODUCTS_SCREEN}      accessibility_id=products screen
${PRODUCT_SCREEN}       accessibility_id=product screen
${LOGIN_SCREEN}         accessibility_id=login screen
${CART_SCREEN}          accessibility_id=cart screen

# Menu
${MENU_LOGIN}           accessibility_id=menu item log in
${MENU_LOGOUT}          accessibility_id=menu item log out

# Login
${INPUT_USERNAME}       accessibility_id=Username input field
${INPUT_PASSWORD}       accessibility_id=Password input field
${BTN_LOGIN}            accessibility_id=Login button

# Catálogo e carrinho
${STORE_ITEM}           accessibility_id=store item
${BTN_ADD_TO_CART}      accessibility_id=Add To Cart button
${PRODUCT_ROW}          accessibility_id=product row
${BTN_CHECKOUT}         accessibility_id=Proceed To Checkout button


*** Keywords ***
Open Demo App
      Wait Until Keyword Succeeds    3x    10s    Open Application    ${REMOTE_URL}    &{CAPS}
    Wait Until Element Is Visible    ${PRODUCTS_SCREEN}    timeout=60s

Close Demo App
    Close All Applications

# ---------- Login ----------
I open the login screen
    Click Element    ${LOC_OPEN_MENU}
    Wait Until Element Is Visible    ${MENU_LOGIN}
    Click Element    ${MENU_LOGIN}
    Wait Until Element Is Visible    ${LOGIN_SCREEN}

I log in with user "${user}" and password "${password}"
    IF    $user        Input Text    ${INPUT_USERNAME}    ${user}
    IF    $password    Input Text    ${INPUT_PASSWORD}    ${password}
    Run Keyword And Ignore Error    Hide Keyboard
    Click Element    ${BTN_LOGIN}

I should be logged in
    Wait Until Page Does Not Contain Element    ${LOGIN_SCREEN}    timeout=15s
    Click Element    ${LOC_OPEN_MENU}
    Wait Until Element Is Visible    ${MENU_LOGOUT}

I should see the error message "${message}"
    Wait Until Page Contains    ${message}

# ---------- Catálogo e carrinho ----------
I open the first product of the catalog
    Wait Until Element Is Visible    ${STORE_ITEM}
    Click Element    ${STORE_ITEM}
    Wait Until Element Is Visible    ${PRODUCT_SCREEN}

I add the product to the cart
    ${visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${BTN_ADD_TO_CART}    timeout=3s
    IF    not ${visible}    Swipe By Percent    50    75    50    25
    Click Element    ${BTN_ADD_TO_CART}

I open the cart
    Click Element    ${LOC_OPEN_CART}
    Wait Until Element Is Visible    ${CART_SCREEN}

the cart should contain the product "${name}"
    Wait Until Page Contains    ${name}
    Page Should Contain Element    ${PRODUCT_ROW}
    Page Should Contain Element    ${BTN_CHECKOUT}

I proceed to checkout
    Click Element    ${BTN_CHECKOUT}

I should be asked to log in
    Wait Until Element Is Visible    ${LOGIN_SCREEN}

*** Settings ***
Documentation     Keywords e localizadores da aplicação SauceDemo (https://www.saucedemo.com).
...               O site é uma aplicação React: logo após cada navegação, a página aparece
...               antes de estar pronta para receber cliques e digitação. Por isso as ações
...               importantes confirmam o resultado e tentam de novo se ele não acontecer.
Library           SeleniumLibrary


*** Variables ***
${URL}                 https://www.saucedemo.com
${BROWSER}             chrome
${TIMEOUT}             10s

${VALID_USER}          standard_user
${LOCKED_USER}         locked_out_user
${PASSWORD}            secret_sauce

# Login
${INPUT_USER}          id=user-name
${INPUT_PASSWORD}      id=password
${BTN_LOGIN}           id=login-button
${MSG_ERROR}           css=[data-test="error"]

# Produtos / carrinho
${PAGE_TITLE}          css=.title
${CART_BADGE}          css=.shopping_cart_badge
${CART_LINK}           css=.shopping_cart_link
${CART_ITEM}           css=.cart_item

# Checkout
${INPUT_FIRST_NAME}    id=first-name
${INPUT_LAST_NAME}     id=last-name
${INPUT_POSTAL_CODE}   id=postal-code
${BTN_CONTINUE}        id=continue
${BTN_FINISH}          id=finish
${MSG_COMPLETE}        css=.complete-header


*** Keywords ***
Open SauceDemo
    Open Browser    ${URL}    ${BROWSER}
    Set Window Size    1366    768
    Set Selenium Timeout    ${TIMEOUT}

Close SauceDemo
    Close All Browsers

# ---------- Login ----------
I am on the login page
    Wait Until Element Is Visible    ${BTN_LOGIN}

I log in with user "${user}" and password "${password}"
    Input Text        ${INPUT_USER}        ${user}
    Input Password    ${INPUT_PASSWORD}    ${password}
    Click Button      ${BTN_LOGIN}

I should see the products page
    Wait Until Element Contains    ${PAGE_TITLE}    Products

I should see the error message "${message}"
    Wait Until Element Is Visible    ${MSG_ERROR}
    Element Should Contain           ${MSG_ERROR}    ${message}

I am logged in as a standard user
    I am on the login page
    I log in with user "${VALID_USER}" and password "${PASSWORD}"
    I should see the products page

# ---------- Carrinho ----------
I add the product "${product_id}" to the cart
    Wait Until Keyword Succeeds    5x    1s    Add product and confirm    ${product_id}

Add product and confirm
    [Arguments]    ${product_id}
    ${already_added}=    Get Element Count    id=remove-${product_id}
    IF    ${already_added} == 0    Click Button    id=add-to-cart-${product_id}
    Wait Until Page Contains Element    id=remove-${product_id}    timeout=3s

the cart badge should show "${quantity}"
    Wait Until Element Contains    ${CART_BADGE}    ${quantity}

I open the cart
    Wait Until Element Is Visible    ${CART_LINK}
    Go To    ${URL}/cart.html
    Wait Until Element Contains    ${PAGE_TITLE}    Your Cart

the cart should have ${quantity} item(s)
    Wait Until Page Contains Element    ${CART_ITEM}    limit=${quantity}

# ---------- Checkout ----------
I fill the checkout form with "${first}" "${last}" "${zip}"
    Go To    ${URL}/checkout-step-one.html
    Wait Until Element Is Visible    ${INPUT_FIRST_NAME}
    Wait Until Keyword Succeeds    5x    1s    Fill form and continue    ${first}    ${last}    ${zip}

Fill form and continue
    [Arguments]    ${first}    ${last}    ${zip}
    Type into field    first-name     ${first}
    Type into field    last-name      ${last}
    Type into field    postal-code    ${zip}
    Click Button    ${BTN_CONTINUE}
    Wait Until Element Is Visible    ${BTN_FINISH}    timeout=3s

Type into field
    [Documentation]    Digita no campo e confere. Se o React descartar o texto digitado,
    ...                preenche via JavaScript disparando o evento "input" que o React escuta.
    [Arguments]    ${field_id}    ${text}
    Input Text    id=${field_id}    ${text}
    ${value}=    Get Value    id=${field_id}
    IF    $value != $text
        Execute Javascript
        ...    const el = document.getElementById(arguments[0]);
        ...    const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set;
        ...    setter.call(el, arguments[1]);
        ...    el.dispatchEvent(new Event('input', { bubbles: true }));
        ...    ARGUMENTS    ${field_id}    ${text}
    END
    Textfield Value Should Be    id=${field_id}    ${text}

I finish the order
    Wait Until Element Is Visible    ${BTN_FINISH}
    Click Button    ${BTN_FINISH}

I should see the order confirmation
    Wait Until Element Contains    ${MSG_COMPLETE}    Thank you for your order!

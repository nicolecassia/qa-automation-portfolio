*** Settings ***
Documentation     Keywords e localizadores da aplicação SauceDemo (https://www.saucedemo.com).
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
${BTN_CHECKOUT}        id=checkout
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
    Click Button    id=add-to-cart-${product_id}

the cart badge should show "${quantity}"
    Element Text Should Be    ${CART_BADGE}    ${quantity}

I open the cart
    Wait Until Element Is Visible    ${CART_LINK}
    Go To    ${URL}/cart.html
    Wait Until Element Contains    ${PAGE_TITLE}    Your Cart

the cart should have ${quantity} item(s)
    Page Should Contain Element    ${CART_ITEM}    limit=${quantity}

I fill the checkout form with "${first}" "${last}" "${zip}"
    Go To    ${URL}/checkout-step-one.html
    Wait Until Element Is Visible    ${INPUT_FIRST_NAME}
    Input Text       ${INPUT_FIRST_NAME}    ${first}
    Input Text       ${INPUT_LAST_NAME}     ${last}
    Input Text       ${INPUT_POSTAL_CODE}   ${zip}
    Wait Until Keyword Succeeds    3x    1s    I continue to the order overview

I continue to the order overview
    Click Button    ${BTN_CONTINUE}
    Wait Until Element Is Visible    ${BTN_FINISH}    timeout=3s

I finish the order
    Wait Until Element Is Visible    ${BTN_FINISH}
    Click Button    ${BTN_FINISH}

I should see the order confirmation
    Wait Until Element Contains    ${MSG_COMPLETE}    Thank you for your order!

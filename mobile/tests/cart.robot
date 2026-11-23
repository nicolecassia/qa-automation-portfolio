*** Settings ***
Documentation     Funcionalidade: Carrinho no app (Android e iOS)
...               Como cliente da loja
...               Quero adicionar produtos ao carrinho pelo app
...               Para comprá-los depois
Resource          ../resources/mydemoapp.resource
Test Setup        Open Demo App
Test Teardown     Close Demo App
Test Tags         mobile    cart


*** Test Cases ***
Add a product to the cart
    [Tags]    smoke
    Given I open the first product of the catalog
    When I add the product to the cart
    And I open the cart
    Then the cart should contain the product "Sauce Labs Backpack"

Checkout without login asks for login
    Given I open the first product of the catalog
    When I add the product to the cart
    And I open the cart
    And I proceed to checkout
    Then I should be asked to log in

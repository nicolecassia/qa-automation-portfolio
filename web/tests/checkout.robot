*** Settings ***
Documentation     Funcionalidade: Carrinho e finalização de compra
...               Como cliente logado
...               Quero adicionar produtos ao carrinho e finalizar o pedido
...               Para receber meus produtos
Resource          ../resources/saucedemo.resource
Test Setup        Open SauceDemo
Test Teardown     Close SauceDemo
Test Tags         web    checkout


*** Test Cases ***
Add one product to the cart
    [Tags]    smoke
    Given I am logged in as a standard user
    When I add the product "sauce-labs-backpack" to the cart
    Then the cart badge should show "1"

Add two products to the cart
    Given I am logged in as a standard user
    When I add the product "sauce-labs-backpack" to the cart
    And I add the product "sauce-labs-bike-light" to the cart
    Then the cart badge should show "2"
    When I open the cart
    Then the cart should have 2 item(s)

Complete a purchase end to end
    [Tags]    smoke    e2e
    Given I am logged in as a standard user
    When I add the product "sauce-labs-backpack" to the cart
    And I open the cart
    And I fill the checkout form with "Nicole" "QA" "30000-000"
    And I finish the order
    Then I should see the order confirmation

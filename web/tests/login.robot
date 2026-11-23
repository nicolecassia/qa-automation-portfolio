*** Settings ***
Documentation     Funcionalidade: Login no SauceDemo
...               Como cliente da loja
...               Quero acessar minha conta
...               Para poder comprar produtos
Resource          ../resources/saucedemo.resource
Test Setup        Open SauceDemo
Test Teardown     Close SauceDemo
Test Tags         web    login


*** Test Cases ***
Successful login with valid credentials
    [Tags]    smoke
    Given I am on the login page
    When I log in with user "${VALID_USER}" and password "${PASSWORD}"
    Then I should see the products page

Login with wrong password
    Given I am on the login page
    When I log in with user "${VALID_USER}" and password "wrong_password"
    Then I should see the error message "Username and password do not match any user in this service"

Login with locked out user
    Given I am on the login page
    When I log in with user "${LOCKED_USER}" and password "${PASSWORD}"
    Then I should see the error message "Sorry, this user has been locked out."

Login with empty fields
    Given I am on the login page
    When I log in with user "${EMPTY}" and password "${EMPTY}"
    Then I should see the error message "Username is required"

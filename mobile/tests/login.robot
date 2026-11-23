*** Settings ***
Documentation     Funcionalidade: Login no app (Android e iOS)
...               Como cliente da loja
...               Quero entrar na minha conta pelo app
...               Para poder finalizar compras
Resource          ../resources/mydemoapp.resource
Test Setup        Open Demo App
Test Teardown     Close Demo App
Test Tags         mobile    login


*** Test Cases ***
Successful login with valid credentials
    [Tags]    smoke
    Given I open the login screen
    When I log in with user "${STANDARD_USER}" and password "${PASSWORD}"
    Then I should be logged in

Login with locked out user
    Given I open the login screen
    When I log in with user "${LOCKED_USER}" and password "${PASSWORD}"
    Then I should see the error message "Sorry, this user has been locked out."

Login with invalid credentials
    Given I open the login screen
    When I log in with user "1@2.com" and password "f-o-o"
    Then I should see the error message "Provided credentials do not match any user in this service."

Login without username
    Given I open the login screen
    When I log in with user "${EMPTY}" and password "${EMPTY}"
    Then I should see the error message "Username is required"

Login without password
    Given I open the login screen
    When I log in with user "${STANDARD_USER}" and password "${EMPTY}"
    Then I should see the error message "Password is required"

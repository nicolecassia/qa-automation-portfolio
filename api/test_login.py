"""Testes do endpoint /login."""
import pytest

pytestmark = [pytest.mark.api]


@pytest.mark.smoke
def test_login_successfully(api, base_url, new_user):
    response = api.post(
        f"{base_url}/login",
        json={"email": new_user["email"], "password": new_user["password"]},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["message"] == "Login realizado com sucesso"
    assert body["authorization"].startswith("Bearer ")


def test_login_with_wrong_password(api, base_url, new_user):
    response = api.post(
        f"{base_url}/login",
        json={"email": new_user["email"], "password": "senha_errada"},
    )

    assert response.status_code == 401
    assert response.json()["message"] == "Email e/ou senha inválidos"


def test_login_with_unregistered_email(api, base_url):
    response = api.post(
        f"{base_url}/login",
        json={"email": "nao.existe@portfolio.com", "password": "qualquer"},
    )

    assert response.status_code == 401

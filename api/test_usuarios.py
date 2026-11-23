"""Testes do endpoint /usuarios."""
import pytest

from data_factory import build_user

pytestmark = [pytest.mark.api]


@pytest.mark.smoke
def test_create_user_successfully(api, base_url):
    payload = build_user()

    response = api.post(f"{base_url}/usuarios", json=payload)

    assert response.status_code == 201
    body = response.json()
    assert body["message"] == "Cadastro realizado com sucesso"
    assert body["_id"]

    api.delete(f"{base_url}/usuarios/{body['_id']}")  # limpeza


def test_create_user_with_duplicated_email(api, base_url, new_user):
    payload = build_user()
    payload["email"] = new_user["email"]

    response = api.post(f"{base_url}/usuarios", json=payload)

    assert response.status_code == 400
    assert response.json()["message"] == "Este email já está sendo usado"


@pytest.mark.parametrize("missing_field", ["nome", "email", "password", "administrador"])
def test_create_user_without_required_field(api, base_url, missing_field):
    payload = build_user()
    payload.pop(missing_field)

    response = api.post(f"{base_url}/usuarios", json=payload)

    assert response.status_code == 400
    assert missing_field in response.json()


def test_get_user_by_id(api, base_url, new_user):
    response = api.get(f"{base_url}/usuarios/{new_user['_id']}")

    assert response.status_code == 200
    body = response.json()
    assert body["nome"] == new_user["nome"]
    assert body["email"] == new_user["email"]


def test_delete_user(api, base_url):
    created = api.post(f"{base_url}/usuarios", json=build_user()).json()

    response = api.delete(f"{base_url}/usuarios/{created['_id']}")

    assert response.status_code == 200
    assert response.json()["message"] == "Registro excluído com sucesso"

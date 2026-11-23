"""Testes do endpoint /produtos (inclui rota autenticada)."""
import pytest

from data_factory import build_product

pytestmark = [pytest.mark.api]



@pytest.mark.smoke
def test_list_products(api, base_url):
    response = api.get(f"{base_url}/produtos")

    assert response.status_code == 200
    body = response.json()
    assert "quantidade" in body
    assert isinstance(body["produtos"], list)


def test_create_product_with_admin_token(api, base_url, auth_token):
    response = api.post(
        f"{base_url}/produtos",
        json=build_product(),
        headers={"Authorization": auth_token},
    )

    assert response.status_code == 201
    product_id = response.json()["_id"]

    api.delete(f"{base_url}/produtos/{product_id}", headers={"Authorization": auth_token})


def test_create_product_without_token(api, base_url):
    response = api.post(f"{base_url}/produtos", json=build_product())

    assert response.status_code == 401

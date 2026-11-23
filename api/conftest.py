"""Fixtures compartilhadas dos testes de API (ServeRest - https://serverest.dev)."""
import os

import pytest
import requests

from data_factory import build_user

BASE_URL = os.getenv("SERVEREST_URL", "https://serverest.dev")


@pytest.fixture(scope="session")
def base_url():
    return BASE_URL


@pytest.fixture(scope="session")
def api():
    """Sessão HTTP reutilizada por todos os testes."""
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})
    yield session
    session.close()



@pytest.fixture
def new_user(api, base_url):
    """Cria um usuário administrador e remove ao final do teste (setup/teardown)."""
    payload = build_user()
    response = api.post(f"{base_url}/usuarios", json=payload)
    assert response.status_code == 201, response.text
    user = {**payload, "_id": response.json()["_id"]}

    yield user

    api.delete(f"{base_url}/usuarios/{user['_id']}")


@pytest.fixture
def auth_token(api, base_url, new_user):
    """Faz login com o usuário criado e devolve o token Bearer."""
    response = api.post(
        f"{base_url}/login",
        json={"email": new_user["email"], "password": new_user["password"]},
    )
    assert response.status_code == 200, response.text
    return response.json()["authorization"]

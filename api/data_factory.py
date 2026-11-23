"""Geração de massa de dados para os testes de API."""
import uuid


def build_user(admin: bool = True) -> dict:
    """Usuário com e-mail único, para não haver conflito entre execuções."""
    unique = uuid.uuid4().hex[:10]
    return {
        "nome": f"QA Portfolio {unique}",
        "email": f"qa.{unique}@portfolio.com",
        "password": f"Senha@{unique}",
        "administrador": "true" if admin else "false",
    }


def build_product() -> dict:
    """Produto com nome único (a API não aceita nomes repetidos)."""
    return {
        "nome": f"Produto QA {uuid.uuid4().hex[:8]}",
        "preco": 150,
        "descricao": "Produto criado pela automação de testes",
        "quantidade": 10,
    }

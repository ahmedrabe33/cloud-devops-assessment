from fastapi.testclient import TestClient
from app import app

client = TestClient(app)


def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_create_user_validation():
    response = client.post(
        "/users",
        json={
            "name": "",
            "age": 25
        }
    )

    assert response.status_code == 400


def test_invalid_age():
    response = client.post(
        "/users",
        json={
            "name": "Ahmed",
            "age": 150
        }
    )

    assert response.status_code == 400

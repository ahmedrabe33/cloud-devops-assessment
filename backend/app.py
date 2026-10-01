import os
import psycopg2

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="DevOps Assessment API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://127.0.0.1:8080", "http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["GET"],
    allow_headers=["*"],
)


@app.get("/")
def root():
    return {
        "message": "Welcome to DevOps Assessment",
        "status": "running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/db-check")
def db_check():
    try:
        connection = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            database=os.getenv("DB_NAME", "devopsdb"),
            user=os.getenv("DB_USER", "devops"),
            password=os.getenv("DB_PASSWORD", "devopspassword"),
            port=os.getenv("DB_PORT", "5432")
        )

        cursor = connection.cursor()
        cursor.execute("SELECT 1;")
        cursor.fetchone()

        cursor.close()
        connection.close()

        return {
            "database": "connected"
        }

    except Exception as error:
        return {
            "database": "disconnected",
            "error": str(error)
        }

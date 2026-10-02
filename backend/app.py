import os
import psycopg2

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="DevOps Assessment API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://127.0.0.1:8080",
        "http://localhost:8080",
        "http://cloud-devops-assessment-assessment-frontend.s3-website-us-east-1.amazonaws.com"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class UserCreate(BaseModel):
    name: str
    age: int


def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME", "devopsdb"),
        user=os.getenv("DB_USER", "devops"),
        password=os.getenv("DB_PASSWORD", "devopspassword"),
        port=os.getenv("DB_PORT", "5432")
    )


def create_table():
    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            age INTEGER NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
    """)

    connection.commit()
    cursor.close()
    connection.close()


@app.on_event("startup")
def startup_event():
    try:
        create_table()
    except Exception as error:
        print(f"Database initialization failed: {error}")


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
        connection = get_db_connection()
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


@app.post("/users")
def create_user(user: UserCreate):
    if not user.name.strip():
        raise HTTPException(
            status_code=400,
            detail="Name is required"
        )

    if user.age <= 0 or user.age > 120:
        raise HTTPException(
            status_code=400,
            detail="Age must be between 1 and 120"
        )

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            INSERT INTO users (name, age)
            VALUES (%s, %s)
            RETURNING id, name, age, created_at;
        """, (user.name.strip(), user.age))

        new_user = cursor.fetchone()

        connection.commit()

        cursor.close()
        connection.close()

        return {
            "message": "User added successfully",
            "user": {
                "id": new_user[0],
                "name": new_user[1],
                "age": new_user[2],
                "created_at": new_user[3]
            }
        }

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )


@app.get("/users")
def get_users():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            SELECT id, name, age, created_at
            FROM users
            ORDER BY created_at DESC;
        """)

        rows = cursor.fetchall()

        cursor.close()
        connection.close()

        users = []

        for row in rows:
            users.append({
                "id": row[0],
                "name": row[1],
                "age": row[2],
                "created_at": row[3]
            })

        return {
            "count": len(users),
            "users": users
        }

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=str(error)
        )

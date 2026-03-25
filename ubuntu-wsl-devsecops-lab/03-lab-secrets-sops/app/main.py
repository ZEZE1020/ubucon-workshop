"""🔐 Secure Secrets Demo - FastAPI Application

A simple API that demonstrates secure secrets management.
"The Matrix has you..." - but your secrets are safe with SOPS!
"""

import os
from pathlib import Path
from fastapi import FastAPI, HTTPException
import yaml

app = FastAPI(
    title="🔐 Nebuchadnezzar Secrets Vault",
    description="Secure secrets management aboard the hovercraft",
    version="1.0.0"
)

def load_secret() -> str:
    """Load the database password from secrets.yaml"""
    secrets_path = Path("/app/secrets/secrets.yaml")
    fallback_path = Path("secrets.yaml")
    
    path = secrets_path if secrets_path.exists() else fallback_path
    
    if not path.exists():
        return None
    
    with open(path) as f:
        data = yaml.safe_load(f)
        return data.get("stringData", {}).get("DB_PASSWORD")

@app.get("/")
async def root():
    return {"message": "🔐 Welcome to the Nebuchadnezzar Vault", "status": "online"}

@app.get("/secret")
async def get_secret():
    password = load_secret()
    if not password:
        raise HTTPException(
            status_code=404,
            detail="🕵️ 'There is no spoon'... and no secrets.yaml either!"
        )
    # Mask the password for demo purposes
    masked = password[:3] + "*" * (len(password) - 3)
    return {"db_password_masked": masked, "length": len(password)}

@app.get("/health")
async def health():
    return {"status": "operational", "crew": "ready", "quote": "Free your mind."}

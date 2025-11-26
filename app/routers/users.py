from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timezone
from pydantic import BaseModel, EmailStr
from uuid import UUID
from ..db import get_db
from .. import models

router = APIRouter(prefix="/users", tags=["users"])

class RegisterIn(BaseModel):
    name: str
    email: EmailStr
    password: str

class LoginIn(BaseModel):
    email: EmailStr
    password: str

class UserOut(BaseModel):
    id: UUID
    name: str
    email: EmailStr
    class Config: from_attributes = True

@router.post("/register", response_model=UserOut, status_code=201)
def register(payload: RegisterIn, db: Session = Depends(get_db)):
    exists = db.query(models.User).filter(models.User.email == payload.email).first()
    if exists:
        raise HTTPException(status_code=409, detail="Email already registered")

    now = datetime.now(timezone.utc)
    user = models.User(
        name=payload.name,
        email=payload.email,
        password_hash=payload.password,  # depois vcs colocam hash de verdade
        created_at=now,
        updated_at=now,
    )
    db.add(user); db.commit(); db.refresh(user)
    return user

@router.post("/login", response_model=UserOut)
def login(payload: LoginIn, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == payload.email).first()
    if not user or user.password_hash != payload.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return user

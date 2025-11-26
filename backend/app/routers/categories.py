from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from uuid import UUID
from datetime import datetime, timezone
from ..db import get_db
from .. import models, schemas

router = APIRouter(prefix="/categories", tags=["categories"])

@router.get("", response_model=list[schemas.CategoryOut])
def list_categories(user_id: UUID = Query(...), db: Session = Depends(get_db)):
    return db.query(models.Category).filter(models.Category.user_id == user_id).order_by(models.Category.name).all()

@router.post("", response_model=schemas.CategoryOut, status_code=201)
def create_category(
    user_id: UUID = Query(...),
    payload: schemas.CategoryCreate = ...,
    db: Session = Depends(get_db)
):
    # regra de unicidade por usuário (name)
    exists = db.query(models.Category).filter(
        models.Category.user_id == user_id,
        models.Category.name.ilike(payload.name)
    ).first()
    if exists:
        raise HTTPException(status_code=409, detail="Category already exists")

    now = datetime.now(timezone.utc)
    cat = models.Category(
        user_id=user_id, name=payload.name, icon=payload.icon, color=payload.color,
        created_at=now, updated_at=now
    )
    db.add(cat); db.commit(); db.refresh(cat)
    return cat

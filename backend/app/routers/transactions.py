from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from uuid import UUID
from datetime import datetime, timezone, date as dt_date
from ..db import get_db
from .. import models, schemas

router = APIRouter(prefix="/transactions", tags=["transactions"])

@router.get("", response_model=list[schemas.TransactionOut])
def list_transactions(
    user_id: UUID = Query(...),
    date_from: dt_date = Query(...),
    date_to: dt_date = Query(...),
    category_id: UUID | None = Query(None),
    type: models.TransactionType | None = Query(None),
    db: Session = Depends(get_db)
):
    q = db.query(models.Transaction).filter(
        models.Transaction.user_id == user_id,
        models.Transaction.date.between(date_from, date_to)
    )
    if category_id: q = q.filter(models.Transaction.category_id == category_id)
    if type: q = q.filter(models.Transaction.type == type)
    return q.order_by(models.Transaction.date.desc(), models.Transaction.created_at.desc()).all()

@router.post("", response_model=schemas.TransactionOut, status_code=201)
def create_transaction(
    user_id: UUID = Query(...),
    payload: schemas.TransactionCreate = ...,
    db: Session = Depends(get_db)
):
    # se categoria informada, precisa pertencer ao mesmo user
    if payload.category_id:
        cat = db.query(models.Category).filter(
            models.Category.id == payload.category_id,
            models.Category.user_id == user_id
        ).first()
        if not cat:
            raise HTTPException(status_code=400, detail="category_id does not belong to user")

    now = datetime.now(timezone.utc)
    tx = models.Transaction(
        user_id=user_id,
        category_id=payload.category_id,
        type=payload.type,
        amount=payload.amount,
        date=payload.date,
        description=payload.description,
        created_at=now,
        updated_at=now
    )
    db.add(tx); db.commit(); db.refresh(tx)
    return tx

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, case, extract
from uuid import UUID
from ..db import get_db
from .. import models, schemas

router = APIRouter(prefix="/reports", tags=["reports"])

@router.get("/monthly", response_model=schemas.MonthlyReportOut)
def monthly(
    user_id: UUID = Query(...),
    year: int = Query(..., ge=1900, le=3000),
    month: int = Query(..., ge=1, le=12),
    db: Session = Depends(get_db)
):
    # soma condicional por mês
    total_income, total_expense = db.query(
        func.coalesce(func.sum(case((models.Transaction.type == models.TransactionType.INCOME, models.Transaction.amount), else_=0)), 0),
        func.coalesce(func.sum(case((models.Transaction.type == models.TransactionType.EXPENSE, models.Transaction.amount), else_=0)), 0),
    ).filter(
        models.Transaction.user_id == user_id,
        extract('year', models.Transaction.date) == year,
        extract('month', models.Transaction.date) == month
    ).one()

    return schemas.MonthlyReportOut(
        year=year, month=month,
        total_income=float(total_income), total_expense=float(total_expense)
    )

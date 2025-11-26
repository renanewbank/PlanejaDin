from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import date, datetime
from uuid import UUID
from .models import TransactionType

# ---- Users ----
class UserOut(BaseModel):
    id: UUID
    name: str
    email: EmailStr
    created_at: datetime
    updated_at: datetime
    class Config: from_attributes = True

# ---- Categories ----
class CategoryCreate(BaseModel):
    name: str = Field(min_length=1)
    icon: Optional[str] = None
    color: Optional[str] = None

class CategoryOut(BaseModel):
    id: UUID
    name: str
    icon: Optional[str]
    color: Optional[str]
    created_at: datetime
    updated_at: datetime
    class Config: from_attributes = True

# ---- Transactions ----
class TransactionCreate(BaseModel):
    category_id: Optional[UUID] = None
    type: TransactionType
    amount: float = Field(gt=0)
    date: date
    description: Optional[str] = None

class TransactionOut(BaseModel):
    id: UUID
    category_id: Optional[UUID]
    type: TransactionType
    amount: float
    date: date
    description: Optional[str]
    created_at: datetime
    updated_at: datetime
    class Config: from_attributes = True

# ---- Reports ----
class MonthlyReportOut(BaseModel):
    year: int
    month: int
    total_income: float
    total_expense: float

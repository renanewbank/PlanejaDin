from fastapi import FastAPI
from .routers import health, categories, transactions, reports

app = FastAPI(title="PlanejaDin API", version="0.1.0")

app.include_router(health.router)
app.include_router(categories.router)
app.include_router(transactions.router)
app.include_router(reports.router)

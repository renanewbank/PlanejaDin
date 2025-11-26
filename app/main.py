from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import health, categories, transactions, reports, users, dicas

app = FastAPI(title="PlanejaDin API", version="0.1.0")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],      
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(categories.router)
app.include_router(transactions.router)
app.include_router(reports.router)
app.include_router(users.router)
app.include_router(dicas.router)

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
import google.generativeai as genai
import os
from typing import Optional
from uuid import UUID
from sqlalchemy.orm import Session
from ..db import get_db
from .. import models

router = APIRouter(prefix="/chat", tags=["chat"])

# Configurar a API do Gemini
def get_gemini_client():
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise HTTPException(status_code=500, detail="GEMINI_API_KEY não configurada")
    genai.configure(api_key=api_key)
    return genai

# Schemas
class ChatRequest(BaseModel):
    user_id: UUID
    message: str
    context: Optional[str] = None

class ChatResponse(BaseModel):
    user_message: str
    ai_response: str
    context: Optional[str] = None

# Endpoint para chat com Gemini
@router.post("/message", response_model=ChatResponse)
def chat_with_gemini(
    request: ChatRequest,
    db: Session = Depends(get_db)
):
    """
    Endpoint para chat com IA Gemini 2.5 Flash
    
    - Recebe mensagem do usuário
    - Opcional: pode receber contexto (ex: dados financeiros)
    - Retorna resposta da IA
    """
    
    # Validar se o usuário existe
    user = db.query(models.User).filter(models.User.id == request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    # Construir contexto para a IA
    system_prompt = """Você é um assistente financeiro inteligente para a aplicação PlanejaDin.
    Ajude o usuário com dicas, análises e orientações sobre suas finanças pessoais.
    Seja conciso, amigável e prático."""
    
    # Se houver contexto adicional (dados financeiros), incluir na mensagem
    user_message = request.message
    if request.context:
        user_message = f"Contexto: {request.context}\n\nPergunta: {request.message}"
    
    try:
        # Inicializar cliente Gemini
        client = get_gemini_client()
        
        # Chamar API do Gemini
        model = genai.GenerativeModel('gemini-2.5-flash')
        response = model.generate_content(
            f"{system_prompt}\n\n{user_message}",
            generation_config=genai.types.GenerationConfig(
                temperature=0.7,
                top_p=0.95,
                max_output_tokens=1024,
            )
        )
        
        ai_response = response.text
        
        return ChatResponse(
            user_message=request.message,
            ai_response=ai_response,
            context=request.context
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao comunicar com Gemini: {str(e)}")


    # Demo schema (não precisa de user_id) - para testes locais
class ChatDemoRequest(BaseModel):
    message: str
    context: Optional[str] = None


# Endpoint de demo para testes sem usuário/UUID
@router.post("/demo", response_model=ChatResponse)
def chat_demo(
    request: ChatDemoRequest
):
    """
    Endpoint de demonstração que ignora validação de usuário.
    Útil para testar integração com Gemini sem depender do banco de dados.
    """

    system_prompt = """Você é um assistente financeiro inteligente para a aplicação PlanejaDin.
    Ajude o usuário com dicas, análises e orientações sobre suas finanças pessoais.
    Seja conciso, amigável e prático."""

    user_message = request.message
    if request.context:
        user_message = f"Contexto: {request.context}\n\nPergunta: {request.message}"

    try:
        client = get_gemini_client()
        model = genai.GenerativeModel('gemini-2.5-flash')
        response = model.generate_content(
            f"{system_prompt}\n\n{user_message}",
            generation_config=genai.types.GenerationConfig(
                temperature=0.7,
                top_p=0.95,
                max_output_tokens=1024,
            )
        )

        ai_response = response.text

        return ChatResponse(
            user_message=request.message,
            ai_response=ai_response,
            context=request.context
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao comunicar com Gemini (demo): {str(e)}")

# Endpoint para análise de transações com IA
@router.post("/analyze-transactions", response_model=ChatResponse)
def analyze_transactions(
    user_id: UUID,
    db: Session = Depends(get_db)
):
    """
    Endpoint para análise automática das transações do usuário com IA
    """
    
    # Validar se o usuário existe
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuário não encontrado")
    
    # Buscar as últimas transações do usuário
    transactions = db.query(models.Transaction).filter(
        models.Transaction.user_id == user_id
    ).order_by(models.Transaction.date.desc()).limit(20).all()
    
    if not transactions:
        raise HTTPException(status_code=404, detail="Nenhuma transação encontrada")
    
    # Construir contexto com as transações
    context = "Minhas últimas transações:\n"
    for tx in transactions:
        tx_type = "Receita" if tx.type.value == "income" else "Despesa"
        context += f"- {tx.date}: {tx_type} de R$ {tx.amount:.2f} - {tx.description or 'Sem descrição'}\n"
    
    try:
        client = get_gemini_client()
        model = genai.GenerativeModel('gemini-2.5-flash')
        
        prompt = f"""Você é um assistente financeiro. Analise as seguintes transações e forneça:
1. Resumo dos gastos e receitas
2. Padrões identificados
3. Sugestões de melhorias

{context}"""
        
        response = model.generate_content(
            prompt,
            generation_config=genai.types.GenerationConfig(
                temperature=0.7,
                top_p=0.95,
                max_output_tokens=1024,
            )
        )
        
        ai_response = response.text
        
        return ChatResponse(
            user_message="Analise minhas transações",
            ai_response=ai_response,
            context=context
        )
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao analisar transações: {str(e)}")

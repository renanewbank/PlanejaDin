from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter(prefix="/dicas", tags=["dicas"])


class DicaIn(BaseModel):
    mensagem: str


class DicaOut(BaseModel):
    resposta: str


def _montar_resposta(mensagem: str) -> str:
    """
    Gera uma resposta simples a partir da mensagem.
    Mantém tudo local (sem chamadas externas) para servir de mock.
    """
    texto = mensagem.lower()

    if not texto.strip():
        raise HTTPException(status_code=400, detail="mensagem não pode ser vazia")

    if "meta" in texto or "objetivo" in texto:
        return "Vou acompanhar suas metas: defina um valor mensal, crie alertas e revise toda semana."

    if "econom" in texto or "poupar" in texto:
        return "Dica rápida: separe 10% assim que receber, negocie tarifas e revise assinaturas mensais."

    if "dívida" in texto or "divida" in texto or "cartão" in texto:
        return "Priorize dívidas com juros maiores, pague acima do mínimo e considere portabilidade ou renegociação."

    return "Anotado! Posso sugerir metas, cortes de gastos e melhores datas de vencimento para ajudar."


@router.post("", response_model=DicaOut)
def gerar_dica(payload: DicaIn):
    resposta = _montar_resposta(payload.mensagem)
    return DicaOut(resposta=resposta)

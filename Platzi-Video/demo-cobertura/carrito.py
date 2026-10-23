"""Cálculo del precio final de un carrito: cupón y descuento VIP."""


def precio_final(subtotal: float, cupon: str | None = None, es_vip: bool = False) -> float:
    """Aplica el cupón y luego el descuento VIP sobre el subtotal."""
    total = subtotal
    if cupon == "BIENVENIDO":
        total = total * 0.90
    if es_vip and total > 100:
        total = total - 10
    return round(total, 2)

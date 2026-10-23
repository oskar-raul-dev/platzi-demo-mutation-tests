"""Cálculo del precio final de un carrito: cupón y descuento VIP."""
def precio_final(
    subtotal: float, cupon: str | None = None, es_vip: bool = False
) -> float:
    """Aplica el cupón y luego el descuento VIP sobre el subtotal."""
    total = subtotal
    # Cupón de bienvenida: 10 % de descuento sobre el subtotal.
    if cupon == "BIENVENIDO":
        total = total * 0.90
    # Descuento VIP: 10 menos, solo si el cliente es VIP  y su total pasa de 100.
    if es_vip and total > 100:
        total = total - 10
    # Redondeo a centavos.
    return round(total, 2)


if __name__ == '__main__':
    print(f"Precio final: {precio_final(200)}")

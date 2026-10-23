#!/usr/bin/env bash
# Deja la demo como al inicio de la clase: carrito.py sin main y con `and`,
# test «que faltaba» comentado y sin cachés.
set -euo pipefail
cd "$(dirname "$0")"

cat > carrito.py <<'PY'
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
PY

cat > tests/test_carrito.py <<'PY'
from carrito import precio_final

def test_vip_con_cupon():
    # 200 → cupón 10 % → 180 → VIP → 170
    assert precio_final(200, cupon="BIENVENIDO", es_vip=True) == 170.0
def test_vip_compra_grande():
    # 200 → VIP → 190
    assert precio_final(200, es_vip=True) == 190.0
def test_normal_compra_chica():
    # 50, sin cupón ni VIP → 50
    assert precio_final(50) == 50.0
PY

# Solo artefactos regenerables por pytest, coverage y mutmut.
rm -rf mutants .mutmut-cache .coverage coverage.xml htmlcov .pytest_cache __pycache__ tests/__pycache__
echo "listo: carrito.py y test restaurados, cachés borradas"

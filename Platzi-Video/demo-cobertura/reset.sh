#!/usr/bin/env bash
# Deja la demo como al inicio de la clase: test «que faltaba» comentado y sin cachés.
set -euo pipefail
cd "$(dirname "$0")"

cat > tests/test_carrito.py <<'PY'
from carrito import precio_final


def test_cupon_y_vip():
    # 200 → cupón 10 % → 180 → VIP → 170
    assert precio_final(200, cupon="BIENVENIDO", es_vip=True) == 170.0


# El test que faltaba: un cliente normal NO recibe el descuento VIP.
# def test_no_vip_no_descuenta():
#     assert precio_final(200) == 200.0
PY

# Solo artefactos regenerables por pytest, coverage y mutmut.
rm -rf mutants .mutmut-cache .coverage .pytest_cache __pycache__ tests/__pycache__
echo "listo: test restaurado y cachés borradas"

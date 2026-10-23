from carrito import precio_final


def test_cupon_y_vip():
    # 200 → cupón 10 % → 180 → VIP → 170
    assert precio_final(200, cupon="BIENVENIDO", es_vip=True) == 170.0


# El test que faltaba: un cliente normal NO recibe el descuento VIP.
# def test_no_vip_no_descuenta():
#     assert precio_final(200) == 200.0

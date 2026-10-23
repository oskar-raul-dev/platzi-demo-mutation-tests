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

def test_normal_compra_grande():
    # 50, sin cupón ni VIP → 50
    assert precio_final(200) == 200.0

# demo-cobertura

Proyecto de la demo class. Instrucciones completas en [`../02-setup-proyecto.md`](../02-setup-proyecto.md).

```bash
source .venv/bin/activate
pytest --cov=carrito
mutmut run && mutmut results
mutmut show carrito.x_precio_final__mutmut_9
./reset.sh   # entre ensayos
```

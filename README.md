# mutation-tests

Demo de cobertura frente a *mutation testing*: `carrito.py` tiene 100 % de cobertura con un solo
test, y aun así `mutmut` encuentra 7 mutantes que ningún test detecta (entre ellos, `and` → `or`).

Versiones fijadas: Python 3.14.9 (pyenv, en `.python-version`), pytest 8.4.2, pytest-cov 7.0.0,
mutmut 3.8.0.

## Crear el entorno desde cero

```bash
pyenv install -s 3.14.9          # -s: no hace nada si ya está instalada
cd ~/Developer/Learning/Python/mutation-tests
python -m venv .venv             # usa el 3.14.9 que fija .python-version
source .venv/bin/activate
pip install -r requirements.txt
```

- `.python-version` hace que pyenv use 3.14.9 dentro de esta carpeta, sin tocar la versión global.
- `.venv/` no se versiona; si se borra, se recrea con los tres últimos comandos.

## Comandos de la demo, en orden

```bash
pytest --cov=carrito --cov-report=term --cov-report=xml   # 3 passed, carrito.py 100%
# escribir al final de carrito.py:
#   if __name__ == "__main__":
#       print("Cliente normal paga:", precio_final(200))
python carrito.py                             # Cliente normal paga: 200
# cambiar `and` por `or` en la línea 11
python carrito.py                             # Cliente normal paga: 190
pytest --cov=carrito --cov-report=term --cov-report=xml   # sigue 3 passed y 100%
# deshacer el `or`
mutmut run                                    # 19/19  🎉 12  🙁 7
mutmut results                                # los 7 sobrevivientes
mutmut show carrito.x_precio_final__mutmut_9  # el diff and → or
# descomentar test_normal_compra_grande en tests/test_carrito.py
rm -r mutants && mutmut run                   # 19/19  🎉 14  🙁 5
mutmut results                                # los 5 que quedan
./reset.sh                                    # carrito.py sin main y con `and`, test comentado
```

## Cobertura en el editor

La extensión Coverage Gutters (`ryanluker.vscode-coverage-gutters`, recomendada en el workspace)
pinta de verde las líneas ejecutadas y de rojo las que no, leyendo `coverage.xml`.

- `--cov-report=xml` escribe `coverage.xml`; `--cov-report=term` mantiene la tabla en la terminal
  (al pedir un reporte explícito, pytest-cov deja de imprimir el de terminal por defecto).
- El Watch de Coverage Gutters arranca solo al abrir el workspace
  (`coverage-gutters.watchOnActivate`): el color se actualiza cada vez que pytest reescribe
  `coverage.xml`. Para limpiar el verde entre ensayos: `./reset.sh` y luego
  Cmd+Shift+P → *Developer: Reload Window*. A mano: `Cmd+Shift+8` (Watch) y `Cmd+Shift+0`
  (quitar), con el foco en el editor.
- **No** se ponen los `--cov…` en `addopts` de `pyproject.toml`: mutmut corre pytest con esas
  opciones y todos los mutantes terminan en `segfault`.

## Diferencias con mutmut 3.3.1

- **3.3.1 no instala en Python 3.14**: exige `libcst~=1.7.0`, que no tiene wheel para 3.14.
  La 3.8.0 usa `libcst>=1.9.0`.
- **Ya no hace falta el parche de `setproctitle`** en macOS: con 3.8.0 los mutantes corren sin
  `segfault`.
- **Al añadir un test, `mutmut run` no vuelve a probar los mutantes que ya tienen veredicto.**
  Detecta el test nuevo, pero conserva el «survived». Hay dos salidas:
  - `rm -r mutants && mutmut run`: corre todo de cero y muestra el resumen `🎉 14 🙁 5`.
  - `mutmut run "carrito*"`: vuelve a probar solo los nombrados (admite comodines), pero
    imprime una línea por mutante en vez del resumen.
- En `pyproject.toml`, `paths_to_mutate` pasa a llamarse `source_paths`, y `tests_dir` se
  sustituye por `pytest_add_cli_args_test_selection`; con los nombres viejos sale un aviso.

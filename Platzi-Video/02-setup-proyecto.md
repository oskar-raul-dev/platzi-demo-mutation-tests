# 🛠️ Setup del proyecto en VS Code · macOS (hecho) y Windows (pendiente)

> **Qué es:** cómo quedó preparado el proyecto (raíz del repo) en el Mac, qué comandos usa la clase y qué
> falta para reproducirlo en el Windows. Versiones fijadas: Python 3.13.4, pytest 8.4.2,
> pytest-cov 7.0.0, mutmut 3.3.1.

## 1. 📁 El proyecto

```
mutation-tests-platzi-demo/
├── carrito.py              # la función que se muestra (10 líneas)
├── tests/test_carrito.py   # un test activo + el test «que faltaba» comentado
├── pyproject.toml          # dependencias fijadas, config de pytest y de mutmut
├── .vscode/settings.json   # letra 20 pt, sin minimap, archivos ocultos
├── reset.sh                # deja todo como al inicio de la clase
├── salidas/                # las salidas reales, por si algo falla en vivo
└── .venv/                  # entorno virtual (no se versiona)
```

- `pyproject.toml` fija `paths_to_mutate = ["carrito.py"]` y `tests_dir = ["tests/"]` para
  mutmut, y `pythonpath = ["."]` para que pytest importe `carrito` sin instalar nada.
- `.vscode/settings.json` sube la letra del editor y de la terminal a 20 puntos (la guía pide 20
  o más), quita el minimap y la barra de estado, y oculta `.venv/`, `mutants/` y las cachés
  para que el explorador se vea limpio en cámara.

## 2. 🍎 macOS: lo que ya está hecho

El entorno se creó con `uv` (ya estaba instalado) y **no se instaló nada global**:

```bash
cd mutation-tests-platzi-demo
uv venv --python 3.13 .venv
uv pip install --python .venv/bin/python "pytest==8.4.2" "pytest-cov==7.0.0" "mutmut==3.3.1"
```

- `uv venv` crea el entorno virtual con el Python 3.13 de pyenv.
- `uv pip install` instala las tres dependencias **dentro** del `.venv`, con versión exacta.

> ⚠️ **Parche de macOS en mutmut.** Sin él, los 19 mutantes terminan en `segfault`: el proceso
> hijo que mutmut crea con `fork()` muere al llamar a `setproctitle` (línea 1062 de
> `mutmut/__main__.py`). El arreglo fue anular esa función en la copia del `.venv`:
>
> ```bash
> sed -i '' 's/^from setproctitle import setproctitle$/def setproctitle(_title): pass/' \
>   .venv/lib/python3.13/site-packages/mutmut/__main__.py
> ```
>
> - `sed -i ''` edita el archivo en sitio (en macOS el sufijo vacío es obligatorio).
> - Sustituye el `import` por una función vacía con el mismo nombre; el resto de mutmut no cambia.
>
> Si algún día se recrea el `.venv`, hay que repetirlo. En Linux (y en WSL) no hace falta.

También quedó un `.venv311/` de una prueba con Python 3.11 que **no sirvió** (el fallo no
dependía de la versión). Se puede borrar.

## 3. ▶️ Los comandos de la clase, en orden

Siempre desde la raíz del repo y con el entorno activado:

```bash
source .venv/bin/activate
```

| Momento | Comando | Qué muestra |
|---|---|---|
| 0:00 | `pytest --cov=carrito` | `1 passed`, `carrito.py 100%` |
| 1:00 | (cambiar `and`→`or`, guardar) `pytest --cov=carrito` | sigue `1 passed`, sigue `100%` |
| 2:20 | `mutmut run` | `19/19 🎉 12 🙁 7` (menos de 5 s) |
| 2:40 | `mutmut results` | los 7 sobrevivientes |
| 2:50 | `mutmut show carrito.x_precio_final__mutmut_9` | el diff `and` → `or` |
| 3:20 | (descomentar el test, guardar) `mutmut run` | `🎉 14 🙁 5` |
| 4:00 | `mutmut results` | los 5 que quedan |

- `--cov=carrito` mide cobertura solo de ese módulo; sin `--cov-branch`, porque la clase es de
  un solo tema y las ramas quedan para «lo que sigue».
- `mutmut run` genera los mutantes en `mutants/`, corre los tests contra cada uno y guarda el
  resultado; si cambias un test, lo detecta y vuelve a correr sin limpiar nada.
- `mutmut show <nombre>` imprime el diff de un mutante concreto.

**Entre ensayos:** `./reset.sh` restaura el test comentado y borra `mutants/`, `.mutmut-cache`,
`.coverage` y `.pytest_cache` (todo regenerable).

## 4. 🪟 Windows: lo que falta (se hace en su sesión)

- **mutmut 3 no corre en Windows nativo**: usa `os.fork()`, que no existe ahí. La vía es
  **WSL2 con Debian** (ya lo tienes): el proyecto se copia dentro del sistema de archivos de
  WSL (no en `/mnt/c`, que es lento) y se abre con la extensión *Remote - WSL* de VS Code.
- Dentro de WSL hacen falta Python 3.13 y `uv` (o `python3 -m venv`); el parche de
  `setproctitle` **no** es necesario en Linux.
- pytest y pytest-cov sí corren en Windows nativo, pero conviene que todo el video salga de un
  mismo entorno. Decidir en la sesión de Windows si se graba desde WSL o solo desde el Mac.

## 5. 🧩 VS Code

- La extensión de Python de Microsoft **no está instalada** y no hace falta: todo corre en la
  terminal integrada. Si la instalas, `settings.json` ya apunta al intérprete del `.venv`.
- Disposición para grabar: explorador cerrado (Cmd+B), `carrito.py` y `test_carrito.py` en dos
  pestañas, terminal abajo ocupando un tercio de la altura. La cámara va en la esquina inferior
  derecha, así que las salidas largas se leen por el lado izquierdo (todas caben en 8 líneas).

# mutation-tests-platzi-demo

Demo de **cobertura frente a *mutation testing***: `carrito.py` tiene 100 % de cobertura con
unos pocos tests y aun así `mutmut` encuentra mutantes que ningún test detecta (entre ellos,
`and` → `or`). La idea de fondo: **la cobertura dice qué código ejecutaron los tests, no qué
verificaron**.

🎬 **Video de la clase demo:** <https://youtu.be/tBB-hvl7KLM>

El repo tiene dos usos:

1. **La demo en sí**: código, tests, configuración de pytest-cov y mutmut, y un `reset.sh` para
   volver al estado inicial entre ensayos.
2. **Proyecto base para grabar pantalla y sesiones**: un workspace de VS Code preparado para que
   el código se lea en video, una terminal limpia y la guía de OBS. Sirve como plantilla para
   futuras clases: se cambia el código, se conserva el montaje.

Versiones fijadas: Python 3.14.9 (pyenv, en `.python-version`), pytest 8.4.2, pytest-cov 7.0.0,
mutmut 3.8.0.

## Contenido

| Ruta | Qué es |
|---|---|
| `carrito.py` | El código bajo prueba: `precio_final()` con cupón y descuento VIP |
| `tests/test_carrito.py` | Los tests de la demo |
| `pyproject.toml` | Configuración de pytest, coverage y mutmut |
| `requirements.txt` | Dependencias con versión exacta |
| `reset.sh` | Deja la demo como al inicio de la clase |
| `salidas/` | Salidas de referencia de cada paso, capturadas en los ensayos |
| `mutation-tests-platzi-demo.code-workspace` | Workspace de VS Code para grabar (ver abajo) |
| `.zsh-video/` | Configuración de zsh solo para la terminal del workspace |
| `Platzi-Video/` | Material de la clase: guion, setup, OBS y la guía de Platzi |

## Crear el entorno desde cero

```bash
pyenv install -s 3.14.9          # -s: no hace nada si ya está instalada
cd ~/Developer/Learning/Python/mutation-tests-platzi-demo
python -m venv .venv             # usa el 3.14.9 que fija .python-version
source .venv/bin/activate
pip install -r requirements.txt
```

- `.python-version` hace que pyenv use 3.14.9 dentro de esta carpeta, sin tocar la versión global.
- `.venv/` no se versiona; si se borra, se recrea con los tres últimos comandos.
- **Si se renombra o se mueve la carpeta, hay que recrear `.venv`**: los scripts de `.venv/bin`
  guardan la ruta absoluta del intérprete y fallan con `bad interpreter`.
  `rm -rf .venv` y repetir los tres últimos comandos.

## Las pruebas

### El código

```python
def precio_final(subtotal, cupon=None, es_vip=False):
    total = subtotal
    if cupon == "BIENVENIDO":      # cupón: 10 % de descuento
        total = total * 0.90
    if es_vip and total > 100:     # VIP: 10 menos, solo si el total pasa de 100
        total = total - 10
    return round(total, 2)         # redondeo a centavos
```

### Los tests

| Test | Caso | Esperado | Qué cubre |
|---|---|---|---|
| `test_vip_con_cupon` | 200, cupón, VIP | 170.0 | Las dos reglas encadenadas: 200 → 180 → 170 |
| `test_vip_compra_grande` | 200, VIP | 190.0 | Solo el descuento VIP |
| `test_normal_compra_chica` | 50, nada | 50.0 | Sin descuentos |
| `test_normal_compra_grande` | 200, nada | 200.0 | **El test que faltaba**: un cliente normal con total > 100 no recibe el descuento VIP |

Con los tres primeros, la cobertura ya es 100 %: cada línea se ejecuta. Pero ninguno distingue
`es_vip and total > 100` de `es_vip or total > 100`, porque en todos los casos con total > 100
el cliente es VIP. El cuarto test es el que mata ese mutante; `reset.sh` lo quita para que en la
clase se escriba en vivo.

### Configuración de las herramientas (`pyproject.toml`)

- **pytest**: `testpaths = ["tests"]`, `pythonpath = ["."]` (para que `from carrito import …`
  funcione sin instalar el paquete) y `addopts = "-q"` (salida corta, cabe en pantalla).
- **coverage**: `branch = false` a propósito, para mostrar primero la cobertura de líneas, que es
  la que da el 100 % engañoso. El bloque `if __name__ == "__main__":` se excluye del cálculo
  porque los tests no lo ejecutan.
- **mutmut**: `source_paths = ["carrito.py"]` y `pytest_add_cli_args_test_selection = ["tests/"]`.
- **No** se ponen los `--cov…` en `addopts`: mutmut corre pytest con esas opciones y todos los
  mutantes terminan en `segfault`.

### Comandos de la demo, en orden

```bash
pytest --cov=carrito --cov-report=term --cov-report=xml   # 3 passed, carrito.py 100%
python carrito.py                             # Precio final: 200
# cambiar `and` por `or` en la línea 11
python carrito.py                             # Precio final: 190  ← bug
pytest --cov=carrito --cov-report=term --cov-report=xml   # sigue 3 passed y 100%
# deshacer el `or`
mutmut run                                    # 19/19  🎉 12  🙁 7
mutmut results                                # los 7 sobrevivientes
mutmut show carrito.x_precio_final__mutmut_9  # el diff and → or
# añadir test_normal_compra_grande a tests/test_carrito.py
rm -r mutants && mutmut run                   # 19/19  🎉 14  🙁 5
mutmut results                                # los 5 que quedan
./reset.sh                                    # vuelve al estado inicial
```

### Los 5 mutantes que siguen vivos

Con los cuatro tests quedan estos sobrevivientes. Son el punto de partida natural para una
segunda clase:

| Mutante | Cambio | Por qué sobrevive | Test que lo mataría |
|---|---|---|---|
| `mutmut_10` | `total > 100` → `total >= 100` | Ningún test usa exactamente 100 | `precio_final(100, es_vip=True) == 100.0` |
| `mutmut_11` | `total > 100` → `total > 101` | Ningún test cae entre 100 y 101 | `precio_final(100.5, es_vip=True) == 90.5` |
| `mutmut_16` | `round(total, 2)` → `round(total, None)` | Todos los resultados son enteros | Un precio con centavos, p. ej. `precio_final(19.99, cupon="BIENVENIDO") == 17.99` |
| `mutmut_18` | `round(total, 2)` → `round(total, )` | Igual que el anterior | El mismo test con centavos |
| `mutmut_19` | `round(total, 2)` → `round(total, 3)` | Ningún resultado tiene tres decimales | El mismo test con centavos: 19.99 × 0.9 = 17.991, que con 3 decimales ya no da 17.99 |

Lección: los **valores frontera** (100, 100.01) y los **decimales** son justo lo que los tests
«de caso feliz» no tocan.

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

## Proyecto base para grabar pantalla

Todo lo que sigue está pensado para que **el código se lea en un video comprimido** y que **no
aparezca nada que distraiga**. Para reutilizarlo en otra clase basta con copiar el
`.code-workspace` y `.zsh-video/`, y cambiar el código.

Se abre con `code mutation-tests-platzi-demo.code-workspace` (o *File → Open Workspace from
File…*). Los ajustes viven en el workspace y no en la configuración de usuario, así que solo
afectan a este proyecto: el VS Code del día a día queda intacto.

### Legibilidad

| Ajuste | Valor | Por qué |
|---|---|---|
| `editor.fontSize` | 20 | La guía de Platzi pide 20 pt o más; se lee incluso en móvil |
| `editor.lineHeight` | 26 | Aire entre líneas sin perder líneas visibles |
| `terminal.integrated.fontSize` / `lineHeight` | 18 / 1.3 | La terminal cabe con las salidas de pytest y mutmut sin cortar líneas |
| `window.zoomLevel` | 1 | Agranda también menús, pestañas y paneles, no solo el código |
| `editor.fontFamily` / `terminal.integrated.fontFamily` | Lucida Console, Menlo… | Monoespaciada muy legible; la misma en editor y terminal |
| `markdown.preview.fontSize` | 18 | Por si se muestra un `.md` en vista previa |
| `workbench.colorTheme` | Best Themes - Github Dark | Tema oscuro de contraste alto que comprime bien en video |
| `workbench.colorCustomizations` (terminal) | Paleta GitHub Dark | La terminal usa los mismos colores que el editor; verde y rojo de pytest se distinguen bien |
| `editor.cursorBlinking` | solid | Un cursor que parpadea distrae y genera artefactos al comprimir |
| `editor.wordWrap` | off | Las líneas no saltan de forma inesperada al teclear |
| `editor.renderWhitespace` | none | Sin puntos de espacios ensuciando la pantalla |
| `editor.lineNumbers` | on | Se puede decir «en la línea 11» y el público la encuentra |

### Pantalla limpia

| Ajuste | Por qué |
|---|---|
| `editor.minimap.enabled: false` | Gana ancho para el código y quita ruido visual |
| `workbench.activityBar.location: hidden` | Oculta la barra de iconos lateral |
| `workbench.statusBar.visible: false` | Oculta la barra de estado (rama, intérprete, notificaciones) |
| `breadcrumbs.enabled: false` | Una línea menos sobre el código |
| `editor.stickyScroll.enabled`, `terminal.integrated.stickyScroll.enabled: false` | Sin encabezados pegados que tapan líneas al hacer scroll |
| `terminal.integrated.shellIntegration.decorationsEnabled: never` | Quita los círculos de éxito/error junto a cada comando |
| `files.exclude` | Oculta `.venv`, `mutants`, cachés, `coverage.xml`, `.zsh-video`… en el explorador: solo se ve lo que se explica |
| `zenMode.*` | Si se usa Zen Mode, mantiene números de línea, barra de estado y diseño normal |

### Sin ayudas que se adelanten

Se apagan **todas** las sugerencias y la IA del editor: en una clase el público tiene que ver
lo que se teclea, no un texto fantasma que aparece solo, ni un popup que tapa el código.

- `editor.inlineSuggest.enabled`, `editor.quickSuggestions`, `editor.suggestOnTriggerCharacters`,
  `editor.wordBasedSuggestions`, `editor.snippetSuggestions`, `editor.parameterHints.enabled`:
  sin autocompletado ni ayudas emergentes.
- `editor.acceptSuggestionOnEnter: off`: Enter siempre es salto de línea.
- `github.copilot.enable: false` y `chat.disableAIFeatures: true`: sin Copilot ni chat.

### Comportamiento predecible

- `workbench.editor.enablePreview*: false`: cada archivo abre en su propia pestaña fija; no se
  reemplazan pestañas al navegar.
- `editor.mouseWheelZoom` y `terminal.integrated.mouseWheelZoom: false`: un Cmd + rueda accidental
  no cambia el tamaño de letra a mitad de toma.
- `files.trimTrailingWhitespace` y `files.insertFinalNewline`: los archivos quedan limpios para git.
- `python.defaultInterpreterPath` y `python.testing.pytestEnabled`: VS Code usa el `.venv` del
  proyecto y reconoce los tests.
- `claudeCode.useTerminal`, `claudeCode.useCtrlEnterToSend`: Claude Code en la terminal y con
  Ctrl+Enter para enviar, para no mandar mensajes por error.

### La terminal (`.zsh-video/`)

`terminal.integrated.env.osx` pone `ZDOTDIR=${workspaceFolder}/.zsh-video`, así que la terminal
de este workspace arranca con su propia configuración de zsh:

- Carga primero los `~/.zshenv`, `~/.zprofile` y `~/.zshrc` de siempre (PATH, pyenv…).
- Cambia el prompt a `% `: sin usuario, máquina, ruta ni rama que ocupen media línea o revelen
  datos personales.
- Activa el `.venv` del proyecto: `pytest` y `mutmut` funcionan sin escribir `source`.

Solo aplica en macOS (`env.osx`). Fuera del workspace, la terminal no cambia.

### Extensiones recomendadas

- `lakshits11.best-themes-redefined`: el tema GitHub Dark.
- `ryanluker.vscode-coverage-gutters`: la cobertura pintada en el editor.

VS Code las ofrece al abrir el workspace.

## OBS y material de la clase

En [`Platzi-Video/`](Platzi-Video/) está todo lo de la grabación:

| Documento | Para qué |
|---|---|
| [`01-guion.md`](Platzi-Video/01-guion.md) | Guion cronometrado: qué se dice y qué se ve, segundo a segundo |
| [`04-guion-lectura-previa.md`](Platzi-Video/04-guion-lectura-previa.md) | La clase en prosa, para leerla antes |
| [`02-setup-proyecto.md`](Platzi-Video/02-setup-proyecto.md) | Cómo dejar VS Code y la terminal listos |
| [`03-obs-macos.md`](Platzi-Video/03-obs-macos.md) | **Configuración de OBS en macOS** paso a paso |
| [`guia democlass.pdf`](Platzi-Video/guia%20democlass.pdf) | La guía de Platzi para la demo class |

La guía de OBS cubre permisos de macOS, resolución (canvas igual a la pantalla, salida
1920×1248 con Lanczos para que el texto se lea), grabación en Hybrid MP4 con encoder por
hardware, audio mono de la diadema sin audio del sistema, hotkey para iniciar/parar, la escena
con la cámara en la esquina inferior derecha y una prueba de 30 s antes de la toma.

**Windows:** por ahora solo hay notas breves de lo que cambia (§7 de `03-obs-macos.md` y §4 de
`02-setup-proyecto.md`). **Más adelante se agregarán las instrucciones completas para Windows**:
OBS y la configuración equivalente del workspace y la terminal.

## Ideas para el futuro

**Pruebas**

- Matar los 5 mutantes restantes con tests de frontera y de decimales (tabla de arriba).
- Pasar los tests a `@pytest.mark.parametrize`: una tabla de casos en lugar de una función por
  caso.
- Activar `branch = true` en coverage y comparar: la cobertura de ramas detecta algunos huecos,
  pero no el `and` → `or`; mutation testing sigue haciendo falta.
- Probar *property-based testing* con Hypothesis: propiedades como «el precio final nunca es
  mayor que el subtotal» o «nunca es negativo».
- Ampliar `carrito.py` (varios cupones, cupones inválidos, subtotal negativo, `Decimal` en vez
  de `float` para dinero) y ver cómo crece el número de mutantes.
- Un umbral mínimo: `--cov-fail-under=100` y un tope de mutantes sobrevivientes.
- Integrar pytest-cov y mutmut en CI (GitHub Actions), con mutmut solo sobre los archivos
  cambiados para que no sea lento.
- Comparar con otras herramientas: `cosmic-ray` en Python, Stryker en JavaScript/TypeScript,
  PIT en Java.
- Mostrar el reporte HTML (`--cov-report=html`) y el navegador de mutantes (`mutmut browse`).

**Montaje de grabación**

- Instrucciones completas de OBS y del workspace para Windows (PowerShell o Git Bash en lugar
  de zsh, `terminal.integrated.env.windows`).
- Un `.code-workspace` de plantilla, sin lo específico de esta demo, para arrancar cualquier
  clase nueva.
- Un perfil de VS Code (*Profiles*) «Grabación» como alternativa al workspace.
- Una escena de OBS solo con cámara para la intro y el cierre, y exportar la colección de
  escenas al repo.
- Un script de «modo grabación» que active No molestar, oculte el Dock y cierre apps ruidosas.
- Subtítulos automáticos y capítulos en YouTube a partir del guion cronometrado.

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

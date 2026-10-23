# 🎙️ Guion cronometrado · 4:30 (tope 5:00)

> **Cómo usarlo:** no se lee. Cada bloque trae **lo que se ve** (acción en pantalla) y **las
> frases clave** (las ideas, con tus palabras). Las citas en cursiva son sugerencias de
> redacción, no texto para memorizar. Las salidas de terminal son las reales de este Mac.
>
> **Proyecto que se graba:** `~/Developer/Learning/Python/mutation-tests` (Python 3.14.9,
> mutmut 3.8.0), abierto con `mutation-tests.code-workspace`. Los comandos, en orden, están en
> la [guía de comandos](04-guion-lectura-previa.md#️-guía-de-comandos) del guion de lectura.

**Regla de la guía que manda aquí:** *primero la acción, después la teoría*. Cada explicación
va **después** de algo que acaba de pasar en pantalla.

---

## 0:00 – 0:15 · Gancho y promesa (sin saludo)

**Se ve:** VS Code con `carrito.py` arriba, la función completa a la vista (líneas 2–14), y la
terminal abajo, vacía: `(.venv) % `. Todavía no hay verde.

**Frases clave:**

- *En los próximos minutos le voy a meter a este código un bug de negocio, y sus tests van a
  seguir en verde, con cien por ciento de cobertura.*
- **La promesa, en una frase:** *Al final vas a poder encontrar, con un comando, qué partes de
  tu código tus tests ejecutan pero no verifican.*

> La idea central ya está dicha antes del segundo quince: **ejecutar no es verificar**.

## 0:15 – 0:35 · El código y los tests (5 segundos para los tests)

**Se ve:** `carrito.py` y, después, la pestaña `tests/test_carrito.py`.

```python
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
```

**Frases clave:**

- *Un carrito: cupón de bienvenida del 10 % y, si el cliente es VIP y lleva más de 100, diez de
  descuento.*
- **Los tests, en cinco segundos:** sombrea cada nombre mientras lo dices. *Tres casos: VIP con
  cupón, VIP con compra grande, cliente normal con compra chica.* Vuelve a `carrito.py`.

## 0:35 – 1:00 · Acción 1: medir la cobertura, tecleando

**Se ve:** escribes el comando en la terminal, explicando cada opción **mientras la tecleas**, y
Enter. Al terminar, las líneas de `carrito.py` se pintan de verde solas (el Watch de Coverage
Gutters quedó activado antes de grabar).

```
(.venv) % pytest --cov=carrito --cov-report=term --cov-report=xml
Name         Stmts   Miss  Cover
--------------------------------
carrito.py       7      0   100%
--------------------------------
TOTAL            7      0   100%
Coverage XML written to file coverage.xml
3 passed in 0.02s
```

**Frases clave, una por opción:**

- `--cov=carrito`: *mide la cobertura de este módulo.*
- `--cov-report=term`: *la tabla, aquí en la terminal.*
- `--cov-report=xml`: *y un archivo que el editor usa para pintar las líneas ejecutadas.*
- *Tres pasan. Cien por ciento. Todo en verde.*

## 1:00 – 1:50 · Acción 2: el main y el sabotaje a mano

**Se ve:** al final de `carrito.py` (scroll para que se vean a la vez la línea 11 y el final)
escribes el main, guardas y lo corres:

```python
if __name__ == "__main__":
    print("Cliente normal paga:", precio_final(200))
```

```
(.venv) % python carrito.py
Cliente normal paga: 200
```

Luego cambias `and` por `or` en la línea 11, guardas, **↑ Enter** (repite el `python`) y
**↑ ↑ Enter** (repite el `pytest`):

```
(.venv) % python carrito.py
Cliente normal paga: 190

(.venv) % pytest --cov=carrito --cov-report=term --cov-report=xml
carrito.py       7      0   100%
3 passed in 0.02s
```

**Frases clave:**

- Con el main: *Un cliente normal, sin cupón, compra 200. Paga 200. Correcto.*
- **Pregunta al estudiante (pausa de 2 segundos):** *Si cambio este `and` por un `or`, ¿qué test
  falla?* Señala la línea con el cursor.
- Tras el `python`: *Ahora paga 190. Acabo de regalarle 10 de descuento a un cliente que no es VIP.*
- Tras el `pytest`: *¿Y mis tests? Tres pasan. Cien por ciento. Y mira el `or`: verde, cubierto.*
  Es el momento visual de la clase; señálalo con el cursor.
- *Deshago el cambio* (Cmd+Z una vez, solo el `or`; el main se queda. Cmd+S).

> El main **no cuenta en la cobertura**: `pyproject.toml` lo excluye con `exclude_also`. Sin
> eso, la tabla bajaría a 89 % y se perdería el «cien por ciento».

## 1:50 – 2:20 · Teoría, ahora sí: qué mide la cobertura

**Se ve:** la terminal con el 100 % todavía visible; tú hablas a cámara.

**Frases clave, la idea dicha de dos formas:**

1. *La cobertura cuenta líneas que se ejecutaron. Esa línea se ejecutó con `and` y con `or`:
   para la cobertura son idénticas. Lo que verifica es el `assert`, y en mis tres casos las dos
   condiciones van juntas, o las dos o ninguna. Ahí `and` y `or` dan lo mismo.*
2. **Analogía:** *La cobertura es la lista de asistencia: dice quién entró al salón, no quién
   aprendió. Para eso hay que poner un examen. Y el examen de tus tests es lo que viene ahora.*

## 2:20 – 3:15 · Acción 3: que la herramienta sabotee por ti

**Se ve:** terminal.

```
$ mutmut run
⠼ 19/19  🎉 12 🫥 0  ⏰ 0  🤔 0  🙁 7  🔇 0  🧙 0

$ mutmut results
    carrito.x_precio_final__mutmut_1: survived
    carrito.x_precio_final__mutmut_9: survived
    carrito.x_precio_final__mutmut_10: survived
    carrito.x_precio_final__mutmut_11: survived
    carrito.x_precio_final__mutmut_16: survived
    carrito.x_precio_final__mutmut_18: survived
    carrito.x_precio_final__mutmut_19: survived

$ mutmut show carrito.x_precio_final__mutmut_9
-    if es_vip and total > 100:
+    if es_vip or total > 100:
```

**Frases clave:**

- **Mientras escribes `mutmut run`, una frase:** *mutmut se instala con `pip install mutmut`,
  igual que pytest-cov. Aquí ya lo tengo en el entorno virtual del proyecto.* No se activa nada
  en cámara: el `(.venv) % ` del prompt ya lo muestra.
- *Lo que hice a mano se llama **mutante**: un cambio pequeño en el código. `mutmut` genera
  todos los que puede, 19 en este archivo, y corre los tests contra cada uno. Si algún test
  falla, el mutante murió: 🎉, doce. Si todos pasan, el mutante **sobrevivió**: 🙁, siete.*
- *Y el número 9 es exactamente mi `or`. Cada sobreviviente es un test que te falta.*
- **Anécdota (con tus palabras, 15 segundos):** en un trabajo anterior, un servicio de pagos
  con cobertura alta; un refactor cambió una condición de negocio, la suite pasó y el error llegó
  a producción. La pregunta no fue «¿por qué no había tests?» sino «¿por qué ninguno lo vio?».
  *Desde entonces, cuando alguien me dice «tenemos 90 % de cobertura», yo pregunto «¿y cuántos
  mutantes sobreviven?».*

## 3:15 – 3:55 · Acción 4: matar el mutante

**Se ve:** en `tests/test_carrito.py` descomentas el test que está al final (seleccionar las dos
líneas de código comentadas, Cmd+/), guardas, `rm -r mutants && mutmut run`.

```python
def test_normal_compra_grande():
    assert precio_final(200) == 200.0
```

```
$ rm -r mutants && mutmut run
⠦ 19/19  🎉 14 🫥 0  ⏰ 0  🤔 0  🙁 5  🔇 0  🧙 0
```

> ⚠️ **El `rm -r mutants` es obligatorio.** mutmut 3.8.0 detecta el test nuevo pero conserva el
> «survived» de cada mutante que ya probó; sin borrar `mutants/`, la corrida sigue en 7. Dilo en
> voz alta como lo que es: *borro los resultados anteriores y lo corro de nuevo*.

**Frases clave:**

- *Borro los resultados anteriores y lo corro de nuevo.* (mientras escribes el comando)
- *Probé VIP y no VIP, compra grande y chica, pero nunca las crucé. El caso que faltaba es el del
  main: cliente normal con compra grande, paga 200. Lo convierto en test: una línea. Catorce muertos, cinco vivos: el `or` ya no
  sobrevive, y de paso cayó otro que cambiaba el valor por defecto de `es_vip`.*
- *Fíjate que la cobertura no se movió: era 100 % antes y es 100 % ahora. Lo que cambió es lo que
  los tests **verifican**.*

## 3:55 – 4:30 · Cierre con lo que sigue (sin despedida)

**Se ve:** `mutmut results` con los 5 que quedan.

**Frases clave:**

- *Quedan cinco. Dos viven en el límite: `> 100` contra `>= 100`. Tres viven en el redondeo.
  ¿Cuáles vale la pena matar y cuáles son ruido? Y, en un proyecto de 300 archivos, ¿cómo corres
  esto en el CI sin que tarde una hora?*
- *Eso es la siguiente clase.* Y se corta.

---

## 🩺 Si algo falla en la toma

| Qué pasa | Qué haces |
|---|---|
| `mutmut run` tarda o muestra `segfault` | Con mutmut 3.8.0 no debería pasar (el parche de [02 §2](02-setup-proyecto.md#2--macos-lo-que-ya-está-hecho) era para 3.3.1); si pasa en vivo, abre `salidas/` y lee de ahí, sin cortar |
| Tras descomentar el test siguen 7 sobrevivientes | Olvidaste el `rm -r mutants`: córrelo y repite `mutmut run` |
| Te equivocas al escribir | Sigue. La guía lo dice: una clase de verdad |
| Pasas de 4:30 en el bloque de teoría | Salta directo a `mutmut run`; la anécdota se acorta a una frase. El tope de Platzi es 5:00 |
| No aparece el verde tras el primer pytest | Cmd+Shift+7 (Display Coverage) y sigue; no lo expliques |
| ↑ trae el comando equivocado | Sigue pulsando ↑ hasta el que toca; el historial es `pytest` → `python` → … |
| El main no imprime nada | Falta guardar (Cmd+S) o la indentación del `print`; corrígelo en vivo, es una línea |
| Olvidas la pregunta al estudiante | Hazla antes de descomentar el test: *«¿qué test escribirías tú?»* |

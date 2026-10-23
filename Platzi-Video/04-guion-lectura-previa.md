# 📖 Guion de lectura previa · texto completo, ≈ 4:45

> **Qué es:** la clase escrita tal como se diría, de corrido, para leerla dos o tres veces
> **antes** de grabar y quedarse con el hilo, no con las palabras. No va en pantalla ni en
> teleprompter: la guía de Platzi dice que leer se nota siempre. Unas 680 palabras habladas,
> unos 4:30 a tu ritmo; con el tecleo (pytest y main) se acerca a 5:00, el tope de Platzi. Si en el
> ensayo pasas de 4:50, recorta primero la analogía y luego la anécdota. Las acotaciones entre corchetes son acciones, no se dicen.
> El guion por bloques, con las salidas exactas, sigue en [`01-guion.md`](01-guion.md). Los
> comandos, en orden, están en la [guía de comandos](#️-guía-de-comandos) al final.

---

[Pantalla: VS Code con `carrito.py` y la terminal vacía. Todavía no hay verde.]

En los próximos minutos le voy a meter a este código un bug de negocio, y sus tests van a
seguir en verde, con cien por ciento de cobertura. Al final vas a poder encontrar, con un solo
comando, qué partes de tu código tus tests ejecutan pero no verifican. Porque eso es lo que
vamos a ver hoy: ejecutar no es verificar.

[Señalar `carrito.py` con el cursor.]

Esto es un carrito de compras. Si el cliente trae el cupón de bienvenida, le descuento el diez
por ciento. Y si es VIP y lleva más de cien, le quito diez más.

[Pestaña `test_carrito.py`; sombrear cada nombre de test mientras se dice. Cinco segundos.]

Mis tests: tres casos. VIP con cupón, VIP con compra grande, y cliente normal con compra chica.

[Volver a `carrito.py`. En la terminal, teclear el comando explicando cada opción al escribirla.]

Mido la cobertura. `pytest`, con `--cov=carrito` para medir este módulo, `--cov-report=term`
para ver la tabla aquí, y `--cov-report=xml`, un archivo que el editor usa para pintar las
líneas que se ejecutaron.

[Enter. Las líneas se pintan de verde.]

Tres pasan. Cien por ciento. Todo en verde.

[Scroll hasta ver la línea 11 y el final del archivo. Dos Enter después del `return` y escribir,
hablando mientras se teclea:]

```python
if __name__ == "__main__":
    print("Cliente normal paga:", precio_final(200))
```

Ahora uso la función como la usaría el programa. Le agrego un main: este bloque solo corre
cuando ejecuto el archivo directamente, no cuando lo importan los tests. Y le pido que imprima
cuánto paga un cliente normal, sin cupón y sin VIP, que compra doscientos.

[Cmd+S. En la terminal: `python carrito.py` → `Cliente normal paga: 200`.]

Paga doscientos. Correcto: no es VIP, no hay descuento.

[Cursor en la línea del `and`.]

Piénsalo un segundo. Si yo cambio este `and` por un `or`, ¿qué test falla?

[Pausa de dos segundos. Cambiar `and` por `or`, guardar, ↑ Enter.]

Ahora el mismo cliente paga ciento noventa. Acabo de regalarle diez de descuento a alguien que
no es VIP.

[↑ ↑ Enter: el pytest.]

¿Y mis tests? Tres pasan. Cien por ciento. Y mira el `or`: verde, cubierto. Mi suite dice que
todo está perfecto.

[Cmd+Z una vez, solo el `or`; el main se queda. Guardar.]

Lo deshago. ¿Qué pasó? La cobertura cuenta líneas que se ejecutaron. Esta línea se ejecutó con
`and` y con `or`: para la cobertura son idénticas. Lo que verifica es el `assert`, y en mis tres
casos las dos condiciones van juntas: o el cliente es VIP y compra mucho, o no es VIP y compra
poco. Ahí `and` y `or` dan lo mismo.

Dicho de otra manera: la cobertura es la lista de asistencia. Dice quién entró al salón, no
quién aprendió. Para eso hay que poner un examen. Y el examen de tus tests es lo que viene
ahora.

[Terminal: `mutmut run`.]

Lo que acabo de hacer a mano, cambiar una cosita en el código a ver si alguien se da cuenta,
se llama un mutante. Y hay una herramienta que lo hace por ti con todos los cambios que se le
ocurran. Se llama mutmut, y se instala con `pip install mutmut`, igual que pytest-cov; aquí
ya lo tengo en el entorno virtual del proyecto. Le digo que corra, y mira: diecinueve
mutantes para esta función tan corta. Contra cada uno corre los tests. Si algún test falla, el mutante murió: esos son
los doce de la carita feliz. Si todos los tests pasan, el mutante sobrevivió. Siete.

[`mutmut results`, luego `mutmut show carrito.x_precio_final__mutmut_9`.]

Veamos quiénes son. Y el número nueve... es exactamente mi `or`. Cada mutante que sobrevive es
un test que te falta.

Esto lo aprendí por un incidente. En un trabajo anterior teníamos un servicio de pagos con
cobertura alta. Un refactor tocó una condición de negocio, pasó todas las pruebas y nos
enteramos en producción. La pregunta no fue «¿por qué no había tests?», sino «¿por qué ninguno
lo vio?». Desde entonces, cuando alguien me dice «tenemos noventa por ciento de cobertura», yo
pregunto: ¿y cuántos mutantes sobreviven?

[En `test_carrito.py`, seleccionar las dos líneas de código comentadas, Cmd+/, guardar.]

Matemos el nuestro. ¿Qué test escribirías tú? Probé VIP y no VIP, compra grande y chica, pero
nunca las crucé. El caso que faltaba es el del main: cliente normal con compra grande, paga
doscientos. Lo convierto en test. Una línea.

[`rm -r mutants && mutmut run`.]

Borro los resultados anteriores y lo corro de nuevo. Catorce muertos, cinco vivos. El `or` ya
no sobrevive. Y de paso cayó otro que cambiaba el valor por defecto de `es_vip`, que tampoco estaba probado. Fíjate en una cosa: la cobertura no se
movió. Era cien por ciento antes y es cien por ciento ahora. Lo que cambió es lo que los tests
verifican.

[`mutmut results`.]

Quedan cinco. Dos viven en el límite: mayor que cien contra mayor o igual que cien. Tres viven
en el redondeo. ¿Cuáles vale la pena matar y cuáles son ruido? Y en un proyecto de trescientos
archivos, no de uno, ¿cómo corres esto en el CI sin que tarde una hora?

Eso es la siguiente clase.

[Cortar.]

---

## ⌨️ Guía de comandos

Todo se escribe en la terminal integrada de VS Code, dentro de
`~/Developer/Learning/Python/mutation-tests`.

### Antes de pulsar «grabar» (no sale en el video)

1. En la terminal: `./reset.sh`. Restaura `carrito.py` (sin main y con `and`) y
   `tests/test_carrito.py` (con el test que falta comentado), y borra `mutants/`, `.coverage`,
   `coverage.xml`, `htmlcov/` y las cachés. Las pestañas abiertas se recargan solas.
2. **Cmd+Shift+P → «Developer: Reload Window».** Borra el verde que quede pegado de un ensayo
   anterior (los atajos de Remove Coverage no siempre lo quitan después de `reset.sh`) y, al
   volver a cargar, Coverage Gutters arranca el Watch solo: el workspace tiene
   `coverage-gutters.watchOnActivate`. No pinta nada porque no hay `coverage.xml`; pintará en
   cuanto el pytest de la clase lo escriba.
3. **Cmd+K** en la terminal: vacía, solo `(.venv) % `. La clase empieza sin ninguna salida.
- Si tras el pytest no aparece el verde: clic en el código de `carrito.py` y **Cmd+Shift+8**
  (Watch). Los atajos de Coverage Gutters solo actúan con el foco en el editor, no en la terminal.
- La terminal del workspace ya abre en la carpeta del proyecto, con el `.venv` activado y el
  prompt corto `(.venv) % `: lo hace `.zsh-video/.zshrc`, que el workspace carga mediante
  `terminal.integrated.env.osx`. Si el prompt sale largo, abre una terminal nueva; si `mutmut`
  responde `command not found`, `source .venv/bin/activate` a mano.
- Pantalla: barra lateral cerrada (Cmd+B), `carrito.py` y `test_carrito.py` en dos pestañas,
  `carrito.py` al frente, terminal abierta abajo en un tercio de la altura.

### Durante la clase

| Momento | Acción o comando | Qué debes ver |
|---|---|---|
| 0:00 | Nada: `carrito.py` a la vista, terminal vacía | — |
| 0:25 | Pestaña `test_carrito.py`: sombrear (doble clic) los tres nombres, 5 s; volver a `carrito.py` | — |
| 0:35 | Teclear `pytest --cov=carrito --cov-report=term --cov-report=xml`, explicando cada opción; Enter | `3 passed`, `carrito.py 100%`; las líneas se pintan de verde |
| 1:00 | Scroll al final; escribir el main (dos líneas); Cmd+S; `python carrito.py` | `Cliente normal paga: 200` |
| 1:15 | Cursor en el `and` de la línea 11; pregunta; pausa | — |
| 1:20 | `and` → `or`, Cmd+S, **↑ Enter** | `Cliente normal paga: 190` |
| 1:30 | **↑ ↑ Enter** (el pytest) | sigue `3 passed`, `100%` y el `or` en verde |
| 1:45 | Cmd+Z **una vez** (solo el `or`), Cmd+S | el `and` de vuelta; el main se queda |
| 2:20 | `mutmut run` | `19/19  🎉 12 … 🙁 7` |
| 2:35 | `mutmut results` | siete líneas `survived` |
| 2:45 | `mutmut show carrito.x_precio_final__mutmut_9` | el diff `and` → `or` |
| 3:15 | Pestaña `test_carrito.py`, seleccionar `# def …` y `#     assert …`, Cmd+/, Cmd+S | `test_normal_compra_grande` sin `#` |
| 3:25 | `rm -r mutants && mutmut run` | `19/19  🎉 14 … 🙁 5` |
| 3:55 | `mutmut results` | cinco líneas `survived` |

- **Solo las dos líneas de código** del test se descomentan; las dos de explicación que hay
  encima se quedan como comentario.
- **El `rm -r mutants` no se salta**: sin él, mutmut conserva los veredictos anteriores y sigue
  mostrando 7 sobrevivientes.
- **El main**, tal cual, al final de `carrito.py` (dos líneas en blanco antes; VS Code indenta
  solo tras los dos puntos):
  ```python
  if __name__ == "__main__":
      print("Cliente normal paga:", precio_final(200))
  ```
  No baja la cobertura: `pyproject.toml` lo excluye con `exclude_also`.
- **Historial con ↑:** tras el `python`, una ↑ trae el `python` y dos ↑ traen el `pytest`. Mira
  el comando antes de pulsar Enter.
- **Cmd+Z una sola vez** en el minuto 1:45: deshace el `or`. Si lo pulsas más, empieza a borrar
  el main.
- Entre ensayos, `./reset.sh` y vuelta al bloque «Antes de pulsar grabar».

## 🎤 Cómo leerlo para no leerlo

1. **Primera lectura** en silencio, entera, para el hilo: promesa → código → sabotaje → por qué →
   herramienta → anécdota → el test → lo que sigue.
2. **Segunda lectura** en voz alta con cronómetro, haciendo las acciones en VS Code. Anota dónde
   pasas de 4:30.
3. **Tercera, sin el texto.** Solo con los siete bloques de [`01-guion.md`](01-guion.md) a un
   lado, o ni eso. Si cambias las palabras, bien: la idea es la misma. Las únicas frases que
   conviene conservar casi literales son la **promesa** del principio, la **pregunta** al
   estudiante y la **última frase**.
4. `./reset.sh` entre lectura y lectura.

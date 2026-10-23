# 🎥 OBS en macOS (y Windows por si acaso) · pantalla + cámara en la esquina + diadema

> **Qué es:** el montaje de OBS 32.2.2 en el MacBook Pro M1 Pro (pantalla 3024×1964; con la escala actual, OBS la captura a 2704×1756) para
> grabar la demo class en **una sola toma**: pantalla completa, tu cara en la esquina inferior
> derecha con la cámara FaceTime HD, y la voz por la diadema Logitech USB. Orden: permisos →
> ajustes → escena → prueba de 30 s. La §7 repite lo que cambia si se graba desde el Dell XPS
> con Windows.

## 1. 🔐 Permisos de macOS (una sola vez)

Ajustes del Sistema → **Privacidad y seguridad**. OBS tiene que estar activado en tres listas:

| Lista | Qué habilita |
|---|---|
| **Grabación de pantalla y audio del sistema** | capturar el escritorio |
| **Cámara** | la FaceTime HD |
| **Micrófono** | la diadema |

Si OBS no aparece en una lista, abre OBS, intenta añadir la fuente correspondiente y macOS te
lo pedirá. **Después de dar un permiso, cierra y vuelve a abrir OBS.**

## 2. ⚙️ Ajustes (menú OBS → Preferences…, Cmd+,)

En macOS, el menú de la app dice **Preferences…** (o *Settings…*, según la versión): es la misma
ventana. También se abre con el botón **Settings** del panel *Controls*, abajo a la derecha.

**Video**

| Campo | Valor | Por qué |
|---|---|---|
| Base (Canvas) Resolution | `2704x1756` | lo que mide la captura de pantalla con la escala actual de macOS; el canvas igual a la pantalla, sin bandas ni recortes |
| Output (Scaled) Resolution | `1920x1248` (escríbelo a mano) | mismo aspecto, ancho 1080p; la letra de 20 pt se lee |
| Downscale Filter | Lanczos | el más nítido para texto |
| FPS | 30 | de sobra para pantalla y cara |

- **Las listas no traen esos valores fijos:** los dos campos se editan. Haz clic en el campo,
  borra y escribe `2704x1756` o `1920x1248`. El *Aspect Ratio* que muestra al lado no será 16:9, y está bien.
- **¿Por qué 2704×1756 y no 3024×1964?** OBS ofrece como base el tamaño de la captura, que
  depende de *Ajustes del Sistema → Pantallas* (la escala «se ve como»). Si cambias esa escala,
  cambia la base: usa siempre la que OBS propone primero en la lista.
- **No uses 1920x1080 como base:** la pantalla no es 16:9, así que la captura no cabe. O se
  recorta, o hay que encogerla con bandas negras a los lados, y la letra queda más pequeña.
  La guía de Platzi no pide 16:9, solo que la pantalla se lea.

**Output** (modo *Simple*)

| Campo | Valor |
|---|---|
| Recording Quality | High Quality, Medium File Size |
| Recording Format | Hybrid MP4 |
| Video Encoder | Hardware (Apple VT H264) |
| Audio Encoder | AAC |
| Recording Path | `~/Movies/platzi-demo/` (créala antes) |

- *Hybrid MP4* sobrevive si OBS se cierra mal a mitad de toma; el MP4 clásico no.
- El encoder por hardware del M1 no calienta la máquina ni roba CPU a pytest.

**Audio**

| Campo | Valor |
|---|---|
| Sample Rate | 48 kHz |
| Channels | Mono |
| Desktop Audio | **Disabled** |
| Mic/Auxiliary Audio | Logitech USB Headset |

- Desktop Audio apagado: no hay sonido del sistema en la clase y así no entra ninguna
  notificación.
- Mono porque la diadema es de un canal; en estéreo se oiría por un solo lado.

**Hotkeys**: asigna *Start Recording* y *Stop Recording* a `Cmd+Shift+R` (ambas a la misma
combinación funciona como interruptor). Así no tienes que volver a la ventana de OBS para parar.

## 3. 🎬 La escena

Una sola escena, `Demo`, con tres fuentes **en este orden** (lo de arriba tapa a lo de abajo):

| Orden | Fuente (tipo) | Ajuste |
|---|---|---|
| 1 (arriba) | `Camara` · **Video Capture Device** | Device: FaceTime HD Camera · Preset: 1280x720 |
| 2 | `Mic` · **Audio Input Capture** | Device: Logitech USB Headset |
| 3 (abajo) | `Pantalla` · **macOS Screen Capture** | Method: Display Capture · Show cursor: sí |

**Que la pantalla llene el lienzo sin deformarse.** Con `Pantalla` seleccionada, `Cmd+E` →
**Reset**: posición 0,0, tamaño 2704×1756 y *Bounds* en **Automatic** (en versiones anteriores a OBS 32, *No bounds*). Nunca *Stretch* a
1920×1080: aplasta la letra y deja bandas negras al reproducir en la pantalla del Mac.

**La franja negra de arriba es el notch.** VS Code a pantalla completa deja una banda negra a la
altura de la cámara del MacBook. Se quita recortándola: en el mismo `Cmd+E`, **Crop → Top**,
subiendo de a poco mirando la vista previa hasta que la banda desaparezca (en esta escala, unos
`74 px`). Luego, en Ajustes → Video, la base pasa a `2704x(1756 − recorte)` y la salida se
recalcula con el mismo aspecto: con 74 px, base `2704x1682` y salida `1920x1194`. La cámara se
recoloca con la nueva Y: `1682 − 32 = 1650`.

**Colocar la cámara en la esquina inferior derecha.** Con `Camara` seleccionada, Edit → Transform
→ **Edit Transform** (`Cmd+E`):

| Campo | Valor | Qué hace |
|---|---|---|
| Positional Alignment | Bottom Right | el punto de referencia pasa a ser la esquina inferior derecha de la cámara |
| Position | X `2672` · Y `1724` | 32 px de margen con el borde de la pantalla |
| Bounding Box Type | **Fit** (antes de OBS 32: *Scale to inner bounds*) | la cámara se ajusta a la caja sin deformarse |
| Bounding Box Size | `560 x 315` | un 21 % del ancho del lienzo de 2704: se ve la cara sin tapar la terminal |

Por qué esos números: la cámara es 16:9, así que `560x315` conserva el aspecto (con el preset `1280x720`; con *Medium* la cámara es 4:3); con alineación
inferior derecha, `Position` es dónde cae esa esquina, y `2704 − 32 = 2672`, `1756 − 32 = 1724`.

**Filtros del micrófono** (clic derecho en `Mic` → Filters): añade **Noise Suppression**
(método RNNoise). Si al ver la prueba la voz suena baja, añade **Gain** de +3 a +6 dB.

**Luz antes que desenfoque.** Lo que más mejora la cámara es la luz, no el fondo:

- Que **ninguna lámpara salga en el cuadro**. Una luz detrás o encima de ti deja la cara en
  sombra; inclina la pantalla o cambia de sitio hasta que desaparezca.
- **Luz de frente**: una ventana o una lámpara detrás del Mac, apuntando a tu cara.
- Preset de la cámara en **1280x720**, no *Medium*: en *Medium* la cara sale borrosa.

**Desenfocar el fondo: solo si el fondo distrae.** Con una pared lisa detrás, no hace falta.

- **Portrait de macOS**: en el Mac de grabación (macOS 26 Tahoe) **no aparece para OBS**. El
  menú de la cámara en la barra solo muestra *Privacy → Camera & Microphone*, sin efectos. No
  cuentes con él.
- **Plugin Background Removal** (`obs-backgroundremoval`, de royshil, gratuito y de código
  abierto): filtro que segmenta la persona con un modelo local y desenfoca el resto. Consume GPU
  todo el tiempo y, con la diadema puesta, el borde del arco puede parpadear: decide en la prueba
  de 30 s si se queda.

**Instalar el plugin (versión 1.4.1, julio de 2026)**

1. Descarga `obs-backgroundremoval-1.4.1-macos-universal.pkg` desde la
   [release 1.4.1 en GitHub](https://github.com/royshil/obs-backgroundremoval/releases/tag/1.4.1)
   (también en la [página del recurso en el foro de OBS](https://obsproject.com/forum/resources/background-removal-virtual-green-screen-low-light-enhance.1260/)).
   *Universal* sirve para el M1.
2. **Cierra OBS** y abre el `.pkg`. Si macOS lo bloquea: Ajustes del Sistema → Privacidad y
   seguridad → **Abrir igualmente**.
3. Abre OBS. Clic derecho en `Camara` → **Filters** → en *Effect Filters*, **+** →
   **Background Removal**.

**Ajustes del filtro**

| Campo | Valor | Por qué |
|---|---|---|
| Inference device | CoreML | corre en el chip del M1, no en la CPU que usan pytest y mutmut |
| Segmentation model | MediaPipe o Selfie Segmentation | los más ligeros; si el borde se ve mal, Robust Video Matting |
| Blur background factor | 5–10, **nunca 0** | con 0 no desenfoca: **borra** el fondo y se ve VS Code a través de tu cuadro |
| Smooth silhouette / Feather | un poco | suaviza el borde del pelo y de la diadema |

- Si en la prueba el arco de la diadema parpadea, sube *Smooth silhouette* o cambia de modelo.
- Si aparecen saltos de imagen, apaga el filtro (el ojo junto a su nombre) y graba sin
  desenfoque: con pared lisa no se nota la diferencia.

## 4. 🖥️ La pantalla antes de grabar

1. **Focus (No molestar)** activado desde el Centro de control; cierra Teams, Mail y Slack
   (Teams deja un dispositivo de audio virtual: que no sea el micrófono seleccionado).
2. Dock oculto (Ajustes → Escritorio y Dock → *Ocultar y mostrar el Dock automáticamente*).
3. VS Code a pantalla completa (Ctrl+Cmd+F), tema oscuro, letra 20 pt (ya en `settings.json`).
4. Terminal limpia (`clear`) y `./reset.sh` corrido.
5. La vista previa de OBS en **otro escritorio** o minimizada: no la mires mientras grabas, mira
   la pantalla y, en las frases clave, la cámara.

## 5. 🧪 Prueba de 30 segundos (hoy, obligatoria)

Graba 30 s haciendo el primer bloque del guion y **mírala en QuickTime**:

| Comprueba | Si falla |
|---|---|
| Se lee `carrito.py` y la terminal sin forzar la vista | sube `editor.fontSize` a 22 o quita el panel lateral |
| La cara no tapa ninguna salida de la terminal | mueve la terminal más alta o baja `Bounding Box Size` a `480x270` |
| La voz se oye clara y sin zumbido de fondo | filtro Noise Suppression; micrófono a 2–3 cm de la boca |
| No hay saltos de imagen | baja FPS a 24 o cierra Docker Desktop |
| La cara se ve iluminada, sin lámpara en el cuadro | mueve la pantalla o pon una luz detrás del Mac; preset en 1280x720 |
| Con el plugin: el fondo desenfocado (no transparente) y la diadema sin parpadeo | *Blur background factor* mayor que 0; sube *Smooth silhouette* o cambia de modelo; si no mejora, apaga el filtro |
| El archivo abre y dura lo que grabaste | cambia el formato a MKV y remuxea (File → Remux Recordings) |

## 6. ⬆️ Subir y enviar

YouTube Studio → *Subir video* → visibilidad **Oculto** (no «Privado»: privado no se puede ver
con enlace). Título: el nombre de la clase. Copia el enlace y mándaselo a Wilson por LinkedIn
con una línea: la clase, la duración y que está grabada por tu cuenta porque el estudio no
tenía el setup.

## 7. 🪟 Si grabas desde el Windows (Dell XPS)

Mismo montaje; cambian los permisos, los nombres de dos fuentes, el encoder y el desenfoque.
Lo que no se nombra aquí (resolución de salida, Hybrid MP4, 48 kHz mono, filtros del micrófono,
cámara en la esquina, prueba de 30 s) se hace igual que arriba. No hay valores de pantalla
escritos porque no se han medido en esa máquina: se toman al montar.

**Permisos.** Configuración → **Privacidad y seguridad**: en *Cámara* y en *Micrófono*, el
interruptor general encendido y OBS permitido en la lista de apps de escritorio. La captura de
pantalla no pide permiso en Windows.

**Video.** Base (Canvas) = la resolución real de la pantalla (Configuración → Sistema → Pantalla,
*Resolución de pantalla*; un XPS suele ser 1920×1200 o 3840×2400). Si es 3840×2400, Output
`1920x1200`; si ya es 1920×1200, Output igual al Canvas. Recalcula la posición de la cámara con
la misma regla: `ancho − 32`, `alto − 32`.

**Output.** Video Encoder según la gráfica que tenga el XPS (Administrador de dispositivos →
*Adaptadores de pantalla*):

| Gráfica | Encoder | Nota |
|---|---|---|
| NVIDIA | Hardware (NVENC, H.264) | la mejor opción; no roba CPU |
| Solo Intel integrada | Hardware (QSV, H.264) | la equivalente de Intel |
| Si ninguna aparece en la lista | Software (x264), preset `veryfast` | funciona siempre; vigila la CPU en la prueba |

**Audio.** Igual, con un aviso: Windows crea un micrófono virtual por cada app de reuniones
instalada; en *Mic/Auxiliary Audio* elige la diadema por su nombre, no «Default».

**Escena.** Mismas tres fuentes, con los tipos que tiene OBS en Windows:

| Orden | Fuente (tipo) | Ajuste |
|---|---|---|
| 1 (arriba) | `Camara` · **Video Capture Device** | Device: la cámara integrada del XPS · Resolution/FPS Type: Custom · 1280x720 |
| 2 | `Mic` · **Audio Input Capture** | Device: Logitech USB Headset |
| 3 (abajo) | `Pantalla` · **Display Capture** | Capture Method: *Windows 10 (1903 and up)* · Capture Cursor: sí |

- *Windows 10 (1903 and up)* es el método WGC: funciona con escalado de pantalla distinto de
  100 % y con varias pantallas; el método *DXGI* heredado a veces da negro en portátiles con dos
  gráficas.
- Si la captura sale negra con una NVIDIA: Configuración → Sistema → Pantalla → *Gráficos*, añade
  `obs64.exe` y fíjalo en **Ahorro de energía** (la integrada, que es la que dibuja el escritorio).

**Hotkeys.** `Ctrl+Shift+R` para *Start* y *Stop Recording* (en Windows `Cmd` no existe).

**Desenfoque del fondo.** Windows no tiene el equivalente del Portrait de macOS salvo en equipos
Copilot+ con NPU (*Windows Studio Effects*), que un XPS normal no tiene. Queda el plugin:

| Paso | Qué hacer |
|---|---|
| 1 | descarga `obs-backgroundremoval-1.4.1-windows-x64.zip` desde la [página del recurso en el foro de OBS](https://obsproject.com/forum/resources/background-removal-virtual-green-screen-low-light-enhance.1260/) (es el mismo proyecto que en Mac, gratuito) |
| 2 | cierra OBS, descomprime el `.zip` y copia sus carpetas (`obs-plugins`, `data`) dentro de la carpeta de OBS (por defecto `C:\Program Files\obs-studio`), fusionándolas con las que ya existen; vuelve a abrir OBS |
| 3 | `Camara` → Filters → **Background Removal**; **Blur background factor** entre 5 y 10, nunca 0 (con 0 borra el fondo en vez de desenfocarlo) |
| 4 | en *Inference device* elige **GPU - DirectML** (usa la gráfica, cualquiera de las dos); si parpadea o la imagen se congela, cambia a **CPU** y baja *Calculate every N frames* a 2 |

- Con *CPU* el filtro compite con pytest y mutmut por los núcleos: mira el uso de CPU durante la
  prueba de 30 s y, si pasa del 70 %, graba sin desenfoque.
- El resto de advertencias de §3 valen igual: el borde de la diadema puede parpadear y conviene
  ordenar el fondo real.

**Antes de grabar.** *No molestar* en Configuración → Sistema → Notificaciones; barra de tareas
oculta (clic derecho → Configuración → *Ocultar automáticamente*); Teams, Mail y Slack cerrados.

**Si la demo corre en WSL** (ver [02-setup-proyecto.md](02-setup-proyecto.md), §4): OBS graba la
pantalla de Windows, así que da igual que la terminal sea de WSL; solo asegúrate de que la
terminal de VS Code abre en la distribución Debian y de que `./reset.sh` se corre ahí.

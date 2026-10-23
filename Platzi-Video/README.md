# 🎬 Demo class para Platzi · «Cobertura de pruebas: encuentra lo que tus tests no están probando»

> **Qué es:** todo lo necesario para grabar la demo class de 5 minutos que pide la Escuela de
> Programación de Platzi ([`guia democlass.pdf`](guia%20democlass.pdf)): tema, guion cronometrado,
> proyecto de demostración ya corrido, y manual de OBS. **Material personal**: no sale de
> `Entrevistas/`.

| # | Documento | Para qué |
|---|---|---|
| 1 | [Guion cronometrado](01-guion.md) | Qué se dice y qué se ve en pantalla, segundo a segundo. Se ensaya en voz alta, no se lee |
| 1b | [Guion de lectura previa](04-guion-lectura-previa.md) | La clase en prosa, de corrido, para leerla antes y asimilar el hilo. Sin teleprompter |
| 2 | [Setup del proyecto](02-setup-proyecto.md) | Cómo dejar VS Code y la terminal listos en macOS (hecho) y en Windows (pendiente) |
| 3 | [OBS en macOS](03-obs-macos.md) | Pantalla + cámara en la esquina inferior derecha + diadema, paso a paso; §7 con lo que cambia en Windows |
| — | [raíz del repo](../) | El proyecto que se muestra: `carrito.py`, un test, pytest-cov y mutmut, ya corridos |

## 🎯 El tema en una frase

**La cobertura te dice qué código ejecutaron tus tests, no qué verificaron.** Un módulo con
100 % de cobertura, un `and` cambiado por `or` que nadie detecta, y la herramienta que hace ese
sabotaje por ti con todos los cambios posibles (*mutation testing* con `mutmut`). Un solo tema,
como pide la guía; la cobertura de ramas y el CI quedan como «lo que sigue».

## 📅 Plan

**Hoy, miércoles 21**

1. Leer el guion y correr la demo a mano siguiendo [02](02-setup-proyecto.md) §3 (el guion lleva
   las salidas reales; nada debería sorprender).
2. Ensayar en voz alta con cronómetro **al menos dos veces** (lo pide la guía). Meta: 4:00–4:30.
   Entre ensayo y ensayo, `./reset.sh` en la raíz del repo.
3. Montar OBS siguiendo [03](03-obs-macos.md) y hacer **una grabación de prueba de 30 s**; verla
   completa: letra legible, cara en la esquina, voz sin ruido.

**Mañana, jueves 22, por la mañana**

1. `./reset.sh`, VS Code con los dos archivos abiertos, terminal limpia, Focus (no molestar) activado.
2. Grabar **una sola toma**. Si hay un tropiezo, seguir (la guía lo dice explícitamente).
3. Subir a YouTube como **oculto** y mandar el enlace a Wilson por LinkedIn.

## ✅ Checklist de la guía de Platzi (se marca en el último ensayo)

- [ ] Dura 5 minutos o menos (meta 4:30)
- [ ] La primera frase es contenido, no saludo
- [ ] Dices qué va a poder hacer el estudiante en los primeros segundos
- [ ] Más de la mitad del tiempo estás sobre la herramienta
- [ ] Hay al menos un ejemplo de algo que viviste (el incidente de pagos)
- [ ] Se te ve y se te escucha bien
- [ ] Cierra con lo que sigue, no con una despedida
- [ ] Letra del editor a 20 puntos o más

# Evar-system-000

**Evar-system-000** es un framework para **Godot 4** (GDScript) orientado a estandarizar
elementos y datos de juegos, de forma que puedan compartirse y adaptarse fácilmente
entre distintos desarrollos o juegos ya terminados (a modo de *mod*).

> ⚠️ Proyecto en desarrollo activo / experimental. La API, los nombres de nodos,
> variables y recursos pueden cambiar sin previo aviso.

## Descripción general

El sistema gira en torno a **tarjetas de datos** (`d_tg`) que describen cualquier
elemento del juego (piezas, aplicadores, mecanismos, reaccionadores, cambiantes,
estructuras y lugares). Cada tarjeta se asocia a un **aspecto/fachada** (`e_fc`)
y a una **pieza** (`e_pz`) que la interpreta en el mundo.

| Script | `class_name` | Rol |
|---|---|---|
| `D-Tg.gd` | `d_tg` | **Recurso de tarjeta**. Define tipo (`tiprrh`), datos (`RR`) y formato (`fmtg()`). Se registra en `EgLb.R["Tg"]` vía `rgtg()` / `defn()`. |
| `E-Pz.gd` | `e_pz` | **Pieza** (`CharacterBody2D`). Contiene el motor de movimiento (`motr`), la física/giroscopio (`girk`) y la estructuración (`sttr`). Usa `pzetev` para mapear nodos internos. |
| `E-Fc.gd` | — (Node) | **Aspecto/fachada** de una pieza. Sincroniza `est_ig`, `ddd_tg` y `RR` con la pieza asociada y gestiona la interacción del inventario (`_on_a_pressed`). |
| `E-Tb.gd` | — (Node) | **Tablero/entidad de mapa**. Aplica fuerzas (`fuerza`), activa eventos (`actt`), procesa colas de misión (`chmt`) y controla el embolsado de reserva (`recerv`, `reppem`). |
| `E-Gm.gd` | — (Node) | **Gestor de partida**. Mantiene jugadores, tableros y transición entre tableros. Implementa el paso del tiempo (`RR["TT"]`, `RR["TL"]`) y `cpps()`. |
| `E-Mn.gd` | — (Node) | **Entradas/menú**. Mapea comandos (`commad`: up, down, right, left, esp, c), hilos de entrada (`ilos`), cámara (`ccam`), foco (`focl`) y misión principal (`mision`). |
| `EG-Lb.gd` | — (autoload `EgLb`) | **Librería de utilidades**. Funciones auxiliares usadas por el resto: `stcM`, `stcL`, `dado`, `ordd`, `camb`, `pisz`, `invl`, `rgst`, `libr`, `catg`, `miti`, `reuv`, `tigt`, `aspe`, `alqm`, `barj`, `atlz`, etc. |

La carpeta `rqs/` contiene escenas y recursos de ejemplo (`p.tscn`, `eev.tscn`,
`IiI.tscn`) que muestran cómo se instancian estos scripts.

## Formatos de tarjeta (`tiprrh`)

El campo `tiprrh` de `d_tg` admite estos valores (definidos con `@export_enum`):

| Código | Significado |
|---|---|
| `0` | Pieza / entidad base (imagen, descripción, límites de acumulación, forma física, marcas) |
| `1` | *(reservado)* |
| `9` | *(reservado)* |
| `A` | **Aplicador** — define `efects` (efectos emitidos) |
| `M` | **Mecanismo** — activación, condición, operación, animación |
| `E` | **Reaccionador** — chequeos (`a_cheq`), conteo (`intchq`), tiempo límite (`timlim`), objetivos (`objchq`), trofeos/castigos |
| `Q` | **Cambiante** — rutas de estado, efectos, reacciones, intérpretes de misión, residuos |
| `R` | **Estructura** — marcas y efectos |
| `L` | **Lugar** — eventualidad (`ejecus`), imbuidos internos (`imbmin`) y externos (`imbext`) |

## Requisitos

- [Godot Engine 4.x](https://godotengine.org/) (probado con scripts `@tool` para
  previsualización en el editor).

## Instalación / uso

1. Clona este repositorio:
   ```bash
   git clone https://github.com/Ginttor/Evar-system-000.git

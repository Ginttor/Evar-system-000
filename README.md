# Evar-system-000
#tll

**Evar-system-000** es un framework  para **Godot 4** (GDScript) para estandarizar elementos y datos de juegos par estos ser compartidos y adaptados de manera fácil a otros desarrollo o juegos ya terminados a modo de mod

> ⚠️ Proyecto en desarrollo activo / experimental. La API y los nombres de nodos y variables pueden cambiar sin previo aviso.

## Descripción general

| Script | Rol |
|---|---|
| `D-Tg.gd` | Recurso de tarjeta (`d_tg`): define el tipo de entidad y sus datos/formato (`fmtg()`). |
| `E-Pz.gd` | **Pieza**: controlador de `CharacterBody2D`, incluye el motor de movimiento (`motr`), física/giroscopio (`girk`) y estructuración inicial (`sttr`). |
| `E-Fc.gd` | **Aspecto/fachada** de una pieza (representación visual asociada a una tarjeta). |
| `E-Tb.gd` | **Tablero/entidad de mapa**: fuerzas, acciones y eventos activos sobre el mapa. |
| `E-Gm.gd` | **Gestor de partida**: jugadores, tableros de la escena y transición entre tableros. |
| `E-Mn.gd` | **Entradas/menú**: mapeo de comandos del jugador (arriba, abajo, accionar, etc.) y misión principal. |
| `EG-Lb.gd` | **Librería de utilidades** (autoload `EgLb`): funciones auxiliares usadas por el resto de scripts (`stcM`, `stcL`, `dado`, `ordd`, `camb`, `pisz`, `invl`, etc.). |

La carpeta `rqs/` contiene escenas y recursos de ejemplo (`p.tscn`, `eev.tscn`, `IiI.tscn`) que muestran cómo se instancian estos scripts.

## Requisitos

- [Godot Engine 4.x](https://godotengine.org/)

## Instalación / uso

1. Clona este repositorio:
   ```bash
   git clone https://github.com/Ginttor/Evar-system-000.git
   ```
2. Ábrelo (o copia la carpeta dentro de tu proyecto) desde el editor de Godot 4.
3. Registra `EG-Lb.gd` como **autoload** (singleton) con el nombre `EgLb`, ya que los demás scripts dependen de él para funciones auxiliares.
4. Usa las escenas de `rqs/` como referencia para crear tus propias piezas (`E-Pz.gd`) y tarjetas de datos (`D-Tg.gd`) desde el editor, aprovechando que los scripts están anotados con `@tool` para previsualizar cambios sin ejecutar el juego.

## Estructura del proyecto

```
Evar-system-000/
├── D-Tg.gd      # Recurso de tarjeta de datos
├── E-Fc.gd      # Aspecto/fachada de la pieza
├── E-Gm.gd      # Gestor de partida
├── E-Mn.gd      # Entradas y misión
├── E-Pz.gd      # Controlador de la pieza (movimiento/física)
├── E-Tb.gd      # Entidad de tablero/mapa
├── EG-Lb.gd     # Librería de utilidades (autoload)
├── rqs/         # Escenas y recursos de ejemplo
├── LICENSE
└── NOTICE
```

## Licencia

Este proyecto está licenciado bajo la **Apache License 2.0**. Consulta el archivo [LICENSE](LICENSE) para más detalles y [NOTICE](NOTICE) para los avisos de atribución.

Copyright © 2026 Evaristo Velásquez.

## Autor

Desarrollado por **Jakzon** ([@Ginttor](https://github.com/Ginttor)) como parte del proyecto **RBN**.

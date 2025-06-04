# Proyecto final: Sistemas Operativos

## Herramienta de Monitoreo de Data Centers

## Integrantes:

Katerine Valens Orejuela - A00399512

Daniel Alejandro Castro Escobar - A00398005

Laura Valentina Revelo Villarreal - A00400031

## Descripción

Este repositorio contiene dos herramientas de monitoreo desarrolladas para sistemas tipo Unix (Bash) y Windows (PowerShell). Estas herramientas permiten a los administradores de data centers visualizar información fundamental sobre el estado de los sistemas y el uso de recursos en tiempo real.

## Características

Tanto la versión de Unix como la de Windows, permiten al usuario:

1. Mostrar los 5 procesos que más CPU consumen.
2. Ver discos conectados junto con su tamaño y espacio libre.
3. Buscar el archivo más grande en un directorio o unidad especificada.
4. Mostrar memoria libre y uso de swap.
5. Mostrar el número de conexiones de red activas con estado `ESTABLISHED`.

## Archivos incluidos

Dentro de la carpeta de su sistema correspondiente, se encuentran:

- `monitoreo.sh` — Script en Bash para sistemas Linux.
- `monitoreo.ps1` — Script en PowerShell para sistemas Windows.

## Herramientas y comandos utilizados

Algunas de las herramientas y comandos utilizados en el desarrollo de ambos scripts son:

### Bash

- `ps` — Para listar los procesos y su uso de CPU.
- `awk` — Para filtrar y procesar columnas de texto.
- `df` — Para mostrar el uso del sistema de archivos.
- `find` — Para localizar archivos y calcular tamaños.
- `du` — Para medir el tamaño de archivos.
- `free` — Para obtener información de memoria RAM y swap.
- `netstat` — Para listar conexiones de red.
- `sort`, `head`, `cut`, `xargs` — Comandos auxiliares de procesamiento de texto.

### PowerShell

- `Get-Process` — Para listar procesos y uso de CPU.
- `Get-PSDrive` y `Get-Volume` — Para mostrar discos y su espacio libre.
- `Get-ChildItem` y `Measure-Object` — Para encontrar archivos y medir tamaños.
- `Get-CimInstance` con la clase `Win32_OperatingSystem` — Para obtener uso de memoria y swap.
- `Get-NetTCPConnection` — Para ver conexiones de red activas.
- `Sort-Object`, `Select-Object`, `Where-Object` — Comandos auxiliares de procesamiento de datos.

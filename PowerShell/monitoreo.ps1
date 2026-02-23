<#
.SYNOPSIS
Herramienta de monitoreo para administradores de data center.

.DESCRIPTION
Este script de PowerShell permite al usuario seleccionar entre varias opciones 
de monitoreo del sistema como procesos por CPU, discos, archivos grandes, memoria/swap 
y conexiones activas.

.PARAMETER Opcion
Permite ejecutar una opción específica (1 a 5) directamente desde línea de comandos sin 
interactuar de manera iterativa con el menú.

.EXAMPLE
.\monitoreo.ps1
Muestra el menú interactivo.

.EXAMPLE
.\monitoreo.ps1 -Opcion 3
Ejecuta directamente la opción 3 (archivo más grande en un disco especificado).
#>

Write-Host "==================="
Write-Host " MONITOREO DATA CENTER"
Write-Host ("Fecha/Hora: " + (Get-Date))
Write-Host "=================="

[CmdletBinding()]
param (
    [ValidateSet('1','2','3','4','5')]
    [string]$Opcion
)

# Esta sección del script muestra el menú de la herramienta de administración, con sus correspondientes opciones disponibles

function Mostrar-Menu {
    Write-Host "=== MENU: HERRAMIENTA DE MONITOREO DE DATA CENTERS ==="
    Write-Host "1. Mostrar los 5 procesos que mas CPU consumen"
    Write-Host "2. Mostrar discos conectados (tamaño y espacio libre)"
    Write-Host "3. Mostrar archivo mas grande en un disco especificado"
    Write-Host "4. Mostrar memoria libre y uso de swap"
    Write-Host "5. Mostrar conexiones de red activas (ESTABLISHED)"
}

# Función 1: Muestra los 5 procesos que más recursos de CPU están consumiendo en el sistema

function Mostrar-ProcesosCPU {
    Write-Host "`nTop 5 procesos por uso de CPU:"
    $procesos = Get-Process | Where-Object { $_.CPU -gt 0 } | Sort-Object CPU -Descending | Select-Object -First 5 Id, ProcessName, CPU
    if ($procesos) {
        $procesos | Format-Table -AutoSize
    } else {
        Write-Host "No hay procesos con uso significativo de CPU en este momento."
    }
}

# Función 2: Muestra información sobre los discos conectados al sistema, incluyendo el tamaño total y el espacio libre de cada uno

function Mostrar-Discos {
    Write-Host "`nDiscos conectados y espacio disponible (en bytes):"
    Get-PSDrive -PSProvider FileSystem | ForEach-Object {
        [PSCustomObject]@{
            'Unidad'       = $_.Name
            'Tamaño total' = $_.Used + $_.Free
            'Espacio libre'= $_.Free
        }
    } | Format-Table -AutoSize
}

# Función 3: Busca el archivo más grande dentro de una unidad especificada por el usuario

function Mostrar-ArchivoMasGrande {
    $letraUnidad = Read-Host "Ingrese la letra de la unidad (Ejemplo: C o D)"
    $unidad = "$letraUnidad`:\"

    if (Test-Path $unidad) {
        Write-Host "`nBuscando el archivo más grande en $unidad ..."
        $archivo = Get-ChildItem -Path $unidad -Recurse -File -ErrorAction SilentlyContinue |
                   Sort-Object Length -Descending |
                   Select-Object -First 1 FullName, Length
        if ($archivo) {
            Write-Host "Archivo más grande encontrado:"
            Write-Host "Ruta: $($archivo.FullName)"
            Write-Host "Tamaño (bytes): $($archivo.Length)"
        } else {
            Write-Host "No se encontraron archivos en la unidad especificada."
        }
    } else {
        Write-Host "Unidad no válida. Intente nuevamente."
    }
}

# Función 4: Muestra información sobre la memoria física libre, el uso del swap y el procentaje de uso del swap

function Mostrar-MemoriaYSwap {
    Write-Host "`nInformacion de memoria y uso de swap:"
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $memLibre = [math]::Round($osInfo.FreePhysicalMemory * 1024)
    $swapEnUso = [math]::Round(($osInfo.TotalVirtualMemorySize - $osInfo.FreeVirtualMemory) * 1024)
    $swapTotal = [math]::Round($osInfo.TotalVirtualMemorySize * 1024)
    $porcentajeSwap = [math]::Round(($swapEnUso / $swapTotal) * 100, 2)

    Write-Host "Memoria libre: $memLibre bytes"
    Write-Host "Swap en uso: $swapEnUso bytes"
    Write-Host "Porcentaje de swap usado: $porcentajeSwap %"
}

# Función 5: Muestra el número de conexiones de red activas con estado "ESTABLISHED"

function Mostrar-ConexionesActivas {
    Write-Host "`nConexiones de red activas (ESTABLISHED):"
    $establecidas = (Get-NetTCPConnection | Where-Object { $_.State -eq "Established" }).Count
    Write-Host "Numero de conexiones ESTABLISHED: $establecidas"
}

# Llamado a las distintas funciones según el número especificado por el usuario

switch ($Opcion) {
    "1" { Mostrar-ProcesosCPU; return }
    "2" { Mostrar-Discos; return }
    "3" { Mostrar-ArchivoMasGrande; return }
    "4" { Mostrar-MemoriaYSwap; return }
    "5" { Mostrar-ConexionesActivas; return }
}

# Menú iterativo presentado cuando no se especifica el parámetro -Opcion al ejecutar el script

do {
    Mostrar-Menu
    $entrada = Read-Host "Seleccione una opcion"
    switch ($entrada) {
        "1" { Mostrar-ProcesosCPU }
        "2" { Mostrar-Discos }
        "3" { Mostrar-ArchivoMasGrande }
        "4" { Mostrar-MemoriaYSwap }
        "5" { Mostrar-ConexionesActivas }
        default { Write-Host "Opcion invalida`n" }
    }
    Write-Host ""
} while ($true)

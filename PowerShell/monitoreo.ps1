function Mostrar-Menu {
    Write-Host "=== MENU - HERRAMIENTA DE MONITOREO ==="
    Write-Host "1. Mostrar los 5 procesos que más CPU consumen"
    Write-Host "2. Mostrar discos conectados (tamaño y espacio libre)"
    Write-Host "3. Mostrar archivo más grande en un disco especificado"
    Write-Host "4. Mostrar memoria libre y uso de swap"
    Write-Host "5. Mostrar conexiones de red activas (ESTABLISHED)"
}

function Mostrar-ProcesosCPU {
    Write-Host "`nTop 5 procesos por uso de CPU:"
    $procesos = Get-Process | Where-Object { $_.CPU -gt 0 } | Sort-Object CPU -Descending | Select-Object -First 5 Id, ProcessName, CPU
    if ($procesos) {
        $procesos | Format-Table -AutoSize
    } else {
        Write-Host "No hay procesos con uso significativo de CPU en este momento."
    }
}


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

function Mostrar-ArchivoMasGrande {
    $unidad = Read-Host "Ingrese la letra de la unidad (por ejemplo C:\ o D:\)"
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
        Write-Host "Ruta no válida. Intente nuevamente."
    }
}

function Mostrar-MemoriaYSwap {
    Write-Host "`nInformación de memoria y uso de swap:"
    $osInfo = Get-CimInstance Win32_OperatingSystem
    $memLibre = [math]::Round($osInfo.FreePhysicalMemory * 1024)
    $swapEnUso = [math]::Round(($osInfo.TotalVirtualMemorySize - $osInfo.FreeVirtualMemory) * 1024)
    $swapTotal = [math]::Round($osInfo.TotalVirtualMemorySize * 1024)
    $porcentajeSwap = [math]::Round(($swapEnUso / $swapTotal) * 100, 2)

    Write-Host "Memoria libre: $memLibre bytes"
    Write-Host "Swap en uso: $swapEnUso bytes"
    Write-Host "Porcentaje de swap usado: $porcentajeSwap %"
}

function Mostrar-ConexionesActivas {
    Write-Host "`nConexiones de red activas (ESTABLISHED):"
    $establecidas = (Get-NetTCPConnection | Where-Object { $_.State -eq "Established" }).Count
    Write-Host "Número de conexiones ESTABLISHED: $establecidas"
}

# Programa principal
do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una opción"
    switch ($opcion) {
        "1" { Mostrar-ProcesosCPU }
        "2" { Mostrar-Discos }
        "3" { Mostrar-ArchivoMasGrande }
        "4" { Mostrar-MemoriaYSwap }
        "5" { Mostrar-ConexionesActivas }
        default { Write-Host "Opción inválida`n" }
    }
    Write-Host ""
} while ($true)




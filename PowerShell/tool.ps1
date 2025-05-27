function Mostrar-Menu {
    Write-Host "=== HERRAMIENTA DE MONITOREO (PowerShell) ==="
    Write-Host "1. Mostrar los 5 procesos que más CPU consumen"
    Write-Host "2. Mostrar discos conectados (tamaño y espacio libre)"
    Write-Host "3. Mostrar archivo más grande en un disco especificado"
    Write-Host "4. [Pendiente]"
    Write-Host "5. [Pendiente]"
    Write-Host "0. Salir"
}

function Mostrar-ProcesosCPU {
    Write-Host "`nTop 5 procesos por uso de CPU:"
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Id, ProcessName, CPU
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


do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una opción"
    switch ($opcion) {
        "1" { Mostrar-ProcesosCPU }
        "2" { Mostrar-Discos }
        "3" { Mostrar-ArchivoMasGrande }
        "0" { Write-Host "Saliendo..."; break }
        default { Write-Host "Opción inválida`n" }
    }
    Write-Host ""
} while ($true)

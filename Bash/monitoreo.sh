#!/bin/bash

# Daniel Alejandro Castro Escobar
# Laura Valentina Revelo Villareal
# Katerine Valens Orejuela

# Sistemas Operativos

# HERRAMIENTA DE MONITOREO DE DATA CENTERS

# Función 1: Mostrar los 5 procesos que más CPU consumen

mostrar_procesos_cpu() {
    echo ""
    echo "Top 5 procesos por uso de CPU:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Función 2: Mostrar discos conectados (tamaño y espacio libre)

mostrar_discos() {
    echo ""
    echo "Discos conectados y espacio disponible (en bytes):"
    df -B1 --output=source,size,avail | column -t
}

# Función 3: Mostrar el archivo más grande en un directorio especificado

mostrar_archivo_mas_grande() {
    read -rp "Ingrese el path del disco o carpeta (por ejemplo /home): " ruta
    if [ -d "$ruta" ]; then
        echo ""
        echo "Buscando el archivo más grande en $ruta ..."
        archivo=$(find "$ruta" -type f -printf "%s %p\n" 2>/dev/null | sort -nr | head -n 1)
        if [ -n "$archivo" ]; then
            tamano=$(echo "$archivo" | cut -d' ' -f1)
            ruta_completa=$(echo "$archivo" | cut -d' ' -f2-)
            echo "Archivo más grande encontrado:"
            echo "Ruta: $ruta_completa"
            echo "Tamaño: $tamano bytes"
        else
            echo "No se encontraron archivos en la ruta especificada."
        fi
    else
        echo "Ruta inválida. Intente nuevamente."
    fi
}

# Función 4: Mostrar memoria libre y uso de swap

mostrar_memoria_swap() {
    echo ""
    echo "Información de memoria y uso de swap:"
    mem_info=$(free -b)

    libre_mem=$(echo "$mem_info" | sed -n '2p' | awk '{print $4}')
    total_swap=$(echo "$mem_info" | sed -n '3p' | awk '{print $2}')
    usado_swap=$(echo "$mem_info" | sed -n '3p' | awk '{print $3}')

    if [ -z "$libre_mem" ]; then
        echo "No se pudo obtener información de memoria."
    else
        echo "Memoria libre: $libre_mem bytes"
    fi

    if [ "$total_swap" -gt 0 ]; then
        porcentaje_swap=$(( usado_swap * 100 / total_swap ))
        echo "Swap en uso: $usado_swap bytes"
        echo "Porcentaje de swap usado: $porcentaje_swap%"
    else
        echo "Swap no configurado o total = 0 bytes"
    fi
}

# Función 5: Mostrar conexiones de red activas (ESTABLISHED)

mostrar_conexiones_establecidas() {
    echo ""
    echo "Conexiones de red activas (ESTABLISHED):"
    conexiones=$(netstat -nat 2>/dev/null | grep -i 'ESTABL' | wc -l)
    echo "Número de conexiones ESTABLISHED: $conexiones"
}

# Ciclo del menú principal, que presenta las distintas opciones que ofrece la herramienta

while true
do
    echo ""
    echo "=== MENU: HERRAMIENTA DE MONITOREO DE DATA CENTERS ==="
    echo "1) Mostrar los 5 procesos que más CPU consumen"
    echo "2) Mostrar discos conectados (tamaño y espacio libre)"
    echo "3) Mostrar archivo más grande en un disco especificado"
    echo "4) Mostrar memoria libre y uso de swap"
    echo "5) Mostrar conexiones de red activas (ESTABLISHED)"
    echo "6) Salir"
    echo "=============================================="
    read -p "Opción? " opcion

    case $opcion in
        1) mostrar_procesos_cpu ;;
        2) mostrar_discos ;;
        3) mostrar_archivo_mas_grande ;;
        4) mostrar_memoria_swap ;;
        5) mostrar_conexiones_establecidas ;;
        6) echo "¡Hasta luego!"; break ;;
        *) echo "Opción inválida. Intenta de nuevo." ;;
    esac
done

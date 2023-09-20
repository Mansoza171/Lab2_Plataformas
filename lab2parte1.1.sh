#!/bin/bash

# Comprobación del ID del proceso 
if [ $# -ne 1 ]; then
    echo "Uso: $0 <ID de proceso>"
    exit 1
fi

process_id=$1

info=$(ps -p $process_id -o comm=,pid=,user=,%cpu=,%mem=,stat=)

executable_path=$(readlink -f /proc/$process_id/exe)

# Verificación del path del proceso
if [ -z "$info" ] || [ -z "$executable_path" ]; then 
    echo "ID $process_id no encontrado"
    exit 1
fi

# Se extrae la información 
process_name=$(echo "$info" | awk '{print $1}')
process_pid=$(echo "$info" | awk '{print $2}')
user=$(echo "$info" | awk '{print $3}')
cpu_usage=$(echo "$info" | awk '{print $4}')
mem_usage=$(echo "$info" | awk '{print $5}')
status=$(echo "$info" | awk '{print $6}')

# Se imprime la información
echo "Nombre del proceso: $process_name"
echo "ID del proceso: $process_pid"
echo "Usuario propietario: $user"
echo "Porcentaje de CPU: $cpu_usage%"
echo "Consumo de memoria: $mem_usage%"
echo "Estado: $status"
echo "Path del ejecutable: $executable_path"

#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Uso: $0 <nombre_del_ejecutable>"
  exit 1
fi

# Nombre del ejecutable a monitorear
ejecutable="$1"

# Duración del monitoreo
duracion_monitoreo=60 

# Nombre del archivo de registro
log_file="monitoring.log"

# Inicio de ejecucion
start_time=$(awk '{print int($1)}' /proc/uptime)

# Se verifica la ejecucion continuamente
is_brave_running() {
  pgrep "$ejecutable" > /dev/null
}

# Se inicializa el archivo de registro
if [ ! -e "$log_file" ]; then
  echo "Tiempo CPU Memoria" > "$log_file"
fi

# Se monitorea el proceso en ejecucion
while is_brave_running; do
  current_time=$(awk '{print int($1)}' /proc/uptime)
  elapsed_time=$((current_time - start_time))
  if [ "$elapsed_time" -le "$duracion_monitoreo" ]; then
    ps -C "$ejecutable" -o %cpu,%mem | tail -n 1 >> "$log_file"
    sleep 1
  else
    break
  fi
done

# Generar la gráfica con Gnuplot
gnuplot <<EOF
set terminal png
set output 'grafica.png'
set title 'Consumo de CPU y Memoria de $ejecutable'
set xlabel 'Tiempo (segundos)'
set ylabel 'Porcentaje'
plot "$log_file" using 1 with lines title 'CPU', \
     "$log_file" using 2 with lines title 'Memoria'
EOF

echo "El monitoreo ha finalizado ver grafico en 'grafica.png'."
echo "Presione Ctrl+C para salir del monitoreo."
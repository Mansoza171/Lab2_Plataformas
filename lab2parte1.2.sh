#!/bin/bash

#Verificacion de argumentos
if [ $# -ne 2 ]; then
  echo "Uso: $0 <nombre_del_proceso> <comando_de_ejecucion>"
  exit 1
fi

#Almacenacion de argumentos
nombre_proceso="$1"
comando_ejecucion="$2"

#Bucle de verificacion hasta detener el proceso
while true; do
  if pgrep -x "$nombre_proceso" >/dev/null; then
    echo "El proceso $nombre_proceso está en ejecución."
  else
    echo "El proceso $nombre_proceso no está en ejecución. Reiniciando..."
    #comando para compatibilidad de los procesos y el reinicio
    export MOZ_USE_XINPUT2=1 
    $comando_ejecucion &
  fi

  # Timpo de espera para verificacion
  sleep 30
done

#!/bin/bash

echo "================================================"
echo "          REPORTE DEL SISTEMA"
echo "================================================"

# 1. SYSTEM OS
echo -e "\nINFORMACION DEL SISTEMA:"
os_name=$(awk -F '=' '/PRETTY_NAME/ {gsub(/"/, "", $2); printf "%s",$2}' /etc/os-release)
echo "Sistema Operativo: $os_name"

# 2. UPTIME
echo -e "\nUPTIME:"
uptime=$(uptime -p)
echo "$uptime"

# 3. LOAD AVERAGE
echo -e "\nLoad Average:"
uptime | awk -F 'load average: ' '{printf $2}' | awk -F ',' '{
      one_minute=$1; five_minutes=$2; fifteen_minutes=$3;
      printf "1 Minuto: %.2f | 5 Minutos: %.2f | 15 Minutos: %.2f\n", one_minute, five_minutes, fifteen_minutes
}'

# 4. TOTAL CPU USAGE
echo -e "\nUSO DE CPU:"
# Lee los tiempos de CPU iniciales
eval $(awk '/^cpu /{printf "prev_idle="$5"; prev_total="$2+$3+$4+$5+$6+$7+$8" "}' /proc/stat)
sleep 1
# Lee los tiempos de CPU finales tras 1 segundo
eval $(awk '/^cpu /{printf "idle="$5"; total="$2+$3+$4+$5+$6+$7+$8" "}' /proc/stat)

# Calcula la diferencia y saca el porcentaje
diff_idle=$(($idle - $prev_idle))
diff_total=$(($total - $prev_total))
cpu_usage=$(awk -v idle="$diff_idle" -v total="$diff_total" 'BEGIN {printf "%.1f", 100 * (total - idle) / total}')
echo "Uso Actual de CPU: $cpu_usage%"

# 5. TOTAL MEMORY USAGE (Free vs Used + Percentage)
echo -e "\nUSO DE MEMORIA (RAM):"
free -m | awk 'NR==2{
    total=$2; used=$3; free=$4;
    percent=(used/total)*100;
    printf "Total: %.2f GB | Usado: %.2f GB (%.1f%%) | Libre: %.2f GB\n", total/1024, used/1024, percent, free/1024
}'

# 6. TOTAL DISK USAGE (Free vs Used + Percentage)
echo -e "\nUSO DE DISCO PRINCIPAL (/):"
df -h / | awk 'NR==2{
    printf "Total: %s | Usado: %s (%s) | Libre: %s\n", $2, $3, $5, $4
}'

# 7. TOP 5 PROCESSES BY CPU USAGE
echo -e "\nTOP 5 PROCESOS POR USO DE CPU:"
echo "------------------------------------------------"
printf "%-8s %-6s %s\n" "PID" "%CPU" "COMANDO"
ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "%-8s %-6s %s\n", $2, $3, $11}'

# 8. TOP 5 PROCESSES BY MEMORY USAGE
echo -e "\nTOP 5 PROCESOS POR USO DE MEMORIA:"
echo "------------------------------------------------"
printf "%-8s %-6s %s\n" "PID" "%MEM" "COMANDO"
ps aux --sort=-%mem | awk 'NR>1 && NR<=6 {printf "%-8s %-6s %s\n", $2, $4, $11}'

# 9. USUARIOS CONECTADOS AHORA
echo -e "\nUSUARIOS LOGUEADOS ACTUALMENTE:"
echo "----------------------------------------------------------------"
w -h | awk '{printf "Usuario: %-10s | Terminal: %-6s | Desde IP: %-15s | Actividad: %s\n", $1, $2, $3, $8}'

# 10. RESUMEN DE INTENTOS FALLIDOS (Últimos 5)
echo -e "\nÚLTIMOS 5 INTENTOS DE LOGIN FALLIDOS:"
echo "----------------------------------------------------------------"
if [ "$EUID" -ne 0 ]; then
  echo "[!] Ejecuta el script con 'sudo' para ver los intentos fallidos de login."
else
  lastb -n 5 | grep -vE "btmp begins|wtmp" | awk 'NF>=6 {printf "Usuario: %-10s | IP/Origen: %-15s | Fecha: %s %s %s\n", $1, $3, $4, $5, $6}'
fi

echo "================================================"

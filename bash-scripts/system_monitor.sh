#!/bin/bash


CPU_THRESHOLD=80       # percent
MEM_THRESHOLD=80       # percent
DISK_THRESHOLD=80      # percent
PROCESS_THRESHOLD=100  # number of processes


LOG_FILE="/var/log/system_health_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")


if [ ! -f "$LOG_FILE" ]; then
    sudo touch "$LOG_FILE"
    sudo chmod 644 "$LOG_FILE"
fi

log_alert() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}


CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE_INT=${CPU_USAGE%.*}

if [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
    log_alert "High CPU usage: ${CPU_USAGE_INT}%"
fi


MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(( (MEM_USED * 100) / MEM_TOTAL ))

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_alert "High Memory usage: ${MEM_USAGE}%"
fi


DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_alert "High Disk usage on /: ${DISK_USAGE}%"
fi


PROCESS_COUNT=$(ps aux --no-heading | wc -l)

if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    log_alert "High number of running processes: ${PROCESS_COUNT}"
fi


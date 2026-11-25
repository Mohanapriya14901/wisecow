
#!/bin/bash

export LC_ALL=C

# Set threshold values
cpu_limit=80
memory_limit=80
disk_limit=80
process_limit=200

log_file="system-health.log"

# Get CPU usage
cpu=$(top -bn2 -d 1 | grep "Cpu(s)" | tail -1 | awk '{print int(100-$8)}')

# Get memory usage
memory=$(free -m | awk '/^Mem:/ {print int($3/$2 * 100)}')

# Get disk usage
disk=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')

# Get number of processes
processes=$(ps -e --no-headers | wc -l)

# Display system health report
echo "----- System Health Report -----"
echo "Date: $(date)"
echo "CPU Usage: $cpu%"
echo "Memory Usage: $memory%"
echo "Disk Usage: $disk%"
echo "Running Processes: $processes"
echo "--------------------------------"

# Check CPU usage
if [ "$cpu" -gt "$cpu_limit" ]; then
    echo "ALERT: CPU usage is high ($cpu%)!"
    echo "$(date): High CPU usage ($cpu%)" >> "$log_file"
else
    echo "CPU usage is normal."
fi

# Check memory usage
if [ "$memory" -gt "$memory_limit" ]; then
    echo "ALERT: Memory usage is high ($memory%)!"
    echo "$(date): High memory usage ($memory%)" >> "$log_file"
else
    echo "Memory usage is normal."
fi

# Check disk usage
if [ "$disk" -gt "$disk_limit" ]; then
    echo "ALERT: Disk usage is high ($disk%)!"
    echo "$(date): High disk usage ($disk%)" >> "$log_file"
else
    echo "Disk usage is normal."
fi

# Check running processes
if [ "$processes" -gt "$process_limit" ]; then
    echo "ALERT: Too many running processes ($processes)!"
    echo "$(date): High process count ($processes)" >> "$log_file"
else
    echo "Process count is normal."
fi

# Save monitoring details to log file
echo "$(date): CPU=$cpu%, Memory=$memory%, Disk=$disk%, Processes=$processes" >> "$log_file"

echo "--------------------------------"
echo "Health report saved to $log_file"

#!/bin/bash

# ==============================
# Server Performance Statistics
# ==============================

echo "======================================"
echo "        SERVER PERFORMANCE STATS"
echo "======================================"
echo

# ------------------------------
# OS Information
# ------------------------------
echo "OS Version:"
if [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -a
fi
echo

# Uptime & Load

echo "Uptime:"
uptime -p
echo

echo "Load Average:"
uptime | awk -F'load average:' '{ print $2 }'
echo

# CPU 

echo "Total CPU Usage:"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "CPU Usage: ${CPU_USAGE}%"
echo

# Memory Usage
 
echo "Memory Usage:"
free -m | awk '
NR==2 {
    total=$2
    used=$3
    free=$4
    percent=(used/total)*100
    printf "Total: %s MB\nUsed: %s MB\nFree: %s MB\nUsage: %.2f%%\n", total, used, free, percent
}'
echo

# Disk 

echo "Disk Usage (Root Partition):"
df -h / | awk '
NR==2 {
    printf "Total: %s\nUsed: %s\nFree: %s\nUsage: %s\n", $2, $3, $4, $5
}'
echo


# Top 5 Processes by CPU

echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo


# Top 5 Processes by Memory

echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo


# Logged In Users

echo "Logged In Users:"
who
echo


# Failed Login Attempts (Debian/Ubuntu)

if [ -f /var/log/auth.log ]; then
    echo "Failed Login Attempts (last 5):"
    grep "Failed password" /var/log/auth.log | tail -n 5
    echo
fi

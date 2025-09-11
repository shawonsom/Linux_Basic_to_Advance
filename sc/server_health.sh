#!/bin/bash
script_name="server_performance_$(date +%F).txt"
mkdir server_performance
# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
UNDERLINE="\e[4m"
{ print_header() {
    echo -e "\n${CYAN}${BOLD}${UNDERLINE}$1${RESET}"
}
# ------------------------ Hostname ------------------------
print_header "IP Address"
ip -4 addr show $(ip route get 1 | awk '{print $5}' | head -1) | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

# ------------------------ Hostname ------------------------
print_header "Hostname"
if [ -f /etc/hostname ]; then
    hostname=$(cat /etc/hostname)
else
    hostname=$(uname -n)
fi
echo -e "${GREEN}${hostname}${RESET}"
# ------------------------ CPU Uptime ------------------------
read system_uptime idle_time < /proc/uptime
total_seconds=${system_uptime%.*}
fractional_part=${system_uptime#*.}
days=$((total_seconds / 86400 ))
print_header "CPU Uptime"
[[ $days -gt 0 ]] && echo "$days days"

# ------------------------ Memory Usage -----------------------
read total_memory available_memory <<< $(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END {print t, a}' /proc/meminfo)
used_memory=$((total_memory - available_memory))
# Convert to GB and format
total_memory_gb=$(awk -v t=$total_memory 'BEGIN { printf("%.2f", t / 1048576) }')
used_memory_gb=$(awk -v u=$used_memory 'BEGIN { printf("%.2f", u / 1048576) }')
available_memory_gb=$(awk -v a=$available_memory 'BEGIN { printf("%.2f", a / 1048576) }')
# Calculate percentages
used_memory_percent=$(awk -v u=$used_memory -v t=$total_memory 'BEGIN { printf("%.1f", (u / t) * 100) }')
free_memory_percent=$(awk -v a=$available_memory -v t=$total_memory 'BEGIN { printf("%.1f", (a / t) * 100) }')
# Output
print_header "Memory Usage"
echo -e "Total Memory  : ${GREEN}${total_memory_gb} GB ${NORMAL}"
ram_usage=$(free -m | awk '/^Mem/ {printf "%.1f", $3/$2 * 100.0}')
echo -e "RAM Usage     : ${GREEN}${ram_usage}%${RESET}"
# ------------------------ Disk Usage ------------------------
print_header "Disk Usage"
# Use awk to join lines and process only the target volume
df -h | awk -v GREEN="\033[0;32m" -v RESET="\033[0m" '
BEGIN { found = 0 }
/\/dev\/mapper\/.*root/ {  # More flexible pattern matching
    found = 1
    fsname = $1
    size = $2
    used = $3
    avail = $4
    usep = $5
    printf "  Filesystem  : %s%s%s\n", GREEN, fsname, RESET
    printf "  Size        : %s%s%s\n", GREEN, size, RESET
    printf "  Used        : %s%s%s\n", GREEN, used, RESET
    printf "  Available   : %s%s%s\n", GREEN, avail, RESET
    printf "  Use%%        : %s%s%s\n", GREEN, usep, RESET
    found = 0
    exit  # Stop after finding the root filesystem
}'

# ------------------------ CPU Utilization ------------------------

# CPU Utilization Check
print_header "CPU Utilization"

# Get overall CPU usage
cpu_util=$(mpstat 1 1 | awk '/all/ {print 100 - $(NF)}' | tail -1 | awk '{printf "%.1f", $1}')
# Get load averages
load_avg=$(awk '{print $1,$2,$3}' /proc/loadavg)
# Get core count
cores=$(nproc)

# Color coding based on utilization
if (( $(echo "$cpu_util > 70" | bc -l) )); then
    color=$RED
elif (( $(echo "$cpu_util > 30" | bc -l) )); then
    color=$YELLOW
else
    color=$GREEN
fi

# Display information
echo -e "  CPU Usage    : ${color}${cpu_util}%${RESET}"
echo -e "  Load Average : ${GREEN}${load_avg}${RESET} (1m, 5m, 15m)"
echo -e "  CPU Cores    : ${GREEN}${cores}${RESET}"


# ------------------------ Load Average ------------------------
print_header "Load Average"
load_avg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
echo -e "Load Average  : ${GREEN}${load_avg}${RESET}"
# ------------------------ Response Time ------------------------
print_header "Response Time"
response_time=$(curl -o /dev/null -s -w '%{time_total}\n' http://localhost)
echo -e "Response Time : ${GREEN}${response_time}s${RESET}"

} > server_performance/"$script_name"
# Display the script name
echo -e "\n${BOLD}Performance report saved to: ${script_name}${NORMAL}"
# Display the content of the script
cat server_performance/"$script_name"
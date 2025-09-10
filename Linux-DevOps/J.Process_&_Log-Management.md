# Linux Process and Log Management

## Table of Contents
1. [Introduction to Process Management](#introduction-to-process-management)
2. [Viewing Processes](#viewing-processes)
3. [Controlling Processes](#controlling-processes)
4. [Process Priority and Scheduling](#process-priority-and-scheduling)
5. [Background and Foreground Processes](#background-and-foreground-processes)
6. [System Monitoring Tools](#system-monitoring-tools)
7. [Introduction to Log Management](#introduction-to-log-management)
8. [System Log Files](#system-log-files)
9. [Log Management Tools](#log-management-tools)
10. [Log Rotation](#log-rotation)
11. [Advanced Process Management](#advanced-process-management)
12. [Systemd Journal](#systemd-journal)
13. [Best Practices](#best-practices)

## Introduction to Process Management

In Linux, a process is an instance of a running program. Each process has a unique Process ID (PID) and maintains its own execution context, including memory space, file descriptors, and security context.

### Process States
- **Running**: Currently executing on CPU
- **Sleeping**: Waiting for an event or resource
- **Stopped**: Suspended by a signal
- **Zombie**: Process has terminated but parent hasn't collected exit status
- **Uninterruptible Sleep**: Waiting for hardware event

## Viewing Processes

### ps Command
```bash
# Basic process listing
ps

# Show all processes
ps -A
ps -e

# Detailed output with full format
ps -ef
ps -aux

# Show processes in hierarchy
ps -ejH
ps axjf

# Show processes for specific user
ps -u username
ps -U username

# Custom output format
ps -eo pid,ppid,user,comm,%cpu,%mem,start_time
ps -eo pid,ppid,user,cmd --sort=-%cpu | head -10
```

### top Command
```bash
# Interactive process viewer
top

# Batch mode (non-interactive)
top -b -n 1

# Custom refresh delay
top -d 5

# Show specific user processes
top -u username

# Show specific columns
top -o %CPU  # Sort by CPU usage
top -o %MEM  # Sort by memory usage
```

### htop Command (Enhanced top)
```bash
# Install htop
sudo apt install htop  # Debian/Ubuntu
sudo yum install htop  # RHEL/CentOS

# Interactive process management
htop

# Tree view
htop -t

# Show custom columns
htop -s PERCENT_CPU
```

### pstree Command
```bash
# Show process tree
pstree

# Show PIDs
pstree -p

# Show all processes
pstree -a

# Show for specific user
pstree username
```

## Controlling Processes

### Killing Processes
```bash
# Graceful termination (SIGTERM)
kill PID
kill -15 PID

# Forceful termination (SIGKILL)
kill -9 PID

# Kill by process name
pkill process_name
pkill -9 process_name

# Kill all processes by name
killall process_name
killall -9 process_name

# Kill processes by user
pkill -u username
killall -u username
```

### Process Signals
```bash
# Common signals
kill -1 PID    # SIGHUP - Hangup (reload configuration)
kill -2 PID    # SIGINT - Interrupt (Ctrl+C)
kill -3 PID    # SIGQUIT - Quit with core dump
kill -9 PID    # SIGKILL - Force termination
kill -15 PID   # SIGTERM - Graceful termination
kill -18 PID   # SIGCONT - Continue stopped process
kill -19 PID   # SIGSTOP - Stop/suspend process

# List all signals
kill -l
```

### nice and renice Commands
```bash
# Start process with low priority
nice -n 19 command

# Start process with high priority
nice -n -20 command

# Change priority of running process
renice -n 10 -p PID
renice -n 5 -u username
```

## Process Priority and Scheduling

### Understanding Nice Values
- Range: -20 (highest priority) to 19 (lowest priority)
- Default nice value: 0
- Regular users can only lower priority (increase nice value)
- Root can set any priority

### ionice Command (I/O Priority)
```bash
# Set I/O priority
ionice -c 2 -n 7 command

# Classes:
# -c 1: Real time (highest priority)
# -c 2: Best effort (default)
# -c 3: Idle (lowest priority)

# Change I/O priority of running process
ionice -p PID -c 3
```

## Background and Foreground Processes

### Job Control
```bash
# Start process in background
command &

# List jobs
jobs
jobs -l

# Bring job to foreground
fg %job_number

# Send job to background
bg %job_number

# Disown process (remove from job table)
disown %job_number
disown -h %job_number  # Keep running after terminal closes

# Use nohup to ignore hangup signals
nohup command &
```

### screen and tmux Commands
```bash
# screen - terminal multiplexer
screen -S session_name
screen -list
screen -r session_name
screen -X -S session_name quit

# tmux - modern terminal multiplexer
tmux new -s session_name
tmux list-sessions
tmux attach -t session_name
tmux kill-session -t session_name
```

## System Monitoring Tools

### vmstat Command
```bash
# System performance overview
vmstat
vmstat 5        # Update every 5 seconds
vmstat 5 10     # Update every 5 seconds, 10 times

# Show disk statistics
vmstat -d

# Show memory statistics
vmstat -s
```

### iostat Command
```bash
# CPU and I/O statistics
iostat
iostat 2        # Update every 2 seconds
iostat -x       # Extended statistics
iostat -dx 2    # Device extended stats every 2 seconds
```

### free Command
```bash
# Memory usage
free
free -h         # Human readable
free -m         # Megabytes
free -g         # Gigabytes
free -t         # Total line
```

### sar Command (System Activity Reporter)
```bash
# Install sysstat
sudo apt install sysstat

# View historical data
sar
sar -u          # CPU usage
sar -r          # Memory usage
sar -b          # I/O statistics
sar -n DEV      # Network statistics

# Real-time monitoring
sar -u 2 5      # CPU every 2 seconds, 5 times
```

## Introduction to Log Management

Linux uses a comprehensive logging system to record system events, application activities, and security-related information.

### Syslog Facility and Severity Levels

**Facilities:**
- auth, authpriv: Security/authentication messages
- cron: Scheduled task messages
- daemon: System daemon messages
- kern: Kernel messages
- mail: Mail system messages
- syslog: Messages from syslog itself
- user: User-level messages
- local0 through local7: Custom facilities

**Severity Levels:**
- emerg: System is unusable
- alert: Action must be taken immediately
- crit: Critical conditions
- err: Error conditions
- warning: Warning conditions
- notice: Normal but significant conditions
- info: Informational messages
- debug: Debug-level messages

## System Log Files

### Common Log Locations
```bash
# System logs
/var/log/syslog          # General system messages
/var/log/messages        # General system messages (RHEL/CentOS)
/var/log/auth.log        # Authentication logs
/var/log/secure          # Authentication logs (RHEL/CentOS)
/var/log/kern.log        # Kernel messages
/var/log/boot.log        # System boot messages
/var/log/dmesg           # Kernel ring buffer messages

# Application logs
/var/log/apache2/        # Apache web server
/var/log/nginx/          # Nginx web server
/var/log/mysql/          # MySQL database
/var/log/postgresql/     # PostgreSQL database

# Service logs
/var/log/cron            # Cron jobs
/var/log/mail.log        # Mail server
/var/log/faillog         # Failed login attempts
/var/log/lastlog         # Last login records
```

### Viewing Log Files
```bash
# Real-time log monitoring
tail -f /var/log/syslog
tail -f /var/log/auth.log

# Follow multiple files
multitail /var/log/syslog /var/log/auth.log

# Search logs
grep "error" /var/log/syslog
grep -i "failed" /var/log/auth.log

# View specific time range
sed -n '/Dec 10 10:00:00/,/Dec 10 11:00:00/p' /var/log/syslog

# Count occurrences
grep -c "authentication failure" /var/log/auth.log
```

## Log Management Tools

### logger Command
```bash
# Send custom messages to syslog
logger "This is a test message"
logger -p local0.notice "Application started"
logger -t myscript -p user.info "Script completed successfully"
```

### logrotate Configuration
```bash
# Manual log rotation
logrotate -f /etc/logrotate.conf
logrotate -f /etc/logrotate.d/nginx

# Force rotation with debug output
logrotate -d -f /etc/logrotate.d/apache2
```

### Example logrotate Configuration
```bash
# /etc/logrotate.d/myapp
/var/log/myapp/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 root root
    postrotate
        /usr/bin/systemctl reload myapp.service > /dev/null
    endscript
}
```

## Log Rotation

### Understanding logrotate
Logrotate automatically manages log files by:
- Rotating logs based on size or time
- Compressing old log files
- Removing very old logs
- Running pre/post scripts

### Common logrotate Options
```bash
daily, weekly, monthly      # Rotation schedule
rotate COUNT                # Keep COUNT rotated logs
size SIZE                   # Rotate when log reaches SIZE (e.g., 100K, 10M)
compress                    # Compress rotated logs
delaycompress               # Compress previous rotation
missingok                   # Don't error if log is missing
notifempty                  # Don't rotate empty logs
create MODE OWNER GROUP     # Create new log file with specified permissions
postrotate/endscript        # Commands to run after rotation
prerotate/endscript         # Commands to run before rotation
```

## Advanced Process Management

### lsof Command (List Open Files)
```bash
# List all open files
lsof

# List files opened by specific process
lsof -p PID

# List processes using specific file
lsof /path/to/file

# List network connections
lsof -i
lsof -i :80          # Processes using port 80
lsof -i tcp:443      # Processes using TCP port 443

# List user's open files
lsof -u username
```

### fuser Command (Identify Process Using File)
```bash
# Show PIDs using file/directory
fuser /path/to/file

# Show with more detail
fuser -v /path/to/file

# Kill processes using file
fuser -k /path/to/file

# Kill with specific signal
fuser -k -TERM /path/to/file
```

### strace Command (System Call Tracer)
```bash
# Trace system calls
strace command

# Trace running process
strace -p PID

# Save output to file
strace -o trace.log command

# Count system calls
strace -c command

# Trace specific system calls
strace -e open,read command
```

### /proc Filesystem
```bash
# Process information
cat /proc/PID/status
cat /proc/PID/cmdline
cat /proc/PID/environ
cat /proc/PID/fd/        # Open file descriptors

# System information
cat /proc/meminfo
cat /proc/cpuinfo
cat /proc/loadavg
cat /proc/uptime
```

## Systemd Journal

### journalctl Command
```bash
# View all logs
journalctl

# Follow logs in real-time
journalctl -f

# Show logs for specific unit
journalctl -u nginx.service
journalctl -u docker.service

# Show logs since boot
journalctl -b

# Show logs with priority
journalctl -p err
journalctl -p warning..err

# Show logs for specific time period
journalctl --since "2023-12-10 10:00:00" --until "2023-12-10 11:00:00"
journalctl --since yesterday
journalctl --since "1 hour ago"

# Show kernel messages
journalctl -k

# Export logs to file
journalctl > journal.log

# Show disk usage
journalctl --disk-usage

# Vacuum old logs
journalctl --vacuum-time=2weeks
journalctl --vacuum-size=500M
```

## Best Practices

### Process Management Best Practices
1. **Monitor Resource Usage**: Regularly check CPU, memory, and I/O usage
2. **Use Appropriate Signals**: Prefer SIGTERM over SIGKILL for graceful shutdown
3. **Set Process Limits**: Use ulimit to prevent resource exhaustion
4. **Monitor Zombie Processes**: Regularly check for and clean up zombie processes
5. **Use Process Supervision**: For critical services, use systemd or supervisor

### Log Management Best Practices
1. **Centralized Logging**: Consider using centralized logging solutions
2. **Regular Log Rotation**: Configure appropriate log rotation policies
3. **Log Monitoring**: Set up alerts for critical errors
4. **Security Considerations**: Protect sensitive log information
5. **Storage Management**: Plan for log storage requirements

### Monitoring Script Example
```bash
#!/bin/bash
# monitor-system.sh

# Check critical processes
CRITICAL_PROCESSES=("nginx" "mysql" "redis")
for process in "${CRITICAL_PROCESSES[@]}"; do
    if ! pgrep -x "$process" > /dev/null; then
        echo "CRITICAL: $process is not running" | logger -p local0.alert
    fi
done

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "CRITICAL: Disk usage is $DISK_USAGE%" | logger -p local0.alert
fi

# Check memory usage
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')
if [ "$MEM_USAGE" -gt 85 ]; then
    echo "WARNING: Memory usage is $MEM_USAGE%" | logger -p local0.warning
fi
```

### Automated Log Analysis
```bash
#!/bin/bash
# analyze-logs.sh

# Count authentication failures
AUTH_FAILURES=$(grep -c "authentication failure" /var/log/auth.log)
if [ "$AUTH_FAILURES" -gt 10 ]; then
    echo "ALERT: $AUTH_FAILURES authentication failures detected" | \
    logger -p auth.alert
fi

# Check for kernel errors
KERNEL_ERRORS=$(journalctl -k --since "1 hour ago" -p err | wc -l)
if [ "$KERNEL_ERRORS" -gt 0 ]; then
    echo "ALERT: $KERNEL_ERRORS kernel errors in last hour" | \
    logger -p kern.alert
fi

# Monitor service restarts
RESTARTS=$(journalctl --since "1 day ago" | grep -c "Stopped\|Started")
if [ "$RESTARTS" -gt 20 ]; then
    echo "NOTICE: $RESTARTS service restarts in last 24 hours" | \
    logger -p daemon.notice
fi
```

This comprehensive guide covers essential Linux process and log management techniques, providing system administrators with the tools needed to monitor, control, and troubleshoot system processes and maintain effective log management practices.

# Cron & At: Scheduling Tasks

## ⏰ Cron - Recurring Job Scheduler

### Basic Cron Usage
```bash
# Edit current user's cron jobs
crontab -e

# List current user's cron jobs
crontab -l

# List another user's cron jobs (root only)
crontab -u username -l

# Remove all cron jobs
crontab -r
```

### System-wide Cron Directories
```bash
/etc/
├── cron.hourly/    # Runs hourly
├── cron.daily/     # Runs daily
├── cron.weekly/    # Runs weekly
├── cron.monthly/   # Runs monthly
└── cron.d/         # Additional cron files
```

### Cron Time Format Syntax
```
* * * * * command-to-execute
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, 0=7=Sunday)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

### Common Cron Examples
```bash
# Run every minute
* * * * * /path/to/command

# Run every day at 2:30 AM
30 2 * * * /path/to/backup.sh

# Run every Monday at 6:00 PM
0 18 * * 1 /path/to/weekly-report.sh

# Run every 10 minutes
*/10 * * * * /path/to/monitor-script.sh

# Run on the 1st of every month at 3:15 AM
15 3 1 * * /path/to/monthly-cleanup.sh

# Run every weekday (Mon-Fri) at 9:00 AM
0 9 * * 1-5 /path/to/daily-check.sh

# Run every Sunday at 11:59 PM
59 23 * * 0 /path/to/sunday-task.sh
```

### Special Cron Strings
```bash
@reboot     /path/to/script.sh    # Run at boot
@yearly     /path/to/script.sh    # Run once a year (0 0 1 1 *)
@annually   /path/to/script.sh    # Same as @yearly
@monthly    /path/to/script.sh    # Run once a month (0 0 1 * *)
@weekly     /path/to/script.sh    # Run once a week (0 0 * * 0)
@daily      /path/to/script.sh    # Run once a day (0 0 * * *)
@hourly     /path/to/script.sh    # Run once an hour (0 * * * *)
```

### Environment Variables in Cron
```bash
# Add to crontab for proper environment
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=user@example.com

# Example with full path and output redirection
0 2 * * * /usr/bin/backup.sh > /var/log/backup.log 2>&1
```

## 🎯 At - One-time Task Scheduling

### Basic At Commands
```bash
# Schedule a one-time job
at 14:30
at now + 1 hour
at 10:00 tomorrow

# List pending jobs
atq

# Remove a job
atrm <job_number>

# View job details
at -c <job_number>
```

### Practical At Examples
```bash
# Schedule job at specific time
echo "/path/to/script.sh" | at 23:00

# Schedule job in 2 hours
echo "tar -czf backup.tar.gz /home" | at now + 2 hours

# Interactive at session
at 15:00
# Then enter commands, press Ctrl+D to finish
/path/to/command1
/path/to/command2
Ctrl+D

# Schedule for specific date
echo "systemctl reboot" | at 02:00 2024-12-31
```

### At Time Formats
```bash
# Absolute times
at 14:30
at 2:30 PM
at 23:45

# Relative times
at now + 1 hour
at now + 30 minutes
at now + 2 days
at now + 1 week

# Specific dates
at 10:00 tomorrow
at 9:00 next week
at 2:30 PM Fri
at 3:00 December 25
```

## 🔧 Management & Monitoring

### Viewing Scheduled Jobs
```bash
# Cron jobs for current user
crontab -l

# All users' cron jobs (root only)
cat /etc/passwd | cut -d: -f1 | xargs -I {} crontab -l -u {} 2>/dev/null

# Pending at jobs
atq

# System cron files
ls -la /etc/cron.*/
```

### Security & Access Control
```bash
# Files controlling access
/etc/cron.allow    # Users allowed to use cron
/etc/cron.deny     # Users denied from using cron
/etc/at.allow      # Users allowed to use at
/etc/at.deny       # Users denied from using at

# If allow file exists, deny file is ignored
# If neither exists, only root can use the command
```

### Best Practices

#### 1. Use Full Paths
```bash
# ❌ Bad - relies on PATH
0 2 * * * backup.sh

# ✅ Good - uses full path
0 2 * * * /usr/local/bin/backup.sh
```

#### 2. Redirect Output
```bash
# Redirect to file
0 2 * * * /path/to/script.sh > /var/log/script.log 2>&1

# Redirect to email (if MAILTO is set)
0 2 * * * /path/to/script.sh

# Discard output
0 2 * * * /path/to/script.sh > /dev/null 2>&1
```

#### 3. Environment Setup
```bash
# Set environment in crontab
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
HOME=/home/username
MAILTO=admin@example.com
```

## 🛠️ Practical Examples for SCA

### System Maintenance Tasks
```bash
# Daily backup at 2 AM
0 2 * * * /usr/bin/tar -czf /backups/$(date +\%Y\%m\%d).tar.gz /home

# Weekly log rotation on Sunday
0 0 * * 0 /usr/sbin/logrotate /etc/logrotate.conf

# Monthly system update on 1st
0 3 1 * * /usr/bin/zypper update -y

# Clean temp files every day at 6 AM
0 6 * * * /usr/bin/find /tmp -type f -mtime +7 -delete
```

### Monitoring Tasks
```bash
# Check disk space every hour
0 * * * * /usr/bin/df -h > /var/log/disk-usage.log

# Monitor service every 5 minutes
*/5 * * * * /usr/bin/systemctl is-active --quiet nginx || systemctl start nginx

# System health check daily
30 1 * * * /usr/local/bin/health-check.sh
```

### Using At for System Tasks
```bash
# Schedule system reboot
echo "systemctl reboot" | at 03:00

# Schedule large file download for off-hours
echo "wget http://example.com/large-file.iso" | at now + 6 hours

# Schedule temporary monitoring
echo "/usr/local/bin/monitor-cpu.sh" | at 14:00 today
```


### Key Concepts to Remember
1. **Cron vs At**: Cron for recurring, At for one-time
2. **Time Format**: `min hour dom month dow`
3. **User Context**: Cron jobs run with user's permissions
4. **Environment**: Cron has minimal environment by default
5. **Output Handling**: Always redirect output appropriately

### Troubleshooting Commands
```bash
# Check if cron service is running
systemctl status cron

# View cron logs
grep CRON /var/log/messages

# Verify cron syntax
crontab -l

# Test at daemon
systemctl status atd
```

This knowledge is essential for the SCA exam - practice creating and managing scheduled tasks regularly!

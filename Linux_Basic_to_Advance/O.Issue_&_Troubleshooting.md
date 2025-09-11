# Linux Issue, Error, and Bug Troubleshooting Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Troubleshooting Methodology](#troubleshooting-methodology)
3. [Common Linux Issues](#common-linux-issues)
4. [System Diagnostics](#system-diagnostics)
5. [Log File Analysis](#log-file-analysis)
6. [Network Troubleshooting](#network-troubleshooting)
7. [Disk and Filesystem Issues](#disk-and-filesystem-issues)
8. [Package Management Problems](#package-management-problems)
9. [Kernel and Hardware Issues](#kernel-and-hardware-issues)
10. [Performance Troubleshooting](#performance-troubleshooting)
11. [Security Issues](#security-issues)
12. [Script Debugging](#script-debugging)
13. [Recovery Techniques](#recovery-techniques)
14. [Prevention Best Practices](#prevention-best-practices)

## Introduction

This guide provides comprehensive troubleshooting techniques for identifying, diagnosing, and resolving common Linux issues, errors, and bugs. Effective troubleshooting requires a systematic approach and knowledge of key diagnostic tools.

## Troubleshooting Methodology

### The Systematic Approach
1. **Identify the Problem**
   - What exactly is happening?
   - When did it start?
   - What changed recently?

2. **Gather Information**
   - Error messages
   - Log files
   - System status

3. **Develop Hypotheses**
   - Possible causes
   - Potential solutions

4. **Test Solutions**
   - One change at a time
   - Document changes

5. **Verify Resolution**
   - Confirm the fix works
   - Monitor for recurrence

6. **Document Findings**
   - Root cause
   - Solution applied
   - Prevention measures

### Essential Troubleshooting Commands
```bash
# System information
uname -a
cat /etc/os-release
hostnamectl

# Process management
ps aux
top
htop

# System monitoring
free -h
df -h
iostat
vmstat

# Network diagnostics
ip a
ss -tuln
ping
traceroute
```

## Common Linux Issues

### Boot Problems
```bash
# Common boot issues and solutions

# 1. Grub rescue prompt
# Solution: Rebuild grub configuration
sudo grub-install /dev/sda
sudo update-grub

# 2. Kernel panic
# Solution: Boot from previous kernel or recovery mode

# 3. Filesystem corruption
# Solution: Boot from live CD and run fsck
sudo fsck -y /dev/sda1

# 4. Initramfs issues
# Solution: Rebuild initramfs
sudo update-initramfs -u
```

### Service Failures
```bash
# Check service status
sudo systemctl status service-name

# View service logs
sudo journalctl -u service-name

# Restart failed service
sudo systemctl restart service-name

# Enable service to start on boot
sudo systemctl enable service-name

# Investigate service dependencies
systemctl list-dependencies service-name
```

### Permission Issues
```bash
# Common permission problems
# 1. "Permission denied" errors
# Solution: Check ownership and permissions
ls -la /path/to/file
sudo chown user:group /path/to/file
sudo chmod 755 /path/to/file

# 2. SELinux/AppArmor denials
# Solution: Check audit logs
sudo ausearch -m avc -ts recent
sudo setenforce 0  # Temporarily disable SELinux

# 3. sudo access issues
# Solution: Check sudoers file
sudo visudo
```

## System Diagnostics

### System Information Gathering
```bash
# Comprehensive system info
sudo dmidecode
sudo lshw
lscpu
lsblk
lsusb
lspci

# Kernel messages
dmesg
dmesg -T  # With timestamps
dmesg -l err  # Only error messages

# Hardware diagnostics
sudo smartctl -a /dev/sda  # Disk health
sensors  # Temperature monitoring
```

### Process Analysis
```bash
# Process troubleshooting
ps aux --sort=-%mem  # Sort by memory usage
ps aux --sort=-%cpu  # Sort by CPU usage

# Find processes using specific port
sudo lsof -i :80
sudo netstat -tulnp | grep :80

# Kill processes
pkill process-name
killall process-name
kill -9 PID

# Process tree view
pstree
pstree -p  # With PIDs
```

## Log File Analysis

### Key Log Files
```bash
# System logs
/var/log/syslog
/var/log/messages
/var/log/kern.log
/var/log/dmesg

# Application logs
/var/log/apache2/access.log  # Apache
/var/log/nginx/access.log    # Nginx
/var/log/mysql/error.log     # MySQL
/var/log/postgresql/         # PostgreSQL

# Authentication logs
/var/log/auth.log
/var/log/secure

# Boot logs
/var/log/boot.log
```

### Log Analysis Techniques
```bash
# Real-time log monitoring
sudo tail -f /var/log/syslog
sudo journalctl -f  # Systemd journals

# Filter logs by time
sudo journalctl --since "2023-01-01" --until "2023-01-02"
sudo journalctl --since "1 hour ago"

# Filter by priority
sudo journalctl -p err  # Error messages
sudo journalctl -p warning  # Warnings

# Search for specific terms
sudo grep -i "error" /var/log/syslog
sudo journalctl -u nginx -g "error"

# Log rotation check
ls -la /var/log/
logrotate --debug /etc/logrotate.conf
```

## Network Troubleshooting

### Network Diagnostics
```bash
# Basic network checks
ip a  # Show IP addresses
ip route  # Show routing table
ip link  # Show network interfaces

# Connectivity testing
ping google.com
ping -c 4 8.8.8.8  # Limited packets
traceroute google.com
mtr google.com  # Continuous traceroute

# Port and service checking
sudo netstat -tulnp
sudo ss -tuln
nc -zv hostname port  # Test specific port
telnet hostname port  # Test TCP connection

# DNS troubleshooting
dig google.com
nslookup google.com
cat /etc/resolv.conf
```

### Network Configuration Issues
```bash
# Common network problems and solutions

# 1. No network connectivity
# Check interface status
ip link show eth0

# Restart network service
sudo systemctl restart networking
sudo systemctl restart NetworkManager

# 2. DNS resolution issues
# Check DNS configuration
cat /etc/resolv.conf
cat /etc/hosts

# 3. Firewall blocking
# Check firewall rules
sudo iptables -L -n
sudo ufw status

# 4. Routing problems
# Check routing table
ip route
traceroute 8.8.8.8
```

## Disk and Filesystem Issues

### Disk Space Problems
```bash
# Disk space analysis
df -h  # Show disk usage
du -sh /path/to/directory  # Directory size
du -h --max-depth=1 / | sort -hr  # Largest directories

# Find large files
find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null
find / -name "*.log" -size +100M  # Large log files

# Cleanup strategies
sudo apt autoremove  # Remove unused packages
sudo journalctl --vacuum-size=100M  # Clean journals
sudo rm /var/log/*.log.*  # Old log files
```

### Filesystem Errors
```bash
# Filesystem check and repair
# Unmount filesystem first if possible
sudo umount /dev/sda1

# Check filesystem
sudo fsck -y /dev/sda1

# For root filesystem, use recovery mode or live CD
# Force check on next reboot
sudo touch /forcefsck
sudo shutdown -r now

# Monitor disk health
sudo smartctl -a /dev/sda
sudo badblocks -v /dev/sda  # Check for bad blocks
```

### Mount Issues
```bash
# Mount problems troubleshooting
cat /etc/fstab  # Check fstab entries
sudo mount -a  # Test mount all filesystems

# Debug mount issues
sudo mount -v /dev/sda1 /mnt  # Verbose mount
sudo dmesg | grep mount  # Check kernel messages

# NFS/CIFS mount issues
sudo showmount -e nfs-server
sudo mount.nfs4 -v server:/share /mnt  # Verbose NFS mount
```

## Package Management Problems

### APT/DNF/YUM Issues
```bash
# Common package management errors

# 1. Broken dependencies
sudo apt --fix-broken install
sudo apt autoremove
sudo dpkg --configure -a

# 2. Repository errors
sudo apt update
sudo rm /var/lib/apt/lists/*  # Clear package lists
sudo apt clean

# 3. Package conflicts
sudo apt install -f  # Fix conflicts
sudo dpkg -r package-name  # Remove problematic package

# 4. Signature errors
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys KEY_ID
```

### Dependency Hell Solutions
```bash
# Advanced dependency resolution
sudo aptitude  # Interactive dependency resolver
sudo apt-get install -o Dpkg::Options::="--force-overwrite"
sudo dpkg -i --force-all package.deb  # Last resort

# Check package integrity
sudo debsums -a  # Verify installed packages
sudo rpm -Va  # Verify RPM packages

# Clean package cache
sudo apt clean
sudo yum clean all
sudo dnf clean all
```

## Kernel and Hardware Issues

### Kernel Problems
```bash
# Kernel issue diagnostics
uname -r  # Current kernel version
cat /proc/version

# Kernel parameter issues
cat /proc/cmdline
sudo grubby --info=ALL  # GRUB2 kernel parameters

# Kernel module problems
lsmod  # Loaded modules
modinfo module-name  # Module information
dmesg | grep module-name  # Module errors

# Blacklist problematic modules
echo "blacklist module-name" | sudo tee /etc/modprobe.d/blacklist.conf
```

### Hardware Diagnostics
```bash
# Hardware troubleshooting tools
sudo lspci -vv  # Detailed PCI information
sudo lsusb -v  # USB device details
sudo lscpu  # CPU information

# Memory testing
sudo memtester 500M 1  # Test 500MB memory once
# For comprehensive test, use memtest86+ from boot

# Disk testing
sudo badblocks -sv /dev/sda  # Surface scan
sudo hdparm -tT /dev/sda  # Disk performance

# Temperature monitoring
sensors
cat /proc/cpuinfo | grep MHz  # CPU frequency
```

## Performance Troubleshooting

### System Performance Analysis
```bash
# Performance monitoring tools
top
htop
atop
glances

# CPU performance
mpstat -P ALL 1  # CPU usage per core
pidstat 1  # Process CPU usage

# Memory analysis
vmstat 1  # Virtual memory statistics
sudo slabtop  # Kernel slab cache

# I/O performance
iostat -xz 1  # Disk I/O statistics
iotop  # Disk I/O by process

# Network performance
nethogs  # Network usage by process
iftop  # Network interface usage
```

### Performance Bottleneck Identification
```bash
# Systematic performance analysis

# 1. CPU bottlenecks
# Check load average
uptime
# Check CPU wait time
vmstat 1

# 2. Memory bottlenecks
# Check swap usage
free -h
# Check page faults
vmstat -s

# 3. I/O bottlenecks
# Check await time
iostat -x 1
# Check I/O wait
top

# 4. Network bottlenecks
# Check bandwidth
nload
# Check connection states
ss -s
```

## Security Issues

### Security Breach Response
```bash
# Suspected compromise checklist

# 1. Immediate actions
sudo systemctl stop networking  # Disconnect from network
sudo systemctl stop service-name  # Stop affected services

# 2. Investigation
sudo last  # Recent logins
sudo lastb  # Failed login attempts
sudo netstat -tulnp  # Unexpected connections
sudo lsof -i  # Open network connections

# 3. Malware scanning
sudo clamscan -r /  # Virus scan
sudo rkhunter --check  # Rootkit check
sudo chkrootkit  # Rootkit detection

# 4. Forensic analysis
sudo find / -uid 0 -perm -4000  # SUID files
sudo find / -type f -mtime -1  # Recently modified files
```

### Security Hardening
```bash
# Security assessment tools
sudo lynis audit system  # System hardening audit
sudo aide --check  # File integrity check

# Firewall configuration
sudo ufw enable
sudo ufw status verbose

# SSH security hardening
sudo nano /etc/ssh/sshd_config
# Disable root login, use key authentication, change port

# Automatic security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

## Script Debugging

### Bash Script Debugging
```bash
# Script debugging techniques

# 1. Syntax checking
bash -n script.sh  # Check syntax without execution

# 2. Trace execution
bash -x script.sh  # Print commands before execution
set -x  # Enable tracing within script
set +x  # Disable tracing

# 3. Verbose mode
bash -v script.sh  # Print shell input lines

# 4. Debug specific sections
trap 'echo "Line: $LINENO, Variable: $var"' DEBUG

# 5. Error handling
set -e  # Exit on error
set -u  # Treat unset variables as error
set -o pipefail  # Pipeline commands fail if any command fails
```

### Common Script Errors
```bash
# Frequent scripting issues and solutions

# 1. Permission problems
chmod +x script.sh
./script.sh  # Instead of sh script.sh

# 2. Path issues
#!/bin/bash  # Correct shebang
export PATH=/usr/local/bin:$PATH

# 3. Variable expansion
# Use quotes: "$variable" instead of $variable
# Use braces: ${variable}_suffix

# 4. Command substitution
# Use $(command) instead of `command`

# 5. Arithmetic operations
# Use $((expression)) instead of expr
result=$((a + b))
```

## Recovery Techniques

### System Recovery
```bash
# Recovery mode access
# Reboot and hold Shift (GRUB) or Esc (systemd-boot)

# Single user mode
# Add "single" or "init=/bin/bash" to kernel parameters

# Filesystem repair from live CD
sudo fsck -y /dev/sda1
sudo mount /dev/sda1 /mnt
sudo chroot /mnt

# Package system recovery
sudo dpkg --configure -a
sudo apt --fix-broken install

# Grub recovery
sudo grub-install /dev/sda
sudo update-grub
```

### Data Recovery
```bash
# Data recovery tools
sudo apt install testdisk photorec

# Deleted file recovery
sudo photorec /dev/sda1

# Partition recovery
sudo testdisk /dev/sda

# File carving
sudo foremost -i /dev/sda1 -o /recovery/

# Backup restoration
# From backup tools: rsync, tar, duplicity, etc.
```

## Prevention Best Practices

### Proactive Monitoring
```bash
# System monitoring setup
sudo apt install nagios-plugins zabbix-agent

# Log monitoring
sudo apt install logwatch logcheck

# Automated health checks
# Create cron jobs for regular system checks
0 * * * * /usr/local/bin/system-health-check.sh

# Backup strategies
# Regular automated backups
0 2 * * * /usr/local/bin/backup-script.sh

# Security updates
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

### Documentation and Knowledge Base
```bash
# Maintain system documentation
# Keep records of:
# - System configuration changes
# - Issues encountered and solutions
# - Backup procedures
# - Recovery processes

# Use configuration management
sudo apt install ansible puppet chef

# Implement version control for configurations
git init /etc/
git add /etc/nginx/nginx.conf
git commit -m "Initial nginx configuration"
```

### Regular Maintenance
```bash
# Scheduled maintenance tasks
# 1. Filesystem checks
sudo tune2fs -c 100 /dev/sda1  # Check every 100 mounts

# 2. Log rotation
sudo logrotate -f /etc/logrotate.conf

# 3. Package updates
sudo apt update && sudo apt upgrade

# 4. Security auditing
sudo lynis audit system
sudo rkhunter --propupd  # Update rootkit database

# 5. Backup verification
# Regularly test backup restoration
```

This comprehensive troubleshooting guide provides systematic approaches to diagnose and resolve Linux issues. Remember that effective troubleshooting requires patience, documentation, and a methodical approach. Always test solutions in a safe environment before applying them to production systems.

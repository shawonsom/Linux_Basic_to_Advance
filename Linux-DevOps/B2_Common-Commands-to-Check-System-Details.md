### Common Linux System Information Commands

### System Identification
 **Check Hostname**: `hostname` or `hostnamectl`
- **Set Hostname**: `hostnamectl set-hostname msi-linux.com`

## System Version Information
- **Check OS Version**: `cat /etc/os-release`
- **Check Kernel Version**: `uname -r`
- **Check System Architecture**: `uname -m`

## System Status
- **Check System Uptime**: `uptime`
- **Check System Boot Time**: `who -b`
- **Check System Time and Timezone**: `timedatectl`

## Hardware Information
- **Check CPU Information**: `lscpu`
- **Check Memory Usage**: `free -mh`
- **Check Hardware Information**: `lshw -short`

## Storage Information
- **Check Disk Usage**: `df -hT`
- **Check Block Devices**: `lsblk`
- **Check Mounted File Systems**: `mount | column -t`

## Network Information
- **Check Network Interface**: `ip a` or `ip addr show`
- **Check IP Routing Table**: `ip route show`

## System Management
- **Check Running Services**: `systemctl list-units --type=service`
- **Check User Logged-In Information**: `who`
- **Check Running Processes**: `ps aux`
- **Check Installed Packages**: `dpkg -l`

## Package Management
- **Check Available Updates**: `apt update`

---

# Package Management Comparison

## RPM-based Systems (Red Hat, CentOS, Fedora)
- **Package Format**: `.rpm` (Red Hat Package Manager)
- **Primary Tools**: 
  - `yum` (older) - Yellowdog Updater Modified
  - `dnf` (newer) - Dandified YUM

## DEB-based Systems (Debian, Ubuntu)
- **Package Format**: `.deb` (Debian Package)
- **Primary Tools**: 
  - `dpkg` - Low-level package manager
  - `apt` - Advanced Package Tool
  - `apt-get` - Original APT command-line tool

## APT vs APT-GET
- **`apt`**: Modern, user-friendly, combines most common operations
- **`apt-get`**: Traditional, more options, better for scripting

### Common APT Commands:
```bash
apt update          # Update package lists
apt upgrade         # Upgrade installed packages
apt install <pkg>   # Install package
apt remove <pkg>    # Remove package
apt search <term>   # Search for packages
```

### Common APT-GET Commands:
```bash
apt-get update          # Update package lists
apt-get upgrade         # Upgrade installed packages
apt-get install <pkg>   # Install package
apt-get remove <pkg>    # Remove package
```

### Common YUM/DNF Commands:
```bash
yum update          # Update all packages (YUM)
dnf update          # Update all packages (DNF)
yum install <pkg>   # Install package (YUM)
dnf install <pkg>   # Install package (DNF)
yum remove <pkg>    # Remove package (YUM)
dnf remove <pkg>    # Remove package (DNF)
```

> **Note**: Most modern distributions recommend using `apt` instead of `apt-get` for interactive use, and `dnf` instead of `yum` for newer RPM-based systems.
```

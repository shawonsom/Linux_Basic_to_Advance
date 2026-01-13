### Common Linux System Information Commands

### System Identification
 **Check Hostname**: `hostname` or `hostnamectl`
- **Set Hostname**: `hostnamectl set-hostname msi-linux.com`

## System Version Information
- **Check OS Version**: `cat /etc/os-release`
- **Check Kernel Version**: `uname -r`
- **Check System Architecture**: `uname -m`
- **Check all information at onece**: `uname -a`

## System Status
- **Check System Uptime**: `uptime`
- **Check System Boot Time**: `who -b`
- **Check System Time and Timezone**: `timedatectl`

## Hardware Information
- **Check CPU Information**: `lscpu`
- **Check Memory Usage**: `free -h`
- **Check details RAM**`dmidecode --type memory`
- **Check Hardware Information short**: `lshw -short`
- **Check All Hardware Information**: `lshw`

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

## Check virtulization Information
- **check is it bearmetal or on VM**: `systemd-detect-virt`
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

### Hide the bash username@hostname:
```bash
unset PS1                # hide interactive Bash session
export PS1="test--> "    # set what you want: example shows (test_server-->   )
PS1='[\u@\h \W]\$ '      # bring back the bash
```

**Note**: Most modern distributions recommend using `apt` instead of `apt-get` for interactive use, and `dnf` instead of `yum` for newer RPM-based systems.

- [Introduction to Linux](#Introduction-to-Linux)
  - What is Operating System
  - History of Linux | Unix
  - Importance of Linux
  - Linux Filesystem and directory Hierarchy
  - Linux Kernel, Boot Sequence, Kernel Space and User Space | How Linux works
- [2.Setting up the environment (installing both Ubuntu and Redhat)](#setting-up-the-environment-installing-both-ubuntu-and-redhat)
  - Graphical vs Minimal Mode
  - Linux - Networking
  - Connect/Login to Linux system | Login Client
  - Introduction to Shell
  - [Common commands to check system details after installing and accessing a server](#common-commands-to-check-system-details-after-installing-and-accessing-a-server)
  - Package Management
  - Package Management Distribution
  - RPM and YUM, DPKG and APT
  - APT Vs APT GET
- [Administering Users and Groups](#Administering-Users-and-Groups)
  - Creating and Managing a user
  - adduser | useradd
  - Understanding passwd and shadow files
  - Understanding Linux Groups (groups, id)
  - Creating, changing, and removing user accounts (useradd, usermod, userdel)
  - Sudo Group,Permissions and sudousers file for a user
  - Group management (groupadd, groupdel, groupmod)
  - User account monitoring (whoami, who am i, who, id, w, uptime, last)

- [System Performance & Tuning Tools]()

Linux – Software management
Linux – Managing disks and partitioning
Linux – Shell, permissions, tools, networking, processes
Web servers setup (LAMP & LEMP)
Deploying websites
Securing Linux Systems

All important Linux commands

Understanding file timestamps: atime, mtime, ctime (stat, touch, date)
Absolute vs. relative paths. Walking through the File System (pwd, cd, tree)
The LS Command in-depth (ls)

The Linux filesystem
File permissions
Process management
User account management
Software management
Networking in Linux
System administration
Bash Scripting
Iptables/Netfilter Firewall
Linux Security





## 🚀2.Setting up the environment (installing both Ubuntu and Redhat)
### Graphical vs Minimal Mode
### Linux - Networking
### Connect/Login to Linux system | Login Client
### Introduction to Shell
### Common commands to check system details after installing and accessing a server.
- Check Hostname - `hostname` | `hostnamectl` | `hostnamectl set-hostname msi-linux.com`
- Check OS Version - `cat /etc/os-release`
- Check Kernel Version - `uname -r`
- Check System Architecture - `uname -m`
- Check System Uptime - uptime
- Check CPU Information - `lscpu`
- Check Memory Usage - `free -mh`
- Check Disk Usage - `df -hT`
- Check Network Interface - `ip a` | `ip addr show`
- Check IP Routing Table - `ip route show`
- Check Running Services - systemctl list-units --type=service
- Check Block Devices - `lsblk`
- Check Mounted File Systems - `mount | column -t`
- Check User Logged-In Information - `who`
- Check Hardware Information - `lshw -short`
- Check Running Processes - `ps aux`
- Check Available Updates - `apt update`
- Check System Time and Timezone - `timedatectl`
- Check Installed Packages - `dpkg -l`
- Check System Boot Time - `who -b`
### Package Management
### Package Management Distribution
### RPM and YUM, DPKG and APT
### APT Vs APT GET





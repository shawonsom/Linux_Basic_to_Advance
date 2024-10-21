- [1.Introduction to Linux](#1Introduction-to-Linux)
  - What is Operating System
  - History of Linux | Unix
  - Importance of Linux
  - Linux Filesystem and directory Hierarchy
  - Linux Kernel, Boot Sequence, Kernel Space and User Space | How Linux works
  - Reset Root Password
- [2.Setting up the environment (installing both Ubuntu and Redhat)](#2setting-up-the-environment-installing-both-ubuntu-and-redhat)
  - Graphical vs Minimal Mode | Single User Mode vs Multi User Mode
  - Networking
  - Connect/Login to Linux system | Login Client
  - Introduction to Shell
  - Hostfile
  - Text Editor - vim | nano | vi | emacs
  - [Common commands to check system details after installing and accessing a server](#common-commands-to-check-system-details-after-installing-and-accessing-a-server)
- [3.Administering Users and Groups](#3Administering-Users-and-Groups)
  - Creating and Managing a user
  - adduser | useradd
  - Understanding passwd and shadow files
  - Understanding Linux Groups (groups, id)
  - Creating, changing, and removing user accounts (useradd, usermod, userdel)
  - Sudo Group,Permissions and sudousers file for a user
  - Group management (groupadd, groupdel, groupmod)
  - User account monitoring (whoami, who am i, who, id, w, uptime, last)   
- [Packages and Software Management]()
  - Package Management Distribution - pacman,zypper,rpm,yum,dpkg,apt and apt-get
  - DPKG (Debian and Ubuntu Based Distros) and APT (Advanced Package Tool)
  - Repository File | /etc/apt/sources.list
  - Installation new applications using `apt`
  - Install manually downloaded packages with example
  - Services like HTTP, SSH
  - Key Linux Package Management Commands
     - Ubuntu Based Systems
            - Searching through the repositories to find new apps
            - Installing packages that are not in the repository
            - Keeping programs updated
     - Fedora/RHEL 8 Based Systems
     - Suse Based Systems
     - Arch Based Systems
- [Command Line | Awesome Linux commands]()
- [Network Management and Troubleshooting]()
   - Telnet
   - Ping(ICMP)
   - Traceroute
   - Static Route IP
   - Curl
   - Packet Analysis
   - Netstat
- [File and Directory Management]()
   - Absolute vs. relative paths
   - Text Processing
- [Linux Compression]()
   - tar  | zip | gz | xz | bz2 | gzip | bzip2 | unzip | extract | decompress
- [File Permission and Ownership]()
   - File/Directory Permission and Ownership
   - Default and Maximum File/Directory Permission
   - File/Directory Types
   - File/Directory Link Types
   - File Permission with Umask
   - Special permissions - Setuid, Setgid, and Sticky Bit
   - Advanced File Permission(ACL)
- [Process Management]()
   - Terminal Multiplexer(nohup,tmux,PM2)
   - Working with Systemd
   - Kernel Update/Upgrade
   - Signal process
   - kill (Terminate)
   - Process Termination
   - top
   - htop
   - fuser
   - lsof
   - ps m
   - uptime
   - iostat
   - vmstat
   - watch
   - ps aux
   - ls /proc
   - cat /proc/12345/status

- [Linux Job Scheduling with at and Crond]()
   - [Managing Disks and Partitioning]
   - Partition Management
   - Logical Volume
   - Swap Partition
   - Mount and Unmount
- [Securing and Hardening]
   - Iptables | Netfilter | NFTables | FirewallD | UFW
   - Security
   - AppArmor
   - TCP Wrapper
   - SeLinux
   - Fail2ban
- [Deploying LAMP/LEMP and Websites]
- [System Performance & Tuning Tools]()
- [Server Deployment]()
   - NTP Server and Client
   - NFS Server and Client
   - HTTP Server with Virtual Hosting
   - MariaDB Server
   - Nginx Web Server & Nginx Reverse Proxy
   - HaProxy LB
   - SSH Server with Key Based authentication
   - SSL & TLS - Let's Encrypt


All important Linux commands

Understanding file timestamps: atime, mtime, ctime (stat, touch, date)
. Walking through the File System (pwd, cd, tree)
The LS Command in-depth (ls)
Bash/Shell Scripting










## 🚀2.Setting up the environment (installing both Ubuntu and Redhat)
### Graphical vs Minimal Mode
### Networking
### Connect/Login to Linux system | Login Client
### Introduction to Shell
### - Hostfile
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





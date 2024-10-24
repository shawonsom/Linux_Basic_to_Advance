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
- [4.Packages and Software Management]()
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
- [5.Network Management and Troubleshooting]()
  - Telnet
  - Ping(ICMP)
  - Traceroute
  - Static Route IP
  - Curl
  - Packet Analysis
  - Netstat
  - ifconfig
  - tcpdump
  - mtr
- [6.File and Directory Management](#6file-and-directory-management)
  - [Basic File and Directory Operations](#Basic-File-and-Directory-Operations)
  - [File/Directory Types](#filedirectory-types)
  - [File/Directory Link Types - Hard Links vs. Soft Links](#filedirectory-link-types---hard-links-vs-soft-links)
  - [Understanding Paths - `Absolute` vs. relative paths](#understanding-paths---absolute-vs-relative-paths)
  - Understanding file timestamps: atime, mtime, ctime (stat, touch, date)
- [7.File Permission and Ownership](#7File-Permission-and-Ownership)
  - Understanding File and Directory Permissions
  - File/Directory Permission and Ownership
  - Default and Maximum File/Directory Permission
  - Advanced File Permission Concepts
    - File Permission with Umask
    - Advanced File Permission with Access Control Lists (ACL)
    - Special permissions - Setuid, Setgid, and Sticky Bit
- [8.inux Archiving/Compression, Backup/Sync and Recovery]()
  - Archiving & Compression
     - tar  | zip | gz | xz | bz2 | gzip | bzip2 | unzip | extract | decompress | gzip, gunzip, tar,
  - Backup & Sync
  - Backup/Recovery
- [9.Command Line | Awesome Linux commands]()
  - [Essential Basic and Advance Linux Commands](#Essential-Basic-and-Advance-Linux-Commands)
  - [Text Processing]
     - Text Manipulation Commands 
- [10.Process and Log Management]()
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
  - ps -ef
  - ip addr
  - nmon
  - 
- [11.Managing Disks and Partitioning]
  - Device - SSD | HDD | USB | Nvme
  - Filesystem Types - ext4, XFS | Block,File,Object
  - Partition Management
  - Logical Volume Managemnt(LVM)
  - Swap Partition
  - Mount and Unmount
  - lspci
  - sscsi 
- [12.Securing and Hardening]
   - Iptables | Netfilter | NFTables | FirewallD | UFW
   - Security
   - AppArmor
   - TCP Wrapper
   - SeLinux
   - Fail2ban
- [13.System Performance & Tuning Tools]()
- [14.Server Deployment]()
   - [Deploying LAMP/LEMP and Websites]
   - NTP Server and Client
   - NFS Server and Client
   - HTTP Server with Virtual Hosting
   - MariaDB Server
   - Nginx Web Server & Nginx Reverse Proxy
   - HaProxy LB
   - SSH Server with Key Based authentication
   - SSL & TLS - Let's Encrypt
- [15.System Monitoring & Cron Scheduling]()
- [16.Bash/Shell Scripting]()







## 🚀2.Setting up the environment (installing both Ubuntu and Redhat)
### Graphical vs Minimal Mode
### Networking
### Connect/Login to Linux system | Login Client
### Introduction to Shell
### Hostfile
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


## 🚀[6.File and Directory Management]()
 - ### 🌟[Basic File and Directory Operations]()
    - ### 🎉Creating, Deleting, Moving, and Copying Files/Directories
      <img src=https://github.com/user-attachments/assets/356a3442-83ed-4c99-954f-be7692d6ec27 height="300" width="900"/>
    - [ ] `ls` - list files and directories
      - [ ] `-a` for listing hidden files
      - [ ] `-l` for list formt
      - [ ] `-t` order by time
      - [ ] `-F` better distinguish between regular files and directories
    - [ ] `touch` - creating files (original intention is updating timestamp)
      - [ ] nice to know: `touch file{1..5}`
    - [ ] `rm` - remove files
      - [ ] `-r` for recursive
      - [ ] `-f` to force removal, no questions asked
    - [ ] `mkdir` - create directories
      - [ ] `-p` - for creating multiple nested directories
    - [ ] `rmdir` - remove directories
    - [ ] `echo` - display a line of text
    - [ ] `cat` - concatenate files (common usage: read a file)
    - [ ] `mv` - move files directories (also rename files and directories)
    - [ ] `cp` - copy a file
      - [ ] `-r` for recursive (copy a directory)

 - ### 🌟[File/Directory Types]()
    🌱Regular\
    🌱Directory\
    🌱Socket\
    🌱Block\
    🌱Symbolic link\
    🌱Hidden file/dir
    - [ ] **🌱Regular `-`**\
   You can identify regular files using ls -l, where the file type is indicated by a dash **(-)** at the beginning of the permission string
       - [ ] `touch example.txt`
       - [ ] `ls -l`
       - [ ] `-rw-r--r--  1 user user  1048576 Oct 21 14:34 example.txt`\
       **Text files:** `example.txt`\
       **Binary files:** `/usr/bin/bash`\
       **Executable scripts:** `script.sh`
    - [ ] **🌱Directory -`d`**\
   Directories can be identified by a **`d`** at the beginning of the permission string when using `ls -l`
      - [ ] `mkdir /home/msi/devops/linux -p`
      - [ ] `ls -l`
      - [ ] `drwxr-xr-x  2 msi msi  4096 Oct 21 14:40 linux\`
      **Home directory: /home/user**\
      **System configuration directories: /etc, /var**
    - [ ] **🌱Socket -`s`**\
   Socket files are identified by an **`s`** at the beginning of the permission string in `ls -l`.
      - [ ] $ `ls -l /var/run/rpcbind.sock`
      - [ ] `srw-rw----  1 root docker 0 Oct 21 14:43 /var/run/rpcbind.sock`
    - [ ] **🌱Block -`s`**\
   Block device files are identified by a **`b`** in the permission string from the `ls -l` command.
      - [ ] `ls -l /dev/sda`
      - [ ] `brw-rw----  1 root disk 8, 0 Oct 21 14:44 /dev/sda`
    - [ ] **🌱Symbolic link -`l`**\
   Symbolic links are indicated by an `l` at the beginning of the permission string when using `ls -l`
      - [ ] `ln -s /path/to/original /path/to/link`
      - [ ] `ls -l`
      - [ ] `lrwxrwxrwx  1 user user 9 Oct 21 14:45 mylink -> example.txt`
    - [ ] **🌱Hidden file/dir -`.`**\
   Files or directories that begin with a dot `.` are hidden from normal directory listings.
      - [ ] `ls -la /home/msi/`
      - [ ] `-rw-r--r-- 1 msi  msi  3771 Oct 19 21:56 .bashrc`
 - ### [🌟File/Directory Link Types - Hard Links vs. Soft Links]()

| **Feature**                | **Hard Link**                             | **Soft Link (Symlink)**                                |
|----------------------------|-------------------------------------------|--------------------------------------------------------|
| **Inode**                  | Shares same inode as original file        | Has its own inode, pointing to the target              |
| **File Type**              | Only for files, not directories           | Can link to both files and directories                 |
| **File System**            | Must be on the same filesystem            | Can link across filesystems                            |
| **Original File Deleted**  | No effect; hard link still accesses data  | Symlink breaks and becomes a "dangling link"           |
| **Cross-Filesystem Links** | Not possible                              | Possible                                               |
| **Directory Linking**      | Not allowed                               | Allowed                                                |

    - View Symlink Path - ls -ln
    - Creating a Hard Link - `ln original.txt hardlink.txt`
    - Creating a Soft Link (Symlink) - `ln -s /path/to/original.txt symlink.txt`
    - Checking Inode Numbers - `ls -li original.txt hardlink.txt`
    - Removing a Soft or Hard Link - `unlink symlink.txt
 - ### [🌟Understanding Paths - `Absolute` vs. relative paths`]()
    - **Absolute Path:** The full path starting from the root directory **(/ in Linux, C:\ in Windows).** It doesn't depend on the current working directory.
      - [ ] Example (Linux): `/home/user/file.txt`
    - **Relative Path:** The path relative to the current working directory. Uses symbols like `.` (current directory) and `..` (parent directory).
      - [ ] Example: `Documents/file.txt` or `../file.txt`

      - [ ] <img src=https://github.com/user-attachments/assets/a5bbe573-e116-4a0c-81f8-658a96962ad6  height="300" width="900"/>

 - ### [🌟Understanding file timestamps: atime, mtime, ctime (stat, touch, date)]()
    - atime (Access Time): Last time the file was read or accessed.
    - mtime (Modification Time): Last time the file content was modified.
    - ctime (Change Time): Last time file metadata (e.g., permissions, ownership) was changed.
      - [ ] `stat filename`
## 🚀[7.File/Dir Permission and Ownership]()

<p align="justify">

Unix-like operating systems, such as Linux, running on shared high-performance computers use settings called permissions to determine who can access and modify the files and directories stored in their file systems. Each file and directory in a file system is assigned "owner" and "group" attributes.

Most commonly, by default, the user who creates a file or directory is set as owner of that file or directory. When needed (for example, when a member of your research team leaves), the system's root administrator can change the user attribute for files and directories.

The group designation can be used to grant teammates and/or collaborators shared access to an owner's files and directories, and provides a convenient way to grant access to multiple users.
</p>

- [ ] 🔴Permissions are applied on three levels:- 
    * Owner or User level  `u`
    * Group level  `g`
    * Others level `o` & `a` for all users

- [ ] 🔴Access modes - Each file or directory has three basic permission types
    * **r** - read only 
    * **w** - write/edit/delete/append 
    * **x** - execute/run a command 
 
- [ ] 🔴Access modes are different on file and directory:- 

| Permissions | Files           | Directory |
|:-----: |:---         |:---   |
| r | Open the file | 'ls' the contents of dir |
| w | Write, edit, append, delete file | Add/Del/Rename contents of dir |
| x | To run a command/shell script | To enter into dir using 'cd' |

- [ ] 🔴Using Binary References to Set permissions

| Binary Reference | Meaning |
|------------------|---------|
| `4`              | Read    |
| `2`              | Write   |
| `1`              | Execute |


- [ ] 🔴There are 2 ways to use the command -

   - [ ] **Absolute mode**
   - [ ] **Symbolic mode**

 - [ ] 🧩[Absolute mode]()

In this mode, file permissions are not represented as characters but a three-digit octal number. The table below gives numbers for all for permissions types.

| Number |	Permission Type	| Symbol |
| :----: |  :-----|  :----:|
| 0	 |No Permission |	---  |
| 1	| Execute	| --x |
| 2	| Write	|-w- |
| 3	| Execute + Write	|-wx |
| 4	| Read	| r-- |
| 5	| Read + Execute |	r-x |
| 6	| Read +Write |	rw- | 
| 7	| Read + Write +Execute |	rwx | 

⚡**Command**\
`chmod 764 samplefile`\
`chmod 777 samplefile` - Assigning full permission to the file i.e. rwx to all

 - [ ] 🧩[Symbolic Mode]()

In the Absolute mode, you change permissions for all 3 owners. In the symbolic mode, you can modify permissions of a specific owner. It makes use of mathematical symbols to modify the file permissions.

| Operator	| Description |
| :---: |:--|
|+ |	Adds a permission to a file or directory|
|-	| Removes the permission|
|=	|Sets the permission and overrides the permissions set earlier.|

⚡**Command**\
`chmod u=rwx,g=rw,o=r samplefile` (user=rwx, group=rw and others=r)\
`chmod u=rwx,g=rw,o=r samplefile` (user=rwx, group=rw and others=r) \
`chmod u=rwx,g+wx,o-x samplefile`\
`chmod ugo=rwx samplefile` - Assigning full permission to the file i.e. rwx to all\
`chmod u+x samplefile` - Adding execute permission to user only\
`chmod go-wx samplefile` - Removing write and execute permissions from group and other\
`chmod go+wx samplefile` - Adding write and execute permissions from group and other\
`chmod go=r samplefile` - Giving only read permission to group and other





  - Default and Maximum File/Directory Permission
  - Advanced File Permission Concepts
    - File Permission with Umask
    - Advanced File Permission with Access Control Lists (ACL)
    - Special permissions - Setuid, Setgid, and Sticky Bit





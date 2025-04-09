- [6.File and Directory Management](#6file-and-directory-management)
  - [Linux File System Hierarchy](#Linux-File-System-Hierarchy) 
  - [Basic File and Directory Operations](#Basic-File-and-Directory-Operations)
  - [File/Directory Types](#filedirectory-types)
  - [File/Directory Link Types - Hard Links vs. Soft Links](#filedirectory-link-types---hard-links-vs-soft-links)
  - [Understanding Paths - `Absolute` vs. relative paths](#understanding-paths---absolute-vs-relative-paths)
  - Understanding file timestamps: atime, mtime, ctime (stat, touch, date)


### 🚀[6.File and Directory Management]()


## Linux File System Hierarchy

The Linux File System Hierarchy Standard (FSH) defines the directory structure and directory contents in Linux operating systems. Below is an overview of the most important directories in the root (`/`) filesystem.
![{C4921C24-38A2-49CD-8B33-A9AD57E82121}](https://github.com/user-attachments/assets/cd56a6b2-9eb3-499f-a3a8-f9c3600b52c1)

### / (Root)
- The top-level directory.
- All other directories are under this.
- Example: `/bin`, `/home`, `/etc`

### /bin (Essential User Binaries)
- Contains essential command binaries that are needed in single-user mode and to repair a system.
- Example: `ls`, `cp`, `mv`, `rm`, `bash`

### /boot
- Contains the Linux kernel and other files needed to boot the system.
- Example: `vmlinuz`, `initrd.img`, `grub/`

### /dev (Device Files)
- Contains device nodes for hardware devices.
- Example: `/dev/sda`, `/dev/null`, `/dev/tty`

### /etc (Configuration Files)
- Contains all system-wide configuration files.
- Example: `/etc/hostname`, `/etc/hosts`, `/etc/passwd`

### /home (Home Directories)
- Contains personal directories for regular users.
- Example: `/home/alice`, `/home/bob`

### /lib, /lib64 (Shared Libraries)
- Contains essential shared libraries for binaries in `/bin` and `/sbin`.
- Example: `libc.so.6`

### /media (Removable Media)
- Mount point for removable devices like USB drives and CD-ROMs.
- Example: `/media/usb`, `/media/cdrom`

### /mnt (Temporary Mount Point)
- Traditionally used for mounting filesystems temporarily.

### /opt (Optional Software)
- Used for installing third-party software.
- Example: `/opt/google`, `/opt/vmware`

### /proc (Process Information)
- Virtual filesystem providing process and kernel information.
- Example: `/proc/cpuinfo`, `/proc/meminfo`, `/proc/1`

### /root (Root User Home Directory)
- Home directory for the root user.
- Example: Files related to root user are stored here.

### /run (Runtime Variable Data)
- Contains system information data describing the system since it was booted.

### /sbin (System Binaries)
- Contains essential system binaries, typically used by root.
- Example: `ifconfig`, `reboot`, `fsck`

### /srv (Service Data)
- Contains data for services provided by the system.
- Example: Web server files might be in `/srv/www`

### /sys (System Information)
- Virtual filesystem containing information about devices, drivers, and kernel features.

## /tmp (Temporary Files)
- Storage for temporary files created by system and users.
- Cleared on reboot.

### /usr (User Binaries and Read-Only Data)
- Secondary hierarchy for read-only user data; contains the majority of (multi-)user utilities and applications.
- Example: `/usr/bin`, `/usr/lib`, `/usr/share`

### /var (Variable Data)
- Contains variable data like logs, databases, and emails.
- Example: `/var/log`, `/var/mail`, `/var/tmp`

---



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

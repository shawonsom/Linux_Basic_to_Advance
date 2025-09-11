# Linux Fundamentals

## 1. Introduction to Linux

### What is an Operating System?
An **Operating System (OS)** is system software that manages computer hardware, software resources, and provides common services for computer programs. It acts as an intermediary between users and the computer hardware.

**Key Functions of an OS:**
- Process Management
- Memory Management
- File System Management
- Device Management
- Security and Access Control
- Network Management
- User Interface

### History of Linux | Unix

**Unix History:**
- **1969**: Unix developed at AT&T Bell Labs by Ken Thompson, Dennis Ritchie, and others
- **1973**: Rewritten in C programming language, making it portable
- **1970s-1980s**: Various Unix variants emerge (BSD, System V, AIX, HP-UX, Solaris)

**Linux History:**
- **1991**: Linus Torvalds, a Finnish student, creates Linux kernel
- **Inspired by MINIX** (a Unix-like system)
- **1992**: Released under GNU GPL license
- **1990s-present**: Various distributions emerge (Debian, Red Hat, Slackware, Ubuntu, etc.)

**Key Milestones:**
- 1983: GNU Project announced by Richard Stallman
- 1991: First Linux kernel release (version 0.01)
- 1994: Linux 1.0 released
- Today: Powers 90% of cloud infrastructure, 85% of smartphones (Android)

### Importance of Linux

**Why Linux is Crucial:**
- 🚀 **Open Source**: Free to use, modify, and distribute
- 🔒 **Security**: Robust security model, fewer vulnerabilities
- 💻 **Stability & Reliability**: Rarely crashes, excellent uptime
- 🏢 **Enterprise Usage**: Powers 90% of cloud infrastructure
- 📱 **Embedded Systems**: Runs on routers, smart TVs, IoT devices
- 🌐 **Web Servers**: LAMP stack (Linux, Apache, MySQL, PHP/Python/Perl)
- ☁️ **Cloud Computing**: Foundation of AWS, Google Cloud, Azure
- 📊 **Supercomputers**: Powers all top 500 supercomputers
- 🤖 **Android**: Based on Linux kernel

### Linux Filesystem and Directory Hierarchy

**Standard Linux Directory Structure:**
```
/
├── bin/          # Essential user binaries
├── boot/         # Boot loader files
├── dev/          # Device files
├── etc/          # Configuration files
├── home/         # User home directories
├── lib/          # Essential shared libraries
├── media/        # Removable media mount points
├── mnt/          # Temporary mount points
├── opt/          # Optional application software
├── proc/         # Process and kernel information
├── root/         # Root user home directory
├── run/          # Runtime variable data
├── sbin/         # System binaries
├── srv/          # Service data
├── sys/          # System information
├── tmp/          # Temporary files
├── usr/          # User programs and data
└── var/          # Variable data files
```

**Key Filesystem Types:**
- ext4 (Most common Linux filesystem)
- XFS (High performance)
- Btrfs (Advanced features)
- ZFS (Enterprise features)

### Linux Kernel, Boot Sequence, Kernel Space and User Space

**Linux Kernel:**
- Core component of Linux OS
- Manages hardware resources
- Provides interface for user programs
- Handles process scheduling, memory management, device drivers

**Boot Sequence:**
1. **BIOS/UEFI**: Initializes hardware, finds bootloader
2. **Bootloader** (GRUB): Loads kernel and initramfs
3. **Kernel Initialization**: Decompresses, initializes hardware
4. **initramfs**: Temporary root filesystem with essential drivers
5. **Init Process** (systemd/sysvinit): First process (PID 1)
6. **Runlevels/Targets**: System initialization and service startup
7. **Login Prompt**: User authentication

**Kernel Space vs User Space:**
- **Kernel Space**: Privileged mode where kernel runs, direct hardware access
- **User Space**: Unprivileged mode where applications run, isolated from hardware
- **System Calls**: Interface between user space and kernel space

### How Linux Works - Key Concepts

**Process Management:**
- Each process has unique PID
- Parent-child process relationships
- Process states: Running, Sleeping, Stopped, Zombie

**Memory Management:**
- Virtual memory system
- Paging and swapping
- Memory protection between processes

**File System:**
- Everything is a file (devices, pipes, sockets)
- Unified directory structure
- Permissions and ownership

**Device Management:**
- Device files in /dev directory
- Kernel modules for device drivers
- Plug and play support

### Reset Root Password

**Method 1: Using GRUB Bootloader (Most Common)**
```bash
1. Reboot system and interrupt boot process at GRUB menu
2. Press 'e' to edit boot parameters
3. Find line starting with 'linux' and add 'rd.break' or 'init=/bin/bash'
4. Press Ctrl+X to boot
5. Remount root filesystem as read-write:
   mount -o remount,rw /sysroot
6. chroot /sysroot
7. passwd root
8. Enter new password twice
9. If SELinux is enabled: touch /.autorelabel
10. exit
11. reboot
```

**Method 2: Using Live CD/USB**
```bash
1. Boot from Live media
2. Mount root partition: mount /dev/sda1 /mnt
3. chroot /mnt
4. passwd root
5. exit
6. umount /mnt
7. reboot
```

**Method 3: Single User Mode**
```bash
1. Add 'single' or '1' to kernel parameters in GRUB
2. Boot into single user mode
3. passwd root
4. reboot
```

**Important Notes:**
- Requires physical access to the machine
- May trigger SELinux relabeling on next boot
- Always test in non-production environment first
- Document the process for compliance purposes

## Security Considerations
- Always use strong passwords
- Consider using SSH keys instead of passwords
- Regularly audit user accounts
- Implement multi-factor authentication where possible
- Keep system updated with security patches

This comprehensive overview covers the fundamental concepts of Linux, from its history and importance to practical system administration tasks like password recovery.

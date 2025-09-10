# Linux Disk Management and Partitioning

## Table of Contents
1. [Introduction to Disk Management](#introduction-to-disk-management)
2. [Disk Identification and Discovery](#disk-identification-and-discovery)
3. [Partitioning Concepts](#partitioning-concepts)
4. [Partitioning with fdisk](#partitioning-with-fdisk)
5. [Partitioning with parted](#partitioning-with-parted)
6. [Filesystem Creation](#filesystem-creation)
7. [Mounting Filesystems](#mounting-filesystems)
8. [Persistent Mounts with fstab](#persistent-mounts-with-fstab)
9. [Disk Space Management](#disk-space-management)
10. [Logical Volume Management (LVM)](#logical-volume-management-lvm)
11. [RAID Configuration](#raid-configuration)
12. [Disk Performance Monitoring](#disk-performance-monitoring)
13. [Troubleshooting and Recovery](#troubleshooting-and-recovery)
14. [Best Practices](#best-practices)

## Introduction to Disk Management

Linux disk management involves creating, modifying, and maintaining storage devices and their partitions. Understanding disk management is crucial for system administrators to ensure optimal storage utilization, performance, and data integrity.

### Storage Concepts
- **Block Devices**: Storage devices that read/write data in fixed-size blocks (e.g., /dev/sda, /dev/nvme0n1)
- **Partitions**: Logical divisions of a physical disk
- **Filesystems**: Structures that organize how data is stored on partitions
- **Mount Points**: Directory locations where filesystems are accessed

## Disk Identification and Discovery

### Listing Block Devices
```bash
# List all block devices
lsblk

# Detailed block device information
lsblk -f
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,UUID

# List all disks and partitions
fdisk -l

# List specific disk
fdisk -l /dev/sda

# Show SCSI/SATA devices
lsscsi

# Show USB devices
lsusb

# Show PCI devices (including storage controllers)
lspci

# Check disk information with hdparm
hdparm -I /dev/sda
```

### Identifying Disk Types
```bash
# Check if device is rotational (HDD) or SSD
cat /sys/block/sda/queue/rotational  # 1=HDD, 0=SSD

# Check disk model and serial number
smartctl -i /dev/sda

# List NVMe devices
nvme list

# Check disk health
smartctl -a /dev/sda
```

## Partitioning Concepts

### Partition Tables
- **MBR (Master Boot Record)**: Legacy standard, supports up to 2TB disks, 4 primary partitions
- **GPT (GUID Partition Table)**: Modern standard, supports large disks, up to 128 partitions

### Partition Types
- **Primary Partition**: Bootable partition (MBR limitation: 4 primary)
- **Extended Partition**: Container for logical partitions (MBR only)
- **Logical Partition**: Partitions within extended partition
- **EFI System Partition**: Required for UEFI boot (typically 100-500MB)

## Partitioning with fdisk

### Basic fdisk Operations
```bash
# Start fdisk for a disk
fdisk /dev/sdb

# Common fdisk commands:
# n - Create new partition
# d - Delete partition
# p - Print partition table
# t - Change partition type
# w - Write changes and exit
# q - Quit without saving

# Create a new partition
fdisk /dev/sdb
Command (m for help): n
Partition type: p (primary)
Partition number: 1
First sector: (press Enter for default)
Last sector: +10G (or specify size)

# Change partition type
Command (m for help): t
Partition number: 1
Hex code: 83 (Linux filesystem) or 8e (Linux LVM)

# Verify changes
Command (m for help): p

# Write changes
Command (m for help): w
```

### Advanced fdisk Usage
```bash
# Create partition with specific size
echo -e "n\np\n1\n\n+20G\nw" | fdisk /dev/sdb

# Create multiple partitions
echo -e "n\np\n1\n\n+10G\nn\np\n2\n\n+15G\nw" | fdisk /dev/sdb

# Create swap partition
echo -e "n\np\n3\n\n+4G\nt\n3\n82\nw" | fdisk /dev/sdb

# Create GPT partition table
echo -e "g\nn\n1\n\n+500M\nt\n1\nn\n2\n\n+30G\nw" | fdisk /dev/sdb
```

## Partitioning with parted

### parted Basics
```bash
# Start parted
parted /dev/sdb

# Create GPT partition table
(parted) mklabel gpt

# Create partition
(parted) mkpart primary ext4 1MiB 10GiB

# Set partition flag (e.g., boot flag)
(parted) set 1 boot on

# Show partition information
(parted) print

# Resize partition
(parted) resizepart 1 15GiB

# Remove partition
(parted) rm 1

# Quit parted
(parted) quit
```

### Non-interactive parted Usage
```bash
# Create GPT table
parted /dev/sdb mklabel gpt

# Create EFI partition
parted /dev/sdb mkpart primary fat32 1MiB 513MiB
parted /dev/sdb set 1 esp on

# Create root partition
parted /dev/sdb mkpart primary ext4 513MiB 20GiB

# Create home partition
parted /dev/sdb mkpart primary ext4 20GiB 100%
```

## Filesystem Creation

### Common Filesystems
```bash
# Create ext4 filesystem
mkfs.ext4 /dev/sdb1

# Create XFS filesystem
mkfs.xfs /dev/sdb1

# Create Btrfs filesystem
mkfs.btrfs /dev/sdb1

# Create FAT32 filesystem
mkfs.fat -F32 /dev/sdb1

# Create NTFS filesystem
mkfs.ntfs /dev/sdb1

# Create swap area
mkswap /dev/sdb2
swapon /dev/sdb2

# Filesystem with label
mkfs.ext4 -L "DATA" /dev/sdb1
```

### Filesystem Options
```bash
# Custom block size
mkfs.ext4 -b 4096 /dev/sdb1

# Reserved blocks percentage
mkfs.ext4 -m 1 /dev/sdb1  # 1% reserved for root

# Journaling options
mkfs.ext4 -O ^has_journal /dev/sdb1  # Without journal

# Force creation
mkfs.ext4 -F /dev/sdb1
```

## Mounting Filesystems

### Basic Mounting
```bash
# Create mount point
mkdir /mnt/data

# Mount filesystem
mount /dev/sdb1 /mnt/data

# Mount with options
mount -o rw,noatime /dev/sdb1 /mnt/data

# Mount read-only
mount -o ro /dev/sdb1 /mnt/data

# Unmount filesystem
umount /mnt/data

# Force unmount (if busy)
umount -f /mnt/data

# Lazy unmount (unmount when not busy)
umount -l /mnt/data
```

### Special Mounts
```bash
# Mount ISO image
mount -o loop image.iso /mnt/iso

# Mount remote NFS share
mount -t nfs server:/export /mnt/nfs

# Mount CIFS/SMB share
mount -t cifs //server/share /mnt/smb -o username=user,password=pass

# Mount tmpfs (in-memory filesystem)
mount -t tmpfs -o size=1G tmpfs /mnt/tmp
```

## Persistent Mounts with fstab

### /etc/fstab Format
```
# device        mountpoint    fstype    options        dump fsck
/dev/sdb1      /mnt/data     ext4      defaults       0     0
UUID=xxxxxxx   /mnt/backup   xfs       defaults       0     0
```

### fstab Options
```bash
# Common options:
defaults      # rw,suid,dev,exec,auto,nouser,async
noatime       # Don't update access times
nodiratime    # Don't update directory access times
relatime      # Update access times relative to modify times
nofail        # Don't report errors if device doesn't exist
x-systemd.automount  # Automount when accessed

# Example fstab entry:
UUID=1234-5678 /mnt/data ext4 defaults,noatime,nofail 0 2
```

### Managing fstab
```bash
# Test fstab entries
mount -a

# Find UUID of partition
blkid /dev/sdb1

# Add entry to fstab
echo "UUID=$(blkid -s UUID -o value /dev/sdb1) /mnt/data ext4 defaults 0 2" >> /etc/fstab

# Backup fstab
cp /etc/fstab /etc/fstab.backup
```

## Disk Space Management

### Checking Disk Usage
```bash
# Show disk space usage
df -h
df -hT  # Show filesystem types

# Show inode usage
df -i

# Show specific filesystem
df -h /dev/sdb1

# Detailed disk usage
du -sh /path/to/directory
du -h --max-depth=1 /path/to/directory

# Find large files
find / -type f -size +100M -exec ls -lh {} \;
```

### Cleaning Disk Space
```bash
# Clean package cache
apt clean          # Debian/Ubuntu
yum clean all      # RHEL/CentOS
dnf clean all      # Fedora

# Remove old kernels (keep current and one previous)
apt autoremove --purge  # Debian/Ubuntu
package-cleanup --oldkernels --count=2  # RHEL/CentOS

# Clean log files
journalctl --vacuum-size=500M
find /var/log -name "*.log" -type f -mtime +30 -delete

# Remove temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*
```

## Logical Volume Management (LVM)

### LVM Concepts
- **Physical Volume (PV)**: Physical disk or partition
- **Volume Group (VG)**: Collection of physical volumes
- **Logical Volume (LV)**: Virtual partition created from volume group

### LVM Setup
```bash
# Create physical volume
pvcreate /dev/sdb1
pvcreate /dev/sdc1

# Create volume group
vgcreate myvg /dev/sdb1 /dev/sdc1

# Create logical volume
lvcreate -n mylv -L 20G myvg

# Create filesystem on LV
mkfs.ext4 /dev/myvg/mylv

# Mount LV
mount /dev/myvg/mylv /mnt/data
```

### LVM Management
```bash
# Extend logical volume
lvextend -L +10G /dev/myvg/mylv
resize2fs /dev/myvg/mylv  # For ext2/3/4
xfs_growfs /mnt/data      # For XFS

# Reduce logical volume (unmount first)
umount /mnt/data
e2fsck -f /dev/myvg/mylv
resize2fs /dev/myvg/mylv 15G
lvreduce -L 15G /dev/myvg/mylv
mount /dev/myvg/mylv /mnt/data

# Add physical volume to VG
vgextend myvg /dev/sdd1

# Remove physical volume from VG
pvmove /dev/sdb1  # Move data off first
vgreduce myvg /dev/sdb1

# Display LVM information
pvdisplay
vgdisplay
lvdisplay

# Create snapshot
lvcreate -s -n snap01 -L 5G /dev/myvg/mylv

# Restore from snapshot
umount /mnt/data
lvconvert --merge /dev/myvg/snap01
mount /dev/myvg/mylv /mnt/data
```

## RAID Configuration

### Software RAID with mdadm
```bash
# Create RAID 1 array
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Create RAID 5 array
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# Create filesystem
mkfs.ext4 /dev/md0

# Mount array
mount /dev/md0 /mnt/raid

# Check array status
cat /proc/mdstat
mdadm --detail /dev/md0

# Add spare disk
mdadm --add /dev/md0 /dev/sde1

# Remove failed disk
mdadm --remove /dev/md0 /dev/sdb1

# Stop array
mdadm --stop /dev/md0

# Assemble array
mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1
```

### RAID Monitoring
```bash
# Check RAID status
mdadm --detail --scan
mdadm --examine /dev/sdb1

# Monitor RAID health
watch cat /proc/mdstat

# Email alerts on failures
echo "MAILADDR admin@example.com" >> /etc/mdadm/mdadm.conf

# Save RAID configuration
mdadm --detail --scan > /etc/mdadm/mdadm.conf
```

## Disk Performance Monitoring

### I/O Monitoring Tools
```bash
# Real-time I/O monitoring
iostat -x 2

# Process I/O monitoring
iotop

# Disk activity statistics
vmstat -d

# Block device I/O
blktrace /dev/sda

# Measure read speed
hdparm -Tt /dev/sda

# Measure write speed
dd if=/dev/zero of=/tmp/test bs=1G count=1 oflag=direct

# Check I/O scheduler
cat /sys/block/sda/queue/scheduler

# Change I/O scheduler
echo deadline > /sys/block/sda/queue/scheduler
```

### Performance Optimization
```bash
# Mount options for performance
mount -o noatime,nodiratime,data=writeback /dev/sdb1 /mnt/data

# Filesystem tuning
tune2fs -o journal_data_writeback /dev/sdb1  # ext4
tune2fs -E stripe-width=64 /dev/sdb1         # For RAID

# SSD optimization
echo noop > /sys/block/sda/queue/scheduler   # For SSDs
```

## Troubleshooting and Recovery

### Common Issues
```bash
# Filesystem check
fsck /dev/sdb1
fsck -y /dev/sdb1  # Auto-repair

# Check disk for bad sectors
badblocks -v /dev/sdb1

# Repair corrupted filesystem
xfs_repair /dev/sdb1  # XFS
btrfs check --repair /dev/sdb1  # Btrfs (use with caution)

# Recover deleted partition
testdisk /dev/sdb

# Rescue data from failing disk
ddrescue /dev/sdb /dev/sdc mapfile.log

# Check disk health
smartctl -a /dev/sda
smartctl -t short /dev/sda  # Run short test
```

### Emergency Recovery
```bash
# Boot from live CD/USB and mount root filesystem
mkdir /mnt/root
mount /dev/sda1 /mnt/root
mount /dev/sda2 /mnt/root/home  # If separate home
mount --bind /dev /mnt/root/dev
mount --bind /proc /mnt/root/proc
mount --bind /sys /mnt/root/sys
chroot /mnt/root

# Reinstall bootloader from chroot
grub-install /dev/sda
update-grub  # Debian/Ubuntu
grub2-mkconfig -o /boot/grub2/grub.cfg  # RHEL/CentOS
```

## Best Practices

### Disk Management Best Practices
1. **Regular Backups**: Always have current backups before making changes
2. **Use GPT**: Prefer GPT over MBR for modern systems
3. **Separate Partitions**: Use separate partitions for /, /home, /var, /tmp
4. **Monitor Disk Health**: Regularly check SMART status and disk usage
5. **Use LVM**: For flexibility in storage management
6. **RAID for Redundancy**: Use appropriate RAID levels for data protection
7. **Regular fsck**: Schedule periodic filesystem checks
8. **Document Configuration**: Keep records of disk layouts and mount options

### Performance Optimization
1. **Align Partitions**: Ensure proper partition alignment for SSDs and RAID
2. **Appropriate Filesystem**: Choose filesystem based on use case
3. **Mount Options**: Use noatime, nodiratime for better performance
4. **I/O Scheduler**: Choose appropriate scheduler for your workload
5. **SSD Optimization**: Enable TRIM and use appropriate mount options

### Security Considerations
1. **Mount Options**: Use nosuid, nodev, noexec where appropriate
2. **Disk Encryption**: Consider LUKS encryption for sensitive data
3. **Permissions**: Set appropriate permissions on mount points
4. **Regular Audits**: Monitor disk usage and access patterns

### Automation Scripts
```bash
#!/bin/bash
# disk-health-check.sh

# Check disk usage
THRESHOLD=90
df -h | awk '0+$5 >= '$THRESHOLD' {print "WARNING: "$1" usage is "$5}'

# Check inode usage
df -i | awk '0+$5 >= '$THRESHOLD' {print "WARNING: "$1" inode usage is "$5}'

# Check disk health
for disk in $(lsblk -d -o NAME | grep -v NAME); do
    if smartctl -H /dev/$disk | grep -q "FAILED"; then
        echo "CRITICAL: /dev/$disk SMART test failed"
    fi
done

# Check RAID status
if which mdadm >/dev/null 2>&1; then
    if mdadm --detail --scan | grep -q "degraded"; then
        echo "CRITICAL: RAID array is degraded"
    fi
fi
```

This comprehensive guide covers essential Linux disk management and partitioning techniques, providing system administrators with the knowledge needed to effectively manage storage systems, optimize performance, and ensure data integrity.

# Linux Archiving, Compression, Backup, Sync, and Recovery

*Comprehensive Data Management in Linux*

## Table of Contents
1. [Introduction](#introduction)
2. [Archiving with tar](#archiving-with-tar)
3. [Compression Tools](#compression-tools)
4. [Backup Strategies](#backup-strategies)
5. [Synchronization with rsync](#synchronization-with-rsync)
6. [Data Recovery Tools](#data-recovery-tools)
7. [Automation with cron](#automation-with-cron)
8. [Best Practices](#best-practices)

## Introduction

Effective data management is crucial for system administration. Linux provides robust tools for archiving, compressing, backing up, synchronizing, and recovering data. This guide covers the essential utilities and strategies for comprehensive data protection.

*Complete Data Protection Workflow*

## Archiving with tar

### Basic tar Commands
```bash
# Create archive
tar -cvf archive.tar file1 file2 directory/

# Extract archive
tar -xvf archive.tar

# List archive contents
tar -tvf archive.tar

# Create archive with gzip compression
tar -czvf archive.tar.gz /path/to/directory

# Extract gzip compressed archive
tar -xzvf archive.tar.gz

# Create archive with bzip2 compression
tar -cjvf archive.tar.bz2 /path/to/directory

# Extract bzip2 compressed archive
tar -xjvf archive.tar.bz2
```

### Advanced tar Options
```bash
# Exclude files/directories
tar -czvf backup.tar.gz --exclude='*.tmp' --exclude='cache/*' /data

# Archive with permissions preservation
tar -cpzvf full-backup.tar.gz /important/data

# Verify archive after creation
tar -czvf backup.tar.gz /data && tar -tzvf backup.tar.gz > /dev/null

# Incremental backups
tar -g snapshot-file -czvf incremental-backup.tar.gz /data
```

*tar Command Usage Examples*

## Compression Tools

### gzip/gunzip
```bash
# Compress file
gzip filename
# Decompress file
gunzip filename.gz

# Keep original file
gzip -c file.txt > file.txt.gz

# Set compression level (1-9, 9=best)
gzip -9 largefile.log

# Compress all files in directory
gzip -r directory/
```

### bzip2/bunzip2
```bash
# Better compression than gzip
bzip2 filename
bunzip2 filename.bz2

# Keep original file
bzip2 -k largefile.db
```

### xz/unxz
```bash
# High compression ratio
xz filename
unxz filename.xz

# Extreme compression
xz -9e verylargefile.img
```

### Compression Comparison
```bash
# Compare compression tools
time gzip -9 bigfile.log
time bzip2 -9 bigfile.log
time xz -9 bigfile.log

# Check compression ratio
ls -lh bigfile.log*
```

*Compression Tools Comparison*

## Backup Strategies

### Full Backups
```bash
# Complete system backup
tar -cpzvf full-backup-$(date +%Y%m%d).tar.gz --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp --exclude=/run --exclude=/mnt --exclude=/media /

# Important data backup
tar -czvf data-backup-$(date +%Y%m%d).tar.gz /home /etc /var/www
```

### Incremental Backups
```bash
# First backup (full)
tar -g snapshot-file -czvf backup-full-$(date +%Y%m%d).tar.gz /data

# Subsequent backups (incremental)
tar -g snapshot-file -czvf backup-inc-$(date +%Y%m%d).tar.gz /data
```

### Differential Backups
```bash
# Using find and tar for differential backups
find /data -newer reference-file -print0 | tar -czvf diff-backup.tar.gz --null -T -
```

### Disk Imaging with dd
```bash
# Create disk image
dd if=/dev/sda of=/backup/disk-image.img bs=4M status=progress

# Compressed disk image
dd if=/dev/sda bs=4M status=progress | gzip -c > /backup/disk-image.img.gz

# Restore disk image
dd if=/backup/disk-image.img of=/dev/sda bs=4M status=progress

# Clone disk to disk
dd if=/dev/sda of=/dev/sdb bs=4M status=progress
```

*Backup Strategy Types*

## Synchronization with rsync

### Basic rsync Usage
```bash
# Local sync
rsync -av source/ destination/

# Remote sync (push)
rsync -avz /local/path/ user@remotehost:/remote/path/

# Remote sync (pull)
rsync -avz user@remotehost:/remote/path/ /local/path/

# Dry run (simulation)
rsync -avzn source/ destination/

# Delete extraneous files
rsync -av --delete source/ destination/
```

### Advanced rsync Options
```bash
# Sync with compression and progress
rsync -avz --progress source/ destination/

# Exclude patterns
rsync -av --exclude='*.tmp' --exclude='cache/' source/ destination/

# Limit bandwidth (KB/s)
rsync -av --bwlimit=1000 source/ destination/

# Resume interrupted transfer
rsync -av --partial source/ destination/

# Preserve permissions and ownership
rsync -av --chmod=Du=rwx,Dg=rx,Do=rx,Fu=rw,Fg=r,Fo=r source/ destination/
```

### rsync for Backups
```bash
# Mirror backup
rsync -a --delete /source/ /backup/daily/

# Versioned backups
rsync -a --link-dest=/backup/previous/ /source/ /backup/$(date +%Y%m%d)/
```

*rsync Synchronization Process*

## Data Recovery Tools

### File Recovery with extundelete
```bash
# Install extundelete
sudo apt install extundelete

# Recover deleted files
extundelete /dev/sda1 --restore-all

# Recover specific file
extundelete /dev/sda1 --restore-file /path/to/file

# Recover files from directory
extundelete /dev/sda1 --restore-directory /path/to/directory
```

### PhotoRec - File Carving
```bash
# Install photorec
sudo apt install testdisk

# Recover files (interactive)
photorec /dev/sda1
```

### ddrescue - Data Recovery
```bash
# Recover data from failing drive
ddrescue /dev/sda /dev/sdb mapfile.log

# Resume interrupted recovery
ddrescue -r 3 /dev/sda /dev/sdb mapfile.log
```

### fsck - Filesystem Repair
```bash
# Check and repair filesystem
fsck /dev/sda1

# Force check even if clean
fsck -f /dev/sda1

# Auto-repair errors
fsck -y /dev/sda1
```

*Data Recovery Workflow*

## Automation with cron

### cron Examples
```bash
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * /path/to/backup-script.sh

# Weekly full backup on Sunday
0 3 * * 0 tar -czf /backup/full-$(date +\%Y\%m\%d).tar.gz /important/data

# Daily incremental backup
0 4 * * * tar -g /backup/snapshot -czf /backup/inc-$(date +\%Y\%m\%d).tar.gz /data

# Sync every hour
0 * * * * rsync -av /source/ /backup/daily/

# Clean old backups (older than 30 days)
0 5 * * * find /backup/ -name "*.tar.gz" -mtime +30 -delete
```

### Backup Script Example
```bash
#!/bin/bash
# backup-script.sh
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d)
LOG_FILE="$BACKUP_DIR/backup-$DATE.log"

{
    echo "Starting backup: $(date)"
    # Create daily backup
    tar -czf "$BACKUP_DIR/daily-$DATE.tar.gz" /home /etc /var/www
    
    # Create weekly full backup on Sundays
    if [ $(date +%u) -eq 7 ]; then
        tar -czf "$BACKUP_DIR/full-$DATE.tar.gz" /important/data
    fi
    
    # Sync to remote server
    rsync -av "$BACKUP_DIR/" user@backupserver:/remote/backup/
    
    echo "Backup completed: $(date)"
} > "$LOG_FILE" 2>&1
```

*cron Job Scheduling*

## Best Practices

### Backup Strategy
1. **3-2-1 Rule**: 3 copies, 2 different media, 1 offsite
2. **Regular Testing**: Periodically test restore procedures
3. **Versioning**: Maintain multiple versions of important files
4. **Documentation**: Keep detailed backup procedures and recovery steps

### Security Considerations
```bash
# Encrypt backups
tar -czf - /data | openssl enc -aes-256-cbc -salt -out backup-$(date +%Y%m%d).tar.gz.enc

# Decrypt backup
openssl enc -aes-256-cbc -d -in backup.tar.gz.enc | tar -xz

# Secure remote transfer
rsync -avz -e "ssh -p 2222 -i /path/to/key" source/ user@host:/backup/
```

### Monitoring and Verification
```bash
# Verify backup integrity
tar -tzf backup.tar.gz > /dev/null && echo "Backup OK" || echo "Backup corrupted"

# Check backup age
find /backup -name "*.tar.gz" -mtime +1 -exec echo "Stale backup: {}" \;

# Monitor backup success
if ! tar -czf backup.tar.gz /data; then
    echo "Backup failed!" | mail -s "Backup Alert" admin@example.com
fi
```

### Recovery Testing
```bash
# Test restore procedure periodically
mkdir /tmp/restore-test
tar -xzf backup.tar.gz -C /tmp/restore-test

# Verify critical files
ls -la /tmp/restore-test/etc/passwd
ls -la /tmp/restore-test/home/user/documents/

# Cleanup test
rm -rf /tmp/restore-test
```

*Data Protection Best Practices*

## Conclusion

Implementing a comprehensive data management strategy using Linux tools ensures business continuity and data integrity. Regular backups, proper synchronization, and tested recovery procedures are essential components of system administration.

Remember to:
- Test backups regularly
- Document procedures
- Monitor backup jobs
- Keep multiple copies in different locations
- Encrypt sensitive data

*Complete Data Protection Ecosystem*

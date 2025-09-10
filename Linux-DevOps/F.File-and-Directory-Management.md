# Linux File and Directory Management

The Linux File System Hierarchy Standard (FSH) defines the directory structure and directory contents in Linux operating systems. Below is an overview of the most important directories in the root (`/`) filesystem.
![{C4921C24-38A2-49CD-8B33-A9AD57E82121}](https://github.com/user-attachments/assets/cd56a6b2-9eb3-499f-a3a8-f9c3600b52c1)

## Table of Contents
1. [Introduction](#introduction)
2. [Basic Commands](#basic-commands)
3. [File Operations](#file-operations)
4. [Directory Operations](#directory-operations)
5. [Permissions and Ownership](#permissions-and-ownership)
6. [Advanced Operations](#advanced-operations)

## Introduction

In Linux, everything is treated as a file, including hardware devices. Understanding file and directory management is fundamental to working effectively with Linux systems.

## Basic Commands

### pwd - Print Working Directory
```bash
pwd
```
Shows the current directory path.

### ls - List Directory Contents
```bash
ls          # List files and directories
ls -l       # Detailed list with permissions
ls -a       # List all files including hidden ones
ls -la      # Detailed list including hidden files
```

<img src=https://github.com/user-attachments/assets/356a3442-83ed-4c99-954f-be7692d6ec27 height="300" width="900"/>

### cd - Change Directory
```bash
cd /path/to/directory    # Change to specific directory
cd ~                    # Change to home directory
cd ..                   # Move to parent directory
cd -                    # Return to previous directory
```

## File Operations

### touch - Create Empty File
```bash
touch filename.txt
```

### cat - View File Content
```bash
cat filename.txt
cat -n filename.txt    # Show line numbers
```

### more/less - View File Page by Page
```bash
more filename.txt
less filename.txt
```

### head/tail - View Beginning/End of File
```bash
head filename.txt        # First 10 lines
head -n 20 filename.txt # First 20 lines
tail filename.txt        # Last 10 lines
tail -f logfile.txt     # Follow file changes in real-time
```

### cp - Copy Files
```bash
cp source.txt destination.txt
cp -r sourcedir/ destinationdir/  # Copy directories recursively
```

### mv - Move/Rename Files
```bash
mv oldname.txt newname.txt    # Rename file
mv file.txt /new/directory/   # Move file
```

### rm - Remove Files
```bash
rm filename.txt              # Remove file
rm -r directoryname/         # Remove directory recursively
rm -f filename.txt           # Force remove without confirmation
```
<img src=https://github.com/user-attachments/assets/a5bbe573-e116-4a0c-81f8-658a96962ad6  height="300" width="900"/>


## Directory Operations

### mkdir - Create Directory
```bash
mkdir newdirectory
mkdir -p parent/child/grandchild  # Create nested directories
```

### rmdir - Remove Empty Directory
```bash
rmdir emptydirectory
```

### tree - Display Directory Structure
```bash
tree
tree -d    # Show only directories
```

      <img src=https://github.com/user-attachments/assets/356a3442-83ed-4c99-954f-be7692d6ec27 height="300" width="900"/>

## Permissions and Ownership

### chmod - Change File Permissions
```bash
chmod 755 filename.sh    # rwxr-xr-x
chmod u+x script.sh      # Add execute permission for user
chmod g-w file.txt       # Remove write permission for group
```

### chown - Change File Owner
```bash
chown user:group filename.txt
chown user filename.txt
chown :group filename.txt
```

### Understanding Permissions
```
- rwx r-x r-x
|  |   |   |
|  |   |   Other permissions
|  |   Group permissions
|  User permissions
File type (- = regular file, d = directory)
```

## Advanced Operations

### find - Search for Files
```bash
find /home -name "*.txt"          # Find by name
find . -type f -size +1M          # Find files larger than 1MB
find /var/log -mtime -7           # Find files modified in last 7 days
```

### grep - Search Within Files
```bash
grep "search term" file.txt
grep -r "pattern" /path/to/dir/   # Recursive search
grep -i "case" file.txt           # Case-insensitive search
```

### ln - Create Links
```bash
ln -s target.txt linkname.txt     # Create symbolic link
ln target.txt hardlink.txt        # Create hard link
```

### diff - Compare Files
```bash
diff file1.txt file2.txt
```

### tar - Archive Files
```bash
tar -cvf archive.tar files/       # Create tar archive
tar -xvf archive.tar              # Extract tar archive
tar -czvf archive.tar.gz files/   # Create compressed tar archive
```

### zip/unzip - Compression Utilities
```bash
zip archive.zip file1.txt file2.txt
unzip archive.zip
```

### df - Disk Space Usage
```bash
df -h    # Human readable format
```

### du - Directory Space Usage
```bash
du -sh /path/to/directory    # Summary of directory size
du -h --max-depth=1          # Size of first-level subdirectories
```

## Best Practices

1. Always use `-i` option with `rm` for interactive deletion
2. Use tab completion for path names
3. Double-check paths before executing destructive commands
4. Use relative paths for files in current directory
5. Use absolute paths for scripts and automation

## Conclusion

Mastering file and directory management is essential for Linux proficiency. Practice these commands regularly to build muscle memory and improve your workflow efficiency.

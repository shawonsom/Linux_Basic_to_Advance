# Linux File & Directory Permissions and Ownership

## Table of Contents
1. [Introduction to Permissions](#introduction-to-permissions)
2. [Understanding Permission Notation](#understanding-permission-notation)
3. [Changing Permissions with chmod](#changing-permissions-with-chmod)
4. [Changing Ownership with chown](#changing-ownership-with-chown)
5. [Special Permissions](#special-permissions)
6. [Access Control Lists (ACL)](#access-control-lists-acl)
7. [umask - Default Permissions](#umask-default-permissions)
8. [Practical Examples](#practical-examples)

## Introduction to Permissions

Linux is a multi-user system where file permissions determine who can access files and directories and what operations they can perform. The permission system ensures security and privacy by controlling access to resources.



## Understanding Permission Notation

### Basic Permission Structure
Linux uses a 10-character notation to represent permissions:

```
-rwxr-xr--
│└─┰─┰─┰─┰─┰─┰─┰─┰─┘
│  │ │ │ │ │ │ │ └── Others: Read permission
│  │ │ │ │ │ │ └──── Others: Write permission
│  │ │ │ │ │ └────── Others: Execute permission
│  │ │ │ │ └──────── Group: Read permission
│  │ │ │ └────────── Group: Write permission
│  │ │ └──────────── Group: Execute permission
│  │ └────────────── User: Read permission
│  └──────────────── User: Write permission
└─────────────────── User: Execute permission
```

### File Type Indicators
The first character indicates the file type:
- `-` Regular file
- `d` Directory
- `l` Symbolic link
- `c` Character device
- `b` Block device
- `p` Named pipe
- `s` Socket

### Permission Characters
- `r` Read permission (value 4)
- `w` Write permission (value 2)
- `x` Execute permission (value 1)
- `-` No permission (value 0)

![image](https://github.com/user-attachments/assets/f70e2ade-4081-4ec1-b1c3-bdf071984a6f)
## Changing Permissions with chmod

### Symbolic Method
```bash
chmod u+x script.sh        # Add execute permission for user
chmod g-w file.txt         # Remove write permission for group
chmod o=r file.txt         # Set others to read only
chmod a+x script.sh        # Add execute for all (user, group, others)
chmod u=rwx,g=rx,o= file.txt  # Set specific permissions for each
```

### Octal/Numeric Method
```bash
chmod 755 script.sh        # rwxr-xr-x
chmod 644 file.txt         # rw-r--r--
chmod 600 secret.txt       # rw-------
chmod 777 open.txt         # rwxrwxrwx (not recommended for security)
```

### Common Permission Values
- `755` - User: rwx, Group: r-x, Others: r-x (executables, directories)
- `644` - User: rw-, Group: r--, Others: r-- (regular files)
- `600` - User: rw-, Group: ---, Others: --- (private files)
- `777` - User: rwx, Group: rwx, Others: rwx (fully open - use with caution)



## Changing Ownership with chown

### Basic Syntax
```bash
chown user file.txt          # Change owner only
chown user:group file.txt    # Change both owner and group
chown :group file.txt        # Change group only
```

### Recursive Ownership Changes
```bash
chown -R user:group /path/to/directory  # Change ownership recursively
```

### Using User and Group IDs
```bash
chown 1000:1000 file.txt     # Change using UID and GID
```



## Special Permissions

### Set User ID (SUID)
- Represented as `s` in user execute position
- When set on an executable, it runs with the owner's privileges
- Set with `chmod u+s file` or `chmod 4755 file`

```bash
chmod u+s /usr/bin/program
```

### Set Group ID (SGID)
- Represented as `s` in group execute position
- When set on a directory, new files inherit the directory's group
- Set with `chmod g+s directory` or `chmod 2755 directory`

```bash
chmod g+s /shared/directory
```

### Sticky Bit
- Represented as `t` in others execute position
- When set on a directory, only owners can delete their own files
- Commonly used on /tmp directory
- Set with `chmod +t directory` or `chmod 1755 directory`

```bash
chmod +t /shared/uploads
```


## Access Control Lists (ACL)

ACLs provide more granular permission control beyond standard user/group/others.

### View ACLs
```bash
getfacl file.txt
```

### Set ACLs
```bash
setfacl -m u:username:rwx file.txt      # Add user ACL
setfacl -m g:groupname:rx file.txt      # Add group ACL
setfacl -m o::r file.txt                # Set others permissions
setfacl -x u:username file.txt          # Remove user ACL
```

### Default ACLs (for directories)
```bash
setfacl -d -m u:username:rwx directory/  # Set default ACL
```



## umask - Default Permissions

The umask value determines default permissions for newly created files and directories.

### View Current umask
```bash
umask          # Symbolic format
umask -S       # Symbolic representation of current permissions
```

### Set umask
```bash
umask 022      # Common default - files: 644, directories: 755
umask 002      # Permissive - files: 664, directories: 775
umask 077      # Restrictive - files: 600, directories: 700
```

### How umask Works
- For files: 666 - umask
- For directories: 777 - umask
- Example: umask 022 results in:
  - Files: 666 - 022 = 644 (rw-r--r--)
  - Directories: 777 - 022 = 755 (rwxr-xr-x)

## Practical Examples

### Secure Configuration File
```bash
touch config.conf
chmod 600 config.conf        # Only owner can read/write
chown root:root config.conf  # Owned by root
```

### Shared Directory for Team
```bash
mkdir /shared/team
chown root:team /shared/team
chmod 2770 /shared/team      # SGID set, group read/write/execute
```

### Web Server Directory
```bash
chown -R www-data:www-data /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;   # Files: rw-r--r--
find /var/www/html -type d -exec chmod 755 {} \;   # Directories: rwxr-xr-x
```

### User Script with SUID
```bash
chown root:users custom_script.sh
chmod 4750 custom_script.sh  # SUID set, root owner, group read/execute
```

### Temporary Upload Directory
```bash
mkdir /uploads
chown www-data:www-data /uploads
chmod 1777 /uploads          # Sticky bit set, full permissions for all
```


## Best Practices

1. **Principle of Least Privilege**: Grant only necessary permissions
2. **Regular Audits**: Periodically review permissions on critical files
3. **Use Groups**: Manage access through groups rather than individual users
4. **Avoid 777**: Never use 777 permissions on production systems
5. **SUID/SGID Caution**: Use special permissions sparingly and understand the risks
6. **Document Changes**: Keep records of permission modifications
7. **Backup Before Changes**: Always backup before making bulk permission changes

## Troubleshooting Common Issues

### Permission Denied Errors
```bash
# Check current permissions
ls -l filename

# Check user and group ownership
ls -n filename  # Show UID and GID

# Check if user is in the required group
groups username
```

### Incorrect Inheritance
```bash
# Check for SGID on parent directory
ls -ld parent_directory

# Check ACLs if permissions aren't as expected
getfacl filename
```


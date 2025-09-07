

### Linux User Management

Linux User Type’s   \                                                                                                                                                                                                                                    => root User: Administrator (#)\
=> system/Service User: Service (mail/ftp/games/daemon)-cannot login.\
=> regular User: Saiful; Parvej ($)



### 1. User Management  
| Task | Command |
|---|---|
| Add a new user | `sudo adduser username` |
| Add a system user | `sudo useradd -r username` |
| Add a user with a specific home directory | `sudo useradd -m -d /home/custom username` |
| Change a user’s home directory | `sudo usermod -d /newhome username` |
| Delete a user (keep home directory) | `sudo userdel username` |
| Delete a user and home directory | `sudo userdel -r username` |
| Lock a user account | `sudo passwd -l username` |
| Unlock a user account | `sudo passwd -u username` |
| Disable a user account temporarily | `sudo usermod -L username` |
| Enable a locked user account | `sudo usermod -U username` |
| Set an expiration date for a user | `sudo usermod -e YYYY-MM-DD username` |
| List all users | `cut -d: -f1 /etc/passwd` or `getent passwd` |
| Show details of a user | `id username` |
| Show last login of a user | `lastlog -u username` |

### 2. Password Management  
| Task | Command |
|---|---|
| Change your own password | `passwd` |
| Change another user’s password | `sudo passwd username` |
| Expire a user’s password (force change on next login) | `sudo passwd --expire username` |
| Set password expiry days | `sudo chage -M 90 username` |
| Check password expiry details | `chage -l username` |
| Disable password-based login | `sudo passwd -l username` |
| Enable password-based login | `sudo passwd -u username` |

### 3. Group Management  
| Task | Command |
|---|---|
| Create a new group | `sudo groupadd groupname` |
| Delete a group | `sudo groupdel groupname` |
| List all groups | `cut -d: -f1 /etc/group` or `getent group` |
| Show groups of a user | `groups username` or `id -Gn username` |
| Add a user to a group | `sudo usermod -aG groupname username` |
| Remove a user from a group | `sudo gpasswd -d username groupname` |
| Change a user's primary group | `sudo usermod -g groupname username` |

### 4. Sudo & Privileges  
| Task | Command |
|---|---|
| Give a user sudo privileges | `sudo usermod -aG sudo username` |
| Remove sudo privileges from a user | `sudo deluser username sudo` |
| Edit sudoers file (use with caution) | `sudo visudo` |
| Check if a user has sudo privileges | `sudo -l -U username` |

### 5. User Session & Activity Management  
| Task | Command |
|---|---|
| Show currently logged-in users | `who` or `w` |
| Show active user sessions | `who -a` |
| Show current user | `whoami` |
| Show login history | `last` |
| Show specific user login history | `last username` |
| Kill a user session | `pkill -u username` |

### 6. Home Directory & File Permissions  
| Task | Command |
|---|---|
| Change file ownership | `sudo chown username:groupname file` |
| Change file permissions | `chmod 755 file` |
| Copy default home directory files for a new user | `cp -r /etc/skel/. /home/username/` |
| Reset ownership of home directory | `sudo chown -R username:username /home/username` |

### 7. Advanced User Management  
| Task | Command |
|---|---|
| Create a user without home directory | `sudo useradd -M username` |
| Create a user with a specific UID | `sudo useradd -u 1050 username` |
| Create a user with a specific GID | `sudo useradd -g groupname username` |
| Change a user’s UID | `sudo usermod -u 1051 username` |
| Change a user’s GID | `sudo usermod -g newgroup username` |
| Move a user to another primary group | `sudo usermod -g newgroup username` |
| Lock root account | `sudo passwd -l root` |
| Unlock root account | `sudo passwd -u root` |

### 8. Miscellaneous Commands  
| Task | Command |
|---|---|
| Display user ID | `id username` |
| Show last system reboot | `last reboot` |
| Show system uptime | `uptime` |
### 9. File Permissions in Linux

Linux permissions control access to files and directories for three classes of users: **User** (owner), **Group**, and **Others**.

### Viewing Permissions: `ls -l`
```bash
$ ls -l important_file.txt
-rwxr-xr-- 1 alice developers 2048 Jun 10 14:30 important_file.txt
```
`-rwxr-xr--` is the permission string. Let's break it down:

**The first character:** File type
*   `-` = Regular file
*   `d` = Directory
*   `l` = Symbolic link

**In our example (`-rwxr-xr--`):**
*   It's a regular file (`-`).
*   The **owner** (`alice`) can read, write, and execute it (`rwx`).
*   The **group** (`developers`) can read and execute it (`r-x`).
*   **All other users** can only read it (`r--`).

### Changing Permissions: `chmod`

You can change permissions using either **symbolic** or **numeric** (octal) mode.

#### Symbolic Mode
Uses letters and operators: `u` (user), `g` (group), `o` (others), `a` (all); `+` (add), `-` (remove), `=` (set exactly); `r`, `w`, `x`.

```bash
# Add execute permission for the group
chmod g+x script.sh

# Remove read permission for others
chmod o-r document.txt

# Set permissions to rwx for user and r-x for group and nothing for others
chmod u=rwx,g=rx,o= myfile

# Give everyone write permission
chmod a+w shared_file.txt
```

#### Numeric (Octal) Mode
More common and concise. Each permission is assigned a number:
*   `r` (Read) = 4
*   `w` (Write) = 2
*   `x` (Execute) = 1

Add the numbers for the permissions you want for each class (User, Group, Other).

**Example: `chmod 754 script.sh`**
*   **User (7)**: 4 (r) + 2 (w) + 1 (x) = `rwx`
*   **Group (5)**: 4 (r) + 0 + 1 (x) = `r-x`
*   **Other (4)**: 4 (r) + 0 + 0 = `r--`

**Common Permission Values:**
*   `755` - `rwxr-xr-x`: Common for directories and executables. Owner has full access, everyone else can read and execute.
*   `644` - `rw-r--r--`: Common for files. Owner can read/write, everyone else can only read.
*   `777` - `rwxrwxrwx`: **Full access for everyone.** **Use with extreme caution!** It's a security risk.
*   `700` - `rwx------`: Private. Only the owner can read, write, or execute. No one else has any access.

### Changing Ownership: `chown` and `chgrp`

*   `chown` (Change Owner): Changes the user and group owner of a file.
    ```bash
    # Change the owner to 'alice'
    sudo chown alice file.txt

    # Change the owner to 'alice' and the group to 'developers'
    sudo chown alice:developers file.txt
    ```
*   `chgrp` (Change Group): Changes only the group owner of a file.
    ```bash
    # Change the group to 'developers'
    sudo chgrp developers file.txt
    ```
> **Note:** Changing ownership typically requires `sudo` privileges.

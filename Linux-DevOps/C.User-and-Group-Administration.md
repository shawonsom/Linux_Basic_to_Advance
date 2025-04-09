- [3.Administering Users and Groups](#3Administering-Users-and-Groups)
  - Creating and Managing a user
  - adduser | useradd
  - Understanding passwd and shadow files
  - Understanding Linux Groups (groups, id)
  - Creating, changing, and removing user accounts (useradd, usermod, userdel)
  - Sudo Group,Permissions and sudousers file for a user
  - Group management (groupadd, groupdel, groupmod)
  - User account monitoring (whoami, who am i, who, id, w, uptime, last)   


## Ubuntu Linux User Management

Linux User Type’s:                                                                                                                                                                                                                                                                                                                    => root User: Administrator (#)
=> system User: Service (mail/ftp/games/daemon)-cannot login.
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

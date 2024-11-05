Command-Line | Awesome-Linux-commands
  - [Essential Basic and Advance Linux Commands](#Essential-Basic-and-Advance-Linux-Commands)
  - [Text Processing]
     - Text Manipulation Commands 



ls Command – List Files and Directories in Linux\
[Switch Between Directories in Linux - `cd`](https://www.tecmint.com/cd-command-in-linux/)\
[Check Current Working Directory in Linux - `pwd`](https://www.tecmint.com/pwd-command-examples/)\
[List Contents of a Directory in Linux - `dir`](https://www.tecmint.com/linux-dir-command-usage-with-examples/)\
[Create New Directories in Linux - `mkdir`](https://www.tecmint.com/mkdir-command-examples/)\
[Delete Directories in Linux - `rmdir`](https://www.tecmint.com/rmdir-command-examples/)\
[Rename or Move Files and Directories in Linux - `mv`](https://www.tecmint.com/mv-command-linux-examples/)\
[Copy Files and Directories in Linux - `cp`](https://www.tecmint.com/cp-command-examples/)\
scp\
rsync\
dd\
[Create New Files in Linux - `touch`](https://www.tecmint.com/8-pratical-examples-of-linux-touch-command/)\
[Find Files and Directories in Linux - `find`](https://www.tecmint.com/35-practical-examples-of-linux-find-command/)\
[List Contents of Files in Linux - `cat`](https://www.tecmint.com/cat-command-linux/)\
Viewing files (cat, less, more, tail, head, watch)\
[Print Last 10 Lines of File in Linux - `tail`](https://www.tecmint.com/tail-command-linux/)\
[Print Frist 10 Lines of File in Linux - `head`](https://www.tecmint.com/view-contents-of-file-in-linux/)\
[Find Patterns or Strings in Text Files - `grep`](https://www.tecmint.com/12-practical-examples-of-linux-grep-command/)\
[Find Patterns or Strings in Text Files - `find`](https://www.tecmint.com/35-practical-examples-of-linux-find-command/)\
[Create Hard and Symbolic Links in Linux - `ln`](https://www.tecmint.com/create-hard-and-symbolic-links-in-linux/)\
[Create Alias (Shortcuts) in Linux - `alias`](https://www.tecmint.com/create-alias-in-linux/)\
[How to Print Line of Text in Linux - `echo`](https://www.tecmint.com/echo-command-in-linux/)\
[Remove Duplicate Lines in Linux - `uniq`](https://www.tecmint.com/remove-duplicate-lines-linux-files/)\
[Check Disk Usage of Files and Directories - `du`](https://www.tecmint.com/check-linux-disk-usage-of-files-and-directories/)\
[List Running Processes with PIDs in Linux - `ps`]()\
[List Running Processes in Linux - `top`]()\
[htop]\
[Kill Running Processes with PIDs in Linux - `kill`]()\
[Check Linux File System Disk Space Usage - `df`](https://www.tecmint.com/how-to-check-disk-space-in-linux/)\
Signals and killing processes (kill, pkill, killall, pidof)\
watch -n 1 "ps aux | grep passwd"\
diff\
file\
df\
Checking for listening ports (netstat, ss, lsof, telnet, nmap)\
less, more, head, tail\
date\
wget\

Search for files, Search file using Grep\
Compare and manipulate file content\
Analyse text using basic regular expressions & extended regular Expressions\
get\
tree\
Working with pipes in Linux (|, wc)\
Command redirection (>, >>, 2> &>, cut, tee)\
Finding files and directories (locate, find, which)\



Mounting and unmounting file systems (df, mount, umount, fdisk, gparted)\
Getting system hardware information (lwhw, lscpu, lsusb, lspci, dmidecode, hdparm)\
Service management (systemd and systemctl)\
netplan






### SCP Command Guide

The `scp` (Secure Copy Protocol) command is used to securely transfer files and directories between local and remote systems over SSH. Below are some common use cases, syntax, and examples to help you get started.

---

### Basic Syntax

```bash
scp [options] [source] [destination]
```

- **[source]**: Specifies the source file or directory path.
- **[destination]**: Specifies the destination file or directory path.
- **Options**: Flags used to modify the behavior of `scp`.

### Key Options

| Option | Description                                |
|--------|--------------------------------------------|
| `-r`   | Recursively copy directories              |
| `-P`   | Specify a port for SSH (default is 22)    |
| `-C`   | Enable compression                        |
| `-i`   | Specify an identity (private key) file    |
| `-v`   | Enable verbose mode for debugging         |
| `-q`   | Suppress progress meter                   |
| `-l`   | Limit bandwidth used (in Kbit/s)          |

```sh
scp myfile.txt user@192.168.1.10:/home/user/                                    ### 1. Copying a File from Local to Remote
scp user@192.168.1.10:/home/user/myfile.txt /local/directory/                   ### 2. Copying a File from Remote to Local
scp -r /home/user/documents user@192.168.1.10:/backup/documents                 ### 3. Copying a Directory Recursively
scp -P 2222 myfile.txt user@192.168.1.10:/home/user/                            ### 4. Using a Custom SSH Port
scp -C myfile.iso user@192.168.1.10:/home/user/                                 ### 5. Copying with Compression | To speed up the transfer of large files
scp -i ~/.ssh/id_rsa myfile.txt user@192.168.1.10:/home/user/                   ### 6. Copying with a Specific Identity File (SSH Key)
scp -l 1000 largefile.zip user@192.168.1.10:/home/user/                         ### 7. Limiting Bandwidth Usage
scp -v /path/to/localfile username@remote_host:/path/to/destination             ### 8. Verbose Mode for Debugging
scp user1@192.168.1.10:/home/user1/myfile.txt user2@192.168.1.20:/home/user2/   ### 9.Transferring Between Two Remote Servers
```



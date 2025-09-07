# Linux Commands & Git Guide

## 🐧 Linux Commands

### Basic File Operations

```bash
# Navigation
pwd                     # Print working directory
ls                      # List files
ls -la                  # List all files (including hidden) with details
cd /path/to/directory   # Change directory
cd ~                    # Go to home directory
cd ..                   # Go up one directory

# File Operations
touch filename          # Create empty file
mkdir dirname           # Create directory
rm filename             # Remove file
rm -r dirname           # Remove directory recursively
cp file1 file2          # Copy file
cp -r dir1 dir2         # Copy directory
mv file1 file2          # Move/rename file

# File Viewing
cat filename            # Display file content
less filename           # View file page by page
head -n 10 filename     # Show first 10 lines
tail -n 10 filename     # Show last 10 lines
tail -f filename        # Follow file changes in real-time
```

### File Permissions

```bash
chmod 755 filename      # Change file permissions (rwxr-xr-x)
chmod +x script.sh      # Make file executable
chown user:group file   # Change file owner and group
```

### System Monitoring

```bash
ps aux                  # Show all running processes
top                     # Interactive process viewer
htop                    # Enhanced top (install with package manager)
free -h                 # Show memory usage
df -h                   # Show disk space
du -sh *                # Show directory sizes
```

### Networking

```bash
ping google.com         # Test network connectivity
ifconfig                # Network interface configuration (deprecated)
ip addr                 # Show IP addresses
netstat -tulpn          # Show listening ports and processes
ssh user@host           # Connect to remote server
scp file user@host:path # Secure copy file to remote
```

### Package Management

**Ubuntu/Debian:**
```bash
sudo apt update         # Update package list
sudo apt upgrade        # Upgrade packages
sudo apt install package # Install package
sudo apt remove package # Remove package
```

**CentOS/RHEL:**
```bash
sudo yum update         # Update packages
sudo yum install package # Install package
```

### Text Processing

```bash
grep "pattern" file     # Search for pattern in file
grep -r "pattern" dir/  # Recursive search
sed 's/old/new/g' file  # Find and replace text
awk '{print $1}' file   # Print first column
sort file              # Sort lines
uniq file              # Remove duplicate lines
```

### Process Management

```bash
kill PID               # Terminate process
kill -9 PID            # Force kill process
pkill process_name     # Kill process by name
bg                     # Send process to background
fg                     # Bring process to foreground
jobs                   # List background jobs
```

### Advanced Commands

```bash
# Find files
find /path -name "*.txt"        # Find files by name
find . -type f -mtime -7        # Find files modified in last 7 days

# Compression
tar -czvf archive.tar.gz dir/   # Create compressed archive
tar -xzvf archive.tar.gz        # Extract compressed archive

# System info
uname -a                        # Show system information
lsb_release -a                  # Show distribution information
```

## 📚 Git Version Control

### Basic Git Workflow

```bash
# Initialize repository
git init
git clone https://github.com/user/repo.git

# Configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Basic operations
git status                      # Show working directory status
git add filename               # Stage file
git add .                      # Stage all changes
git commit -m "Commit message" # Commit changes
git push origin main           # Push to remote repository
git pull origin main           # Pull latest changes
```

### Branching

```bash
git branch                      # List branches
git branch new-branch           # Create new branch
git checkout branch-name        # Switch to branch
git checkout -b new-branch      # Create and switch to new branch
git merge branch-name           # Merge branch into current
git branch -d branch-name       # Delete branch
```

### Advanced Git

```bash
# Stashing
git stash                      # Save changes temporarily
git stash pop                  # Apply stashed changes

# History
git log                        # Show commit history
git log --oneline --graph      # Compact history with graph
git diff                       # Show changes
git diff --staged              # Show staged changes

# Remote operations
git remote -v                  # Show remote repositories
git remote add origin URL      # Add remote repository
git fetch origin               # Download objects from remote
git push -u origin main        # Push and set upstream

# Undoing changes
git reset --soft HEAD~1        # Undo last commit, keep changes staged
git reset --hard HEAD~1        # Undo last commit, discard changes
git checkout -- filename       # Discard changes in working directory
```

### Git Tags

```bash
git tag v1.0.0                 # Create lightweight tag
git tag -a v1.0.0 -m "Message" # Create annotated tag
git push origin --tags         # Push tags to remote
```

### Git Workflows

```bash
# Rebasing (clean history)
git rebase main               # Rebase current branch onto main

# Interactive rebase (squash commits)
git rebase -i HEAD~3          # Interactive rebase of last 3 commits

# Cherry-picking
git cherry-pick commit-hash   # Apply specific commit to current branch
```

## 🔧 Useful Tips

### Aliases
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
alias ll='ls -la'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph'
```

### SSH Key Setup for Git
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub  # Add this to your GitHub/GitLab account
```

## 📖 Resources

- **Linux Documentation**: `man command` (e.g., `man ls`)
- **Git Documentation**: `git help command` (e.g., `git help commit`)
- **Online Resources**: 
  - [Linux Journey](https://linuxjourney.com/)
  - [Pro Git Book](https://git-scm.com/book/en/v2)
  - [Explain Shell](https://explainshell.com/)

## 🚀 Practice Projects

1. **Linux**: Set up a personal server, create scripts for automation
2. **Git**: Contribute to open source, maintain personal projects with version control
3. **Combined**: Set up CI/CD pipelines, automate deployments

Remember: Practice regularly and always check man pages (`man command`) for detailed information!

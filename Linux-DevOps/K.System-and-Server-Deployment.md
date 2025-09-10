# Linux System and Server Deployment Guide

## Table of Contents
1. [Introduction to System Deployment](#introduction-to-system-deployment)
2. [Pre-Deployment Planning](#pre-deployment-planning)
3. [Post-Installation Configuration](#post-installation-configuration)
4. [Server Role Configuration](#server-role-configuration)
5. [Security Hardening](#security-hardening)
6. [Service Configuration Management](#service-configuration-management)
7. [Automation with Scripts](#automation-with-scripts)
8. [Monitoring and Maintenance](#monitoring-and-maintenance)
9. [Backup and Recovery](#backup-and-recovery)
10. [Deployment Tools](#deployment-tools)
11. [Cloud Deployment](#cloud-deployment)
12. [Best Practices](#best-practices)

## Introduction to System Deployment

System deployment involves preparing, configuring, and deploying servers for production use. This process ensures consistency, reliability, and security across your infrastructure.

### Deployment Lifecycle
1. **Planning**: Requirements gathering and architecture design
2. **Preparation**: Environment setup and resource allocation
3. **Installation**: OS and base software installation
4. **Configuration**: Service setup and customization
5. **Testing**: Validation and performance testing
6. **Deployment**: Going live and monitoring
7. **Maintenance**: Ongoing updates and management

## Pre-Deployment Planning

### Hardware Requirements Assessment
```bash
# Check system hardware
lshw -short
dmidecode -t system
lscpu
free -h
lsblk

# Example minimal requirements for different server types:
# Web Server: 2 CPU, 4GB RAM, 20GB Storage
# Database Server: 4 CPU, 16GB RAM, 100GB+ Storage
# Application Server: 4 CPU, 8GB RAM, 50GB Storage
```

### Network Planning
```bash
# Network interface information
ip addr show
ip link show

# Network configuration planning
# - IP addressing scheme
# - DNS servers
# - Gateway configuration
# - Firewall rules
# - VLAN configuration if needed
```

### Storage Planning
```bash
# Storage assessment
fdisk -l
lsblk
parted -l

# RAID planning considerations:
# - RAID 1 for OS (mirroring)
# - RAID 5/6 for data storage
# - RAID 10 for high performance databases
```
## Post-Installation Configuration

### System Update and Baseline
```bash
# Update system packages
yum update -y          # RHEL/CentOS
apt update && apt upgrade -y  # Debian/Ubuntu

# Install essential tools
yum install -y epel-release vim curl wget git htop      # RHEL/CentOS
apt install -y vim curl wget git htop build-essential   # Debian/Ubuntu

# Set hostname
hostnamectl set-hostname server01.example.com

# Configure static IP (example for CentOS)
nmcli con mod eth0 ipv4.addresses 192.168.1.10/24
nmcli con mod eth0 ipv4.gateway 192.168.1.1
nmcli con mod eth0 ipv4.dns "8.8.8.8 8.8.4.4"
nmcli con mod eth0 ipv4.method manual
nmcli con up eth0
```

### User and Group Management
```bash
# Create administrative user
useradd -m -s /bin/bash admin
passwd admin

# Add user to sudoers
usermod -aG wheel admin  # RHEL/CentOS
usermod -aG sudo admin   # Debian/Ubuntu

# Configure SSH keys for secure access
mkdir -p /home/admin/.ssh
chmod 700 /home/admin/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2E..." > /home/admin/.ssh/authorized_keys
chmod 600 /home/admin/.ssh/authorized_keys
chown -R admin:admin /home/admin/.ssh

# Disable root SSH login
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd
```

## Server Role Configuration

### Web Server (Nginx)
```bash
# Install Nginx
yum install -y nginx    # RHEL/CentOS
apt install -y nginx    # Debian/Ubuntu

# Configure Nginx
cat > /etc/nginx/conf.d/example.com.conf << EOF
server {
    listen 80;
    server_name example.com www.example.com;
    root /var/www/example.com;
    index index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    access_log /var/log/nginx/example.com.access.log;
    error_log /var/log/nginx/example.com.error.log;
}
EOF

# Create web directory
mkdir -p /var/www/example.com
echo "<h1>Welcome to example.com</h1>" > /var/www/example.com/index.html
chown -R nginx:nginx /var/www/example.com
chmod -R 755 /var/www/example.com

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
```

### Database Server (MySQL/MariaDB)
```bash
# Install MariaDB
yum install -y mariadb-server mariadb     # RHEL/CentOS
apt install -y mariadb-server             # Debian/Ubuntu

# Secure MySQL installation
mysql_secure_installation

# Configure MySQL
cat > /etc/my.cnf.d/custom.cnf << EOF
[mysqld]
bind-address = 192.168.1.20
max_connections = 200
innodb_buffer_pool_size = 1G
query_cache_size = 128M
EOF

# Create database and user
mysql -u root -p << EOF
CREATE DATABASE appdb;
CREATE USER 'appuser'@'%' IDENTIFIED BY 'securepassword';
GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
EOF

# Enable and start MariaDB
systemctl enable mariadb
systemctl start mariadb
```

### Application Server (Node.js)
```bash
# Install Node.js
curl -sL https://rpm.nodesource.com/setup_14.x | bash -  # RHEL/CentOS
yum install -y nodejs

curl -sL https://deb.nodesource.com/setup_14.x | bash -  # Debian/Ubuntu
apt install -y nodejs

# Create application directory
mkdir -p /opt/myapp
cd /opt/myapp

# Initialize Node.js application
npm init -y
npm install express

# Create sample app
cat > app.js << EOF
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  console.log(\`App listening at http://localhost:\${port}\`);
});
EOF

# Create systemd service
cat > /etc/systemd/system/myapp.service << EOF
[Unit]
Description=My Node.js Application
After=network.target

[Service]
Type=simple
User=appuser
Group=appuser
WorkingDirectory=/opt/myapp
ExecStart=/usr/bin/node app.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start application
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp
```

## Security Hardening

### Basic Security Configuration
```bash
# Configure firewall
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --remove-service=dhcpv6-client
firewall-cmd --reload

# Install and configure fail2ban
yum install -y fail2ban    # RHEL/CentOS
apt install -y fail2ban    # Debian/Ubuntu

cat > /etc/fail2ban/jail.local << EOF
[sshd]
enabled = true
maxretry = 3
bantime = 3600
EOF

systemctl enable fail2ban
systemctl start fail2ban

# Configure automatic security updates
yum install -y yum-cron    # RHEL/CentOS
apt install -y unattended-upgrades  # Debian/Ubuntu

# For RHEL/CentOS:
sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
systemctl enable yum-cron
systemctl start yum-cron

# For Debian/Ubuntu:
dpkg-reconfigure unattended-upgrades
```

### Advanced Security Measures
```bash
# Install and configure SELinux
yum install -y selinux-policy-targeted selinux-policy-devel
semanage port -a -t http_port_t -p tcp 8080
setsebool -P httpd_can_network_connect 1

# Or install AppArmor for Debian/Ubuntu
apt install -y apparmor apparmor-utils
aa-enforce /path/to/profile

# Configure auditd for security monitoring
cat > /etc/audit/audit.rules << EOF
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k identity
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
EOF

systemctl enable auditd
systemctl start auditd
```

## Service Configuration Management

### Systemd Service Management
```bash
# Service management commands
systemctl status servicename
systemctl start servicename
systemctl stop servicename
systemctl restart servicename
systemctl reload servicename
systemctl enable servicename
systemctl disable servicename

# View service logs
journalctl -u servicename
journalctl -u servicename -f  # Follow logs
journalctl -u servicename --since "2023-01-01" --until "2023-01-02"

# Create custom systemd service
cat > /etc/systemd/system/custom-service.service << EOF
[Unit]
Description=Custom Service
After=network.target

[Service]
Type=simple
User=serviceuser
ExecStart=/usr/bin/python3 /opt/custom/service.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

### Configuration File Management
```bash
# Backup configuration files
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Use version control for configuration
cd /etc
git init
git add nginx/ ssh/
git commit -m "Initial configuration backup"

# Deploy configuration changes safely
# 1. Test configuration
nginx -t
sshd -t

# 2. Backup current config
cp current.conf current.conf.backup

# 3. Deploy new config
cp new.conf current.conf

# 4. Reload service
systemctl reload servicename

# 5. Verify functionality
curl -I http://localhost

# 6. Rollback if necessary
cp current.conf.backup current.conf
systemctl reload servicename
```

## Automation with Scripts

### Deployment Automation Script
```bash
#!/bin/bash
# deployment-automation.sh

set -e  # Exit on error

# Configuration
SERVER_IP="192.168.1.10"
SERVER_USER="admin"
SSH_KEY="/path/to/ssh/key"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Function to execute remote commands
remote_exec() {
    ssh -i "$SSH_KEY" "${SERVER_USER}@${SERVER_IP}" "$1"
}

# Function to copy files to remote
remote_copy() {
    scp -i "$SSH_KEY" "$1" "${SERVER_USER}@${SERVER_IP}:$2"
}

# Main deployment function
deploy() {
    log "Starting deployment to $SERVER_IP"
    
    # Update system
    log "Updating system packages"
    remote_exec "sudo yum update -y || sudo apt update && sudo apt upgrade -y"
    
    # Install required packages
    log "Installing required packages"
    remote_exec "sudo yum install -y epel-release vim curl wget git htop || sudo apt install -y vim curl wget git htop"
    
    # Deploy configuration files
    log "Deploying configuration files"
    remote_copy "config/nginx.conf" "/tmp/nginx.conf"
    remote_exec "sudo mv /tmp/nginx.conf /etc/nginx/nginx.conf && sudo nginx -t"
    
    # Deploy application code
    log "Deploying application code"
    remote_copy "app.tar.gz" "/tmp/app.tar.gz"
    remote_exec "sudo tar -xzf /tmp/app.tar.gz -C /var/www/html && sudo chown -R nginx:nginx /var/www/html"
    
    # Restart services
    log "Restarting services"
    remote_exec "sudo systemctl restart nginx"
    
    # Run tests
    log "Running deployment tests"
    if remote_exec "curl -s http://localhost | grep -q 'Welcome'"; then
        log "Deployment completed successfully"
    else
        error "Deployment test failed"
    fi
}

# Execute deployment
deploy
```

### Configuration Management Script
```bash
#!/bin/bash
# server-bootstrap.sh

# System configuration
hostnamectl set-hostname server01.example.com

# Time synchronization
timedatectl set-timezone UTC
systemctl enable chronyd || systemctl enable systemd-timesyncd
systemctl start chronyd || systemctl start systemd-timesyncd

# Security configuration
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "AllowUsers admin" >> /etc/ssh/sshd_config
systemctl restart sshd

# Firewall configuration
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --remove-service=dhcpv6-client
firewall-cmd --reload

# System tuning
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "net.core.somaxconn=65535" >> /etc/sysctl.conf
sysctl -p

# Create swap file if needed
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

echo "Server bootstrap completed"
```

## Monitoring and Maintenance

### Monitoring Setup
```bash
# Install and configure monitoring agent
# For Prometheus node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xzf node_exporter-*.tar.gz
cp node_exporter-*/node_exporter /usr/local/bin/
useradd -m -s /bin/false node_exporter

# Create systemd service
cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Install log monitoring
apt install -y logwatch   # Debian/Ubuntu
yum install -y logwatch   # RHEL/CentOS

# Configure logwatch
cat > /etc/logwatch/conf/logwatch.conf << EOF
Output = mail
Format = html
MailTo = admin@example.com
Range = yesterday
Detail = Low
EOF
```

### Maintenance Scripts
```bash
#!/bin/bash
# system-maintenance.sh

# Daily maintenance tasks
logfile="/var/log/maintenance.log"

echo "$(date): Starting maintenance tasks" >> $logfile

# Clean package cache
if command -v apt-get &> /dev/null; then
    apt-get clean >> $logfile 2>&1
elif command -v yum &> /dev/null; then
    yum clean all >> $logfile 2>&1
fi

# Remove old log files
find /var/log -name "*.log" -type f -mtime +30 -delete >> $logfile 2>&1

# Clean temporary files
rm -rf /tmp/* >> $logfile 2>&1
rm -rf /var/tmp/* >> $logfile 2>&1

# Update locate database
updatedb >> $logfile 2>&1

# Check disk space
df -h >> $logfile 2>&1

echo "$(date): Maintenance tasks completed" >> $logfile
```

## Backup and Recovery

### Backup Strategy Implementation
```bash
#!/bin/bash
# backup-script.sh

# Configuration
BACKUP_DIR="/backup"
DATE=$(date +%Y%m%d)
RETENTION_DAYS=30

# Create backup directory
mkdir -p $BACKUP_DIR/$DATE

# Backup important directories
tar -czf $BACKUP_DIR/$DATE/etc-backup.tar.gz /etc
tar -czf $BACKUP_DIR/$DATE/var-www-backup.tar.gz /var/www
tar -czf $BACKUP_DIR/$DATE/home-backup.tar.gz /home

# Database backup (if MySQL/MariaDB is installed)
if command -v mysqldump &> /dev/null; then
    mysqldump -u root --all-databases > $BACKUP_DIR/$DATE/databases.sql
    gzip $BACKUP_DIR/$DATE/databases.sql
fi

# Create backup manifest
find $BACKUP_DIR/$DATE -type f -exec ls -la {} \; > $BACKUP_DIR/$DATE/manifest.txt

# Clean up old backups
find $BACKUP_DIR -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \;

# Sync to remote backup server (if configured)
if [ -f /etc/backup/remote.config ]; then
    rsync -avz $BACKUP_DIR/$DATE/ backup-server:/remote/backup/$DATE/
fi

echo "Backup completed: $BACKUP_DIR/$DATE"
```

### Recovery Procedures
```bash
#!/bin/bash
# recovery-script.sh

# Restore from backup
BACKUP_DATE="20231201"
BACKUP_DIR="/backup/$BACKUP_DATE"

# Verify backup integrity
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Restore files
tar -xzf $BACKUP_DIR/etc-backup.tar.gz -C /
tar -xzf $BACKUP_DIR/var-www-backup.tar.gz -C /
tar -xzf $BACKUP_DIR/home-backup.tar.gz -C /

# Restore databases
if [ -f "$BACKUP_DIR/databases.sql.gz" ]; then
    gunzip -c $BACKUP_DIR/databases.sql.gz | mysql -u root
fi

echo "Recovery completed from backup: $BACKUP_DATE"
```

## Deployment Tools

### Ansible Playbook Example
```yaml
# site.yml
---
- hosts: webservers
  become: yes
  vars:
    http_port: 80
    https_port: 443
  tasks:
    - name: Install nginx
      package:
        name: nginx
        state: present
    
    - name: Copy nginx configuration
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify: restart nginx
    
    - name: Enable and start nginx
      systemd:
        name: nginx
        enabled: yes
        state: started
    
    - name: Open firewall ports
      firewalld:
        port: "{{ item }}/tcp"
        permanent: yes
        state: enabled
      loop:
        - "{{ http_port }}"
        - "{{ https_port }}"
  
  handlers:
    - name: restart nginx
      systemd:
        name: nginx
        state: restarted
```

### Docker Deployment
```bash
# Dockerfile for application deployment
FROM node:14-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .

EXPOSE 3000
USER node
CMD ["node", "app.js"]

# docker-compose.yml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
  
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - web
```

## Cloud Deployment

### AWS EC2 Deployment Script
```bash
#!/bin/bash
# aws-deploy.sh

# Configuration
AMI_ID="ami-0c02fb55956c7d316"
INSTANCE_TYPE="t3.medium"
KEY_NAME="my-keypair"
SECURITY_GROUP="sg-1234567890"
SUBNET_ID="subnet-1234567890"
TAG_NAME="production-web-server"

# Create EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SECURITY_GROUP \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Instance $INSTANCE_ID is running at $PUBLIC_IP"

# Deployment commands
ssh -i ~/.ssh/my-keypair.pem ec2-user@$PUBLIC_IP << 'EOF'
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
EOF
```

## Best Practices

### Deployment Best Practices
1. **Infrastructure as Code**: Use tools like Ansible, Terraform, or CloudFormation
2. **Version Control**: Keep all configuration and deployment scripts in version control
3. **Testing**: Implement comprehensive testing before production deployment
4. **Rolling Deployments**: Deploy changes gradually to minimize impact
5. **Monitoring**: Implement comprehensive monitoring and alerting
6. **Documentation**: Maintain detailed deployment and operational documentation
7. **Security**: Follow security best practices throughout the deployment process
8. **Backup**: Implement robust backup and recovery procedures

### Performance Optimization
```bash
# Kernel tuning for web servers
echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 65535" >> /etc/sysctl.conf
echo "vm.swappiness = 10" >> /etc/sysctl.conf
sysctl -p

# Database optimization
echo "innodb_buffer_pool_size = 1G" >> /etc/my.cnf
echo "query_cache_size = 128M" >> /etc/my.cnf

# Web server optimization
echo "worker_processes auto;" >> /etc/nginx/nginx.conf
echo "worker_connections 4096;" >> /etc/nginx/nginx.conf
```

### Security Checklist
```bash
# Regular security tasks
#!/bin/bash
# security-audit.sh

# Check for unauthorized SUID files
find / -perm -4000 -type f -exec ls -la {} \;

# Check for world-writable files
find / -perm -2 -type f -exec ls -la {} \;

# Check for unauthorized cron jobs
ls -la /etc/cron.*/

# Verify package integrity
rpm -Va  # RHEL/CentOS
debsums -c  # Debian/Ubuntu

# Check listening ports
netstat -tulpn
ss -tulpn

# Review authentication logs
grep "Failed password" /var/log/secure
grep "Accepted password" /var/log/secure
```

This comprehensive guide provides a solid foundation for Linux system and server deployment, covering everything from initial planning to ongoing maintenance and optimization.

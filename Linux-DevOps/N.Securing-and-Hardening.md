- [12.Securing and Hardening]
   - Iptables | Netfilter | NFTables | FirewallD | UFW
   - Security
   - AppArmor
   - TCP Wrapper
   - SeLinux
   - Fail2ban



# 🔥 AlmaLinux 9.5 Firewalld Full Training Guide

- Zones
- Services & Ports Management
- Runtime vs Permanent Rules
- Rich Rules
- Masquerading (NAT)

---

## 🧩 What is firewalld?

**firewalld** is a dynamic firewall manager that supports zones, services, and ports. It allows you to manage firewall rules without restarting the firewall daemon.

---

## 1️⃣ Install and Enable Firewalld

### Install firewalld
```
sudo dnf install firewalld -y
```

### Enable and start the service
```
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

### Check status
```
sudo systemctl status firewalld
```

### Disable firewalld (optional)
```
sudo systemctl disable firewalld
sudo systemctl stop firewalld
```

---

## 2️⃣ Zones Management

### Check active zones
```
sudo firewall-cmd --get-active-zones
```

### Check default zone
```
sudo firewall-cmd --get-default-zone
```

### List all zones
```
sudo firewall-cmd --list-all-zones
```

---

## 3️⃣ Service Management

### Add service to zone
```
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
```

### Remove service
```
sudo firewall-cmd --zone=public --remove-service=http --permanent
```

### Reload to apply changes
```
sudo firewall-cmd --reload
```

### List services in a zone
```
sudo firewall-cmd --zone=public --list-services
```

---

## 4️⃣ Port Management

### Add port
```
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
```

### Add port range
```
sudo firewall-cmd --zone=public --add-port=30000-31000/tcp --permanent
```

### Remove port
```
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent
```

### List open ports
```
sudo firewall-cmd --zone=public --list-ports
```

---

## 5️⃣ Runtime vs Permanent Rules

| Runtime | Permanent |
|---------|-----------|
| Immediate effect, lost on reboot | Persistent, survives reboot |
| Great for testing | Use for production environments |

Example (runtime):
```
sudo firewall-cmd --zone=public --add-service=ftp
```

Example (permanent):
```
sudo firewall-cmd --zone=public --add-service=ftp --permanent
sudo firewall-cmd --reload
```

---

## 6️⃣ Rich Rules (Advanced)

### Allow SSH from specific IP
```
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.50" service name="ssh" accept'
```

### Block IP address
```
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.100" reject'
```

### Allow port from specific IP
```
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.1.50" port port="8080" protocol="tcp" accept'
```

### Apply changes
```
sudo firewall-cmd --reload
```

### List all rules
```
sudo firewall-cmd --list-all
```

### Test rule existence
```
sudo firewall-cmd --query-port=8080/tcp
sudo firewall-cmd --query-service=http
```

---



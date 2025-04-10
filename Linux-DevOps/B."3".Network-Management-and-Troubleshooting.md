- [5.Network Management and Troubleshooting]()
  - Telnet
  - Ping(ICMP)
  - Traceroute
  - Static Route IP
  - Curl
  - Packet Analysis
  - Netstat
  - ifconfig
  - tcpdump
  - mtr




### AlmaLinux 9.5 Network and Service Management Guide

This guide is for training purposes and covers:
- Static IP Configuration
- DNS Configuration
- Route Management
- Hostname Configuration
- /etc/hosts File Management
- Service Management

---

#### 🧩 Static IP Configuration (nmcli & config file)

##### Using nmcli (Recommended way)

1. List all network interfaces:
```
nmcli device status
```

2. Assign static IP address:
```
sudo nmcli con mod <connection-name> ipv4.addresses 192.168.1.100/24
sudo nmcli con mod <connection-name> ipv4.gateway 192.168.1.1
sudo nmcli con mod <connection-name> ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli con mod <connection-name> ipv4.method manual
sudo nmcli con up <connection-name>
```

#### Using configuration file

Edit the connection profile in:
```
/etc/NetworkManager/system-connections/<connection-name>.nmconnection
```

Example config section:
```
[ipv4]
address1=192.168.1.100/24,192.168.1.1
dns=8.8.8.8;8.8.4.4;
method=manual
```

Apply changes:
```
sudo nmcli con reload
sudo nmcli con up <connection-name>
```

---

### 🌐 DNS Configuration

#### Temporary (session only)
```
sudo nmcli dev modify <connection-name> ipv4.dns "8.8.8.8 1.1.1.1"
sudo nmcli con up <connection-name>
```

#### Permanent
Edit your connection profile or:
```
sudo nano /etc/resolv.conf
```

Add:
```
nameserver 8.8.8.8
nameserver 1.1.1.1
```

*Note: If NetworkManager manages resolv.conf, use nmcli for persistence.*

---

### 🛣️ Route Management

#### Add Persistent Route using nmcli
```
sudo nmcli con mod <connection-name> +ipv4.routes "192.168.2.0/24 192.168.1.1"
sudo nmcli con up <connection-name>
```

#### Temporary Route
```
sudo ip route add 192.168.2.0/24 via 192.168.1.1
```

#### View Routing Table
```
ip route show
```

---

### 🖥️ Hostname Configuration

#### Check current hostname
```
hostnamectl status
```

#### Set new hostname
```
sudo hostnamectl set-hostname server1.example.com
```

#### Verify
```
hostnamectl
```

---

### 🗂️ /etc/hosts File Management

Edit `/etc/hosts` to map hostnames to IP addresses:

Example:
```
127.0.0.1   localhost
192.168.1.100   server1.example.com server1
192.168.1.101   server2.example.com server2
```

Save and close the file.

---




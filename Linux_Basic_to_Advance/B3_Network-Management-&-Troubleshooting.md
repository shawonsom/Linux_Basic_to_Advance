# Network Management and Troubleshooting

## 3. Network Management and Troubleshooting

### Telnet
**Purpose:** Test TCP connectivity to specific ports
```bash
# Install telnet client if not installed default
sudo apt install telnet        # Ubuntu/Debian
sudo yum install telnet        # RedHat/CentOS

# Basic syntax
telnet [host] [port]

# Examples
telnet google.com 80           # Test HTTP connectivity
telnet 192.168.1.1 22          # Test SSH connectivity
telnet example.com 443         # Test HTTPS connectivity

# Exit telnet
Ctrl+] then type 'quit' or 'q'
```

**Common Uses:**
- Verify service availability
- Test firewall rules
- Check port accessibility

---

### Ping (ICMP)
**Purpose:** Test network connectivity using ICMP echo requests
```bash
# Basic ping
ping google.com
ping 192.168.1.1

# Ping with specific count
ping -c 4 google.com           # Send 4 packets

# Ping with interval
ping -i 2 google.com           # 2 second interval

# Ping with packet size
ping -s 1000 google.com        # 1000 byte packets

# Continuous ping
ping -t google.com             # Linux (some distros)
ping google.com                # Ctrl+C to stop

# Flood ping (root only)
ping -f google.com             # Stress testing
```

**Interpretation:**
- **Reply from**: Successful connectivity
- **Request timed out**: No response
- **Destination host unreachable**: Routing issue
- **TTL expired**: Routing loop

---

### Traceroute
**Purpose:** Trace the path packets take to reach destination
```bash
# Basic traceroute
traceroute google.com

# Using specific protocol
traceroute -I google.com       # Use ICMP
traceroute -T google.com       # Use TCP
traceroute -U google.com       # Use UDP

# Set maximum hops
traceroute -m 30 google.com    # Max 30 hops

# Bypass DNS resolution
traceroute -n google.com       # Show IP addresses only

# Alternative command (on some systems)
tracepath google.com
```

**Output Interpretation:**
- Each line represents a hop (router)
- *** indicates no response
- High latency indicates network congestion

---

### Static Route Configuration
**Purpose:** Manually configure network routes
```bash
# View current routing table
ip route show
route -n

# Add static route
sudo ip route add 192.168.2.0/24 via 192.168.1.1
sudo route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.1.1

# Add default gateway
sudo ip route add default via 192.168.1.1
sudo route add default gw 192.168.1.1

# Delete route
sudo ip route del 192.168.2.0/24
sudo route del -net 192.168.2.0 netmask 255.255.255.0

# Persistent routes (Ubuntu/Debian)
# Add to /etc/network/interfaces or netplan config

# Persistent routes (RedHat/CentOS)
# Add to /etc/sysconfig/network-scripts/route-eth0
```

---

### Curl
**Purpose:** Transfer data from or to a server
```bash
# Basic HTTP request
curl http://example.com

# Save output to file
curl -o output.html http://example.com

# Follow redirects
curl -L http://example.com

# Include headers in output
curl -i http://example.com

# Show only headers
curl -I http://example.com

# POST request with data
curl -X POST -d "name=value" http://example.com

# With authentication
curl -u username:password http://example.com

# Download file
curl -O http://example.com/file.zip

# Test download speed
curl -o /dev/null -w "%{speed_download}\n" http://example.com/largefile

# Verbose output
curl -v http://example.com
```

---

### Packet Analysis

#### tcpdump
**Purpose:** Capture and analyze network traffic
```bash
# Install tcpdump
sudo apt install tcpdump        # Ubuntu/Debian
sudo yum install tcpdump        # RedHat/CentOS

# Capture on specific interface
sudo tcpdump -i eth0

# Capture specific number of packets
sudo tcpdump -c 10 -i eth0

# Capture and save to file
sudo tcpdump -w capture.pcap -i eth0

# Read from capture file
sudo tcpdump -r capture.pcap

# Filter by host
sudo tcpdump host 192.168.1.100

# Filter by port
sudo tcpdump port 80

# Filter by protocol
sudo tcpdump icmp
sudo tcpdump tcp
sudo tcpdump udp

# Advanced filters
sudo tcpdump src host 192.168.1.100 and dst port 80
sudo tcpdump net 192.168.1.0/24

# Verbose output
sudo tcpdump -v
sudo tcpdump -vv
```

---

### Netstat
**Purpose:** Network statistics and connections
```bash
# Show all listening ports
netstat -tulnp

# Show all connections
netstat -tunp

# Show routing table
netstat -rn

# Show interface statistics
netstat -i

# Show statistics by protocol
netstat -s

# Continuous monitoring
netstat -c

# Show process information
netstat -p

# Common combinations:
netstat -tuln              # All listening TCP/UDP ports
netstat -an                # All connections numerical
netstat -rn                # Routing table
```

---

### ifconfig (Deprecated but still used)
**Purpose:** Configure network interfaces (use `ip` command for new systems)
```bash
# Show all interfaces
ifconfig
ifconfig -a

# Show specific interface
ifconfig eth0

# Enable/disable interface
ifconfig eth0 up
ifconfig eth0 down

# Set IP address
ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# Modern alternative: ip command
ip addr show
ip link show
```

---

### mtr (My Traceroute)
**Purpose:** Combination of ping and traceroute
```bash
# Install mtr
sudo apt install mtr          # Ubuntu/Debian
sudo yum install mtr          # RedHat/CentOS

# Basic usage
mtr google.com

# Use TCP instead of ICMP
mtr --tcp google.com

# Use UDP instead of ICMP
mtr --udp google.com

# Set number of pings per hop
mtr -c 10 google.com

# Report mode (output and exit)
mtr --report google.com

# Show IP addresses only
mtr -n google.com

# Set interval between pings
mtr -i 0.5 google.com
```

---

### Additional Troubleshooting Commands

#### ss (Socket Statistics) - Modern netstat replacement
```bash
# Show all listening ports
ss -tuln

# Show all connections
ss -tun

# Show process information
ss -tunp

# Filter by port
ss -tun sport = :80
```

#### nslookup/dig - DNS troubleshooting
```bash
# DNS lookup
nslookup google.com
dig google.com

# Reverse DNS lookup
nslookup 8.8.8.8
dig -x 8.8.8.8

# Specific DNS server
nslookup google.com 8.8.8.8
dig @8.8.8.8 google.com
```

#### iperf/iperf3 - Network performance testing
```bash
# Server mode
iperf3 -s

# Client mode
iperf3 -c server_ip

# Bandwidth test with specific parameters
iperf3 -c server_ip -t 30 -P 4
```


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




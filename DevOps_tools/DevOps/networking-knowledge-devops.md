# **Networking Troubleshooting Guide for DevOps Engineers**

## **🌐 PHASE 1: NETWORKING FUNDAMENTALS (Must-Know Concepts)**

### **1. OSI/TCP-IP Model & Protocols**
```
Layer 7 - Application: HTTP, HTTPS, DNS, SSH
Layer 4 - Transport: TCP (connection-oriented), UDP (connectionless)
Layer 3 - Network: IP, ICMP, Routing
Layer 2 - Data Link: MAC addresses, ARP
Layer 1 - Physical: Cables, switches
```

**Key Protocols to Understand:**
- **TCP**: 3-way handshake, flow control, congestion control
- **UDP**: When to use (streaming, DNS queries, gaming)
- **ICMP**: Ping, traceroute, network diagnostics
- **DNS**: Resolution process (recursive vs iterative)
- **HTTP/HTTPS**: Status codes, headers, TLS handshake

### **2. IP Addressing & Subnetting**
```bash
# Quick subnetting cheat sheet
/24 = 256 addresses (254 usable)
/25 = 128 addresses (126 usable)
/26 = 64 addresses (62 usable)
/16 = 65,536 addresses

# Private IP Ranges
10.0.0.0/8       # Large networks
172.16.0.0/12    # AWS default VPC range
192.168.0.0/16   # Home/office networks
```

### **3. Network Architecture Components**
- **Switches** (Layer 2) vs **Routers** (Layer 3)
- **Firewalls**: Stateful vs Stateless
- **Load Balancers**: Layer 4 (TCP/UDP) vs Layer 7 (HTTP)
- **NAT Gateway**: Private ↔ Public IP translation
- **VPN/GRE Tunnels**: Site-to-site connectivity

---

## **🔧 PHASE 2: ESSENTIAL NETWORKING TOOLS & COMMANDS**

### **1. Connectivity Testing**
```bash
# 1. Ping (Basic connectivity)
ping google.com
ping -c 4 8.8.8.8           # Send 4 packets
ping -I eth0 8.8.8.8        # Specify interface
ping -M do -s 1500 8.8.8.8  # Test MTU (Don't Fragment)

# 2. Traceroute (Path discovery)
traceroute google.com
tracepath google.com         # No root required
mtr google.com               # Continuous traceroute
```

### **2. DNS Troubleshooting**
```bash
# 1. Basic DNS lookup
nslookup google.com
dig google.com
dig google.com A             # Only A records
dig google.com MX            # Mail records
dig +short google.com        # Short output

# 2. DNS resolution chain
dig +trace google.com        # Follow resolution path
dig @8.8.8.8 google.com      # Use specific DNS server

# 3. Reverse DNS lookup
dig -x 8.8.8.8
nslookup 8.8.8.8

# 4. Check local DNS config
cat /etc/resolv.conf         # DNS servers
cat /etc/hosts               # Local host entries
systemd-resolve --status     # Systemd DNS (Linux)
```

### **3. Port & Service Checking**
```bash
# 1. Check if port is open/listening
nc -zv google.com 443        # Quick port check
telnet google.com 80         # Old school method
nmap -p 443 google.com       # Port scan

# 2. See what's listening locally
netstat -tulpn               # All listening ports
ss -tulpn                    # Modern replacement for netstat
lsof -i :8080                # What process uses port 8080

# 3. Test service connectivity
curl -I https://google.com   # HTTP headers
curl -v https://google.com   # Verbose (see TLS handshake)
wget --spider https://google.com
```

### **4. Network Configuration & Routing**
```bash
# 1. Interface configuration
ip addr show                 # IP addresses
ip link show                 # Network interfaces
ifconfig                    # Legacy (deprecated)

# 2. Routing tables
ip route show                # Routing table
route -n                     # Legacy routing table
ip route get 8.8.8.8        # Route to specific IP

# 3. ARP cache
ip neigh show                # ARP table
arp -a                       # Legacy ARP

# 4. Network statistics
ss -s                        # Socket statistics
netstat -s                   # Protocol statistics
ip -s link show eth0         # Interface statistics
```

### **5. Bandwidth & Performance**
```bash
# 1. Bandwidth testing
iperf3 -c server.ip          # Client mode
iperf3 -s                    # Server mode

# 2. Transfer speed
curl -o /dev/null http://speedtest.file  # Download speed test

# 3. Latency measurement
ping -c 100 google.com | tail -2         # Packet loss & avg

# 4. Continuous monitoring
nload                        # Real-time network load
iftop                        # Bandwidth usage by connection
bmon                         # Interface monitor
```

### **6. Packet Capture & Analysis**
```bash
# 1. Basic capture
tcpdump -i eth0              # Capture on interface
tcpdump port 80              # Capture HTTP traffic
tcpdump host 8.8.8.8         # Traffic to/from host

# 2. Advanced filters
tcpdump -i any port 443 -w capture.pcap  # Save to file
tcpdump -n -i eth0 'tcp and port 22'     # SSH traffic

# 3. Wireshark (GUI)
# Use tcpdump to capture, Wireshark to analyze
tcpdump -i eth0 -w capture.pcap
# Then open capture.pcap in Wireshark
```

---

## **🚨 PHASE 3: COMMON NETWORK ISSUES & SOLUTIONS**

### **Issue 1: "Service is Slow/High Latency"**
```bash
# Diagnosis steps:
1. ping -c 10 target.com          # Check latency/packet loss
2. mtr target.com                  # Find where latency occurs
3. traceroute target.com          # Alternative to mtr
4. iperf3 -c target.com -p 5201   # Bandwidth test
5. ss -t -a                        # Check TCP connections
6. netstat -s | grep -i retrans   # Check retransmissions
```

**Common Causes & Fixes:**
- **High RTT**: Use CDN, closer regions, optimize routes
- **Packet Loss**: Check ISP, network equipment, MTU issues
- **Bandwidth Saturation**: Implement QoS, upgrade links
- **TCP Window Size**: Tune TCP parameters

### **Issue 2: "Can't Connect to Service"**
```bash
# Troubleshooting checklist:
1. ping service_ip                 # Basic connectivity
2. telnet service_ip port         # Port accessibility
3. nc -zv service_ip port         # Alternative port check
4. curl -v http://service:port    # HTTP service test
5. tcpdump -i any port port       # Check if traffic arrives
6. firewall-cmd --list-all        # Check firewalls (Linux)
7. iptables -L -n                 # Check iptables
```

**Common Causes:**
- Firewall blocking
- Service not running
- Wrong port
- Network ACL/Security Groups
- Routing issues
- DNS resolution failure

### **Issue 3: "DNS Resolution Failing"**
```bash
# Diagnosis flow:
dig @8.8.8.8 domain.com          # Bypass local DNS
dig +trace domain.com            # Follow resolution path
nslookup domain.com              # Simple lookup
cat /etc/resolv.conf             # Check DNS servers
systemd-resolve --status         # Systemd DNS
dig localhost                    # Test local resolver
```

**Quick Fixes:**
```bash
# Flush DNS cache
sudo systemd-resolve --flush-caches    # Systemd
sudo dscacheutil -flushcache           # macOS
ipconfig /flushdns                     # Windows

# Test with public DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

### **Issue 4: "Intermittent Connectivity"**
```bash
# Monitoring commands:
ping -i 0.2 target.com > ping.log &   # Continuous ping
mtr --report target.com               # Path quality report
tcpdump -i eth0 -w intermittent.pcap  # Capture during issue

# Check for:
1. Duplicate IP addresses (arpwatch)
2. Network loops (STP issues)
3. Flapping routes
4. Interface errors (ip -s link)
```

---

## **☁️ PHASE 4: CLOUD-SPECIFIC NETWORKING**

### **AWS Networking Issues**
```bash
# Common AWS checks:
1. Security Groups (ingress/egress rules)
2. Network ACLs (stateless filtering)
3. VPC Route Tables
4. Internet Gateway attachment
5. NAT Gateway configuration
6. VPC Peering/Transit Gateway
7. VPC Flow Logs analysis

# AWS CLI commands:
aws ec2 describe-security-groups
aws ec2 describe-network-acls
aws ec2 describe-route-tables
aws logs get-log-events --log-group-name vpc-flow-logs
```

### **Kubernetes Networking Issues**
```bash
# Kubernetes network debugging:
1. Check pod networking:
   kubectl exec pod-name -- ip addr
   kubectl exec pod-name -- ping other-pod-ip

2. Check service:
   kubectl get svc
   kubectl describe svc service-name
   kubectl get endpoints service-name

3. Network policies:
   kubectl get networkpolicies
   kubectl describe networkpolicy policy-name

4. DNS in cluster:
   kubectl run test --image=busybox --rm -it -- nslookup kubernetes.default
```

### **Docker Networking Issues**
```bash
# Docker network commands:
docker network ls                    # List networks
docker network inspect bridge        # Inspect network
docker exec container-name ip addr   # Container IP
docker logs container-name          # Check container logs

# Common issues:
1. Port mapping (-p flag)
2. Network driver (bridge vs host)
3. DNS resolution in containers
4. Inter-container communication
```

---

## **🤖 PHASE 5: AUTOMATION & MONITORING**

### **Automated Network Testing Script**
```bash
#!/bin/bash
# network-health-check.sh

TARGETS=("google.com:443" "github.com:22" "internal.service:8080")
DNS_SERVERS=("8.8.8.8" "1.1.1.1" "192.168.1.1")

echo "=== Network Health Check ==="
echo "Timestamp: $(date)"
echo ""

# Test DNS
echo "DNS Resolution Test:"
for dns in "${DNS_SERVERS[@]}"; do
    echo -n "  $dns: "
    if dig @$dns google.com +short >/dev/null 2>&1; then
        echo "OK"
    else
        echo "FAILED"
    fi
done

# Test connectivity
echo ""
echo "Connectivity Test:"
for target in "${TARGETS[@]}"; do
    host=$(echo $target | cut -d: -f1)
    port=$(echo $target | cut -d: -f2)
    
    echo -n "  $host:$port: "
    if nc -zv -w3 $host $port >/dev/null 2>&1; then
        echo "OK"
    else
        echo "FAILED"
    fi
done

# Latency test
echo ""
echo "Latency Test:"
ping -c 4 8.8.8.8 | tail -2

# Save to log
echo "" >> /var/log/network-health.log
cat $0 | tail -30 >> /var/log/network-health.log
```

### **Network Monitoring Tools**
1. **Prometheus + Grafana**: Metrics collection & visualization
2. **SmokePing**: Latency monitoring with graphs
3. **Zabbix/Nagios**: Comprehensive monitoring
4. **ELK Stack**: Log analysis for network devices
5. **CloudWatch/Stackdriver**: Cloud provider monitoring

### **Infrastructure as Code (Network Automation)**
```terraform
# Terraform example for AWS networking
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "prod-vpc"
  }
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

## **📖 RECOMMENDED LEARNING RESOURCES**

### **Free Online Courses**
1. **Practical Networking** (YouTube channel)
2. **Network Chuck** (YouTube - beginner friendly)
3. **Cisco DevNet** (Free networking courses)
4. **Cloud Provider Docs**: AWS/Azure/GCP networking guides

### **Books**
1. **"Computer Networking: A Top-Down Approach"** (Kurose & Ross)
2. **"TCP/IP Illustrated"** (Richard Stevens)
3. **"Network Warrior"** (Gary Donahue)
4. **"The TCP/IP Guide"** (Charles Kozierok)

### **Hands-On Practice**
1. **GNS3/Cisco Packet Tracer**: Network simulation
2. **TryHackMe/HTB**: Networking challenges
3. **AWS Free Tier**: Build VPCs, test networking
4. **Minikube/Kind**: Practice Kubernetes networking

### **Cheat Sheets to Create**
```markdown
## Network Troubleshooting Cheat Sheet

### Quick Diagnosis Flow:
1. Ping → Basic connectivity
2. Traceroute → Path issues  
3. DNS lookup → Name resolution
4. Port check → Service availability
5. Firewall rules → Access control

### Common Ports:
22 - SSH, 80 - HTTP, 443 - HTTPS
53 - DNS, 3306 - MySQL, 5432 - PostgreSQL
8080 - HTTP Alt, 8443 - HTTPS Alt

### Useful One-Liners:
# Find what's using port 8080
sudo lsof -i :8080

# Continuous ping with timestamp
ping target.com | while read pong; do echo "$(date): $pong"; done

# Test MTU
ping -M do -s 1472 -c 1 google.com
```

---

## **🎯 DAILY PRACTICE ROUTINE**

1. **Morning (5 min)**: Check network stats on your servers
   ```bash
   ss -s
   ip -s link
   netstat -i
   ```

2. **Weekly (15 min)**: Simulate an outage and troubleshoot
   - Block a port with iptables, then diagnose
   - Change DNS, test resolution
   - Simulate high latency with `tc` command

3. **Monthly (1 hour)**: Build a lab network
   - Create VPC with subnets, routes, ACLs
   - Set up VPN between two networks
   - Configure load balancer and test failover

---

## **🚨 PRO TIPS FOR DEVOPS ENGINEERS**

1. **Always start with the simplest check first** (ping before packet capture)
2. **Use the OSI model** to isolate layer-specific issues
3. **Document network topology** for your infrastructure
4. **Implement monitoring before issues occur**
5. **Automate repetitive troubleshooting steps**
6. **Understand cloud provider's shared responsibility model**
7. **Learn to read packet captures** (start with Wireshark displays)

---
**Remember**: Networking troubleshooting is 70% systematic approach + 30% experience.

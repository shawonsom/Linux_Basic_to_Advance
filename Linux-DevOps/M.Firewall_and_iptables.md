# Linux Firewall and iptables Guide

## Table of Contents
1. [Introduction to Firewalls](#introduction-to-firewalls)
2. [iptables Fundamentals](#iptables-fundamentals)
3. [FirewallD - The Dynamic Firewall Manager](#firewalld---the-dynamic-firewall-manager)
4. [Common iptables Commands](#common-iptables-commands)
5. [Firewall Configuration Examples](#firewall-configuration-examples)
6. [FirewallD vs iptables](#firewalld-vs-iptables)
7. [UFW (Uncomplicated Firewall)](#ufw-uncomplicated-firewall)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

## Introduction to Firewalls

A firewall is a network security system that monitors and controls incoming and outgoing network traffic based on predetermined security rules.

### Types of Firewalls
- **Packet-filtering firewalls**: Examine packets and allow or block them based on rules
- **Stateful inspection firewalls**: Monitor the state of active connections
- **Proxy firewalls**: Filter messages at the application layer
- **Next-generation firewalls**: Include additional features like intrusion prevention

## iptables Fundamentals

iptables is a user-space utility program that allows system administrators to configure the IP packet filter rules of the Linux kernel firewall.

### Key Concepts
- **Tables**: Filter, NAT, Mangle, Raw
- **Chains**: INPUT, OUTPUT, FORWARD
- **Targets**: ACCEPT, DROP, REJECT, LOG

### Default Tables
```bash
# View available tables
cat /proc/net/ip_tables_names
```

## FirewallD - The Dynamic Firewall Manager

FirewallD is a complete firewall solution available by default on CentOS, RHEL, and Fedora systems. It provides a dynamically managed firewall with support for network zones.

### Key Concepts
- **Zones**: Predefined sets of rules (public, internal, external, etc.)
- **Services**: Predefined configurations for common applications
- **Runtime vs Permanent**: Runtime changes are temporary, permanent changes survive reboot

### Installation and Setup

```bash
# Install FirewallD (if not already installed)
sudo yum install firewalld    # RHEL/CentOS
sudo dnf install firewalld    # Fedora
sudo apt install firewalld    # Ubuntu/Debian

# Enable and start FirewallD
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Check status
sudo systemctl status firewalld
sudo firewall-cmd --state
```

### Basic FirewallD Commands

```bash
# View active zones
sudo firewall-cmd --get-active-zones

# View default zone
sudo firewall-cmd --get-default-zone

# Change default zone
sudo firewall-cmd --set-default-zone=internal

# List all available zones
sudo firewall-cmd --get-zones

# View complete zone configuration
sudo firewall-cmd --list-all-zones

# View specific zone configuration
sudo firewall-cmd --zone=public --list-all
```

### Managing Services and Ports

```bash
# List all available services
sudo firewall-cmd --get-services

# Add a service to current runtime configuration
sudo firewall-cmd --add-service=http

# Add service permanently (survives reboot)
sudo firewall-cmd --add-service=http --permanent

# Remove a service
sudo firewall-cmd --remove-service=http
sudo firewall-cmd --remove-service=http --permanent

# Add a specific port
sudo firewall-cmd --add-port=8080/tcp
sudo firewall-cmd --add-port=8080/tcp --permanent

# Remove a port
sudo firewall-cmd --remove-port=8080/tcp
sudo firewall-cmd --remove-port=8080/tcp --permanent

# Add a range of ports
sudo firewall-cmd --add-port=5000-5100/tcp
sudo firewall-cmd --add-port=5000-5100/tcp --permanent
```

### Zone Management

```bash
# View zone information for all interfaces
sudo firewall-cmd --get-active-zones

# Assign an interface to a specific zone
sudo firewall-cmd --zone=public --add-interface=eth0

# Change zone of an interface permanently
sudo firewall-cmd --zone=public --change-interface=eth0 --permanent

# Remove an interface from a zone
sudo firewall-cmd --zone=public --remove-interface=eth0
```

### Rich Rules (Advanced Configuration)

```bash
# Allow traffic from specific IP address
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.10" accept'

# Allow traffic from subnet
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" service name="ssh" accept'

# Forward port to internal server
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" forward-port port="8080" protocol="tcp" to-port="80" to-addr="10.0.0.10"'

# Rate limiting
sudo firewall-cmd --zone=public --add-rich-rule='rule service name="ssh" limit value="2/m" accept'

# Log rejected packets
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="203.0.113.0/24" log prefix="DROPPED: " level="info" limit value="1/m" reject'
```

### Masquerading and Port Forwarding

```bash
# Enable masquerading (NAT)
sudo firewall-cmd --zone=external --add-masquerade
sudo firewall-cmd --zone=external --add-masquerade --permanent

# Port forwarding
sudo firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080
sudo firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toaddr=192.168.1.10
sudo firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toaddr=192.168.1.10:toport=8080

# With source address restriction
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" forward-port port="80" protocol="tcp" to-port="8080" to-addr="10.0.0.10"'
```

### ICMP Filtering

```bash
# View available ICMP types
sudo firewall-cmd --get-icmptypes

# Block specific ICMP type
sudo firewall-cmd --zone=public --add-icmp-block=echo-reply

# Block ping requests (echo-request)
sudo firewall-cmd --zone=public --add-icmp-block=echo-request

# Remove ICMP block
sudo firewall-cmd --zone=public --remove-icmp-block=echo-request
```

### Reloading and Runtime vs Permanent Configuration

```bash
# Reload firewall (applies permanent configuration to runtime)
sudo firewall-cmd --reload

# Check differences between runtime and permanent configuration
sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --check-config

# Make runtime changes permanent
sudo firewall-cmd --runtime-to-permanent

# Directly modify permanent configuration
sudo firewall-cmd --permanent [other-options]
sudo firewall-cmd --reload
```

### Creating Custom Services

```bash
# Create a custom service definition
sudo nano /etc/firewalld/services/myapp.xml

# Example service definition
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>My Application</short>
  <description>This is my custom application service</description>
  <port protocol="tcp" port="9000"/>
  <port protocol="udp" port="9001"/>
</service>

# Reload firewall to recognize new service
sudo firewall-cmd --reload

# Use the custom service
sudo firewall-cmd --add-service=myapp
sudo firewall-cmd --add-service=myapp --permanent
```

### Emergency Mode and Lockdown

```bash
# Emergency mode - blocks all traffic
sudo firewall-cmd --panic-on
sudo firewall-cmd --panic-off

# Enable lockdown mode (prevents unwanted configuration changes)
sudo firewall-cmd --lockdown-on
sudo firewall-cmd --lockdown-off

# Check lockdown status
sudo firewall-cmd --query-lockdown
```

## Common iptables Commands

### Viewing Current Rules
```bash
# List all rules
sudo iptables -L -n -v

# List rules with line numbers
sudo iptables -L -n -v --line-numbers

# List rules for specific table
sudo iptables -t nat -L -n -v
```

### Basic Rule Management
```bash
# Flush all rules (clear firewall)
sudo iptables -F

# Delete specific rule
sudo iptables -D INPUT 3  # Delete rule #3 in INPUT chain

# Set default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
```

### Saving and Restoring Rules
```bash
# Save rules (varies by distribution)
sudo iptables-save > /etc/iptables/rules.v4

# Restore rules
sudo iptables-restore < /etc/iptables/rules.v4

# For CentOS/RHEL
sudo service iptables save

# For Ubuntu/Debian
sudo apt-get install iptables-persistent
sudo netfilter-persistent save
```

## Firewall Configuration Examples

### Basic Server Protection
```bash
# Set default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow established connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow loopback interface
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow ping (ICMP)
sudo iptables -A INPUT -p icmp -j ACCEPT
```

### Port Forwarding Example
```bash
# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Forward port 8080 to internal server
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.100:80
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
```

### Rate Limiting
```bash
# Limit SSH connections to 3 per minute
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP
```

## FirewallD vs iptables

### Comparison Table

| Feature | FirewallD | iptables |
|---------|-----------|----------|
| Configuration | Dynamic, zone-based | Static, rule-based |
| Rule Management | Runtime and permanent separation | Direct modification |
| Service Definitions | XML-based service files | Manual port specification |
| IPv6 Support | Integrated (firewall-cmd) | Separate (ip6tables) |
| Learning Curve | Moderate | Steep |
| Default on RHEL/CentOS | Yes | No (replaced by nftables) |

### Migration from iptables to FirewallD

```bash
# Export iptables rules
sudo iptables-save > iptables-backup.txt

# Stop iptables service
sudo systemctl stop iptables
sudo systemctl disable iptables

# Start and enable FirewallD
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Import rules (manual conversion needed)
# Review iptables-backup.txt and create equivalent FirewallD rules
```

## UFW (Uncomplicated Firewall)

UFW provides a user-friendly interface for iptables, commonly used on Ubuntu/Debian systems.

### Basic UFW Commands
```bash
# Enable UFW
sudo ufw enable

# Check status
sudo ufw status verbose

# Allow traffic
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow from 192.168.1.0/24

# Deny traffic
sudo ufw deny http
sudo ufw deny from 203.0.113.100

# Delete rule
sudo ufw delete allow ssh

# Rate limiting
sudo ufw limit ssh
```

### Advanced UFW Configuration
```bash
# Edit before.rules for custom iptables commands
sudo nano /etc/ufw/before.rules

# Add custom rules in before.rules
# Example: Allow NAT
# *nat
# :POSTROUTING ACCEPT [0:0]
# -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
# COMMIT
```

## Best Practices

### Security Recommendations
1. **Default deny policy**: Start with all ports closed, then open only what's needed
2. **Limit SSH access**: Use key-based authentication and consider changing the default port
3. **Regular reviews**: Periodically audit your firewall rules
4. **Logging**: Implement logging for dropped packets
   ```bash
   sudo iptables -A INPUT -j LOG --log-prefix "IPTABLES-DROPPED: " --log-level 4
   ```
5. **IPv6 protection**: Don't forget to configure IPv6 firewall rules (ip6tables)

### Performance Considerations
1. Put commonly matched rules at the top of chains
2. Use connection tracking for stateful rules
3. Consider using ipset for large sets of IP addresses
   ```bash
   # Create ipset
   sudo ipset create blacklist hash:ip
   sudo iptables -I INPUT -m set --match-set blacklist src -j DROP
   ```

## Troubleshooting

### Common Issues and Solutions
```bash
# Check if firewall is blocking ports
sudo iptables -L -n -v

# Check kernel messages
dmesg | grep -i reject

# Test connectivity
telnet example.com 80
nc -zv example.com 80

# Check listening ports
sudo netstat -tulnp
sudo ss -tuln

# Check packet counters
sudo iptables -L -n -v

# Reset firewall if needed
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
```

### Log Analysis
```bash
# View firewall logs
sudo tail -f /var/log/kern.log | grep -i iptables
sudo grep -i "iptables" /var/log/syslog

# Custom log monitoring
sudo tail -f /var/log/messages | grep -i "IPTABLES-DROPPED"

# FirewallD logs
sudo journalctl -u firewalld
sudo journalctl -u firewalld --since "2023-01-01" --until "2023-01-02"
```

## Conclusion

Proper firewall configuration is essential for Linux system security. Whether you choose raw iptables, FirewallD, or UFW, understanding the underlying concepts will help you create effective security policies. Always test your rules in a non-production environment and maintain backups of your working configurations.

### Additional Resources
- [iptables Man Page](https://linux.die.net/man/8/iptables)
- [FirewallD Documentation](https://firewalld.org/documentation/)
- [UFW Community Help Wiki](https://help.ubuntu.com/community/UFW)

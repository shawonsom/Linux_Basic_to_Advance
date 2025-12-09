

# 🚀 Setting up the environment (installing both Ubuntu and Redhat)

## Networking

### Static IP Configuration - Netplan (Ubuntu/Debian)

**Netplan Configuration File Location:**
```bash
/etc/netplan/
# Common files: 01-netcfg.yaml, 50-cloud-init.yaml, 00-installer-config.yaml
```

**Basic Netplan YAML Structure:**
```yaml
network:
  version: 2
  renderer: networkd  # or NetworkManager
  ethernets:
    interface_name:
      dhcp4: no
      dhcp6: no
      addresses: [ip_address/subnet_mask]
      gateway4: gateway_ip
      nameservers:
        addresses: [dns_server1, dns_server2]
        search: [domain_name]
```

**Example 1: Basic Static IPv4 Configuration**
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
        search: [example.com]
```

**Example 2: Multiple IP Addresses**
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
      dhcp4: no
      addresses:
        - 192.168.1.100/24
        - 192.168.1.101/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 8.8.8.8]
```

**Example 3: With NetworkManager Renderer**
```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: no
      addresses: [10.0.0.50/24]
      gateway4: 10.0.0.1
      nameservers:
        addresses: [10.0.0.1, 1.1.1.1]
```

**Applying Netplan Configuration:**
```bash
# Test configuration
sudo netplan try

# Apply configuration
sudo netplan apply

# Generate configuration
sudo netplan generate

# Debug issues
sudo netplan --debug apply
```

#### Static IP Configuration - NetworkManager (RedHat/CentOS)

**Using nmcli (Command Line):**
```bash
# Disable DHCP
sudo nmcli con mod "eth0" ipv4.method manual

# Set static IP
sudo nmcli con mod "eth0" ipv4.addresses "192.168.1.100/24"

# Set gateway
sudo nmcli con mod "eth0" ipv4.gateway "192.168.1.1"

# Set DNS
sudo nmcli con mod "eth0" ipv4.dns "8.8.8.8,8.8.4.4"

# Bring connection up
sudo nmcli con up "eth0"
```

**Using nmtui (Text UI):**
```bash
sudo nmtui
```

**Configuration Files (RedHat):**
```bash
# Network configuration files
/etc/sysconfig/network-scripts/ifcfg-eth0

# Example ifcfg-eth0 file
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
```

**Restart Networking (RedHat):**
```bash
# Traditional method
sudo systemctl restart network

# NetworkManager method
sudo systemctl restart NetworkManager
```

### Verification Commands

**Check IP Configuration:**
```bash
ip addr show
ip link show
ip route show
```

**Test Connectivity:**
```bash
ping -c 4 google.com
ping -c 4 192.168.1.1
```

**Check DNS Resolution:**
```bash
nslookup google.com
dig google.com
```

**Network Interface Information:**
```bash
# Ubuntu/Debian
netplan ip leases eth0

# RedHat/CentOS
nmcli device show eth0
```

**Debug Commands:**
```bash
# Check network manager status
systemctl status NetworkManager
systemctl status systemd-networkd

# View logs
journalctl -u NetworkManager
journalctl -u systemd-networkd

# Check configuration
netplan --debug generate
```

This comprehensive guide covers setting up both Ubuntu and RedHat environments with static IP configurations using their respective networking utilities.

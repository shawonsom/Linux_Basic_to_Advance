# What is a Proxy Server?
A proxy server is an intermediary server that sits between your device and the internet. It acts as a gateway between your device and the internet, filtering requests and responses to improve performance, security, and privacy. When you request a web page or resource, the proxy server intercepts the request and retrieves the data on your behalf. It then sends the data back to your device, without revealing your IP address to the website you are accessing.

# Why use a Proxy Server?
There are many reasons why you might want to use a proxy server. Here are some of the most common reasons:

=> Improved speed: A proxy server can cache frequently accessed web pages and resources, reducing the time it takes to access them in the future.
=> Increased security: A proxy server can act as a barrier between your device and the internet, protecting you from malicious attacks and filtering out unwanted content.
=> Enhanced privacy: A proxy server can hide your IP address, making it difficult for websites to track your online activity.
### Step 1: Install Squid Proxy

The first step is to install Squid Proxy on your Ubuntu machine. Open up a terminal window and type the following command:
```bash
sudo apt-get install squid

```
### Step 2: Configure Squid
we need to configure Squid Proxy to work with your network. keep the basic config as back up:
```bash
mv /etc/squid/squid.conf /etc/squid/squid.conf.backup
```
paste below code in new config file
```bash
sudo nano /etc/squid/squid.conf
```
#### Config file sample 1
```bash
### Configure Hostname
visible_hostname grafana
#
### Allow all
acl mynet src all
### Allow only your network to use the Squid Proxy
#acl mynet src 192.168.0.0/24
#
### blockspecific site
acl blocksite dstdomain "/etc/squid/blocked_sites.txt"
http_access deny blocksite

#
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
#
###
#
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
#
### Allow Local Network
http_access allow mynet
http_access allow localhost manager
http_access deny manager
include /etc/squid/conf.d/*.conf
http_access allow localhost
http_access deny all
#
### Default port 3128, you can change if you want.
http_port 3128
#
### Cache MEM =1/3 Physical RAM
cache_mem 512 MB
#
### Cache DIR
### Syntax : cache_dir ufs PATH L0 L1 L2
### L0 = 'Mbytes' is the amount of disk space (MB) to use under this directory.  
### The default is 100 MB.  Change this to suit your configuration.
### L1 is the number of first-level subdirectories which will be created under the 'Directory'. 
### The default is 16.
### 'L2' is the number of second-level subdirectories which will be created under each first-level directory.
### The default is 256.
cache_dir ufs /var/spool/squid 2048 16 256
#
### coredump_dir
### By default Squid leaves core files in the directory from where it was started. 
### If you set 'coredump_dir' to a directory that exists, Squid will chdir() to that directory at startup and coredump files will be left there.
coredump_dir /var/spool/squid
#
### Default
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern \/(Packages|Sources)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern \/Release(|\.gpg)$ 0 0% 0 refresh-ims
refresh_pattern \/InRelease$ 0 0% 0 refresh-ims
refresh_pattern \/(Translation-.*)(|\.bz2|\.gz|\.xz)$ 0 0% 0 refresh-ims
refresh_pattern .		0	20%	4320

```

#### Config file sample 
```bash
# ---------------------------------------------------------
# AUTHENTICATION
# ---------------------------------------------------------
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic children 5
auth_param basic realm Squid Proxy Server
auth_param basic credentialsttl 2 hours
acl authenticated_users proxy_auth REQUIRED

# ---------------------------------------------------------
# ACL DEFINITIONS
# ---------------------------------------------------------
acl SSL_ports port 443
acl Safe_ports port 80 443 137 138 139 445
acl CONNECT method CONNECT

# IP-based ACLs
acl vip_user src 192.168.1.50
acl local_net src 192.168.1.0/24

# Website blocking ACL
acl blocked_sites dstdomain .facebook.com .youtube.com .instagram.com
### Or
#acl blocksite dstdomain "/etc/squid/blocked_sites.txt"
#http_access deny blocksite

# ---------------------------------------------------------
# HTTP ACCESS RULES (Order is Critical)
# ---------------------------------------------------------

# 1. Deny ports that aren't safe
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports

# 2. VIP bypass: Allow this IP to see blocked sites WITHOUT auth (or move below auth)
http_access allow vip_user blocked_sites

# 3. Force authentication for everyone else
http_access deny !authenticated_users

# 4. Deny blocked sites for authenticated users (except VIP)
http_access deny blocked_sites

# 5. Allow all other traffic for authenticated users
http_access allow authenticated_users
http_access allow local_net

# Final catch-all
http_access deny all

# ---------------------------------------------------------
# BANDWIDTH LIMITS (Delay Pools)
# ---------------------------------------------------------
delay_pools 1
delay_class 1 1
# Limit to 512 KB/s (524288 bytes/s)
delay_parameters 1 524288/524288
delay_access 1 allow authenticated_users

# ---------------------------------------------------------
# GENERAL SETTINGS
# ---------------------------------------------------------
http_port 3128
coredump_dir /var/spool/squid
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
```

Step 3: Start Squid
Now that Squid Proxy is installed and configured, we can start the service by typing the following command:
```bash
sudo systemctl start squid
sudo systemctl enable squid

```
This will start the Squid Proxy service.

# Configure Proxy Authentication
Create a Password File
First, you need to create a password file that will store the usernames and passwords of the users who are allowed to access the proxy server. You can create the password file by typing the following command:
```bash
sudo htpasswd -c /etc/squid/passwd username
```

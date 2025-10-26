# Server, Web & Database Monitoring with Prometheus and Grafana

A comprehensive guide to implementing full-stack monitoring using Prometheus and Grafana.

## 📊 Monitoring Architecture

```
+-------------+    +-----------+    +-------------+    +---------+
|  Targets    | -> | Prometheus| -> |  Grafana    | -> | Alerts  |
| (Servers,   |    | (Collect &|    | (Visualize &|    |(Notification|
| Apps, DBs)  |    |  Store)   |    |  Dashboard) |    | Channels)|
+-------------+    +-----------+    +-------------+    +---------+
```

## 🚀 Prometheus Setup & Configuration

### Installation on CentOS/RHEL

```bash
# Create prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Download and install Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.47.0/prometheus-2.47.0.linux-amd64.tar.gz
tar xvf prometheus-2.47.0.linux-amd64.tar.gz
cd prometheus-2.47.0.linux-amd64

# Copy binaries
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool

# Copy configuration
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus
```

### Prometheus Configuration File

```yaml
# /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "alert_rules.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:

scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter - Server Metrics
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100', 'server2:9100', 'server3:9100']
    scrape_interval: 30s

  # MySQL Exporter
  - job_name: 'mysql_exporter'
    static_configs:
      - targets: ['localhost:9104']
    params:
      collect[]:
        - global_status
        - innodb_metrics
        - slave_status
        - info_schema.processlist

  # Nginx Exporter
  - job_name: 'nginx_exporter'
    static_configs:
      - targets: ['localhost:9113']
    scrape_interval: 30s

  # Apache Exporter
  - job_name: 'apache_exporter'
    static_configs:
      - targets: ['localhost:9117']

  # Blackbox Exporter - Web Probes
  - job_name: 'blackbox_http'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - https://example.com
        - https://api.example.com
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115
```

### Systemd Service for Prometheus

```ini
# /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Time Series Collection and Processing Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.external-url=

Restart=always

[Install]
WantedBy=multi-user.target
```

## 🖥️ Server Monitoring with Node Exporter

### Installation & Setup

```bash
# Download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo cp node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create user
sudo useradd --no-create-home --shell /bin/false node_exporter

# Systemd service
sudo cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter \
    --collector.systemd \
    --collector.processes \
    --collector.filesystem.mount-points-exclude="^/(sys|proc|dev|run)($|/)"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

### Key Server Metrics to Monitor

```promql
# CPU Usage
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory Usage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk Usage
100 - (node_filesystem_avail_bytes{mountpoint="/",fstype!="tmpfs"} / node_filesystem_size_bytes{mountpoint="/",fstype!="tmpfs"} * 100)

# Disk I/O
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])

# Network I/O
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])

# Load Average
node_load1
node_load5
node_load15

# Running Processes
node_procs_running
```

## 🌐 Web Server Monitoring

### Nginx Monitoring Setup

```bash
# Enable Nginx status module
# Add to /etc/nginx/nginx.conf or site config
server {
    listen 8080;
    server_name localhost;
    
    location /nginx-status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}

# Install nginx_exporter
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.11.0/nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
tar xvf nginx-prometheus-exporter_0.11.0_linux_amd64.tar.gz
sudo cp nginx-prometheus-exporter /usr/local/bin/

# Systemd service for nginx_exporter
sudo cat > /etc/systemd/system/nginx_exporter.service << EOF
[Unit]
Description=NGINX Prometheus Exporter
After=nginx.service

[Service]
Type=simple
User=nginx_exporter
ExecStart=/usr/local/bin/nginx-prometheus-exporter -nginx.scrape-uri http://localhost:8080/nginx-status
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

### Key Web Metrics

```promql
# HTTP Requests per Second
rate(nginx_http_requests_total[5m])

# Active Connections
nginx_connections_active

# Server Errors (5xx)
rate(nginx_http_responses_total{code="5xx"}[5m])

# Request Duration
histogram_quantile(0.95, rate(nginx_http_request_duration_seconds_bucket[5m]))
```

### Blackbox Exporter for Website Uptime

```yaml
# blackbox.yml
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_status_codes: [200]
      method: GET
      headers:
        User-Agent: "Blackbox Exporter"
      
  http_post_2xx:
    prober: http
    timeout: 5s
    http:
      method: POST
      headers:
        Content-Type: application/json
        User-Agent: "Blackbox Exporter"
      body: '{"test": "data"}'

  tcp_connect:
    prober: tcp
    timeout: 5s

  icmp:
    prober: icmp
    timeout: 5s
```

## 🗄️ Database Monitoring (MySQL)

### MySQL Exporter Setup

```bash
# Create MySQL user for monitoring
mysql -u root -p
CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'StrongPassword123!' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
FLUSH PRIVILEGES;

# Download and install mysqld_exporter
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.0/mysqld_exporter-0.15.0.linux-amd64.tar.gz
tar xvf mysqld_exporter-0.15.0.linux-amd64.tar.gz
sudo cp mysqld_exporter-0.15.0.linux-amd64/mysqld_exporter /usr/local/bin/
sudo chown mysql:mysql /usr/local/bin/mysqld_exporter

# Create config file
sudo cat > /etc/.my.cnf << EOF
[client]
user=exporter
password=StrongPassword123!
host=localhost
port=3306
EOF

sudo chown mysql:mysql /etc/.my.cnf
sudo chmod 600 /etc/.my.cnf

# Systemd service
sudo cat > /etc/systemd/system/mysqld_exporter.service << EOF
[Unit]
Description=MySQL Prometheus Exporter
After=mysql.service

[Service]
User=mysql
Group=mysql
Type=simple
ExecStart=/usr/local/bin/mysqld_exporter \
  --config.my-cnf=/etc/.my.cnf \
  --collect.global_status \
  --collect.info_schema.innodb_metrics \
  --collect.auto_increment.columns \
  --collect.info_schema.processlist \
  --collect.binlog_size \
  --collect.info_schema.tablestats \
  --collect.global_variables \
  --collect.info_schema.query_response_time \
  --collect.info_schema.userstats \
  --collect.info_schema.tables \
  --collect.perf_schema.tablelocks \
  --collect.perf_schema.file_events \
  --collect.perf_schema.eventswaits \
  --collect.perf_schema.indexiowaits \
  --collect.perf_schema.tableiowaits \
  --collect.slave_status \
  --web.listen-address=0.0.0.0:9104

Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

### Key Database Metrics

```promql
# MySQL Connection Usage
mysql_global_status_threads_connected / mysql_global_variables_max_connections * 100

# Query Performance
rate(mysql_global_status_questions[5m])
rate(mysql_global_status_slow_queries[5m])

# InnoDB Buffer Pool Hit Rate
(1 - mysql_innodb_buffer_pool_reads / mysql_innodb_buffer_pool_read_requests) * 100

# Active Transactions
mysql_global_status_innodb_row_lock_current_waits

# Replication Lag
mysql_slave_status_seconds_behind_master

# Table Locks
rate(mysql_global_status_table_locks_waited[5m])
```

## 📈 Grafana Setup & Dashboards

### Installation on CentOS

```bash
# Install Grafana
sudo cat > /etc/yum.repos.d/grafana.repo << EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

sudo yum install grafana -y
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

### Example Dashboard JSON Configurations

#### 1. Server Monitoring Dashboard

```json
{
  "dashboard": {
    "title": "Linux Server Metrics",
    "tags": ["prometheus", "node_exporter"],
    "timezone": "browser",
    "panels": [
      {
        "title": "CPU Usage",
        "type": "stat",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{instance}}"
          }
        ],
        "format": "percent",
        "thresholds": [
          {"color": "green", "value": 0},
          {"color": "yellow", "value": 80},
          {"color": "red", "value": 90}
        ]
      },
      {
        "title": "Memory Usage",
        "type": "gauge",
        "targets": [
          {
            "expr": "(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100",
            "legendFormat": "{{instance}}"
          }
        ],
        "format": "percent"
      }
    ],
    "time": {"from": "now-6h", "to": "now"}
  }
}
```

#### 2. Database Monitoring Dashboard

```json
{
  "dashboard": {
    "title": "MySQL Database Metrics",
    "panels": [
      {
        "title": "Database Connections",
        "type": "stat",
        "targets": [
          {
            "expr": "mysql_global_status_threads_connected",
            "legendFormat": "Connected"
          },
          {
            "expr": "mysql_global_variables_max_connections",
            "legendFormat": "Max"
          }
        ]
      },
      {
        "title": "Query Performance",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(mysql_global_status_questions[5m])",
            "legendFormat": "Queries/sec"
          },
          {
            "expr": "rate(mysql_global_status_slow_queries[5m])",
            "legendFormat": "Slow Queries/sec"
          }
        ]
      }
    ]
  }
}
```

## 🔔 Alerting Rules

### Prometheus Alert Rules

```yaml
# /etc/prometheus/alert_rules.yml
groups:
- name: server_alerts
  rules:
  - alert: HighCPUUsage
    expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High CPU usage on {{ $labels.instance }}"
      description: "CPU usage is above 80% for more than 5 minutes"

  - alert: HighMemoryUsage
    expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 90
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High memory usage on {{ $labels.instance }}"
      description: "Memory usage is above 90% for more than 5 minutes"

  - alert: DiskSpaceCritical
    expr: (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100 > 95
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "Disk space critical on {{ $labels.instance }}"
      description: "Disk usage is above 95% on {{ $labels.mountpoint }}"

- name: database_alerts
  rules:
  - alert: MySQLDown
    expr: mysql_up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "MySQL is down on {{ $labels.instance }}"

  - alert: HighMySQLConnections
    expr: mysql_global_status_threads_connected / mysql_global_variables_max_connections > 0.8
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High MySQL connections on {{ $labels.instance }}"
      description: "MySQL connections are above 80% of maximum"

- name: web_alerts
  rules:
  - alert: WebsiteDown
    expr: probe_success{job="blackbox_http"} == 0
    for: 2m
    labels:
      severity: critical
    annotations:
      summary: "Website {{ $labels.instance }} is down"
      description: "HTTP probe failed for 2 minutes"
```

## 🚀 Docker Compose Setup (Alternative)

```yaml
# docker-compose.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    volumes:
      - grafana_data:/var/lib/grafana
      - ./dashboards:/etc/grafana/provisioning/dashboards

  node_exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'

volumes:
  prometheus_data:
  grafana_data:
```

## 📊 Useful Queries for Troubleshooting

```promql
# Top 5 processes by CPU
topk(5, rate(node_cpu_seconds_total[5m]))

# Disk I/O by device
rate(node_disk_read_bytes_total[5m])
rate(node_disk_written_bytes_total[5m])

# Network errors
rate(node_network_receive_errs_total[5m])
rate(node_network_transmit_errs_total[5m])

# MySQL deadlocks
rate(mysql_global_status_innodb_row_lock_waits[5m])

# HTTP error rates
rate(nginx_http_responses_total{code=~"5.."}[5m])
```

## 🎯 GitHub Repository Structure

```
monitoring-stack/
├── prometheus/
│   ├── prometheus.yml
│   ├── alert_rules.yml
│   └── docker-compose.yml
├── grafana/
│   ├── dashboards/
│   │   ├── server-metrics.json
│   │   ├── database-metrics.json
│   │   └── web-metrics.json
│   └── provisioning/
├── exporters/
│   ├── node_exporter/
│   ├── mysql_exporter/
│   └── nginx_exporter/
├── alerts/
│   └── alertmanager.yml
└── README.md
```

This monitoring stack provides comprehensive visibility into your infrastructure, from server-level metrics to application and database performance, all visualized through beautiful Grafana dashboards with proactive alerting capabilities.
```

This comprehensive guide includes:

- **Complete setup instructions** for Prometheus and Grafana
- **Server monitoring** with Node Exporter
- **Web monitoring** with Nginx and Blackbox exporters
- **Database monitoring** with MySQL exporter
- **Ready-to-use configuration files**
- **Alerting rules** for proactive monitoring
- **Dashboard JSON examples**
- **Docker Compose setup** for easy deployment
- **GitHub repository structure**

All examples are production-ready and can be easily adapted for your specific environment.

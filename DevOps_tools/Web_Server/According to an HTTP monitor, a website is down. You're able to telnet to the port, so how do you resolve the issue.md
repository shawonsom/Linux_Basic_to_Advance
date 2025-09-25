# DevOps: Advanced to Basic Web Server Guide

This guide covers setting up a web server from basic to advanced configurations, including deployment automation and monitoring.

## Table of Contents
- [Basic Web Server Setup](#basic-web-server-setup)
- [Intermediate Configuration](#intermediate-configuration)
- [Advanced DevOps Integration](#advanced-devops-integration)
- [Infrastructure as Code](#infrastructure-as-code)
- [Monitoring and Logging](#monitoring-and-logging)
- [CI/CD Pipeline](#cicd-pipeline)

## Basic Web Server Setup

### 1. Simple Apache/Nginx Server

**Apache on Ubuntu:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Start and enable Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Configure firewall
sudo ufw allow 'Apache Full'
```

**Nginx on Ubuntu:**
```bash
# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure firewall
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
```

### 2. Basic HTML Deployment
```html
<!-- /var/www/html/index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Basic Web Server</title>
</head>
<body>
    <h1>Welcome to Our Web Server!</h1>
    <p>This is a basic web server setup.</p>
</body>
</html>
```

## Intermediate Configuration

### 1. Virtual Hosts Setup

**Apache Virtual Host:**
```apache
<!-- /etc/apache2/sites-available/example.com.conf -->
<VirtualHost *:80>
    ServerName example.com
    ServerAdmin webmaster@example.com
    DocumentRoot /var/www/example.com/public_html
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

**Nginx Server Block:**
```nginx
# /etc/nginx/sites-available/example.com
server {
    listen 80;
    server_name example.com;
    
    root /var/www/example.com/html;
    index index.html index.htm;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
```

### 2. SSL Certificate Setup

**Using Let's Encrypt:**
```bash
# Install Certbot
sudo apt install certbot python3-certbot-apache -y

# Obtain SSL certificate
sudo certbot --apache -d example.com -d www.example.com

# Auto-renewal setup
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

## Advanced DevOps Integration

### 1. Docker Configuration

**Dockerfile:**
```dockerfile
FROM nginx:alpine

# Copy custom configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy website content
COPY html /usr/share/nginx/html

# Expose port
EXPOSE 80 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./logs:/var/log/nginx
    restart: unless-stopped
    networks:
      - webnet

  reverse-proxy:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./proxy.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - web
    networks:
      - webnet

networks:
  webnet:
    driver: bridge
```

### 2. Kubernetes Deployment

**web-deployment.yaml:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-server
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        - name: nginx-config
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: web-content
        configMap:
          name: web-content
      - name: nginx-config
        configMap:
          name: nginx-config
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```

## Infrastructure as Code

### 1. Terraform Configuration

**main.tf:**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1d0"
  instance_type = "t2.micro"
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hello from Terraform</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

### 2. Ansible Playbook

**webserver-setup.yml:**
```yaml
---
- name: Configure Web Server
  hosts: webservers
  become: yes
  vars:
    http_port: 80
    https_port: 443
    doc_root: /var/www/html

  tasks:
    - name: Update apt package cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install Apache
      apt:
        name: apache2
        state: present

    - name: Start and enable Apache
      systemd:
        name: apache2
        state: started
        enabled: yes

    - name: Configure firewall
      ufw:
        rule: allow
        port: "{{ http_port }}"
        proto: tcp

    - name: Create document root
      file:
        path: "{{ doc_root }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Deploy index.html
      template:
        src: templates/index.html.j2
        dest: "{{ doc_root }}/index.html"
        owner: www-data
        group: www-data
        mode: '0644'
      notify: restart apache

  handlers:
    - name: restart apache
      systemd:
        name: apache2
        state: restarted
```

## Monitoring and Logging

### 1. Prometheus Configuration

**prometheus.yml:**
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'web_server'
    static_configs:
      - targets: ['localhost:9113']
    metrics_path: /probe
    params:
      module: [http_2xx]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox-exporter:9115
```

### 2. Grafana Dashboard

**dashboard.json:**
```json
{
  "dashboard": {
    "title": "Web Server Monitoring",
    "panels": [
      {
        "title": "HTTP Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "probe_http_duration_seconds{instance=\"example.com\"}",
            "legendFormat": "Response Time"
          }
        ]
      }
    ]
  }
}
```

## CI/CD Pipeline

### 1. GitHub Actions Workflow

**.github/workflows/deploy.yml:**
```yaml
name: Deploy Web Server

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Run tests
      run: |
        echo "Running tests..."
        # Add your test commands here

  deploy:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to production
      run: |
        echo "Deploying to production..."
        # Add deployment commands here
```

### 2. Jenkins Pipeline

**Jenkinsfile:**
```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'docker build -t web-server:${BUILD_NUMBER} .'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'docker run web-server:${BUILD_NUMBER} npm test'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                sh 'kubectl set image deployment/web-server web-server=web-server:${BUILD_NUMBER}'
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -f'
        }
    }
}
```

## Quick Start Script

**setup-webserver.sh:**
```bash
#!/bin/bash

# Basic Web Server Setup Script
set -e

echo "Starting web server setup..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install web server (Apache)
sudo apt install apache2 -y

# Configure firewall
sudo ufw allow 'Apache'

# Create basic webpage
sudo cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Success! Your web server is running.</h1>
    <p>Deployed automatically via script.</p>
</body>
</html>
EOF

# Start services
sudo systemctl start apache2
sudo systemctl enable apache2

echo "Web server setup completed!"
echo "Visit: http://$(curl -s ifconfig.me)"
```

## Best Practices Checklist

- [ ] Use version control for all configurations
- [ ] Implement proper security headers
- [ ] Set up automated backups
- [ ] Configure monitoring and alerts
- [ ] Use HTTPS with proper certificate management
- [ ] Implement access logging
- [ ] Set up automated deployments
- [ ] Configure load balancing for high availability
- [ ] Implement disaster recovery procedures
- [ ] Regular security updates and patches

This guide provides a comprehensive approach to web server management from basic setup to advanced DevOps practices.

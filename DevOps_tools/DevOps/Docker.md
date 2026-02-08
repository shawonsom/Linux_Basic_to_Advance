# Docker Guide: Basic to Advanced Commands

## 📋 Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Image Management](#image-management)
- [Container Operations](#container-operations)
- [Docker Compose](#docker-compose)
- [Networking](#networking)
- [Volumes & Storage](#volumes--storage)
- [Dockerfile Guide](#dockerfile-guide)
- [Advanced Topics](#advanced-topics)
- [Best Practices](#best-practices)

## Introduction

Docker is a platform for developing, shipping, and running applications in containers. Containers allow you to package an application with all its dependencies into a standardized unit.

## Installation

### Windows (Docker Desktop)
1. Download Docker Desktop from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
2. Enable WSL 2 (Recommended) or Hyper-V
3. Install and restart
4. Verify installation: `docker --version`

### Linux (Local Install)
```bash
# Update packages
sudo apt-get update

# Install prerequisites
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group (avoid using sudo)
sudo usermod -aG docker $USER
# Log out and log back in for changes to take effect
```

## Basic Commands

### Version Information
```bash
docker --version
docker version
docker info
```

### Help Commands
```bash
docker --help
docker <command> --help
docker run --help
```

## Image Management

### Pull Images
```bash
docker pull ubuntu:20.04
docker pull nginx:latest
docker pull python:3.9-slim
```

### List Images
```bash
docker images
docker image ls
docker images -a
docker images --filter "dangling=true"
```

### Remove Images
```bash
docker rmi <image_id>
docker rmi ubuntu:20.04
docker image prune -a  # Remove all unused images
```

### Image Information
```bash
docker image inspect <image_id>
docker history <image_id>
```

### Save/Load Images
```bash
# Save image to tar file
docker save -o myimage.tar myimage:tag

# Load image from tar file
docker load -i myimage.tar
```

## Container Operations

### Run Containers
```bash
# Run container interactively
docker run -it ubuntu:20.04 /bin/bash

# Run in detached mode
docker run -d -p 80:80 nginx

# Run with name
docker run --name mycontainer -d nginx

# Run with environment variables
docker run -e MY_VAR=value -d myimage

# Run with volume mounting
docker run -v /host/path:/container/path -d myimage

# Run with memory limits
docker run -m 512m --memory-swap 1g -d myimage
```

### List Containers
```bash
docker ps           # Running containers
docker ps -a        # All containers
docker ps -q        # Only container IDs
docker ps --filter "status=exited"
```

### Start/Stop Containers
```bash
docker start <container_id>
docker stop <container_id>
docker restart <container_id>
docker pause <container_id>
docker unpause <container_id>
```

### Remove Containers
```bash
docker rm <container_id>
docker rm -f <container_id>      # Force remove running container
docker container prune           # Remove all stopped containers
```

### Container Information
```bash
docker logs <container_id>
docker logs -f <container_id>    # Follow logs
docker logs --tail 100 <container_id>

docker inspect <container_id>
docker stats <container_id>
docker top <container_id>
```

### Execute Commands in Running Containers
```bash
docker exec -it <container_id> /bin/bash
docker exec <container_id> ls -la
```

### Copy Files
```bash
# Copy from host to container
docker cp file.txt <container_id>:/path/

# Copy from container to host
docker cp <container_id>:/path/file.txt ./
```

## Docker Compose

### Basic Commands
```bash
docker-compose up
docker-compose up -d
docker-compose down
docker-compose ps
docker-compose logs
docker-compose logs -f
docker-compose exec service_name bash
```

### Sample docker-compose.yml
```yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - mynetwork

  db:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: example
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - mynetwork

volumes:
  db_data:

networks:
  mynetwork:
    driver: bridge
```

## Networking

### Network Commands
```bash
docker network ls
docker network create mynetwork
docker network inspect mynetwork
docker network connect mynetwork <container_id>
docker network disconnect mynetwork <container_id>
docker network rm mynetwork
```

### Network Types
```bash
# Bridge network (default)
docker run --network bridge -d nginx

# Host network (Linux only)
docker run --network host -d nginx

# None network (no networking)
docker run --network none -d nginx

# Custom network
docker network create --driver bridge my-custom-network
```

## Volumes & Storage

### Volume Management
```bash
docker volume ls
docker volume create myvolume
docker volume inspect myvolume
docker volume rm myvolume
docker volume prune
```

### Bind Mounts vs Volumes
```bash
# Bind Mount
docker run -v /host/path:/container/path nginx

# Volume Mount
docker run -v myvolume:/container/path nginx

# Named Volume
docker run -v dbdata:/var/lib/mysql mysql
```

## Dockerfile Guide

### Basic Dockerfile Structure
```dockerfile
# Base image
FROM ubuntu:20.04

# Metadata
LABEL maintainer="your.email@example.com"
LABEL version="1.0"

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Set working directory
WORKDIR /app

# Copy files
COPY package*.json ./
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && npm install

# Expose port
EXPOSE 3000

# Command to run
CMD ["npm", "start"]
```

### Build Image from Dockerfile
```bash
docker build -t myapp:latest .
docker build -t myapp:v1.0 -f Dockerfile.prod .
docker build --no-cache -t myapp:latest .  # Build without cache
```

### Multi-stage Build Example
```dockerfile
# Build stage
FROM node:14 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## Advanced Topics

### Docker Swarm (Orchestration)
```bash
# Initialize swarm
docker swarm init

# Join swarm
docker swarm join --token <token> <manager_ip>:2377

# Deploy stack
docker stack deploy -c docker-compose.yml myapp

# List services
docker service ls

# Scale service
docker service scale myapp_web=3
```

### Health Checks
```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

### Resource Management
```bash
# CPU limits
docker run --cpus="1.5" -d myapp

# Memory limits
docker run -m 512m --memory-reservation 256m -d myapp

# Restart policies
docker run --restart always -d myapp
docker run --restart on-failure:5 -d myapp
```

### Logging Configuration
```bash
# Configure logging driver
docker run --log-driver json-file --log-opt max-size=10m -d nginx
docker run --log-driver syslog -d nginx
```

### Security Best Practices
```bash
# Run as non-root user
docker run -u 1000:1000 -d myapp

# Read-only filesystem
docker run --read-only -d myapp

# Security options
docker run --security-opt no-new-privileges -d myapp
```

## Best Practices

### 1. Use Official Images
- Prefer official images from Docker Hub
- Use specific version tags instead of `latest`

### 2. Keep Images Small
- Use multi-stage builds
- Clean up package manager cache
- Use `.dockerignore` file

### 3. One Process per Container
- Each container should have a single responsibility
- Use process supervisors only when necessary

### 4. Environment Configuration
- Use environment variables for configuration
- Don't store secrets in images
- Use Docker secrets or external secret management

### 5. Persistent Data
- Use volumes for persistent data
- Don't store data in container's writable layer
- Backup volumes regularly

### 6. Monitoring and Logging
- Use centralized logging
- Monitor container resource usage
- Set up health checks

### 7. Security
- Scan images for vulnerabilities
- Keep images updated
- Use minimal base images

## Troubleshooting

### Common Issues

**Permission denied on Linux:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Then log out and log back in
```

**Docker Desktop WSL 2 issues:**
```bash
# Reset Docker Desktop
# In Docker Desktop: Troubleshoot → Reset to factory defaults

# Check WSL 2 installation
wsl --list --verbose
```

**Clean up disk space:**
```bash
docker system prune -a
docker volume prune
docker image prune
```

### Debugging Commands
```bash
# Check Docker daemon logs
sudo journalctl -u docker.service

# Check container logs
docker logs <container_id>

# Inspect container
docker inspect <container_id>

# Check container processes
docker top <container_id>

# Check resource usage
docker stats
```

## Useful Aliases for Shell

Add to your `~/.bashrc` or `~/.zshrc`:
```bash
alias dk='docker'
alias dkc='docker-compose'
alias dkps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dkimg='docker images'
alias dklog='docker logs -f'
alias dkprune='docker system prune -a'
alias dkstop='docker stop $(docker ps -q)'
alias dkrm='docker rm $(docker ps -aq)'
```

## Cheat Sheet

| Command | Description |
|---------|-------------|
| `docker build -t name .` | Build image from Dockerfile |
| `docker run -d -p 80:80 image` | Run container in background |
| `docker exec -it container bash` | Enter running container |
| `docker-compose up -d` | Start compose services |
| `docker system prune` | Clean up unused data |
| `docker logs -f container` | Follow container logs |
| `docker stats` | Show container resource usage |
| `docker network create net` | Create custom network |
| `docker volume create vol` | Create named volume |

---

## 📚 Additional Resources

- [Official Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Compose File Reference](https://docs.docker.com/compose/compose-file/)

## 🚀 Quick Start Example

```bash
# 1. Create a simple web app
mkdir docker-demo && cd docker-demo
echo "Hello Docker!" > index.html

# 2. Create Dockerfile
cat > Dockerfile << EOF
FROM nginx:alpine
COPY index.html /usr/share/nginx/html
EXPOSE 80
EOF

# 3. Build and run
docker build -t my-website .
docker run -d -p 8080:80 --name website my-website

# 4. Visit http://localhost:8080
```

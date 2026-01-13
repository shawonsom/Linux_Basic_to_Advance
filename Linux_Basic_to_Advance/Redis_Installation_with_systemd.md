# Redis Installation with systemd Service on Linux

### 1. Download and Extract Redis
```bash
wget http://download.redis.io/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable
```

### 2. Compile and Install
```bash
make
sudo make install
```

### 3. Configure Redis
```bash
sudo mkdir /etc/redis
sudo mkdir /var/redis
sudo cp utils/redis_init_script /etc/init.d/redis_6379
sudo cp redis.conf /etc/redis/6379.conf
```

### 4. Create Redis Working Directory
```bash
sudo mkdir /var/redis/6379
```

### 5. Update Redis Configuration
Edit `/etc/redis/6379.conf` and make the following changes:
```
daemonize yes
pidfile /var/run/redis_6379.pid
logfile /var/log/redis_6379.log
dir /var/redis/6379
```

### 6. Create systemd Service File
Create `/etc/systemd/system/redis.service` with the following content:

```ini
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/6379.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
```

### 7. Create Redis User
```bash
sudo adduser --system --group --no-create-home redis
sudo chown redis:redis /var/redis/6379
```

### 8. Enable and Start Redis Service
```bash
sudo systemctl daemon-reload
sudo systemctl start redis
sudo systemctl enable redis
```

### 9. Verify Installation
```bash
sudo systemctl status redis
redis-cli ping
```

## Maintenance

### Check Redis Status
```bash
sudo systemctl status redis
```

### Restart Redis
```bash
sudo systemctl restart redis
```

### Stop Redis
```bash
sudo systemctl stop redis
```

### View Redis Logs
```bash
sudo journalctl -u redis.service
```

## Troubleshooting

- Check Redis logs at `/var/log/redis_6379.log`
- Verify configuration file syntax
- Ensure proper permissions on Redis directories
- Confirm network connectivity if accessing remotely

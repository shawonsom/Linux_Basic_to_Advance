### At-a-glance knowledge base summary on UNIX sockets, TCP sockets, and WebSockets

#### 🔌 1. TCP Socket

##### ✅ What is it?
A network-based socket that uses IP + Port for communication over TCP.

```bash
# Python (Gunicorn)
gunicorn --bind 0.0.0.0:8000 myproject.wsgi:application

# Node.js
app.listen(3000);

# 🧬 Nginx config using TCP to connect to PHP-FPM
location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;  # TCP connection to PHP-FPM
    include fastcgi_params;
}

# 🛢️ MySQL TCP connection (default port 3306)
mysql -h 127.0.0.1 -P 3306 -u root -p

```

##### 🌍 Use Case
- Remote API calls
- Browser-to-server HTTP(S) communication
- DB connections (e.g., PostgreSQL on port 5432)

---

#### 📁 2. UNIX Domain Socket

##### ✅ What is it?
File-based socket for local inter-process communication (IPC).

##### 🔧 Example
```bash
# Gunicorn
gunicorn --bind unix:/run/gunicorn.sock myproject.wsgi:application

# ⚙️Nginx
proxy_pass http://unix:/run/gunicorn.sock:;


# ⚙️ Nginx config using Unix socket for PHP
location ~ \.php$ {
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    include fastcgi_params;

# 🐬 MySQL via Unix socket
mysql -S /var/run/mysqld/mysqld.sock -u root -p

# 🐳 Docker Unix socket example (Docker-in-Docker)
docker -H unix:///var/run/docker.sock ps


```

##### 💡 Use Case
- Nginx ↔ Gunicorn or PHP-FPM
- PostgreSQL local socket access

##### ✅ Benefits
- Fast and secure for local use
- No networking stack overhead

---

#### 🌐 3. WebSocket

##### ✅ What is it?
A protocol for real-time, full-duplex communication over TCP.

##### 🔧 Example
```js
const ws = new WebSocket("wss://yourdomain/ws");
ws.onmessage = (msg) => console.log(msg.data);
ws.send("hello");
```

##### 💡 Use Case
- Chat apps, notifications, dashboards
- Persistent browser-to-server connections

##### Django ASGI (WebSocket):
```python
# ASGI setup
application = ProtocolTypeRouter({
  "http": get_asgi_application(),
  "websocket": URLRouter(routes),
})
```

---

#### 🆚 Comparison Table

| Feature           | TCP Socket                   | UNIX Socket                    | WebSocket                         |
|------------------|------------------------------|---------------------------------|-----------------------------------|
| Protocol Layer    | Transport Layer (TCP/IP)     | Filesystem-based (AF_UNIX)      | Application Layer (built on TCP)  |
| Scope             | Network-wide (local/remote)  | Local-only (same host)          | Network-wide (remote/browser)     |
| Duplex Mode       | ✅ Full-Duplex               | ✅ Full-Duplex                 | ✅ Full-Duplex                    |
| Persistent        | ✅ Yes (long-lived TCP)      | ✅ Yes (streaming)              | ✅ Yes (after HTTP Upgrade)       |
| Accessed By       | IP:PORT                      | File path (e.g. /run/app.sock)  | ws://host or wss://host           |
| Use Cases         | HTTP, DBs, APIs, SSH         | Fast IPC: Nginx ↔ Gunicorn      | Chat, dashboard, live updates     |
| Security          | Firewall, IP restrictions    | OS file permissions             | TLS (wss://) encryption            |
| Performance       | Fast (some overhead)         | Fastest (no network stack)      | Varies with network, persistent   |
| Client Support    | OS, CLI, all languages       | Local apps only                 | Browsers, mobile, CLI supported   |
| Connection Setup  | socket() / bind() APIs       | socket(AF_UNIX) / bind()        | HTTP Upgrade, WS frames           |
---

#### 📚 Real-Life Stack Examples

| Tech     | TCP | UNIX Socket | WebSocket |
|----------|-----|-------------|-----------|
| Nginx    | ✅  | ✅          | ✅ (proxy) |
| Apache   | ✅  | ❌          | ✅ (with mod) |
| PHP-FPM  | ❌  | ✅          | ❌         |
| Django   | ✅  | ✅          | ✅ (via ASGI) |
| Node.js  | ✅  | ✅          | ✅         |
| Redis    | ✅  | ✅          | ❌         |
| RabbitMQ | ✅  | ✅          | ✅ (with plugin) |

---

#### 🛡️ DevOps/SRE Best Practices

- Use **UNIX sockets** for secure, fast local communication.
- Use **TCP sockets** for remote services and container-to-container comms.
- Use **WebSockets** for client-server real-time messaging.
- Always secure WebSockets with **WSS** in production.
- Monitor socket traffic using `ss`, `netstat`, `lsof`, or `tcpdump`.

---

#### 📄 Sample Nginx for HTTP + WebSocket

```nginx
server {
  listen 443 ssl;
  server_name example.com;

  ssl_certificate /etc/ssl/certs/cert.pem;
  ssl_certificate_key /etc/ssl/private/key.pem;

  location / {
    proxy_pass http://unix:/run/gunicorn.sock;
  }

  location /ws/ {
    proxy_pass http://unix:/run/ws.sock;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
```

---


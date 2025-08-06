
## What is a Namespace?
➤ **Namespace = Isolation**  
Namespaces in Linux isolate system resources so that one container can't see or affect another — or the host system.

✅ **Real-Life Analogy:**  
Namespace is like a private room in a hotel.  
Each room (container) has its own TV, bathroom, lights, windows, etc.  
Even though all rooms are in the same hotel (host), you can’t see or interact with others.

🧪 **Docker/Container Scenario:**  
Suppose you run:
```bash
docker run -it ubuntu
```
Docker will assign this container:

| Namespace Type | Isolated Resource |
|----------------|-------------------|
| pid            | Process IDs (container sees only its own processes) |
| net            | Its own network stack (IP address, interfaces)      |
| mnt            | Its own filesystem mount points                    |
| uts            | Hostname (can set its own hostname)                |
| ipc            | Shared memory (can't talk to host/shared IPC)      |
| user           | User and group IDs (can map different UID/GID)     |
| cgroup         | Resource limits (handled separately below)         |

✅ **Example:**  
```bash
docker run -it ubuntu
```
Inside the container:
```bash
ps aux        # shows only container's processes (pid namespace)
hostname      # container-specific hostname (uts namespace)
```
It also has its own virtual network stack (net namespace).

---

## What is a cgroup (Control Group)?
➤ **cgroup = Resource Control**  
cgroups limit or track how much of the host system’s resources (CPU, memory, IO, etc.) a container can use.

✅ **Real-Life Analogy:**  
Think of cgroups like limits on water and electricity in a hotel room:  
Each room (container) can only use a certain amount.  
You avoid one guest (container) using all the hot water or power.

🧪 **Docker/Container Scenario:**  
```bash
docker run -it --memory=256m --cpus=0.5 ubuntu
```
The container gets:
- Max 256 MB RAM
- Only 50% of one CPU core

These restrictions are enforced using cgroups.

You can verify limits with:
```bash
cat /sys/fs/cgroup/memory/docker/<container-id>/memory.limit_in_bytes
```

---

## 🧠 Summary Table

| Feature    | Linux Mechanism        | Purpose                                      | Docker Use Example                     |
|------------|------------------------|----------------------------------------------|----------------------------------------|
| Namespace  | pid, net, mnt, uts, ipc, user | Isolation (container sees only its world)    | Separate network/processes/hostnames   |
| Cgroup     | cgroup v1 or v2         | Resource control (CPU, memory, IO)           | Limit memory or CPU for container      |

---

## ✅ Real Docker Example Using Both:
```bash
docker run -it \
  --cpus="1" \
  --memory="512m" \
  --hostname="web1" \
  nginx
```
- **cgroups**: CPU limited to 1 core, RAM to 512 MB  
- **namespaces**: nginx has isolated hostname `web1`, its own network stack, and can't see host processes

---

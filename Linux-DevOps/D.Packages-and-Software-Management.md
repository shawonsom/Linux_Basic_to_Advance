- [4.Packages and Software Management]()
  - Package Management Distribution - pacman,zypper,rpm,yum,dpkg,apt and apt-get
  - DPKG (Debian and Ubuntu Based Distros) and APT (Advanced Package Tool)
  - Repository File | /etc/apt/sources.list
  - Installation new applications using `apt`
  - Install manually downloaded packages with example
  - Services like HTTP, SSH
  - Key Linux Package Management Commands
     - Ubuntu Based Systems
            - Searching through the repositories to find new apps
            - Installing packages that are not in the repository
            - Keeping programs updated
     - Fedora/RHEL 8 Based Systems
     - Suse Based Systems
     - Arch Based Systems




### 📦 AlmaLinux 9.5 Package Management Training Guide

This training guide covers:
- Installing, updating, and managing packages using `yum` / `dnf`
- Manual package installation (`rpm`)
- Comparison: `apt` vs `dpkg` vs `yum/dnf` vs `rpm`
- Visual Diagram for understanding!

---

#### 🧩 Package Managers Overview

| Package Manager | OS Family | Description |
|----------------|-----------|-------------|
| **dnf / yum** | RHEL, AlmaLinux, CentOS, Fedora | Dependency resolver & package manager |
| **rpm** | RHEL-based systems | Lower-level tool to manage `.rpm` files |
| **apt** | Debian, Ubuntu | High-level package manager for Debian-based systems |
| **dpkg** | Debian-based systems | Lower-level tool to manage `.deb` files |

---

#### 🔥 Using `dnf` / `yum`

AlmaLinux 9.5 uses `dnf`, which is the improved version of `yum`.

##### Install a package
```
sudo dnf install package_name
```

##### Example:
```
sudo dnf install httpd
```

##### Remove a package
```
sudo dnf remove package_name
```

##### Update system
```
sudo dnf update -y
```

##### Search for packages
```
dnf search package_name
```

##### Show package info
```
dnf info package_name
```

##### List installed packages
```
dnf list installed
```

---

#### 🛠️ Manual Package Installation with `rpm`

##### Install an RPM manually
```
sudo rpm -ivh package_file.rpm
```

##### Example:
```
sudo rpm -ivh httpd-2.4.37-51.module_el8.7.0+1087+0a21e43f.x86_64.rpm
```

##### Upgrade a package manually
```
sudo rpm -Uvh package_file.rpm
```

##### Remove a package
```
sudo rpm -e package_name
```

##### Query installed package
```
rpm -qa | grep package_name
```

---

#### 🧩 apt vs dpkg vs yum/dnf vs rpm — Visual Comparison

> **For GitHub**: Save this image in your repo as `package-managers.png`

```
+----------------+----------------+-------------------+------------------+
| Tool           | System         | Role              | Dependency Mgmt |
+----------------+----------------+-------------------+------------------+
| yum / dnf      | RHEL, Alma     | High-level manager| Yes              |
| rpm            | RHEL, Alma     | Low-level manager | No               |
| apt            | Debian, Ubuntu | High-level manager| Yes              |
| dpkg           | Debian, Ubuntu | Low-level manager | No               |
+----------------+----------------+-------------------+------------------+
```

![Package Managers Comparison](package-managers.png)

---

#### ✅ Best Practices

- ✅ Prefer `dnf` for day-to-day package management.
- ✅ Use `rpm` only for manual, specific installs.
- ✅ Always update package metadata:
  ```
  sudo dnf makecache
  ```
- ✅ Clean up unused packages:
  ```
  sudo dnf autoremove
  ```



## Packages and Software Management
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


## Ubuntu

### Automatic Installation (APT) | APT-based installation (repo-managed)
Purpose: APT resolves dependencies automatically and for the latest version add fficial repository.
- Installing Oldest or Latest
```sh
sudo apt update
sudo apt install docker-ce
sudo apt install nginx -y
```
- Installing Latest | Signed Custom Repository
  - A custom repository is when you add a third-party software vendor’s repository to your system.
  - “Signed” means the repo’s packages are verified with a GPG key, so Ubuntu trusts them.
  - GPG stands for GNU Privacy Guard | A GPG key is a digital signature tool used for encryption and verification.
  - This is the official way vendors distribute their software outside of Ubuntu’s default repos.
  - The package really comes from the trusted developer/repository.
  - The package was not tampered with during download.

```sh
# Add Docker’s GPG key and repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
```
- Installing Latest | PPA (Personal Package Archive)

  - A PPA is a software repository hosted on Launchpad (Ubuntu’s community repo system).
  - Developers use PPAs to publish newer or custom versions of software that aren’t available in Ubuntu’s default repositories.
  - Installed with add-apt-repository

```bash
# Add the PPA for Git
sudo add-apt-repository ppa:git-core/ppa -y

# Update package list
sudo apt update

# Install Git from the PPA (newer than Ubuntu’s default repo)
sudo apt install git -y

# Check version
git --version
```

### Manual Installation (.deb or Source) | Manual Installation via `.deb` Files Installation
Purpose: Usually downloaded manually for specific versions

```bash
# Step 1: Download the package
wget https://downloads.rclone.org/v1.62.2/rclone-v1.62.2-linux-amd64.deb

# Step 2: Install using dpkg
sudo dpkg -i rclone-v1.62.2-linux-amd64.deb

# Step 3: Resolve dependencies
sudo apt --fix-broken install

# Step 4: Verify installation
rclone version
```
### Tarball (source code) installation | Manual Source Compilation
Purpose: Download source code, compile, and install.
##### Update system
sudo apt update -y
sudo apt upgrade -y

##### Install dependencies

```bash
sudo apt install -y build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    git

# Download Python 3.8.20
wget https://www.python.org/ftp/python/3.8.20/Python-3.8.20.tgz

# Extract
tar -xzf Python-3.8.20.tgz
cd Python-3.8.20

# Configure build
./configure --enable-optimizations

# Compile & install
make -j$(nproc)
sudo make altinstall   # prevents overwriting default 'python3'

# Create symlinks
sudo ln -s /usr/local/bin/python3.8 /usr/bin/python3.8
sudo ln -s /usr/local/bin/pip3.8 /usr/bin/pip3.8

# Verify
python3.8 --version
pip3.8 --version

```
### Tarball (binary release) installation
Purpose: The software is distributed as a compressed .tar.gz containing a prebuilt binary. You extract and move the binary manually.
```bash
wget https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz
tar -zxvf helm-v3.10.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
helm version
```

```bash
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.12+7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz
tar -xvzf OpenJDK17U-jdk_x64_linux_hotspot_17.0.12_7.tar.gz
sudo mv jdk-17.0.12+7 /usr/local/java17
echo 'export PATH=$PATH:/usr/local/java17/bin' >> ~/.bashrc
source ~/.bashrc
java -version
```


### Local Repository for Offline Use


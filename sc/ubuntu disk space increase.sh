Goal: Expand server space to e 25GB disk


🔧 Step 1: Grow Partition /dev/sda3 to Use Full Disk
sudo apt install cloud-guest-utils -y
sudo growpart /dev/sda 3
lsblk

🔧 Step 2: Resize the Physical Volume (PV)
Once the partition has grown:
sudo pvresize /dev/sda3

🔧 Step 3: Extend the Logical Volume
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

🔧 Step 4: Resize the Filesystem

sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
sudo xfs_growfs /
✅ Final Check

df -h 


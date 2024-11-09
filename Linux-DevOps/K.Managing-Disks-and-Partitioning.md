## Managing Disks and Partitioning
  - Device - SSD | HDD | USB | Nvme
  - Filesystem Types - ext4, XFS | Block,File,Object
  - Partition Management
  - Logical Volume Managemnt(LVM)
  - Swap Partition
  - Mount and Unmount
  - lspci
  - sscsi
  - Block device
  - SCSI device
  - Raid
  - LVM
  - XFS
  - EXT4
  - NAS/NFS(Client & Server)
  - SAMBA
  - FTP
  - iSCSI(Initiator & Target)


[Linux disk management terminology](https://www.computernetworkingnotes.com/linux-tutorials/linux-disk-management-tutorial.html)\
File Management Commands in Linux\
List view and find hard disk names in Linux\
Linux file system types explained\
The fdisk command on Linux explained\
Manage Linux disk partition with the gdisk command\
The /etc/fstab file on Linux explained\
Linux disk management with the parted command\
The mkfs command on Linux\
The mount command on Linux temporary mounting\
The swap space on Linux explained\
How to create a swap partition in Linux\
How to configure LVM in Linux step-by-step\
How to configure RAID in Linux step-by-step\
How to manage disk quota in Linux step-by-step\

https://github.com/kodekloudhub/linux-basics-course/tree/master/docs/08-Storage-in-Linux



<img src=https://github.com/user-attachments/assets/f37882a4-f020-48f2-a37d-d9c1c034b209 height="800" width="700"/>


## Storage Management In Linux

**How the disk is divided into partitions and how the information about these partitions is stored?**\
MBR (Master Boot Record) and GPT (GUID Partition Table) are two different partitioning schemes used to organize and manage data on storage devices, particularly on hard disk drives (HDDs) and solid-state drives (SSDs).



### Overview of Key Terms

1. **BIOS (Basic Input/Output System)**:
   - **Definition**: BIOS is the traditional firmware interface for computers. It initializes hardware during the boot process and provides runtime services for operating systems and programs.
   - **Example**: Older PCs (pre-2010) typically use BIOS for booting.

2. **UEFI (Unified Extensible Firmware Interface)**:
   - **Definition**: UEFI is a modern replacement for BIOS. It offers a more advanced interface and greater capabilities such as secure boot, faster startup, and support for larger disk sizes.
   - **Example**: Most modern computers and motherboards released after 2012 use UEFI.

3. **MBR (Master Boot Record)**:
   - **Definition**: MBR is a partitioning scheme that has been the standard for decades. It defines how the data is organized on a disk and is limited to 2 TB disk size and 4 primary partitions.
   - **Example**: Older Windows installations (Windows XP, Vista) typically used MBR partitioning.

4. **GPT (GUID Partition Table)**:
   - **Definition**: GPT is the newer partitioning scheme, which is part of the UEFI standard. GPT supports larger disk sizes (up to 9.4 ZB) and allows up to 128 partitions.
   - **Example**: Newer systems with UEFI firmware use GPT for partitioning.

---

### Key Comparisons

| Feature               | **BIOS**                             | **UEFI**                               | **MBR**                                | **GPT**                              |
|-----------------------|--------------------------------------|----------------------------------------|----------------------------------------|--------------------------------------|
| **Partitioning Scheme**| MBR only                             | MBR or GPT                             | MBR only                                | GPT only                             |
| **Max Disk Size**      | 2 TB                                 | 9.4 ZB                                 | 2 TB                                   | 9.4 ZB                               |
| **Max Partitions**     | 4 primary or 3 primary + 1 extended  | 128 partitions                         | 4 primary or 3 primary + 1 extended    | 128 partitions                       |
| **Boot Mode**          | Legacy (BIOS)                       | UEFI (Unified Extensible Firmware Interface) | MBR bootloader                       | UEFI bootloader, requires GPT       |
| **Secure Boot**        | No                                   | Yes                                    | No                                     | Yes                                  |
| **Fast Boot**          | No                                   | Yes                                    | No                                     | Yes                                  |
| **Compatibility**      | Works with legacy systems and operating systems | Works with modern systems and operating systems | Only supports MBR systems             | Only supports UEFI systems           |

---

`sudo fdisk -l /dev/sda`\
`sudo gdisk /dev/sda`\
`sudo parted -l`

**What is a Partition?**

Partition is a logical container which is used to house filesystems, where operating systems, applications, anddata is stored on. A single partition may span the entirety of a physical storage device.

**Types of Disk Partitions**

**There are three main types of partitions:**\
Primary Partitions: Directly accessible and used for booting the system. A disk can have up to four primary partitions.\
Extended Partitions: Created within a primary partition, acting as a container that can hold multiple logical partitions. This is a workaround for the four-partition limit.\
Logical Partitions: Nested within an extended partition, allowing for more than four partitions on a disk.



**What is a File System?**

A file system provides a way of separating the data on the drive into individual pieces, which are the files. Italso provides a way to store data about these files for example, their filenames, permissions, and otherattributes.

Each partition can use a different file system (ext4, NTFS, FAT32, etc.), affecting performance, storage efficiency, and compatibility.

Tools for Disk Partitioning in Linux. Linux offers a plethora of tools for disk partitioning, including:

fdisk: A command-line utility ideal for MBR disks.\
gdisk: Similar to fdisk but for GPT disks.\
parted: A versatile tool that supports both MBR and GPT disks.

**What is LVM?**

LVM is a more flexible approach to managing disk space. It allows for resizing partitions (logical volumes) on the fly, creating snapshots, and combining multiple physical disks into one large virtual one.


Physical Volumes (PV): Physical disks or disk partitions.
Volume Groups (VG): Collections of physical volumes, acting as a pool of disk space.
Logical Volumes (LV): Segments of a volume group that are used by the system as individual partitions.


## Add a New Disk to your existing LVM 

- Partition the new drive (if necessary): If sdb is not already partitioned, you need to create a new partition on it.

- Create a physical volume (PV): Initialize the new partition or the whole disk as a physical volume for LVM.

- Extend the volume group (VG): Add the new physical volume to your existing volume group.

- Extend the logical volumes (LVs): Expand your logical volumes to use the new space.

**Steps to Extend an LVM Partition and Filesystem**

**Steps 1:** List Block Devices\
`sudo lsblk`

**Steps 2:** Open Disk for Partitioning\
`sudo fdisk /dev/sdb`

**Steps 3:** List Partitions on the Disk\
`sudo fdisk -l /dev/sdb`

**Steps 4:** Initialize a Partition as a Physical Volume\
`sudo pvcreate /dev/sdb1`

**Steps 5:** Display Information About Volume Groups\
`sudo vgdisplay`

**Steps 6:** Display Information About Physical Volumes\
`sudo pvdisplay`

**Steps 7:** Extend an Existing Volume Group\
`sudo vgextend vg0 /dev/sdb1`

**Steps 8:** Display Information About Logical Volumes\
`sudo lvdisplay`

**Steps 9:** Display Disk Usage\
`sudo df -h`

**Steps 10:** Extend a Logical Volume\
`sudo lvextend -l +100%FREE /dev/mapper/vg0-lv--0`

**Steps 11:** Resize the Filesystem on the Logical Volume\
`sudo resize2fs /dev/mapper/vg0-lv--0`

**Steps 12:** Display Disk Usage (Again)\
    `sudo df -h`

**Summary of Steps**
- View Current Block Devices: Identify current disk and partition layout.
- Partition the Disk: Use fdisk to partition the new disk (/dev/sdb).
- Initialize the Partition for LVM: Set up the new partition (/dev/sdb1) as a physical volume.
- Check LVM Configuration: Ensure current volume groups and physical volumes are correctly set up.
- Add New PV to VG: Extend the volume group vg0 to include the new physical volume.
- Extend Logical Volume: Increase the size of an existing logical volume to utilize the new space.
- Resize Filesystem: Adjust the filesystem on the logical volume to take advantage of the extended space.
- Verify Changes: Confirm that the disk space has been correctly extended and allocated.

## Without LVM setting up and mounting a new disk into Ubuntu

**Steps 1:** List block devices before partitioning (sudo lsblk).\
`sudo lsblk`

**Steps 2:** Partition the disk (sudo fdisk /dev/sdb).\
`sudo fdisk /dev/sdb`

**Steps 3:** List block devices after partitioning (sudo lsblk).\
`sudo lsblk`

**Steps 4:** Format the partition (sudo mkfs.ext4 /dev/sdb1).\
`sudo mkfs.ext4 /dev/sdb1`

**Steps 5:** Create a mount point (sudo mkdir /mnt/sdb_mount).\
`sudo mkdir /mnt/sdb_mount`

**Steps 6:** Mount the partition (sudo mount /dev/sdb1 /mnt/sdb_mount).\
`sudo mount /dev/sdb1 /mnt/sdb_mount`

**Steps 7:** Verify the mount (df -h /mnt/sdb_mount).\
`df -h /mnt/sdb_mount`

**Steps 8:** Get filesystem attributes and UUID (Universally Unique Identifier) \
`sudo blkid /dev/sdb1`

**Steps 9:** Add entry to /etc/fstab\
Edit /etc/fstab using a text editor (sudo vim /etc/fstab) and add the following line at the end.\
`UUID=c9516c06-7a49-441d-b1cb-6cc3db593217 /mnt/sdb_mount ext4 defaults 0 0`

**Steps 10:** Mount all entries in /etc/fstab (sudo mount -a).\
`sudo mount -a`

**Steps 11:** Verify the mount after adding to /etc/fstab (df -h /mnt/sdb_mount).\
`df -h /mnt/sdb_mount`


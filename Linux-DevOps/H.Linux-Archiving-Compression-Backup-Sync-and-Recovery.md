



Archiving and Compression
**Archiving:** Combining files into a single file for easy storage/transfer and **Compression:** Reducing file size to save space and bandwidth. **Why It Matters -** Efficient storage, faster transfer, simplified management.


| Feature                 | Linux                     | Windows                     |
|-------------------------|---------------------------|-----------------------------|
| Common Archive Tools    | `tar`, `zip`,`rar`, `7z`  | File Explorer, WinRAR, 7-Zip|
| Common Compression      | `gzip`, `bzip2`, `xz`     | `.zip`, `.rar`, `.7z`       |
| Built-In Support        | Mostly `tar`, `gzip`      | File Explorer (`.zip`)      |
| CLI Support             | Yes, via Shell            | Yes, via PowerShell         |


Archive
-------
.tar 
.zip
.rar
.7z

Archive + Compression
---------------------
.tar.gz  - Archive + Compression
.tar.bz2 - Archive + More Compression
.tar.xz  - Archive + More and More Compression


10 MB - 4MB(.tar.gz) | 3MB(.tar.bz2) | 2MB(tar.xz)

c - Create
v - Verbose
f - Files
z - gz
j - bz2
J - xz
x - Extract


Archive
----------------------------------------
tar -cvf archive-etc.tar etc
tar -xvf archive-etc.tar

Archive + Compression
----------------------------------------
tar -czvf archive+compression.tar.gz etc
tar -xzvf archive+compression.tar.gz

Archive + More Compression
----------------------------------------
tar -cjvf archive+more-compression.tar.bz2 etc
tar -xjvf archive+more-compression.tar.bz2

Archive + More and More Compression
----------------------------------------
tar -cJvf archive+more+more-compression.tar.xz etc
tar -xJvf archive+more+more-compression.tar.xz

Only Compression
----------------------------------------
gzip passwd
gunzip passwd.gz

bzip2 passwd
bunzip2 passwd.bz2

xz passwd
unxz passwd.xz


### Archive Formats
Archiving combines multiple files or folders into a single file without compression. Common archive formats include:
- **.tar**: Linux standard archiving format without compression.
- **.zip**: Archive format with built-in compression (cross-platform).
- **.rar**: Proprietary archive format with compression.
- **.7z**: High compression archive format.

### Archive + Compression Formats
Archive + Compression combines files into a single file and reduces file size:
- **.tar.gz**: Archive with **gzip** compression (standard compression).
- **.tar.bz2**: Archive with **bzip2** compression (higher compression).
- **.tar.xz**: Archive with **xz** compression (highest compression).

| File Size Comparison | 10 MB File |
|----------------------|------------|
| `.tar.gz`            | 4 MB       |
| `.tar.bz2`           | 3 MB       |
| `.tar.xz`            | 2 MB       |

### Common Flags for `tar` Command
| Flag | Description                       |
|------|-----------------------------------|
| `c`  | Create a new archive              |
| `v`  | Verbose (show progress in terminal) |
| `f`  | Specify filename of archive       |
| `z`  | Compress with gzip                |
| `j`  | Compress with bzip2               |
| `J`  | Compress with xz                  |
| `x`  | Extract an archive                |

### Archive Commands

#### Basic Archive (No Compression)
Create and extract a simple archive with `tar`:
```bash
# Create a .tar archive
tar -cvf archive-etc.tar etc

# Extract a .tar archive
tar -xvf archive-etc.tar
```

#### Archive + Compression (gzip)
Create and extract a `.tar.gz` archive:
```bash
# Create a .tar.gz archive
tar -czvf archive+compression.tar.gz etc

# Extract a .tar.gz archive
tar -xzvf archive+compression.tar.gz
```

#### Archive + More Compression (bzip2)
Create and extract a `.tar.bz2` archive:
```bash
# Create a .tar.bz2 archive
tar -cjvf archive+more-compression.tar.bz2 etc

# Extract a .tar.bz2 archive
tar -xjvf archive+more-compression.tar.bz2
```

#### Archive + Highest Compression (xz)
Create and extract a `.tar.xz` archive:
```bash
# Create a .tar.xz archive
tar -cJvf archive+more+more-compression.tar.xz etc

# Extract a .tar.xz archive
tar -xJvf archive+more+more-compression.tar.xz
```

### Compression Only (No Archiving)
Compress individual files without creating an archive, only compression is better for single file not directory. 

### Using gzip
```bash
# Compress a file
gzip passwd

# Decompress a file
gunzip passwd.gz
```

### Using bzip2
```bash
# Compress a file
bzip2 passwd

# Decompress a file
bunzip2 passwd.bz2
```

### Using xz
```bash
# Compress a file
xz passwd

# Decompress a file
unxz passwd.xz
```



















  - Backup & Sync
  - Backup/Recovery

zgrep "SI1580049228" server.log.2020-01-*.*.gz

zgrep "REQUEST_ALREADY_TIMED_OUT_BY_PRODUCER" app-2020-01-28-02-[3-7].log.gz |wc -l

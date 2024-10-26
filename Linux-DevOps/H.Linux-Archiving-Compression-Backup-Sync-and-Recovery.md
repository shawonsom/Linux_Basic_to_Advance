## Archiving and Compression
**Archiving:** Combining files into a single file for easy storage/transfer and **Compression:** Reducing file size to save space and bandwidth. **Why It Matters -** Efficient storage, faster transfer, simplified management.


| Feature                 | Linux                     | Windows                     |
|-------------------------|---------------------------|-----------------------------|
| Common Archive Tools    | `tar`, `zip`,`rar`, `7z`  | File Explorer, WinRAR, 7-Zip|
| Common Compression      | `gzip`, `bzip2`, `xz`     | `.zip`, `.rar`, `.7z`       |
| Built-In Support        | Mostly `tar`, `gzip`      | File Explorer (`.zip`)      |
| CLI Support             | Yes, via Shell            | Yes, via PowerShell         |


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


| Command                  | Purpose                                                 | Usage                                   | Example Command                       |
|--------------------------|---------------------------------------------------------|-----------------------------------------|---------------------------------------|
| `apt install unrar`      | Installs tool to **extract** `.rar` files               | Use to decompress `.rar` files          | `unrar x archive.rar`                 |
| `apt install rar`        | Installs tool to **create and extract** `.rar` files    | Use to create or decompress `.rar` files| `rar a archive.rar folder/`           |
| `apt install zip`        | Installs tool to **create** `.zip` files                | Use to compress files into `.zip`       | `zip archive.zip file1 file2`         |
| `apt install unzip`      | Installs tool to **extract** `.zip` files               | Use to decompress `.zip` files          | `unzip archive.zip`                   |
| `apt install p7zip-full` | Installs tool to **create and extract** `.7z` files     |

### Key Differences
- **unrar**: For extracting `.rar` files only.
- **rar**: For creating and extracting `.rar` files.
- **zip**: Used for creating compressed `.zip` files.
- **unzip**: Used for extracting `.zip` files.
- **7z**: For creating and extracting `.7z` files.







  - Backup & Sync
  - Backup/Recovery

zgrep "SI1580049228" server.log.2020-01-*.*.gz

zgrep "REQUEST_ALREADY_TIMED_OUT_BY_PRODUCER" app-2020-01-28-02-[3-7].log.gz |wc -l

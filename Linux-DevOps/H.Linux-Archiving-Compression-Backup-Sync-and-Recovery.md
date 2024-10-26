



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




 - Archiving & Compression
     - tar  | zip | gz | xz | bz2 | gzip | bzip2 | unzip | extract | decompress | gzip, gunzip, tar,
  - Backup & Sync
  - Backup/Recovery

zgrep "SI1580049228" server.log.2020-01-*.*.gz

zgrep "REQUEST_ALREADY_TIMED_OUT_BY_PRODUCER" app-2020-01-28-02-[3-7].log.gz |wc -l

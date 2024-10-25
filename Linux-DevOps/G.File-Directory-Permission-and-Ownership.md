- [File Permission and Ownership](#FileDir-Permission-and-Ownership)
  - Understanding File and Directory Permissions
  - File/Directory Permission and Ownership
  - Default and Maximum File/Directory Permission
  - Advanced File Permission Concepts
    - File Permission with Umask
    - Advanced File Permission with Access Control Lists (ACL)
    - Special permissions - Setuid, Setgid, and Sticky Bit

#### 🚀[File/Dir Permission and Ownership]()

<p align="justify">

Unix-like operating systems, such as Linux, running on shared high-performance computers use settings called permissions to determine who can access and modify the files and directories stored in their file systems. Each file and directory in a file system is assigned "owner" and "group" attributes.

Most commonly, by default, the user who creates a file or directory is set as owner of that file or directory. When needed (for example, when a member of your research team leaves), the system's root administrator can change the user attribute for files and directories.

The group designation can be used to grant teammates and/or collaborators shared access to an owner's files and directories, and provides a convenient way to grant access to multiple users.
</p>

- [ ] 🔴Permissions are applied on three levels:- 
    * Owner or User level  `u`
    * Group level  `g`
    * Others level `o` & `a` for all users
![image](https://github.com/user-attachments/assets/f70e2ade-4081-4ec1-b1c3-bdf071984a6f)

- [ ] 🔴Access modes - Each file or directory has three basic permission types
    * **r** - read only 
    * **w** - write/edit/delete/append 
    * **x** - execute/run a command 
 
- [ ] 🔴Access modes are different on file and directory:- 

| Permissions | Files           | Directory |
|:-----: |:---         |:---   |
| r | Open the file | 'ls' the contents of dir |
| w | Write, edit, append, delete file | Add/Del/Rename contents of dir |
| x | To run a command/shell script | To enter into dir using 'cd' |

- [ ] 🔴Using Binary References to Set permissions

| Binary Reference | Meaning |
|------------------|---------|
| `4`              | Read    |
| `2`              | Write   |
| `1`              | Execute |



- [ ] 🔴There are 2 ways to use the command -

   - [ ] **Absolute mode**
   - [ ] **Symbolic mode**

 - [ ] 🧩[Absolute mode]()

In this mode, file permissions are not represented as characters but a three-digit octal number. The table below gives numbers for all for permissions types.

| Number |	Permission Type	| Symbol |
| :----: |  :-----|  :----:|
| 0	 |No Permission |	---  |
| 1	| Execute	| --x |
| 2	| Write	|-w- |
| 3	| Execute + Write	|-wx |
| 4	| Read	| r-- |
| 5	| Read + Execute |	r-x |
| 6	| Read +Write |	rw- | 
| 7	| Read + Write +Execute |	rwx | 

⚡**Command**\
`chmod 764 samplefile`\
`chmod 777 samplefile` - Assigning full permission to the file i.e. rwx to all

 - [ ] 🧩[Symbolic Mode]()

In the Absolute mode, you change permissions for all 3 owners. In the symbolic mode, you can modify permissions of a specific owner. It makes use of mathematical symbols to modify the file permissions.

| Operator	| Description |
| :---: |:--|
|+ |	Adds a permission to a file or directory|
|-	| Removes the permission|
|=	|Sets the permission and overrides the permissions set earlier.|

⚡**Command**\
`chmod u=rwx,g=rw,o=r samplefile` (user=rwx, group=rw and others=r)\
`chmod u=rwx,g=rw,o=r samplefile` (user=rwx, group=rw and others=r) \
`chmod u=rwx,g+wx,o-x samplefile`\
`chmod ugo=rwx samplefile` - Assigning full permission to the file i.e. rwx to all\
`chmod u+x samplefile` - Adding execute permission to user only\
`chmod go-wx samplefile` - Removing write and execute permissions from group and other\
`chmod go+wx samplefile` - Adding write and execute permissions from group and other\
`chmod go=r samplefile` - Giving only read permission to group and other

⚡**Random Command**\
`ls -al /path/to/file/or/dir` 	   	- Check current permissions\
`chmod 755 file-name` 			   	- Set owner have full permission group and other users has only read and execute permission.\
`chmod u+x your_script.sh` 		   	- Set execute permission for the owner only.\
`chmod u+rwx test-file` 			- Provide full access to owners\
`chmod ugo+r-x test-file` 		   	- Provide Read access to Owners, groups and others, Remove execute access\
`chmod o-rwx test-file` 			- Remove all access for others\
`chmod u+rwx,g+r-x,o-rwx test-file` - Full access for Owner, add read , remove execute for group and no access for others\
`chmod 777 test-file` 			   	- Provide full access to Owners, group and others\
`chmod 660 test-file` 			   	- Read and Write access for Owner and Group, No access for others.\
`chmod 750 test-file` 			   	- Full access for Owner, read and execute for group and no access for others.\
`chown bob:developer test-file` 	- Changes owner to bob and group to developer\
`chown bob andoid.apk` 			   	- Changes just the owner of the file to bob. Group unchanged\
`chgrp android test-file` 		   	- Change the group for the test-file to the group called android\
`chown -R msi:msi /dir` 		   	- Append -R for recursive syntax (include sub files and directories)\
`chmod -u+r,g-w,o-rwx` 			   	- Multiple permissions at once\
`chmod +rwx filename`\
`chmod +x filename`\
`chmod u-rwx`\						
`chmod g-rwx`\
`chmod o-rwx`\
`chmod a-rwx`\
`chmod 000`


- [ ] 🔴[Default and Maximum File/Directory Permission]()
      
<img src=https://github.com/user-attachments/assets/19733486-3857-4b70-86d5-872cbc2f6b95 height="250" width="900"/>



      
- [ ] 🔴[Advanced File Permission Concepts]()
  - [ ] 🔴[File Permission with Umask]()
  - [ ] 🔴[Advanced File Permission with Access Control Lists (ACL)]()
  - [ ] 🔴[Special permissions - Setuid, Setgid, and Sticky Bit]()


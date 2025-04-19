<img src="https://github.com/user-attachments/assets/3649ecd8-62dc-4ba9-baae-06bbb9246fe0" width="600" height="800"/>


- [ ] [File/Dir Permissions and Ownership](#FileDir-Permission-and-Ownership)
  - [File/Directory Permission and Ownership](#FileDir-Permission-and-Ownership)
  - [Advanced File Permission Concepts](#Advanced-File-Permission-Concepts)
    - File/Dir Permission with Umask
    - Advanced File Permission with Access Control Lists (ACL)
    - Special permissions - Setuid, Setgid, and Sticky Bit

### 🚀File/Dir Permissions and Ownership

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

       🧩[Absolute mode]()

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
      🧩[Symbolic Mode]()

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
`chmod 755 file-name` 			   	    - Set owner have full permission group and other users has only read and execute permission.\
`chmod u+x your_script.sh` 		   	  - Set execute permission for the owner only.\
`chmod u+rwx test-file` 			      - Provide full access to owners\
`chmod ugo+r-x test-file` 		   	  - Provide Read access to Owners, groups and others, Remove execute access\
`chmod o-rwx test-file` 			      - Remove all access for others\
`chmod u+rwx,g+r-x,o-rwx test-file` - Full access for Owner, add read , remove execute for group and no access for others\
`chmod 777 test-file` 			   	    - Provide full access to Owners, group and others\
`chmod 660 test-file` 			   	    - Read and Write access for Owner and Group, No access for others.\
`chmod 750 test-file` 			   	    - Full access for Owner, read and execute for group and no access for others.\
`chown bob:developer test-file` 	  - Changes owner to bob and group to developer\
`chown bob andoid.apk` 			   	    - Changes just the owner of the file to bob. Group unchanged\
`chgrp android test-file` 		   	  - Change the group for the test-file to the group called android\
`chown -R msi:msi /dir` 		       	- Append -R for recursive syntax (include sub files and directories)\
`chmod -u+r,g-w,o-rwx` 			   	    - Multiple permissions at once\
`chmod +rwx filename`\
`chmod +x filename`\
`chmod u-rwx`\						
`chmod g-rwx`\
`chmod o-rwx`\
`chmod a-rwx`\
`chmod 000`

### 🚀Advanced File Permission Concepts

<img src=https://github.com/user-attachments/assets/19733486-3857-4b70-86d5-872cbc2f6b95 height="250" width="900"/>

#### 🔴[File/Dir Permission with Umask]()

Linux uses **permissions** to control who can **read**, **write**, or **execute** files and directories. **Umask** sets the default permissions for new files and directories by removing some permissions to improve security.

##### Basic Permissions

- **Read (`r`)**: View content.
- **Write (`w`)**: Modify content.
- **Execute (`x`)**: Run files or access directories.

Each file has three permission sets for:
1. **User (Owner)**
2. **Group**
3. **Others**

Permissions are shown as `rwxr-xr--` (User/Group/Others).

##### What is Umask?

**Umask** stands for **User Mask**. It subtracts permissions from the default settings for new files and directories, helping secure them automatically.

- **Default Permissions**:
  - **Files**: `666` (read/write for everyone) – no execute by default.
  - **Directories**: `777` (read/write/execute for everyone).

The umask value is subtracted from the default permissions. Here’s a step-by-step example to see it in action.

##### Example 1: Umask `022`

1. **Determine Default Permissions**:
   - Files: `666`
   - Directories: `777`

2. **Apply the Umask (`022`)**:
   - Subtract each umask digit from the default permission digit:
     - `6 - 0 = 6`
     - `6 - 2 = 4`
     - `6 - 2 = 4`

3. **Resulting Permissions**:
   - New files: `644` (read and write for user, read-only for group and others).
   - New directories: `755` (full access for user, read and execute for group and others).

##### Commands to Check and Set Umask

- **View Current Umask**:
  ```bash
  umask
  ```
- **Set a New Umask**:
  ```bash
  umask 027
   ```      

#### 🔴[Advanced File Permission with Access Control Lists (ACL)]()

ACLs provide finer-grained control over file and directory permissions, allowing specific permissions for individual users and groups beyond standard user, group, and other permissions.

`apt install acl -y`

##### Key Commands and Examples
1. **Setting ACL for a User**
   - Grant read, write, and execute permissions to `user1` for `file.txt`:
     ```bash
     setfacl -m u:user1:rwx file.txt
     ```
2. **Setting ACL for a Group**
   - Grant read and execute permissions to `group1` for `file.txt`:
     ```bash
     setfacl -m g:group1:rx file.txt
     ```
3. **Default ACL for a Directory**
   - Set default permissions for new files in `dir1` so `user2` has read and write access:
     ```bash
     setfacl -d -m u:user2:rw dir1
     ```
4. **Removing an ACL Entry**
   - Remove ACL permissions for `user1` on `file.txt`:
     ```bash
     setfacl -x u:user1 file.txt
     ```
5. **Viewing ACLs**
   - Display ACL entries for a file or directory:
     ```bash
     getfacl file.txt
     ```
6. **Setting ACL for Multiple Users and Groups**
   - Allow `user1` and `group1` read-only permissions on `dir1`:
     ```bash
     setfacl -m u:user1:r g:group1:r dir1
     ```
7. **Granting ACL for Others**
   - Set read-only permissions for others on `file.txt`:
     ```bash
     setfacl -m o::r file.txt
     ```
## Additional Tips

- **usermod**: Modify user attributes, e.g., adding `user1` to `group1`:
  ```bash
  usermod -aG group1 user1

##### More Commands and Examples

- `setfacl -x saiful file/directory`  	    - remove only specified ACL from file/directory.
- `setfacl -x u:saiful file/directory`      - remove only specified ACL from file/directory.
- `setfacl -b  file/directory`   		        - removing all ACL from file/direcoty 
- `setfacl -R -m g:groupname:+x testfolder/`- To add groupname to have recursive +execute on testfolder
- `setfacl -m d:g:groupname:rw testfolder/` - To add default group access right to read and write on testfolder folder 


#### 🔴[Special permissions - Setuid, Setgid, and Sticky Bit]()


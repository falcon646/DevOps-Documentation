# `chmod`

The `chmod` command in Linux is used to change file and directory permissions. It has different variations based on how permissions are specified.

- **File Permissions**
    - In Linux file permissions, **4, 2, and 1** represent the basic permission values that can be assigned to a file or directory. They are used in combination to define **read (r), write (w), and execute (x)** permissions.
        - **Read (`4`)** Allows viewing the file's contents (`cat`, `less`, `vi`).
        - **Write (`2`)** Allows modifying or deleting the file (if the directory allows deletion). 
        - **Execute (`1`)** Allows running the file as a program or script.  
    - **Permission Values**  Each permission type has a numeric value:
        | Numeric Value | Permission | Symbol |
        |--------------|-----------|--------|
        | **4**        | Read      | `r--`  |
        | **2**        | Write     | `-w-`  |
        | **1**        | Execute   | `--x`  |
    
    - **How It Works** : 
        - Each file or directory has three permission groups:
            - `Owner (User)`  + `Group`   + `Others (Everyone else)` 
            -   `---`         + `---`     + `---`
        - These values are **added together** to assign the correct permissions. 
            - `rwx` → Read (4) + Write (2) + Execute (1) = **7**
            - `rw-` → Read (4) + Write (2) = **6**
            - `r-x` → Read (4) + Execute (1) = **5**
            - `r--` → Read (4) only = **4**
            - `---` → No permissions = **0**
    - **Examples**
        - **Grant full permissions to the owner, read & execute for others:**
            ```bash
            chmod 755 file.txt
            ```
            **Breakdown:**
            - Owner (`7`): Read (4) + Write (2) + Execute (1) = `rwx`
            - Group (`5`): Read (4) + Execute (1) = `r-x`
            - Others (`5`): Read (4) + Execute (1) = `r-x`
            - **Final permissions:** `rwxr-xr-x`

        - **Read & write for the owner, read-only for others:**
            ```bash
            chmod 644 file.txt
            ```
            **Breakdown:**
            - Owner (`6`): Read (4) + Write (2) = `rw-`
            - Group (`4`): Read (4) = `r--`
            - Others (`4`): Read (4) = `r--`
            - **Final permissions:** `rw-r--r--`

        - **Owner can do everything, others have no access:**
            ```bash
            chmod 700 script.sh
            ```
            **Breakdown:**
            - Owner (`7`): Read (4) + Write (2) + Execute (1) = `rwx`
            - Group (`0`): No permissions = `---`
            - Others (`0`): No permissions = `---`
            - **Final permissions:** `rwx------`

    - **Octal Values for Permissions Table** : Each digit represents a combination of permissions:

        | Octal | Permission | Symbolic Representation |
        |--------|-------------|-------------------------|
        | 0 | No permissions | `---` |
        | 1 | Execute only | `--x` |
        | 2 | Write only | `-w-` |
        | 3 | Write + Execute | `-wx` |
        | 4 | Read only | `r--` |
        | 5 | Read + Execute | `r-x` |
        | 6 | Read + Write | `rw-` |
        | 7 | Read + Write + Execute | `rwx` |
        
        - **Examples:**
            - `chmod 755 file.txt`  → Owner: `rwx`, Group: `r-x`, Others: `r-x`
            - `chmod 644 file.txt`  → Owner: `rw-`, Group: `r--`, Others: `r--`
            - `chmod 700 script.sh` → Owner: `rwx`, Group: `---`, Others: `---`

    - **Symbolic Mode**  : We can also uses letters and operators to modify specific permissions.
        - **Operators:**
            - `+` → Adds permission
            - `-` → Removes permission
            - `=` → Sets exact permissions
        - **User Classes:**
            - `u` → Owner
            - `g` → Group
            - `o` → Others
            - `a` → All (Owner, Group, Others)
        - **Examples:**
            - `chmod u+x script.sh` → Gives the owner execute permission.
            - `chmod g-w file.txt`  → Removes write permission from the group.
            - `chmod o=r file.txt`  → Sets read-only permission for others.
            - `chmod a+rx file.txt` → Adds read and execute permissions for all.
        - **Combining Options**   : Multiple permission changes can be combined in one command.
            - `chmod u=rwx,g=rx,o=r file.txt` → Owner: full access, Group: read+execute, Others: read-only.
            - `chmod 750  project.txt/`  → Owner: full access, Group: read+execute, Others: no access.
            - `chmod g+w,o-r file.txt` → Grants write access to the group and removes read access for others.

    - **Recursive Flag (`-R`)**  : use this to change permissions for directories and all their contents.
        - **Examples:**
            - `chmod -R 755 myfolder/`   : → Sets `755` permissions for all files and subdirectories.
            - `chmod -R a+rwx shared/`   :→ Grants full access to all users in `shared/`.


- **Directories Permissions**
    - The same **read (4), write (2), execute (1)** system applies to **directories** and can be combined with **special permissions** like **SetUID, SetGID, and Sticky Bit**.
    - **Permissions on Directories** : Unlike files, **execute (`x`) permission on a directory** is crucial because:  
        - **Read (`4`)** allows listing files inside the directory (`ls`).  
        - **Write (`2`)** allows creating, renaming, or deleting files inside the directory.  
        - **Execute (`1`)** allows accessing files inside the directory (`cd` into it).  
    - **Examples:**
        - **Full access to owner, read-only for others**:
            ```bash
            chmod 755 mydir
            ```
            **Breakdown:**
            - Owner (`7`): `rwx` → Can list, create, modify, and enter the directory.
            - Group (`5`): `r-x` → Can list and enter the directory but cannot modify contents.
            - Others (`5`): `r-x` → Same as the group.
        - **Only the owner can enter and modify, others have no access**:
            ```bash
            chmod 700 mydir
            ```
            - **Permissions:** `rwx------`
        - **Give everyone full permissions**:
            ```bash
            chmod 777 public_folder
            ```
            - **Permissions:** `rwxrwxrwx` (Not recommended for security reasons).

- **Special File Permissions in Linux (`SetUID`, `SetGID`, and `Sticky Bit`)**
    - Linux supports **special file permissions** that modify how files and directories behave. These include:
        - **SetUID (`s` on the user bit)**
        - **SetGID (`s` on the group bit)**
        - **Sticky Bit (`t` on the others bit, mainly for directories)**
    - **SetUID (Set User ID) - `4000`**
        - **What it does:**
            - When a file with SetUID is executed, it **runs as the file owner, not as the user who executed it**.
            - **Only applies to executable files** (not directories).
            - Used for system commands that require **temporary elevated privileges**.
        - **Example Usage:**
            ```bash
            chmod 4755 program
            ```
            - `4` (`4000`) sets **SetUID**.
            - Resulting permission: `rwsr-xr-x`
            - **Effect:** Anyone who runs `program` executes it **as the file owner**.
        - **Real-World Example:**
            Check the `passwd` command:
            ```bash
            ls -l /usr/bin/passwd
            # -rwsr-xr-x 1 root root 54256 Feb 2 12:34 /usr/bin/passwd
            ```
            - The `s` in `rwsr-xr-x` means SetUID is enabled.
            - `passwd` must **temporarily elevate privileges** to change the password in system files.

    - **SetGID (Set Group ID) - `2000`**
        - **What it does:**
            - For **executable files**: When executed, the file runs with **the group’s permissions** instead of the user's primary group.
            - For **directories**: Any new files inside will **inherit the directory's group** (instead of the user's primary group).
        - **Example Usage (Executable File)**
            ```bash
            chmod 2755 script.sh
            ```
            - `2` (`2000`) sets **SetGID**.
            - Resulting permission: `rwxr-sr-x`
            - **Effect:** Anyone who runs `script.sh` executes it **as the file’s group**.
        - **Example Usage (Directory)**
            ```bash
            chmod 2775 shared_folder
            ```
            - **Effect:** All new files inside `shared_folder` inherit its group.
            - **Useful for:** Shared team directories where files need the same group.
        - **Real-World Example:**
            Check `/usr/bin/locate`:
            ```bash
            ls -l /usr/bin/locate
            # Output:
            -rwxr-sr-x 1 root locate 34256 Feb 2 12:34 /usr/bin/locate
            ```
            - The `s` in `rwxr-sr-x` shows **SetGID** is set.
            - The `locate` command runs as the `locate` group.

    - **Sticky Bit - `1000` (Only for Directories)**
        - **What it does:**
            - **Prevents non-owners from deleting files inside a directory, even if they have write access.**
            - Used in **shared directories** like `/tmp`.
        - **Example Usage:**
            ```bash
            chmod 1777 /shared
            ```
            - `1` (`1000`) sets the **Sticky Bit**.
            - Resulting permission: `rwxrwxrwt`
            - **Effect:** Users can **add** files but can **only delete their own** files.
        - **Real-World Example:**
            Check `/tmp`:
            ```bash
            ls -ld /tmp
            # Output:
            drwxrwxrwt 1 root root 4096 Feb 2 12:34 /tmp
            ```
            - The `t` in `rwxrwxrwt` means the **Sticky Bit is set**.
            - Users can create files in `/tmp`, but only **the file owner can delete them**.

## User Managemnt in Linux
In Ubuntu, a new user can be added using the `adduser` or `useradd` command. Below are the steps:

- **Method 1: Using `adduser` (Recommended)** : The `adduser` command is user-friendly and interactive.
   ```bash
   sudo adduser newusername
   # Grant sudo privileges
   sudo usermod -aG sudo newusername # This adds the user to the **sudo** group, allowing administrative actions.

   # Verify the new user
   id newusername
   ```

- **Method 2: Using `useradd` (Manual Approach)** : The `useradd` command is lower-level and requires additional steps.
  ```bash
   # Create the user
   sudo useradd -m -s /bin/bash newusername
   # -m → Creates a home directory (`/home/newusername`).
   # -s /bin/bash → Sets the default shell to Bash.

   # Set a password
   sudo passwd newusername

   # Add the user to the sudo group
   sudo usermod -aG sudo newusername
   ```


### **User Creation & Management**  
```bash
# adduser
sudo adduser newusername                   # Creates a new user interactively with a home directory  
sudo adduser newusername --disabled-password  # Creates a user without setting a password  
sudo adduser newusername --gecos "Full Name, Room, Work Phone, Home Phone"  # Creates a user with specific details  

# useradd
sudo useradd -m -s /bin/bash newusername   # Creates a user with a home directory and Bash shell  
sudo useradd -m newusername                # Creates a user with a home directory and default shell  
sudo useradd -r newusername                # Creates a system user (for services, without a login shell)  
sudo passwd newusername                     # Sets or changes the user's password  
sudo passwd -l newusername                  # Locks the user account (disables login)  
sudo passwd -u newusername                  # Unlocks a locked user account  
sudo chage -d 0 newusername                 # Forces the user to change the password at next login  

# How to List All Users
cat /etc/passwd | cut -d: -f1

# Switch to the New User
su - newusername
# or  
sudo -i -u newusername
```

### **User Deletion**  
```bash
sudo deluser newusername                    # Deletes a user but keeps the home directory  
sudo deluser --remove-home newusername      # Deletes a user along with the home directory  
sudo deluser --remove-all-files newusername # Deletes a user and all their files  


sudo userdel newusername                    # Deletes a user (without removing the home directory)  
sudo userdel -r newusername                 # Deletes a user and removes their home directory  
```

### **Managing User Groups**  
```bash
sudo groupadd groupname                     # Creates a new group  
sudo groupdel groupname                     # Deletes an existing group  
sudo usermod -aG groupname newusername      # Adds a user to a group  
sudo deluser newusername groupname          # Removes a user from a group  
groups newusername                          # Displays the groups a user belongs to  
id newusername                              # Shows user ID (UID), group ID (GID), and group memberships  
```

### **Modifying Users**  
```bash
sudo usermod -aG sudo newusername           # Grants sudo privileges  
sudo usermod -G group1,group2 newusername   # Assigns multiple groups to a user (removes other groups)  
sudo usermod -s /bin/zsh newusername        # Changes the user's default shell to Zsh  
sudo usermod -d /new/home newusername       # Changes the user's home directory  
sudo usermod -l newname oldname             # Renames a user  
```

### **Switching & Managing Users**  
```bash
su - newusername                            # Switches to the new user session  
sudo -i -u newusername                      # Runs a shell as the new user  
whoami                                      # Displays the current logged-in user  
who                                          # Shows logged-in users  
w                                           # Displays active users and their processes  
```

### **Listing Users & Groups**  
```bash
cat /etc/passwd | cut -d: -f1               # Lists all users on the system  
getent passwd                               # Lists all users including system accounts  
cut -d: -f1 /etc/group                      # Lists all groups on the system  
getent group                                # Displays all groups and their members  
```


## **`su - newusername`** vs **`sudo -i -u newusername`** 

- **`su - newusername`** 
    - This starts a new shell session as `newusername`, loading their full environment
    - **Switches to the new user’s shell with a full login session.**  
    - The `-` (hyphen) ensures that the environment variables, home directory, and shell profile settings are loaded just like a normal login.  
    - Requires the **target user’s password** (i.e., `newusername`’s password), **unless run as root or with `sudo`**.  
    - **Best used when:**
        - Fully switching to another user’s environment as if logging in normally.  
        - Running commands as another user without using `sudo`.  

- **`sudo -i -u newusername`**  
    - **Starts a login shell (`-i` = interactive) as the target user.**  
    - Loads the user's environment **similar to `su -`**, but **uses `sudo` privileges instead of asking for the user's password**.  
    - Requires **sudo access** to execute.  
    - Each part of this command has a specific purpose:
        - `sudo` → Runs the command with superuser privileges.
        - `-i` (interactive login shell) → Simulates a full login session by:
            - Loading the target user’s environment variables (e.g., $HOME, $PATH).
            - Running their profile scripts (~/.bashrc, ~/.profile, etc.).
            - Setting the working directory to the target user’s home directory (/home/newusername).
        - `-u` newusername → Specifies which user to switch to.
    - Why Does sudo -i -u newusername Not Ask for the User’s Password?
        - Since sudo runs commands as root, it bypasses the need for the target user’s password.
        - Instead, it asks for your own sudo password (if required).
        - Once verified, it executes the command as root and then switches to newusername, simulating a fresh login.
    - **Best used when:**
        - Running commands as another user **without knowing their password**.  
        - Running administrative tasks as a different user.  

- **Which One to Use?**
    - If **you have sudo access** and don’t want to enter the target user's password → Use **`sudo -i -u newusername`**  
    - If **you don’t have sudo privileges but know the target user’s password** → Use **`su - newusername`**  

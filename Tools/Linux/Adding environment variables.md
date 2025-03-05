

```bash

#  Temporary (Current Session Only) 
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"

#  Permanent (User-Specific) 

# Add to ~/.bashrc (For Interactive Shells)
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.bashrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc

# Add to ~/.bash_profile (For Login Shells)
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.bash_profile
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bash_profile

# Add to ~/.profile (For Non-Bash Shells)
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.profile
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.profile

# Reload user-specific configurations
source ~/.bashrc
source ~/.bash_profile
source ~/.profile

#  Permanent (System-Wide) 

# Add to /etc/environment (For All Users - Persistent)
echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee -a /etc/environment

# Add to /etc/profile (For All Users - Login Shells)
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee -a /etc/profile
echo 'export PATH="$JAVA_HOME/bin:$PATH"' | sudo tee -a /etc/profile

# Create a script in /etc/profile.d/ for modular system-wide configuration
echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee /etc/profile.d/java.sh
echo 'export PATH="$JAVA_HOME/bin:$PATH"' | sudo tee -a /etc/profile.d/java.sh

# Reload system-wide configurations
source /etc/environment
source /etc/profile
source /etc/profile.d/java.sh

#  Manage Multiple Java Versions 
sudo update-alternatives --config java

#  Verify Java Configuration 
echo "JAVA_HOME: $JAVA_HOME"
java -version
javac -version

```

## Adding Values To Environment Variables


In **Linux**, Java can be added to environment variables in multiple ways, depending on whether it is for **temporary use**, a **specific user**, or **system-wide** access.  

#### **Temporary Method (For Current Session)**
- These settings will be **lost** once the terminal is closed.
    ```bash
    export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
    export PATH="$JAVA_HOME/bin:$PATH"
    ```
    - This sets `JAVA_HOME` for the **current session** only.  
    - `PATH` is updated so Java commands (`java`, `javac`) work from anywhere.
    -  **Use Case:** Quick temporary changes for testing.


#### **Permanent Methods (For a Specific User)**
To make Java available **permanently** for a single user, add it to shell configuration files.
- **Method 1: Add to `~/.bashrc` (For Interactive Shells)**
    ```bash
    echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.bashrc
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    ```
    - Works for **interactive shells** (e.g., when opening a new terminal).
    - **Use Case:** Java environment for a **specific user**.

- **Method 2: Add to `~/.bash_profile` (For Login Shells)**
    ```bash
    echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.bash_profile
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
    ```
    - Used when logging in via SSH or TTY.  
    - Works for **login shells**, but **not for non-login shells**.
    - **Use Case:** When logging in via SSH.

- **Method 3: Add to `~/.profile` (For Non-Bash Shells)**
    ```bash
    echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' >> ~/.profile
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.profile
    source ~/.profile
    ```
    - Works with **different shells**, including Dash and Sh.
    - **Use Case:** If using **non-Bash shells** like Dash.

#### **System-Wide Methods (For All Users)**
To set Java **globally** and permanently for all users, update system configuration files.

- **Method 4: Add to `/etc/environment` (Recommended for System-Wide Use)**
    ```bash
    echo 'JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee -a /etc/environment
    source /etc/environment
    ```
    - This does **not** require `export`.  
    - It is loaded **before user login**.
    - **Use Case:** For system-wide Java access.

- **Method 5: Add to `/etc/profile` (For All Users - Login Shells)**
    ```bash
    echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee -a /etc/profile
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' | sudo tee -a /etc/profile
    source /etc/profile
    ```
    - This applies to **all users** but **only login shells**.
    - **Use Case:** If Java is needed for all users in SSH sessions.

- **Method 6: Add to `/etc/profile.d/java.sh` (For Modular Global Settings)**
    ```bash
    echo 'export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"' | sudo tee /etc/profile.d/java.sh
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' | sudo tee -a /etc/profile.d/java.sh
    source /etc/profile.d/java.sh
    ```
    - `/etc/profile.d/` is used for modular scripts.  
    - This is the **best practice for global environment variables**.
    - **Use Case:** When multiple system-wide environment variables need to be managed separately.

- **Method 7: Using `update-alternatives` (Best for Multiple Java Versions)**
    If multiple Java versions are installed, use `update-alternatives`:
    ```bash
    sudo update-alternatives --config java
    ```
    - This allows selecting a **default Java version**.
    - **Use Case:** When managing **multiple Java versions**.



## **Summary Table**
| Method | Scope | Persistent? | Use Case |
|--------|------|------------|----------|
| `export JAVA_HOME=...` | Current session | ❌ No | Temporary changes |
| `~/.bashrc` | User-specific | ✅ Yes | Interactive shells |
| `~/.bash_profile` | User-specific | ✅ Yes | Login shells |
| `~/.profile` | User-specific | ✅ Yes | Non-Bash shells |
| `/etc/environment` | System-wide | ✅ Yes | Recommended for all users |
| `/etc/profile` | System-wide | ✅ Yes | Login shells for all users |
| `/etc/profile.d/java.sh` | System-wide | ✅ Yes | Modular system-wide approach |
| `update-alternatives` | System-wide | ✅ Yes | Multiple Java versions |

---

Would you like help with **switching Java versions** dynamically?

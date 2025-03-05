To find where a software package is installed on a Linux system, you can use different methods depending on how the software was installed. Here are some ways to locate a software’s installation path:

- **Using `which` (For Executable Binaries)**
    ```sh
    which <software_name>

    which az
    # Output: This tells you where the executable is located.
    /usr/bin/az
    ```
- **Using `whereis` (For Executables and Related Files)**
    ```sh
    whereis <software_name>

    whereis az
    # Output: It shows the binary and any related documentation.
    az: /usr/bin/az /usr/share/man/man1/az.1.gz
    ```
- **Using `type` (To Check If It’s an Alias or Built-in)**
    ```sh
    type <software_name>

    type az
    # Output: This confirms whether it's an executable or a shell alias.
    az is /usr/bin/az
    ```
- **Using `command -v` (For Shell-Recognized Commands)** : Similar to `which`, this shows where the software is located.
    ```sh
    command -v <software_name>
    command -v az
    ```
- **Using `dpkg -L` (For Debian-Based Systems like Ubuntu)**
    - If the software was installed via `apt` (Debian-based package manager):
    ```sh
    dpkg -L <package_name>
    # This lists all files installed by the package.
    dpkg -L azure-cli
    ```
- **Using `rpm -ql` (For RHEL/CentOS-Based Systems)**
    - If installed via `yum` or `dnf`:
    ```sh
    rpm -ql <package_name>
    rpm -ql azure-cli
    ```
- **Using `find` (Search for Files Manually)** : 
    - If the above methods don’t work, manually search using `find`:
    - This searches the entire filesystem for a file named `az`.
    ```sh
    sudo find / -name "<software_name>" 2>/dev/null
    sudo find / -name "az"
    ```
- **Using `ps` or `lsof` (If the Software is Running)**
    - If the software is currently running, find its location:
    ```sh
    ps aux | grep <software_name>
    lsof -c <software_name>
    ```

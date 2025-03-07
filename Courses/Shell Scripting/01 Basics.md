### **Introduction to Scripting**  

- **What is a Script?**  
A   -  **script** is simply a **sequence of system commands** stored in a file. At its most basic level, a script is nothing more than a **list of commands** that can be executed in sequence.  
    - However, scripts can be enhanced with **loops, conditionals, variables, and arguments**, making them more **powerful and flexible**.  
 
 - **Executing Basic System Commands**  
    - To begin, open a **terminal** and execute the following commonly used **system commands**:  
        - **`ls`** – Lists the contents of a directory.  
        - **`pwd`** – Prints the **current working directory**.  
        - **`date`** – Displays the current **date and time**.  
    - These commands can be typed directly into the **terminal**, and their output will be displayed immediately.  
    - However, manually retyping these commands every time can be **tedious**. Instead, a **script** can be created to automate this process.  

- **Creating a Script**
    - To automate the execution of these commands, create a new script file named **`first_script.sh`**.  
    - The **`.sh`** extension is commonly used to indicate a **shell script**. 
    - While other extensions like **`.bash`** can also be used, **`.sh`** remains the standard convention.  
    - The first line of any script should begin with a **shebang (`#!`)**, which specifies the **interpreter** that should be used to execute the script.  
    - This line is **critical**, and many **system administrators** make errors here, leading to **non-functional scripts** in production environments.  
        ```bash
        #!/bin/bash
        ```  
    - Add the previously executed **system commands** to the script file, ensuring that **each command is written on a separate line** to prevent errors:  
        ```bash
        #!/bin/bash
        ls
        pwd
        date
        ```  
    - If using **Vi/Vim**, press `ESC`, then type `:wq` and hit `Enter` to **save** and **exit** the editor.  
    - Before running the script, its **file permissions** need to be modified to allow execution. `chmod a+x <file-name.sh>`
    - Run the script using `./scriptfile.sh`



### **Understanding the Shebang (`#!/bin/bash`) and Its Importance**  


**What is a Shebang (`#!`)?**  
- The first character **`#`** is called **"sharp"** (as seen in programming languages like **C#**).  
- The second character **`!`** is commonly referred to as **"bang"**, especially in comic books, where exclamation marks indicate excitement.  
- When combined, **"sharp"** + **"bang"** forms the term **"shebang"** (sometimes written as **"shabang"**).  

**How the Shebang Works**  
- Everything that follows `#!` specifies the **interpreter** that should be used to execute the script. In this case:  
    ```bash
    #!/bin/bash
    ```  
    - This means the script will be executed using **Bash**, located at **`/bin/bash`**.  
    - When a script is executed, the system internally runs:  
    ```bash
    /bin/bash ./try.sh
    ```  
    - Here, `./` represents the **current directory**, and `/bin/bash` is the **interpreter** executing the script.  

Technically, the **shebang line is not mandatory**. If omitted, the script can still be executed by explicitly specifying the interpreter:  
```bash
bash try.sh
```  
However, in real-world scenarios, **relying on manual interpreter specification is impractical**. It is always best practice to include the **shebang** in the script itself.


**Changing the Interpreter**   

- Creating a a script file  and modify the interpreter to below
    ```bash
    #!/bin/rm
    ```  
    ```bash
    ./scriptfile.sh
    ```  
    - Upon running  , There is no output  . But when we run `ls` we see the  file **`scriptfile.sh`** is missing.  
    - Since **`/bin/rm`** is the **remove command**, the script executed `/bin/rm scriptfile.sh` effectively deleting itself. 
- If we use a non exixtant interpretor , like `#!/bin/abc`  and run it . 
    ```bash
    bad interpreter: No such file or directory
    ```  
    - This occurs because `/bin/abc` does **not exist**.  


**Using `/bin/sh` Instead of `/bin/bash`**  
- Modify the shebang line to:  
    ```bash
    #!/bin/sh
    ```  
    - Save and execute the script:  
- **Is `/bin/sh` the Same as `/bin/bash`?**  
    - Many administrators assume `/bin/sh` is a link to `/bin/bash`, but that is not always the case.  
        - Check what `/bin/sh` points to:  
            ```bash
            ls -l /bin/sh
            ```  
            - On **Ubuntu**, it typically points to **Dash**, not Bash:  
            ```bash
            /bin/sh -> dash
            ```  
            - Since **Dash** is a lightweight shell, some Bash-specific features may not work properly.  


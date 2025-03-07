## Playbooks

- Playbook is a single YAML file, containing one or more plays in a list.
- Plays are ordered sets of tasks to execute against host servers from your inventory file.
- Play defines a set of activities (tasks) to run on managed nodes.
- Task is an action to be performed on the managed node

Examples are:

    Execute a command
    Run a shell script
    Install a package
    Shutdown / Restart the hosts


- Playbook contains the following sections:

        1. Every playbook starts with 3 hyphens (---)
        2. Host section: Defines the target machines on which the playbook should run. This is based on the Ansible host inventory file.
        3. Variable section: This is optional and can declare all the variables needed in the playbook. We will look at some examples as well.
        4. Tasks section: This section lists out all the tasks that should be executed on the target machine. It specifies the use of Modules. Every task has a name which is a small description of what the task will do and will be listed while the playbook is run.

### Playboook syntax
```yaml
---
- name : this is sample playbook # name for the playbook
  hosts: all                      # mentiosn the target host groups/ips etc
  become: true                    # run as super user ie run with sudo
  gather_facts: false              # by default its true / even if not mentioed

  tasks:
    - name: task1
      <module_name>:
        <module_parameters>

    - name: task2
      <module_name>:
        <module_parameters>
```
### Tasks
Tasks are defined inside the tasks section of a play and consist of the following components:
```
name               : A human-readable name for the task, describing the action it performs.
<module_name>      : The name of the Ansible module to execute. Modules are units of code that Ansible uses to perform actions.
<module_parameters>: Parameters specific to the module, specifying what action to take.
```

### Gather Facts
refers to the process of collecting information about the target hosts before executing tasks. These facts include details about the host system, h/w information, os details, network configuration, and more.

By default, Ansible automatically gathers facts about the target hosts at the beginning of each playbook run. This information is then made available as variables that you can use in your playbooks.

The facts gathering process is performed by the Ansible module called setup. This module collects system information and stores it in a set of variables, making it available for use in subsequent tasks. The gathered facts are stored in the ansible_facts dictionary.

Here's a simple example of using the setup module to gather facts in an Ansible playbook:

```yaml
---
- name: Gather Facts Example
  hosts: your_target_hosts
  gather_facts: yes  # This is the default behavior, but you can explicitly specify it

  tasks:
    - name: Display Gathered Facts
      debug:
        var: ansible_facts
```
In this example:

The ```gather_facts: yes``` line indicates that facts gathering should be performed. It's optional because gathering facts is the default behavior.
The debug task is used to display the gathered facts using the ansible_facts variable.
After running this playbook, you will see a detailed output containing information about the target hosts, such as their IP addresses, operating system, architecture, and more.

Gathering facts is useful because it allows you to tailor your playbooks based on the characteristics of the target hosts. For example, you might use facts to conditionally execute tasks or to dynamically configure systems based on their properties.

### Anisible playbook commands
To run playbook, save it to a file (e.g., nginx_setup.yml) and run:<br>
```ansible-playbook nginx_setup.yml```<br>

to dry run <br>
```ansible-playbook nginx_setup.yml --check```<br>

for different verbose levels<br>
```ansible-playbook nginx_setup.yml -v``` <br>
```ansible-playbook nginx_setup.yml -vv``` <br>
```ansible-playbook nginx_setup.yml -vvv``` <br>

for syntax checking <br>
```ansible-playbook nginx_setup.yml --syntax-check``` <br>

list hosts that will be affected before running the playbook<br>
```ansible-playbook nginx_setup.yml --list-hosts```<br>

get confirmation before running any task in a playbook <br>
```ansible-playbook nginx_setup.yml --step```<br>

### Sample playbooks
```yaml
---
- name: check ping on all hosts
  hosts: all

  tasks:
    - name : ping hosts
      ping:
```
### to run the commands as specific user 
```yaml
# at playbook level : all task will be run by the user mention at the top
---
- name: check ping on all hosts
  remote_user: ansible     # specify the remote user (this is playbook level)
  hosts: all

  tasks:
    - name : ping hosts
      ping:

# at task level : the specific task will be run by the user mentioned
---
- name: check ping on all hosts
  hosts: all

  tasks:
    - name : ping hosts
      ping:
      remote_user: ansible     # specify the remote user (this is task level)
```

## File operations playbook
```yaml
- name : file operations
  hosts: all
  gather_facts: false

  tasks: 
    - name: create a new file
      file : # we are using file module
        path: /home/ansible/test.txt
        state: touch
    
    - name: add data to file
      blockinfile: # we are using blockinfile to add a block
        path: /home/ansible/test.txt
        #block: value  # for single line data
        block: | 
            my name is ashwein
            i am usning ansible
            for a single line use block: value
        marker: "# {mark} ANSIBLE MANAGED BLOCK"
```
- ###  file module
    file module is used for managing files and directories on remote hosts. It allows you to create, delete, or modify files and directories, set permissions, and change ownership.

    Basic Syntax:
    ```yaml
    ---
    - name: Example using file module
      hosts: target_hosts
      become: true 
      
      tasks:
        - name: Create a directory and changing ownership and permission
          file:
            path: /path/to/directory
            state: directory
            mode: 0755
            owner: ansible
            group: ansible

        - name: Create a file and changing ownership and permission
          file:
            path: /path/to/file.txt
            state: touch
            mode: 0644
            owner: ec2-user
            group: ec2-user

        - name: Remove a file
          file:
            path: /path/to/file.txt
            state: absent
    ```
    - Parameters:

            1. path: The path to the file or directory.
            2. state: The desired state of the file or directory. Possible values are directory (to ensure it's a directory), file (to ensure it's a regular file), link (to ensure it's a symbolic link), touch (to create an empty file), or absent (to remove the file or directory).
            3. mode (optional): The permission mode to set on the file or directory. It can be specified in octal format (e.g., 0755).
            4. owner (optional): The owner of the file or directory.
            5. group (optional): The group of the file or directory.

- ### blockinfile module.
    blockinfile is used to insert or update a block of content in a file. This module is particularly useful when you want to manage specific sections of configuration files without altering the rest of the file.

            - path: The path to the file where the content should be inserted or updated.
            - block: The block of content to be inserted or updated. It is specified using the YAML syntax for multiline strings (|).
            - marker (optional): A string that marks the beginning and end of the managed block. If not provided, a default marker is used.

    When Ansible runs, it checks if the specified marker is present in the file. If it is, Ansible will update the content between the markers. If the marker is not found, Ansible will insert the entire block at the end of the file.
### Register 
register is a feature that allows you to capture the output of a task and store it in a variable. This variable can then be referenced later in the playbook. The register keyword is used to specify the variable name to store the output.

Here's a simple example to illustrate the use of register.

```yaml
---
- name: Playbook with Register
  hosts: all
  gather_facts: false  # Disable facts gathering for simplicity

  tasks:
    - name: register the output
      shell: cat /home/ansible/test.txt
      register: command_output
    
    - name: display output
      debug:
        var: command_output.stdout
```
In this example:

- The first task runs a shell command and registers the output in a variable named command_output.
- The second task uses the debug module to display the standard output (stdout) of the registered variable. use stdout_lines to see the output in multiple lines

When you run this playbook, you'll see the output of the echo command displayed in the Ansible output.

- ### User module

    - The user module in Ansible is used for managing user accounts on remote hosts. It allows you to create, modify, and delete user accounts, set user-specific parameters, and manage user groups. 

    Here's an overview of the basic syntax and usage of the user module:

    ```yaml
    ---
    - name: Example Playbook with user module
      hosts: all
      tasks:
        - name: Create a user
          user:
            name: username
            state: present
            groups: user_groups
            password: "{{ 'password' | password_hash('sha512', 'mysecretsalt') }}"
            shell: /bin/bash
            comment: "Optional user comment"
            createhome: yes
    ```
    
    Parameters:

        name: The username to be managed.
        state: The desired state of the user. Possible values are present, absent, locked, and unlocked.
        groups (optional): A list of groups to which the user should belong.
        password (optional): The hashed password for the user. You can use the password_hash filter to generate a hashed password.
        shell (optional): The user's login shell.
        comment (optional): A comment or description for the user.
        createhome (optional): If set to yes, the user's home directory will be created.

    - Example Playbook:
    Here's an example playbook that uses the user module to create a user:

    ```yaml
    ---
    - name: Create a user
      hosts: target_hosts
      tasks:
        - name: Create a user
          user:
            name: john_doe
            state: present
            groups: wheel
            password: "{{ 'secretpassword' | password_hash('sha512', 'mysecretsalt') }}"
            shell: /bin/bash
            comment: "John Doe"
            createhome: yes
    ```
    - Managing User Deletion: To delete a user, set the state parameter to absent:
    ```yaml
    ---
    - name: Delete a user
      hosts: target_hosts
      tasks:
        - name: Delete a user
          user:
            name: john_doe
            state: absent
    ```
    - Managing User Modification: To modify an existing user, provide the new parameters:

    ```yaml
    ---
    - name: Modify a user
      hosts: target_hosts
      tasks:
        - name: Modify a user
          user:
            name: john_doe
            groups: admin
            shell: /bin/zsh
    ```
The user module simplifies the management of user accounts, making it easy to create, modify, and delete users on remote hosts in a consistent and idempotent way.

- ### yum module
to install 
```yaml
---
- name: install maven
  hosts: all
  become: true
  gather_facts: false

  tasks:
   - name: install maven 
     yum:
       name: maven 
       state: prsent

   - name : get maven version
     command: mvn --version
     register: mvn_version
     
   - name: display mvn version
     debug:
       var: mvn_version.stdout_lines
```

to install maven for different linux distros types
```yaml
---
- name: ionstall maven for diff distros
  hosts: all
  gather_facts: true
  become: true

  type:
  - name: update cache for os (ubuntu only)
    apt:
      update_cache: yes
    when: ansible_pkg_mgr == 'apt' # only run this task when the package manager is apt

  - name: install maven for ubuntu
    apt:
      name: maven
      state: present
    when: ansible_pkg_mgr == 'apt' # only run this task when the package manager is apt

  - name: install maven for yum bases distros
    yum:
      name: maven
      state: present
    when: ansible_pkg_mgr == 'yum' # when package manager is yum



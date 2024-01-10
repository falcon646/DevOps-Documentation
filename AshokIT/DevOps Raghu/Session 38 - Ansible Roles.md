# Anisble Roles
when we are writing anible playbooks it is not a good approach to write all the taks, vars , templates , handlers etc in a single playbook , since it can get quite cluttered and difficult to manage eg. task1: install maven , task2: instak java , task3: install jenkins etc

![playbook](images/ans-1.png)

A better approcah is to seperate non related task into their onw playbook and further seperate their vars, template , handlers etc into different yaml files. These seperated Playbooks are called as Role

![roles](images/ans-2.png)

### Roles 
Roles are a way to organize playbooks and associated files in a structured manner, promoting code reuse and modularity. Roles provide a higher-level abstraction for organizing and structuring your Ansible content. A role typically includes tasks, handlers, variables, and other files needed for a specific purpose.

Here's a breakdown of the components within an Ansible role:

1. Role Directory Structure:

    Each role is structured within a directory that follows a specific hierarchy. Common directories within a role include:
    - defaults : Contains default variables for the role.
    - files : Contains static files that need to be copied to the target hosts.
    - handlers : Contains handlers, which are tasks triggered by other tasks.
    - meta : Contains role metadata, including dependencies.
    - tasks : Contains the main tasks that the role performs.
    - templates : Contains Jinja2 templates used by tasks.
    - vars : Contains variables specific to the role.

2. Role Tasks:

    The ```tasks/main.yml``` file typically includes the main set of tasks that the role performs. This file is automatically included when the role is used in a playbook.

3. Role Variables:

    Default variables for a role are defined in the ```defaults/main.yml``` file. These variables can be overridden in playbooks.
    
4. Role Handlers:

    The handlers/main.yml file contains handlers, which are tasks that are triggered by other tasks. Handlers are defined to restart services or perform other actions in response to changes.

5. Role Templates:

    If your role involves generating configuration files dynamically, you might have a templates/ directory containing Jinja2 templates.

6. Role Dependencies:

    Dependencies on other roles are specified in the meta/main.yml file. This file lists the roles that need to be present for the current role to work correctly.

- Example Role Structure:
```plaintext
my_role/
├── defaults
│   └── main.yml
├── files
│   └── some_file.txt
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
│   └── template_file.j2
├── vars
│   └── main.yml
```

Example Role Usage in a Playbook:
```yaml
---
- name: Playbook with Ansible Role
  hosts: target_servers
  roles:
    - my_role
```
This simple playbook includes the my_role role, and Ansible automatically looks for the role in the default roles directory.

Running the Playbook: ```ansible-playbook my_playbook.yml```

Roles are especially useful for breaking down complex automation tasks into modular and reusable components. They encourage best practices in playbook organization, make your code more maintainable, and facilitate collaboration among team members. Additionally, roles can be shared with the community through Ansible Galaxy, allowing others to easily reuse and contribute to your automation code.

# Creating a Role

Creating an Ansible role involves organizing your tasks, variables, templates, and other files in a structured directory hierarchy. Below is a step-by-step guide on how to create an Ansible role. Let's assume the role is named my_role and it's intended to deploy a simple configuration file.

- Step 1 : Create the Role Directory Structure

    Create a directory for your role, and within that directory, the subdirectories for tasks, handlers, defaults, templates, and other components and placed.

    Recomendedn location : /etc/ansible/roles

    to generate a template for roles use the initi command

    ``` bash
    # initialise a role directory structure
    ansible-galaxy init <role_name>
    ```
    Your role directory structure should now look like this:
    ```plaintext
    roles/
    └── httpd
        ├── README.md
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml
    ```
- Step 2: Define Variables

    In the vars directory, create a main.yml file to define variables for your role.

    ```yaml
    # roles/httpd/vars/main.yml
    package_name: "httpd"
    ```
 - Step 3: Define Tasks

    In the tasks directory, create a main.yml file to define the main tasks for your role.

    ```yaml
    # roles/httpd/tasks/main.yml
    ---
    - name: install httpd
      yum:
        name: "{{ package_name }}"
        state: present
      tags:
        - install
      notify: start httpd

    - name: copy index.html
      copy:
        src: index.html
        dest: /var/www/html
      tags:
        - copy
      notify: restart httpd
    ```
 - Step 4: Define Handlers

    In the handlers directory, create a main.yml file to define handlers that respond to specific events.

    ```yaml
    # roles/httpd/handlers/main.yml
    - name: start httpd
      service:
        name: "{{ package_name }}"
        state: started
        enabled: true
    - name: restart httpd
      service:
        name: "{{ package_name }}"
        state: restarted
    ```
 - Step 5: (Optional) Define Meta Dependencies

    In the meta directory, create a main.yml file if your role has dependencies on other roles.

    ```yaml
    # roles/my_role/meta/main.yml
    ---
    dependencies:
    - { role: other_role }
    ```
 - Step 6: Create Templates (optional)

    In the templates directory, create a Jinja2 template for the configuration file.

    ```bash
    # roles/httpd/templates/my_config.j2
    # Configuration file content with variables
    MyVariable = "{{ my_role_variable }}"
    ```

 - Step 7: Use the Role in a Playbook

    Create a playbook that uses your role. Let's name it httpd_playbook.yml. Include any other roles if required. this can be in any location

    ```yaml
    # httpd_playbook.yml
    ---
    - name: Httpd Setup Playbook
      hosts: all
      become: true
      roles:
        - httpd
        - jenkins # optional
        - maven  # optional
    ```

 - Step 8: create an index.html file and place it under the ```roles/httpd/files/``` directory
Run your playbook to execute the tasks defined in your role.

 - Step 9: Run the Playbook

    Run your playbook to execute the tasks defined in your role.

    ```bash
    ansible-playbook httpd_playbook.yml
    ```
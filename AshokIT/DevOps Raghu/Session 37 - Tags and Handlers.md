# Tags
Tags are labels that you can assign to tasks, making it possible to selectively run or skip specific tasks when executing a playbook. 

Tags are useful when you want to focus on specific parts of your playbook during development, testing, or maintenance.

Here's how you can use tags in your playbook:

- Assigning Tags to Tasks
    ```yaml
    ---
    - name: Example Playbook with Tags
    hosts: localhost
    tasks:
        - name: Task 1
        debug:
            msg: "This is task 1"
        tags:
            - debug_output

        - name: Task 2
        debug:
            msg: "This is task 2"
    ```
    In this example, "Task 1" has been assigned the tag debug_output.

- commands
    ```bash
    # list all tags
    ansible-playbook your_playbook.yml --list-tags

    # Running Tasks with Specific Tags
    ansible-playbook your_playbook.yml --tags debug_output

    # selecting multiple tags
    ansible-playbook your_playbook.yml --tags "tag1,tag2"

    #Excluding Tasks with Specific Tags
    ansible-playbook your_playbook.yml --skip-tags debug_output

    # To debug and see which tags are being applied during playbook execution
    ansible-playbook your_playbook.yml --tags "tag" -v
    ```

# Handlers & Notify
- Handlers are special tasks that are only executed when notified by other tasks. They are typically used to perform actions such as restarting a service or reloading a configuration file when a change requires it.
- The notify keyword is used within a task to specify which handler should be triggered if that task makes changes. When a task specifies notify: Some Handler, it means that if the task result changes, the associated handler (Some Handler in this case) will be triggered.

Example
```yaml
---
- name: install and start httpd
  hosts: all
  become: true

  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: present
      notify: start httpd service

  handlers:
    - name: start httpd service
      service:
        name: httpd
        state: started
```
Explaination

 - Notify Keyword:

    The notify: start httpd service line indicates that if the task "install httpd" makes any changes (e.g., installs the httpd package), it should notify the handler named "start httpd service."
- Handlers Section:

    The handlers section defines a handler named "start httpd service."
    This handler uses the service module to start the httpd service (name: httpd, state: started).

- How It Works:

    When the task "install httpd" makes changes (installs the httpd package), it triggers the handler "start httpd service" because of the notify keyword.
    At the end of the playbook, Ansible checks for any pending handlers and runs them. In this case, it starts the httpd service.

- Usage Scenario:

    This playbook is useful when you want to ensure that the Apache HTTP server (httpd) is installed and started on all hosts. If the package installation task makes changes, it triggers the handler to start the service.

Note:
Handlers are a way to link tasks and actions that should be taken in response to changes during playbook execution.
Using handlers with notify helps organize and control the order of tasks, especially when one task depends on the result of another.

Another example
```yaml
---
- name: httpd setup
  hosts: all
  become: true

  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: present
      notify: start httpd
    - name: copy index.html
      copy:
        src: index.html
        dest: /var/www/html/index.html
      notify: restart httpd
  handlers:
    - name: start httpd
      service:
        name: httpd
        state: started
    - name: restart httpd
      service:
        name: httpd
        state: restarted
```
- When Handlers Are Run:
    - Notification Occurs: A task in the playbook notifies a specific handler using the notify keyword.
    Example: notify: restart httpd
    - Task Makes Changes: The notifying task must make changes to the system during playbook execution.
    Changes can include installing packages, modifying configuration files, etc.
    - End of Playbook Execution: Handlers are executed at the end of the playbook run, after all tasks have been processed.
    - Task Resulting in Changes Exits Successfully: The task notifying the handler should exit successfully. If the task fails, the handler is not executed.

- When Handlers Are Not Run:
    - No Notification: If no task notifies a handler, the handler is not executed.
    - Tasks Do Not Make Changes: If tasks do not make any changes during playbook execution, even if they are notified, handlers associated with them are not executed.
    - Tasks Notify Handlers, but Changes Do Not Occur: If a task notifies a handler, but the task itself does not result in any changes, the handler is not executed.
    - Tasks Fail to Complete Successfully: If a task notifying a handler fails to complete successfully, the associated handler is not executed.




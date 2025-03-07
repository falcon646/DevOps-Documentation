### install git and clone repo playbook
whenever you run a command , it will retur a status code.

0 => sucess
non zero => error
```yaml
---
- name: install git if not present and clone repo
  hosts: all
  gather_facts: false
  become: true

  tasks:
    - name: check git version
      command: git --version
      register: git_check # to store the return code of the above command in register
      ignore_errors: true # to continue execution even if error comes 

    - name: install git
      yum:
        name: git
        state: present
      when: git_check.rc != 0 # only run this task when the git version returns error (rc means return code)

    - name: clone git repo
      git:
        repo: https://github.com/javabyraghu/maven-web-app.git
        dest: /home/ansible/web-app
```        

### install httpd , copt index.html , start htpd service
- create a index.html on the master node
```yaml
---
- name: setup webserver
  hosts: all
  become: true
  gather_facts: true

  tasks:
    - name: install httpd
      yum:
       name: httpd
       state: present
    
    - name: place index.html in /var/www/html
      copy:
        src: index.html
        dest: /var/www/html/index.html

    - name: enable httpd servuce
      service:
        name: httpd:
        enabled: true # enable the servive to start on boot
    
    - name: start httpd service
      service:
        name: httpd
        state: started
```
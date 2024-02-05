# Ansible Setup
- A simple and faster way to setup ansible
- Using SSH authentication instead of password authetication

Execute below commands in master:
```bash
# Install Python and PIP for Ansible Runtime
sudo yum install python3 -y
python3 --version
sudo yum install python3-pip -y

# Install Ansible
pip3 install ansible --user
ansible --version

# create ansible root directory 
sudo mkdir /etc/ansible

# create ansible configuration and inventory files
    # ansible.cfg
sudo vi /etc/ansible/ansible.cfg
# copy the below 3 lines and paste in yout ansible.cfg file ( remove the comments from the actual file)

[defaults]
inventory = /etc/ansible/aws.ini # to specify the location of hosts file
sudo_user = ec2-user # to specify the user

# aws.ini
sudo vi /etc/ansible/aws.ini
# create the inventory file by adding the host details and the pem key like below
[web]
web1 ansible_ssh_host=3.84.124.82 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/test.pem
web2 ansible_ssh_host=x.x.x.x ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/test.pem

[db]
db1 ansible_ssh_host=44.201.249.80 ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/test.pem

# Test Ansible and after installation successful

ansible all --list-hosts
ansible ungrouped --list-hosts
ansible webservers --list-hosts
ansible dbservers --list-hosts
ansible webservers[0] --list-hosts
ansible webservers[1] --list-hosts
```

- the inventory file can also be represented in yaml format
```yaml
all:
  hosts:
    ungrouped_host:
      ansible_ssh_host: host4_ip
      ansible_ssh_user: ec2-user
      ansible_ssh_private_key_file: /path/to/your/private-key.pem

  children:
    web:
      hosts:
        web1:
          ansible_ssh_host: host1_ip
          ansible_ssh_user: your_ssh_user
          ansible_ssh_private_key_file: /path/to/your/private-key.pem
        web2:
          ansible_ssh_host: host2_ip
          ansible_ssh_user: your_ssh_user
          ansible_ssh_private_key_file: /path/to/your/private-key.pem

    db:
      hosts:
        db1:
          ansible_ssh_host: host3_ip
          ansible_ssh_user: your_ssh_user
          ansible_ssh_private_key_file: /path/to/your/private-key.pem
```
Explanation:

- Top-level Section (all): This is the default group that includes all hosts. In this case, there is one ungrouped host (ungrouped_host).

- Host Definitions: Each host has specified SSH connection details like ansible_ssh_host, ansible_ssh_user, and ansible_ssh_private_key_file.

- Child Groups (web and db): These are groups that contain subsets of hosts. In this case, the web group has web1 and web2 hosts, and the db group has the db1 host.

- This inventory file is correctly structured and defines three hosts (ungrouped_host, web1, web2, and db1) with their respective connection details and groupings


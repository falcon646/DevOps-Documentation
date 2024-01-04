## Ansible Setup:
Create 3 Amazon Linux Instances of type t2.micro (Free tier eligible)

1 Control Node & 2 or more Managed Nodes

Execute below commands in alll nodes:
```bash
# Create one new user 
sudo useradd ansible
sudo passwd Ansible

# Provide sudoer permission
sudo visudo
# add below lines
ansible ALL=(ALL) NOPASSWD: ALL

# Activate Password Authentication YES
vi /etc/ssh/sshd_config
PasswordAuthentication yes  # (by default value would be no, change to yes)

# Restart sshd service
$ sudo systemctl restart sshd

# Switch to Ansible user
$ sudo su - ansible
```
Execute below commands only on master node
```bash
# Generate a new KEY-PAIR using SSH
ssh-keygen

# Copy Public Key (Authorized Keys) into Managed Nodes
ssh-copy-id ansible@<ManagedNode-Private-IP>
# eg : ssh-copy-id ansible@172.31.8.95
#make sure port 22 is open for SSH (Anywhere)

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

# copy the entire ansible.cfg file from https://github.com/ansible/ansible/tree/stable-2.9/examples , paste it your local file and Uncomment below lines
inventory = /etc/ansible/hosts # to specify the location of hosts file
sudo_user = ansible # to specify the user
# or just copy the above 2 lines and paste in yout ansible.cfg file

    # hosts
sudo vi /etc/ansible/hosts
# copy the contents of the host file from https://github.com/ansible/ansible/tree/stable-2.9/examples and paste i your hosts file and update the ip address and domain names
65.0.205.235
[webserver]
13.234.239.70
13.234.239.71
# or just create the hosts file by adding the ip address and domain names of your machines

# Test Ansible and after installation successful

ansible all --list-hosts
ansible ungrouped --list-hosts
ansible webservers --list-hosts
ansible dbservers --list-hosts
ansible webservers[0] --list-hosts
ansible webservers[1] --list-hosts
```

### types of ansible commands:
1. ad-hoc
2. playbook

## Ansible modules
1. ping modules: to check connectivity between master and managed nodes
2. shell module: to excute shell comands
3. yum/apt modules : package manager modules 

### ANSIBLE AD-HOC COMMANDS
Switch to ansible user and run ansible ad-hoc commands 

```sudo su ansible```

To run any ansible command we will follow below syntax:

```ansible [ all / groupName / HostName / IP ] -m <<Module Name>> -a <<args>>```

Note: Here -m is the module name and -a is the arguments to module.

Example:
```bash
# ping all managed nodes listed in host inventory file
ansible all -m ping

#ping only webservers listed in host inventory file
ansible webservers -m ping

#ping only dbservers listed in host inventory file
ansible dbservers -m ping

# display date from all host machines.
ansible all -m shell -a date 

# display uptime from all host machines.
ansible all -m shell -a uptime
```
There are two default groups
1. all :  contains every host
2. ungrouped : contains all hosts that don’t have another group
```bash
# display the all the modules available in Ansible.
ansible-doc -l

# display particular module information
ansible-doc <moduleName>

# To display shell module information
ansible-doc shell

# display details of copy module
ansible-doc -l | grep "copy"

# display information about yum module
$ ansible-doc yum


# PING MODULE:
# It will ping all the servers which you have mentioned in inventory file (/etc/ansible/hosts)
ansible all -m ping

# It will display the output in single line.
ansible all -m ping -o

# SHELL MODULE: To execute all shell commands 
# Date of all machines
ansible all -m shell -a 'date' 

# Release of all the machines
ansible all -m shell -a 'cat /etc/*release' 

# Check the service status on all the machines
ansible all -b -m shell -a 'service sshd status' 

# Here it will check the disk space use for all the nodes which are from db servers group
ansible dbservers -b -m shell -a "df -h" 

# Here it will check the disk space use for all the nodes which are from webservers group
ansible webservers -b -m shell -a "free -m"

# display date from from webservers group
ansible webservers -b -m shell -a "date"

# YUM MODULE:

# install vim package in all node
ansible all -b -m yum -a "name=vim"

# Check git version in all machines
ansible all -m shell -a "git --version"

# to install git client in all node machines
ansible all -m shell -b -a "yum install git -y"

# installl git only in webserver nodes
ansible webservers -m shell -b -a "yum install git -y"

# install webserver only in particular machine
ansible 172.1921.1.0 -m shell -b -a "yum install git -y"

# for packagemenagemnt using yum modules , use below states
# present : install , latest : update to latest , absent : uninstall
ansible all -m yum -b -a "name=git state=present"
ansible all -m yum -b -a "name=git state=latest"
ansible all -m yum -b -a "name=git state=absent"


# APT MODULE : to install any software in ubuntu server
# install git in ubuntu server
ansible all -m apt -a "name="git state="present"

# To install httpd package in all node machines
ansible all -b -m yum -a "name=httpd state=present"

# Note: Here state=latest, is not a mandatory, it is by default.

# update httpd package in all node machines. 
ansible all -b -m yum -a "name=httpd state=latest" 

# remove httpd package in all node machines.
ansible all -b -m yum -a "name=httpd state=absent" 
ansible all -m copy -a "src=index.html dest=/var/www/html/index.html"

# start httpd service 
ansible all -b -m service -a "name=httpd state=started"
ansible all -b -m shell -a "service httpd start"

## Note: For privilege escalations we can use -b option (sudoer permissions)
```

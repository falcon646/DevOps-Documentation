# ANSIBLE

Ansible is an open-source automation tool that is widely used for configuration management, application deployment, task automation, and orchestration. It is developed by Red Hat and is designed to simplify complex IT tasks, making them more manageable and repeatable.

Key features of Ansible include:

- Agentless Architecture: Ansible operates in an agentless manner, meaning it doesn't require any agent software to be installed on the managed nodes. It communicates with remote servers over SSH (Secure Shell) or other transport protocols.
- Declarative Language: Ansible playbooks, which are the configuration files written in YAML, describe the desired state of a system rather than specifying the sequence of steps to achieve that state. This declarative approach makes playbooks easy to read, understand, and maintain.
- Idempotency: Ansible is designed to be idempotent, which means that running a task multiple times produces the same result as running it once. This ensures that the system is always in the desired state, regardless of how many times the playbook is executed.
- Extensibility: Ansible is extensible and supports a wide range of modules that can be used to interact with various systems, services, and APIs. Modules can be written in various programming languages.
- Inventory Management: Ansible uses an inventory file to define the hosts or nodes it will manage. The inventory can be static or dynamic, and it allows you to organize and categorize your infrastructure.
- Playbook Execution: Ansible playbooks consist of one or more plays, each containing a set of tasks. Playbooks are executed on the control node, and Ansible communicates with the managed nodes to apply the specified configurations.
- Community and Ecosystem: Ansible has a large and active community that contributes to the development of modules, playbooks, and roles. This results in a rich ecosystem of reusable automation content.


### CONFIGURATION MANAGEMENT:
Configuration management is a set of processes and tools used to systematically manage changes to software, hardware, or any other system throughout its lifecycle. It involves tracking and controlling the configuration of items within a system, ensuring consistency and integrity, and providing the ability to trace and audit changes.

It is a method through which we automate admin tasks. Configuration management tool turns your code into infrastructure. So your code would be testable, repeatable and version able.

Infrastructure refers to the composite of: Software, Network, Storage and Process.

#### ANSIBLE:

    1.	Ansible is one among the DevOps configuration management tools which is famous for its simplicity.
    2.	It is an open source software developed by Michael DeHaan and its ownership is on RedHat
    3.	Ansible is an open source IT Configuration Management, Deployment & Orchestration tool.
    4.	This tool is very simple to use yet powerful enough to automate complex multi-tier IT application environments.
    5.	Ansible is an automation tool that provides a way to define infrastructure as code.
    6.	Infrastructure as code (IaC) simply means that managing infrastructure by writing code rather than using manual processes.
    7.	The best part is that you don’t even need to know the commands used to accomplish a particular task.
    8.	You just need to specify what state you want the system to be in and Ansible will take care of it.
    9.	The main components of Ansible are playbooks, configuration management and deployment.
    10.	Ansible uses playbooks to automate deploy, manage, build, test and configure anything
    11.	Ansible is developed using Python Programming language.



#### ANSIBLE FEATURES:

    - Ansible manages machines in an agent-less manner using SSH
    - Built on top of Python and hence provides a lot of Python's functionality
    - YAML based playbooks
    - Uses SSH for secure connections
    - Follows push based architecture for sending configuration related notifications

#### PUSH BASED VS PULL BASED:
    - Tools like Puppet and Chef are pull based 
    - Agents on the server periodically checks for the configuration information from central server (Master)
    - Ansible is push based 
    - Central server pushes the configuration information on target servers.

#### HOW ANSIBLE WORKS?

- Ansible works by connecting to your nodes and pushing out a small program called Ansible modules to them.

- Then Ansible executed these modules and removed them after finished. The library of modules can reside on any machine, and there are no daemons, servers, or databases required.

- The Management Node is the controlling node that controls the entire execution of the playbook.

- The inventory file provides the list of hosts where the Ansible modules need to be run.

- The Management Node makes an SSH connection and executes the small modules on the hosts machine and install the software.

- It connects to the host machine executes the instructions, and if it is successfully installed, then remove that code in which one was copied on the host machine.

Ansible basically consists of three components

1) Controlling Node
2) Managed Nodes
3) Ansible Playbook

1. Controlling Nodes are usually Linux Servers that are used to access the switches/routers and other Network Devices. These Network Devices are referred to as the Managed Nodes.

2. Managed Nodes: (Host Machines)
Managed Nodes are stored in the hosts file for Ansible automation.

3. Ansible Playbook:
Ansible Playbooks are expressed in YAML format and serve as the repository for the various tasks that will be executed on the Managed Nodes (hosts).
Playbooks are a collection of tasks that will be run on one or more hosts.


#### Host Inventory file: 
- Ansible's inventory hosts file is used to list and group your servers.
- Its default locaton is /etc/ansible/hosts
- Note: In inventory file we can mention IP address or Hostnames also.

INVENTORY FILE IMPORTANT POINTS:

    a.	Comments begins with '#' character
    b.	Blank lines are ignored.
    c.	Groups of hosts are delimited by '[header]' elements
    d.	You can enter hostnames or IP-addresses
    e.	A hostname/IP can be a member of multiple groups
    f.	Ungrouped hosts are specifying before any group headers like below

Ansible inventory hosts file is used to list and group your servers. Its default location is ```/etc/ansible/hosts```


SAMPLE INVENTORY FILE:
```yaml
#Blank lines are ignored
#Ungrouped hosts are specified before any group headers

192.168.122.1
192.168.122.2
192.168.122.3

[webservers]
192.168.122.1
192.168.122.2
192.168.122.3

[dbserver]
192.168.122.1
192.168.122.2
Raghuit-db1.com
Raghuit-db2.com
```

sid: 45
sname: ashwin
course:
    - devops
    - springboot
    - iac
location:
    name: trilangs
    pincode: 462039




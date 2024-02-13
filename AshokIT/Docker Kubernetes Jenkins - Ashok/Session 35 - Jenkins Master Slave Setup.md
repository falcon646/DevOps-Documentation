# Jenkins Master Slave Setup
Steps to setup Jenkins Master Slave Archicture

- Create a master node
    - Follow the normal jenkins server installation steps to create the master node
- Creating a Slave node
    - Create ec2 instance
    - install git
        ```yaml
        sudo apt update
        sudo apt install git -y
        ```
    - install java
        ```yaml
        sudo apt update
        sudo apt install default-jdk -y
        ```

- create a directory in `/home/ubuntu` which will act as root directory for the slave machine eg `/home/ubuntu/jenkins`
    - note: jenkins is not required to be install in the slave machine

- Configuring the slave nodes on the master node
    - goto jenkins dashboard -> manager jenins -> Manage nodes and cloud
    - click new node -> enter name -> Select permanent agent
    - enter remote root directory path that we added in the slave node
    - add label -> select launch agent via ssh 
    - give host as "slave vm dns url" by pasting the public dns url of the ec2 machine
    - add credentials (select kind as : ssh username with private key)
    - enter username as ubuntu
    - select private ket as enter drectly and copy the private key contents there
    - select host key strategy as "manually trusted key verification strategy"
    - apply and save
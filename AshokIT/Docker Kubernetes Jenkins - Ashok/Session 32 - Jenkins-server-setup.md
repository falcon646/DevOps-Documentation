# Jenkins Server Setup
- Create Ubuntu VM using AWS EC2 (t2.medium)
- Enable SSH & 8080 Ports in Ec2 Security Group
- Install Java & Jenkins using below commands
    ```bash
    sudo apt-get update <br/>
    sudo apt-get install default-jdk <br/>
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null <br/>
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null <br/>
    sudo apt-get update <br/>
    sudo apt-get install jenkins <br/>
    sudo systemctl status jenkins <br/>
    ```
- Copy jenkins admin pwd <br/>
	`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Open jenkins server in browser using VM public ip <br/>
    URL : `http://public-ip:8080/`
- Create Admin Account & Install Required Plugins in Jenkins
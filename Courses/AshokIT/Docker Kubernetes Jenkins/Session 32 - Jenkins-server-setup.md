# Jenkins Server Setup
- Create Ubuntu VM using AWS EC2 (t2.medium)
- Enable SSH & 8080 Ports in Ec2 Security Group
- Install Java & Jenkins using below commands
    ```bash
    sudo apt-get update
    sudo apt-get install default-jdk
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    sudo systemctl status jenkins
    ```
- Copy jenkins admin pwd : `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Open jenkins server in browser using VM public ip : URL : `http://public-ip:8080/`
- Create Admin Account & Install Required Plugins in Jenkins
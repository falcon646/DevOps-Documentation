## JENKINS
- Jenkins is an open-source automation tool written in Java programming language that allows continuous integration. 
- Jenkins offers a straightforward way to set up a continuous integration or continuous delivery environment for almost any combination of languages and source code repositories using pipelines, as well as automating other routine development tasks.

The following are the main or most popular Jenkins use cases:
- Continuous Integration: With Jenkins pipelines, we can achieve CI for both applications and infrastructure as code.
- Continuous Delivery: You can set up well-defined and automated application delivery workflows with Jenkins pipelines.

Jenkins achieves CI (Continuous Integration) and CD (Continuous Deployment) with the help of plugins. Plugins are used to allow the integration of various DevOps stages. If you want to integrate a particular tool, you must install the plugins for that tool.

Features : 

    - It is an open-source tool.
    - It is free of cost.
    - It does not require additional installations or components. Means it is easy to install.
    - Easily configurable.
    - It supports 1000 or more plugins to ease your work. 
    - If a plugin does not exist, you can write the script for it and share with community.
    - It is built in java and hence it is portable.
    - It is platform independent.
    - Easy support since its open source and widely used.
    - Jenkins also supports cloud-based architecture so that we can deploy Jenkins in cloud-based platforms.

## Installation
- on RHEL/Centos/Amazon Linux:
```bash
# Download lates jenins repo
# https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# import jenkins key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# Upgrade the existing packages in the instance.
sudo yum upgrade
# Install openjdk-11 as a dependency for Jenkins package for RHEL and old Amazon Linux.
sudo yum install java-11-openjdk -y
# for Amazon Linux 2023
sudo yum install java-11-amazon-corretto -y
# Install Jenkins from the repository.
sudo yum install jenkins -y
# Reload the daemon for effecting the changes.
sudo systemctl daemon-reload

# Starting and enabling Jenkins:
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status Jenkins
sudo systemctl stop Jenkins

# access jenkins with the ip and port 8080
http://<IP>:8080/ 
# If there is a firewall enabled on your instance and preventing the connection to port 8080, disable the firewalld or add exception to Jenkins for port 8080.
# default password is present at
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword	
# select Install the suggested plugins.
# Add the Admin details and credentials to save it.
``` 
- NOTE: If you forget the password, then change no security tag to “false” in /var/lib/jenkins/config.xml

- Jenkins Home Directory in EC2 is at: ```/var/lib/jenkins/workspace/```


# Jenkins Jobs:

## PROJECT-1 : CREATING FIRST JOB IN JENKINS:

1. on the jenkins dashboard , Click on New Item

        Enter Item Name (Job Name)
        Select Free Style Project & Click OK
        Enter some description.
        Click on 'Build' tab.
        Click on 'Add Build Step' and select 'Execute Shell'.

2. Enter below shell script && Apply and Save
```bash
echo "Welcome to All"
touch raghu.txt
echo "Hello All, Welcome to Jenkins Sessions" >> raghu.txt
echo "Completed..!!"
```
3. Click on 'Build Now' to start Job execution and see the console output

4. Go to Jenkins home directory and check for the job name , then check the file created inside the job


## PROJECT-2: JENKINS JOB WITH GIT HUB REPO + MAVEN - INTEGERATION

Pre requisities :  java , maven , git

    Either you can install these 3 softwares in the ec2 machine directly 
    or you can configure them in jenkins global tools to automatically install it i the machine(but only accessible for the jenkins context)
Jdk installation in jenkins using plugin

    Jenkins Dashboard -> Manage Jenkins -> Global Tools Configuration -> Add JDK -> Choose JDK 8 -> Configure Oracle account credentials to download JDK.

MAVEN INSTALLATION IN JENKINS: 

    Jenkins Dashboard -> Manage Jenkins --> Global Tools Configuration -> Add maven -> select version -> (have sure install automatically is selected)

Sample GitHub Repo For Practise

Git Hub Repo URL-1 : https://github.com/javabyraghu/maven-web-app.git

Steps To Create Jenkins Job with GubHub + Maven

1.  On the jenkins dashboard , Click on New Item

        1. New Item
        2. Enter Item Name (Job Name)
        3. Select 'Free Style Project' & Click OK
        4. Enter some description.
        5. Go to "Source Code Management" Tab and Select "Git"
        6. Enter Project "GitHub Repository URL" 
        7. Add Your GitHub account credentials and branch details
        8. Go to "Build tab"
        9. Click on Add Build Step and Select 'Invoke Top Level Maven Targets'
        10. Select Maven and enter goals 'clean package'.
        11. Click on Apply and Save

2. Click on 'Build Now' to start Job execution

3. Click on 'Build Number' and then click on 'Console Output' to see job execution details.


## PROJECT-3: JENKINS JOB WITH GIT REPO + MAVEN + TOMCAT SERVER

Pre-requisite:
    1. java , maven , git
    2. Install Java and Tomcat – 9 (on different EC2 Instance)

1. Tomcat ec2 configuration : Go to Tomcat server folder and configure below users in "tomcat-users.xml" file (it will be available in tomcat / conf folder) . we need to provide the manager-script username and password in jenkins later on for authetication
    ```xml
    <role rolename="manager-gui" />
    <role rolename="manager-script" />
    <role rolename="admin-gui" />

    <user username="tomcat" password="tomact" roles="manager-gui" />
    <user username="admin" password="admin" roles="manager-gui,manager-script,admin-gui"/>
    ```

2. On the Jenkins Dashboard.

        1. Manage Jenkins
        2. Manage Plugins
        3. Go to Available Tab
        4. Search For "Deploy To Container" Plugin
        5. Install without restart.

3. Create Jenkins new Job 

        1. Select Free Style Project & Click OK
        2. On the "Source Code Management" Tab and Select "Git" & enter Project "GitHub Repository URL
        3. Add Your GitHub account credentials.
        4. On the build tab , Click on Add Build Step and Select 'Invoke Top Level Maven Targets'
        5. Select Maven and enter goals 'clean package'.
        6. Click on 'Post Build Action' and Select 'Deploy war/ear to container' option.
        7. Give path of war file (if you dont know the exact path , then use : **/*.war )
        8. Enter Context Path (give project name)
        9. Click on 'Add Container' and select Tomcat version 9.x
        10. Add Tomcat server credentials ie username &  password of manager-script role configured in tomcat-users.xml 
        11. Enter Tomcat Server URL (http://ec2-vm-ip:tomcat-server-port)
        12. Click on Apply and Save

4. Run the job now using 'Build Now' option and see 'Console Output' of job.

5. Once Job Executed successfully, go to tomcat server dashboard, and see application access the application deployed.



## Project 1: deploying a Maven Web application on Tomcat server

### Setup apache maven
```bash
#Install updates to linux instance	
sudo yum update -y 

#Install openjdk-11	
sudo yum install java-11-openjdk -y # for rhel
sudo yum install java-11-amazon-corretto -y # for amazonlinux2023
#Verify the JAVAHOME link	
readlink -f $(which java)
#Install wget utility	
sudo yum install git wget -y
# Download the latest version of Apache-Maven	
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz -P /tmp
#Extract the maven tar file to ‘/opt’	
sudo tar xvzf /tmp/apache-maven-3.9.1-bin.tar.gz -C /opt
#Rename the extracted directory to /opt/maven
sudo mv  /opt/apache-maven-3.9.1 /opt/maven
# or create a soft link maven in /opt directory	
sudo ln -s /opt/apache-maven-3.9.1 maven
#Add the environment variables in ‘/etc/profile.d/maven.sh’ file	
sudo vi /etc/profile.d/maven.sh
# add below lines
export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}
# change the permissions of maven.sh file to executable	
sudo chmod +x /etc/profile.d/maven.sh
# Run the ‘maven.sh’ file with source	
source /etc/profile.d/maven.sh
```

### Setup tomcat server
```bash
# download apache tomcat https://tomcat.apache.org/download-90.cgi 
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.84/bin/apache-tomcat-9.0.84.tar.gz -P /tmp

# Extrat the contents of the tarball to ‘/opt’ directory	
sudo tar xvzf /tmp/apache-tomcat-9.0.84.tar.gz -C /opt

# Rename the extracted directory in ‘/opt’ to ‘tomcat’	
sudo mv /opt/apache-tomcat-9.0.84 /opt/tomcat

# Create user and group ‘tomcat and update ownnership of /opt/tomcat
sudo useradd tomcat
sudo chown -R tomcat:tomcat /opt/tomcat

# Make the binary files of tomcat as executable	
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'

# Verify the JAVA_HOME environment variable to be added to ‘tomcat.service’ file	
readlink -f $(which java)
# copy /usr/lib/jvm/java-11-openjdk-11.0.18.0.10-1.el7_9.x86_64

#create tomcat service
sudo vi /etc/systemd/system/tomcat.service
#Add the below to ‘tomcat.service’ file with proper JAVA_HOME variable	
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.19.0.7-1.el9_1.x86_64/"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target

#Reload the system daemon	
sudo systemctl daemon-reload

# Enable tomcat service to run at startup	
sudo systemctl enable tomcat

# Start the tomcat service	
sudo systemctl start tomcat

# below firewall commands should only be performed on bare metal servers not on the cloud servers
#Install firewalld if not already installed	
sudo yum install firewalld -y
#Enable firewalld to run at startup (good practice)	
sudo systemctl enable firewalld
# Start firewalld service	
sudo systemctl start firewalld
# Add an exception to port 8080 which is presently being used by tomcat application in this project	
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
# Reload the firewall to apply the exception to port 8080	
sudo firewall-cmd --reload


# Edit the tomcat-users.xml file to add new roles ‘admin-gui’ and ‘manager-gui’ and user credentials for both the roles	
sudo vi /opt/tomcat/conf/tomcat-users.xml

# Add the following roles in the file:
    <role rolename="admin-gui"/>
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <user username="admin" password="admin" roles="admin-gui,manager-gui,manager-script"/>

# Add your system IP into the allow rules for Manager and Host-manager pages of tomcat application	
sudo vi /opt/tomcat/webapps/manager/META-INF/context.xml
    # Add your system IP to the allow list (or .* at the end of Value)

sudo vi /opt/tomcat/webapps/host-manager/META-INF/context.xml
    # Add your system IP to the allow list (or .* at the end of Value)
    
# Restart tomcat service to apply the updated  changes 	
sudo systemctl restart tomcat
```

### Deploying the application to the webserver
- pull the code into the server using git
- cd inside the project to th path containing the pom.xml
- run maven command to generate the .war file ``` mvn clean package```
- copy the .war file generated to the tomcat webaps directory ```sudo cp ./target/<name>.war /opt/tomcat/webapps/
- access the app on the browser using public ip
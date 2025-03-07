## Environment Setup:

Requirements
- SonarQube requires a machine with a minimum of 2 CPU cores and 2 GB of RAM.
- Recommended to have at least 4 CPU cores and 8 GB of RAM for performance.
- Disk space requirements depend on the number of projects and the size of the codebase being analyzed. A minimum of 1 GB of free disk space is recommended.
- Make sure you have a compatible JDK installed and configured properly.
    - SonarQube requires Java to be installed on the machine.
    - SonarQube 9.0 and later versions require Java 11 or later.
    - SonarQube 8.x versions support Java 11 
- Database:
    - SonarQube requires a database to store analysis results and other data.
    - Supported databases include PostgreSQL, Microsoft SQL Server, Oracle, and MySQL.
    - SonarQube also supports the use of an embedded database (H2) for evaluation or small setups, but it is not recommended for production environments.
- SonarQube requires network connectivity to download plugins, updates, and dependencies during installation and runtime.
- Ensure that the server has access to the internet or the necessary network resources.

### SonarQube Installation in Amazon Linux 2023:
 - we will use EC2 instance with 4 GB RAM (t2.medium)
 - Check space (free -h)
```bash 
# Switch to root user
sudo su -
# Install JDK 11
yum install java-11-amazon-corretto -y
# Download SonarQube 8.9 LTS
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip -P /tmp 
# Unzip to /opt location
unzip /tmp/sonarqube-8.9.10.61524.zip -d /opt
# Rename to sonarqube (remove version for better naming)
mv /opt/sonarqube-8.9.10.61524/ /opt/sonarqube
# Create user sonar (we cannot run sonarqube as root user)
useradd sonar
# Modify Sudoer file to use sonar user without password
visudo
# add below line after root line
sonar  ALL=(ALL)   NOPASSWD:  ALL
# Modify owner and file permissions for sonarqube directory
chown -R sonar:sonar /opt/sonarqube/
chmod -R 775 /opt/sonarqube/
# Switch to sonar user
su - sonar
# create sonarqube as service
sudo vi /etc/systemd/system/sonarqube.service
# add below lines and save
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always

[Install]
WantedBy=multi-user.target

# Enable and Start SonarQube, check status
sudo systemctl enable sonarqube
sudo systemctl start sonarqube
sudo systemctl status sonarqube

# Default port number is 9000 (Allow in EC2 Instance Security Group)
ls -l /opt/sonarqube/conf/
cat /opt/sonarqube/conf/sonar.properties | grep "port="

# Log files location incase of any issues in install/start
cat "/opt/sonarqube/logs/" 
# Access Sonar Server in Browser 
http://EC2-VM-IP:9000/

# Default Credentials of Sonar User is admin & admin 

# conatins the sonar.propertities file
`/opt/sonarqube/conf` 
 # contains logs for troubleshooting
`/opt/sonarqube/logs`
```
### Sonarqube dashboard
once on the dashboard , it can be divided into 3 sections
1. Project & Issues : : lists the projects configured and the issues that were reported in them
2. Rules , Quality Profiles and Quality Gates : Conatins the configuration for the quality check
3. Administration 



# Integrating a Maven app on Sonarqube:

### Step 1.  Setup maven on a new machine (amazonlinux)

```bash
# install java
sudo yum install java-11-amazon-corretto -y
# Install Git and Maven
sudo yum install git -y
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.zip -P /tmp

sudo unzip /tmp/apache-maven-3.8.8-bin.zip -d /opt/
sudo mv /opt/apache-maven-3.8.8/ /opt/maven
sudo vi /etc/profile.d/maven.sh
# add below line in the file
export M2_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version
```

### Step 2. Onboarding your project to sonarqube
``` bash
# Clone GitHub Project:
git clone https://github.com/javabyraghu/SB-REST-H2-DB-APP.git

# Configure Sonar Properties under <properties/> tag in "pom.xml"
  <properties>
	<sonar.host.url>http://ec2-public-ip:9000/</sonar.host.url>
	<sonar.login>user-name</sonar.login>
	<sonar.password>password</sonar.password>
  </properties>
	
# Go to project pom.xml file location and execute below goal
mvn clean package
mvn sonar:sonar

# After build is sucessfull, navigate to projects on sonar dashboard and verify
```

#### Note: Instead of username and password we can configure sonar token in pom.xml

    WORKING WITH SONAR TOKEN:
    Go to Sonar -> Login -> Click on profile -> My Account -> Security -> Generate Token 

    Copy the token and configure that token in pom.xml file like below
        <sonar.host.url>http:// ec2-public-ip:9000/</sonar.host.url>
        <sonar.login>ff4d464eda3eccdea05d77b742767c777545863e</sonar.login>
    Then build the project using "mvn sonar:sonar" goal

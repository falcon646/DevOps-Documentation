#### Using RHEL/CentOS/AmazonLinux/Ubuntu
```bash
# Step1 Check Java and Maven are installed
java -version
mvn --version
# Step 2 Install wget if not exist
 sudo yum install wget -y
# Step 3 Install Java 11 Software (JRE)
sudo yum install java-11-openjdk -y # for rhel/centos
sudo yum install java-11-amazon-corretto -y # for amazonlinux2023
sudo yum install java-11-amazon-corretto-devel -y # amazonlinux2022
sudo apt install openjdk-11-jdk openjdk-11-jre -y # ubuntu
java -version
# Verify the JAVAHOME link	
readlink -f $(which java)
# Step 4 Download Maven Software
cd /tmp
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz
# Step 5 Extract to a folder
sudo tar xvzf apache-maven-3.9.1-bin.tar.gz -C /opt/
cd /opt
# rename to a short folder name
sudo mv apache-maven-3.9.1 maven
# Step 6 Set Maven Home Directory
    # Optional if execute permissions are given
    $ sudo chmod +x /etc/profile.d/maven.sh 
    $ sudo vi /etc/profile.d/maven.sh
    # paste the below lines into the and save it 
    export M2_HOME=/opt/maven
    export PATH=${M2_HOME}/bin:${PATH}

# Step 7 Reload Profiles for updating path
source /etc/profile.d/maven.sh
# Step 8  Check Maven Installation
mvn -version
# Step 9 Remove TAR ZIP File
sudo rm -f /tmp/apache-maven-3.9.1-bin.tar.gz
```

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
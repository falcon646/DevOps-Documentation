- tomcat is a application server that can handle dynamic websites
- default home dir is called `$CATALINA_HOME`
- war file deployment path `$CATALINA_HOME/webapps/`

**Manual Setup and Deployment of Dynamic website**

- Setup Apache Tomcat on Amazon Linux 2022 and Deploy a war file on the server
```bash
## 1. Setup Openjdk 11
wget https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz

# extract the files amd move contents to /opt/java/
tar -xvzf <file-name>.tar.gz
mv jdk-11 /opt/java/jdk11

# append java bin path to env variable path and export the path variable
PATH = $PATH:/opt/java/jdk11/x64_bin
echo $PATH
export PATH

# add a new env varible called JAVA_HOME poiniting to java installation dir
JAVA_HOME = /opt/java/jdk11
export JAVA_HOME

## 2. Setup Maven 3.8.6
wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

# extact and move to /opt/maven
tar -xvzf <filename>.tar.gz
mv <dir-name> /opt/maven

# add maven to env path variable and set M2_HOME as /opt/maven/bin and expor both of them
PATH = $PATH:/opt/maven/bin
M2_HOME = /opt/maven
export PATH
export M2_HOME  

## 3. Clone repo and setup access keys
# Configure ssh keys
ssh-keygen -t rsa

# copy and paste the pubic key to access keys in repo settings
# add repo domain to known known_hosts
ssh-keyscan bitbicket.org >> /root/.ssh/known_hosts

# install git 
yum install git -y

# clone repo 
git clone <url> /opt/app/

# 4. intsall and configure tomcat 8.5.82
wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz
tar -xvzf - file-name.tar.gz
mv <dir-name> /opt/tomcat 
# /opt/tomcat is referenced as CATALINA_HOME)

# start tomcat
cd /opt/tomcat/bin
./catalina.sh start

## 5. Packaging the project using maven
# package the project  
mvn package

# copy the artifact generated in the traget folder to tomcat webapps directory
mv /opt/app/target/<file-name>.war /opt/tomcat/webapps/

# restart tomcat
restart tomcat
```
**Containerizing the above process using Dockerfile**

```Dockerfile
FROM amazonlinux

RUN yum install wget -y && \
    yum install gzip -y && \
    yum install tar -y && \
    yum install git -y 

RUN wget https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    tar xvzf openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    mv jdk-11.0.0.1 /opt/jdk11

RUN PATH=$PATH:/opt/jdk11/bin && \
    export PATH && \
    JAVA_HOME = /opt/jdk11 && \
    export JAVA_HOME

RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar xvzf apache-maven-3.8.6-bin.tar.gz && \
    mv apache-maven-3.8.6 /opt/maven

RUN PATH=$PATH:/opt/maven/bin && \
    export PATH && \
    M2_HOME=/opt/maven && \
    export M2_HOME

COPY id_rsa /root/.ssh/
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts && \
    chown -R root:root /root/.ssh && \
    chmod -R 700 /root/.ssh && \
    chmod 600 id_rsa 

RUN git clone git@bitbucket.org:falcon646/ashwin-java-login-app.git /opt/app/

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz && \
    tar xvzf apache-tomcat-8.5.82.tar.gz && \
    mv apache-tomcat-8.5.82 /opt/tomcat

RUN cd /opt/app/

RUN mvn clean package

RUN  cp target/dptweb-1.0.war /opt/tomcat/webapps

CMD ["/opt/tomcat/bin/catalina.sh","start"]
```
**Optimising the above Dockerfile**
```Dockerfile
FROM amazonlinux

ENV PATH $PATH:/opt/jdk11/bin:/opt/maven/bin
ENV JAVA_HOME /opt/jdk11
ENV M2_HOME /opt/maven

RUN export PATH
RUN export JAVA_HOME
RUN export M2_HOME

RUN yum install wget -y && \
    yum install gzip -y && \
    yum install tar -y && \
    yum install git -y 

RUN wget https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    tar xvzf openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    mv jdk-11.0.0.1 /opt/jdk11

RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar xvzf apache-maven-3.8.6-bin.tar.gz && \
    mv apache-maven-3.8.6 /opt/maven

COPY id_rsa /root/.ssh/
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts && \
    chown -R root:root /root/.ssh && \
    chmod -R 700 /root/.ssh && \
    chmod 600 id_rsa 

RUN git clone git@bitbucket.org:falcon646/ashwin-java-login-app.git /opt/app/

WORKDIR cd /opt/app/

RUN mvn clean package && \
    
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz && \
    tar xvzf apache-tomcat-8.5.82.tar.gz && \
    mv apache-tomcat-8.5.82 /opt/tomcat

RUN  cp target/dptweb-1.0.war /opt/tomcat/webapps

CMD ["/opt/tomcat/bin/catalina.sh","start"]
```

**More Optimisations**
- Multi staged Docker files
```Dockerfile
FROM amazonlinux as build

ENV PATH $PATH:/opt/jdk11/bin:/opt/maven/bin
ENV JAVA_HOME /opt/jdk11
ENV M2_HOME /opt/maven

RUN export PATH
RUN export JAVA_HOME
RUN export M2_HOME

RUN yum install wget -y && \
    yum install gzip -y && \
    yum install tar -y && \
    yum install git -y

RUN wget https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    tar xvzf openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    mv jdk-11.0.0.1 /opt/jdk11

RUN wget https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
    tar xvzf apache-maven-3.8.6-bin.tar.gz && \
    mv apache-maven-3.8.6 /opt/maven

COPY id_rsa /root/.ssh/
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts && \
    chown -R root:root /root/.ssh && \
    chmod -R 700 /root/.ssh && \
    chmod 600 /root/.ssh/id_rsa

RUN git clone git@bitbucket.org:falcon646/ashwin-java-login-app.git /opt/app/

WORKDIR /opt/app/

RUN mvn clean package

FROM amazonlinux

ENV PATH $PATH:/opt/jdk11/bin
ENV JAVA_HOME /opt/jdk11

RUN export PATH
RUN export JAVA_HOME

RUN yum install wget -y && \
    yum install gzip -y && \
    yum install tar -y

RUN wget https://download.java.net/openjdk/jdk11.0.0.1/ri/openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    tar xvzf openjdk-11.0.0.1_linux-x64_bin.tar.gz && \
    mv jdk-11.0.0.1 /opt/jdk11

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz && \
    tar xvzf apache-tomcat-8.5.82.tar.gz && \
    mv apache-tomcat-8.5.82 /opt/tomcat

COPY --from=build /opt/app/target/dptweb-1.0.war /opt/tomcat/webapps

CMD ["/opt/tomcat/bin/catalina.sh","run"]
```
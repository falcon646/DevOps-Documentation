
### Nexus Setup
Download Link: https://help.sonatype.com/repomanager3/product-information/download

requirements:

    - Nexus 3.x requires JDK 8 or 11 (OpenJDK or Oracle JDK). It does not support JDK 9 or 10.
    - Nexus 2.x supports JDK 7 or 8.
    - Recommended minimum heap size for Nexus 3.x: 4 GB RAM
    - Recommended minimum heap size for Nexus 2.x: 2 GB RAM
    - For Nexus 3.x, you should have at least 1 GB of free disk space for installation
    - For Nexus 2.x, it is recommended to have a minimum of 4 GB of free disk space for installation.
    - Nexus requires access to the internet for downloading artifacts, metadata, and plugins from remote repositories.

** Use t2.medium or above configuration <br>
** nexus runs on port 8081 by default

```bash
#update
sudo yum update -y
#Download wget	
sudo yum install wget -y
# Install Java	
sudo yum install java-1.8.0-amazon-corretto -y

# Download Nexus to /tmp	
sudo wget https://download.sonatype.com/nexus/3/nexus-3.53.0-01-unix.tar.gz -P /tmp
# extract to /opt directory	
sudo tar xvzf /tmp/nexus-3.53.0-01-unix.tar.gz -C /opt/

# Rename directory	
sudo mv /opt/nexus-3.53.0-01/ /opt/nexus

# Create nexus user	
sudo useradd nexus
# Allow User to execute commands with no password	
sudo visudo
# add below line under root line
    nexus ALL=(ALL) NOPASSWD: ALL

# Change Owner to nexus	
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
# Modify file permissions	
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work

# Enable nexus user	
sudo vi /opt/nexus/bin/nexus.rc
run_as_user="nexus"

# Create Nexus service file	
sudo vi /etc/systemd/system/nexus.service
# copy below content to it
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target

# Enable Nexus to run on boot	
sudo systemctl enable nexus
#Start nexus server	
sudo systemctl start nexus
# View Nexus status	
sudo systemctl status nexus

#Check Default port number	
sudo cat /opt/nexus/etc/nexus-default.properties

# get default admin password	
cat /opt/sonatype-work/nexus3/admin.password
```



#### In Sonatype Nexus, repositories are organized into three main types: 
When ever you try to create a repository on nexus you will see 3 diff version of the samw repo eg . docker  (group) , docker (hosted) , docker (proxy)

- Hosted Repositories:

    - Purpose: Hosted repositories are used to store and manage internally created artifacts. These artifacts are typically built and deployed by the organization's development teams.
   -  Usage: When a project is built, artifacts are deployed to a hosted repository. Other projects or developers within the organization can then access these artifacts.
    - Example: If your organization builds a custom library, you might deploy the resulting JAR file to a hosted repository.

- Proxy Repositories:

    - Purpose: Proxy repositories act as a cache for external repositories. Instead of directly accessing external repositories on the internet, Nexus proxies these repositories locally to improve build performance and reduce external dependencies.
    - Usage: When a build tool requests an artifact, Nexus checks if it's available in the proxy repository. If it is, Nexus serves the artifact from its cache; otherwise, it retrieves the artifact from the external repository and caches it for future use.
    - Example: If your project depends on a third-party library hosted on Maven Central, Nexus can proxy Maven Central to reduce the reliance on external servers.

- Group Repositories:

    - Purpose: Group repositories are virtual repositories that combine multiple repositories (hosted and/or proxy) into a single logical repository. This allows developers to access artifacts from multiple repositories through a single URL.
    - Usage: Instead of configuring build tools to use individual repositories, developers can configure them to use a group repository. Nexus then aggregates artifacts from the associated repositories and presents them as a unified view.
    - Example: A group repository might include a hosted repository for internal artifacts and a proxy repository for external dependencies. Developers can configure their builds to use this group repository for simplicity.

### Steps to create a new repository
1. Click on Server Admin and Config (Setting button type)
2. Click on Repository > Create Repository
3. choose maven2(hosted) -> Enter details
4. select snapshort or release in version policy
5. allow redeploy in deployment policy
6. create repo


### Deploy maven artifacts to the nexus repositories
1. Maven Configuration
    - we need to configure the nexus server credentials to access the nexus services
    - add the below ```<server>``` tag inside the already present```<server>``` tag in the settings.xml file present in the installation directory of maven ie /opt/maven/conf
    ```xml
    <server>
		<id>nexus</id>
		<username>nexus_username</username>
		<password>nexus_password</password>
	</server>
    ```
2. Application configuration
    - nexus repository details need to be configured in the pom.xml file of the project
    - add the below lines before dependency tag and after properties tag
    ```xml
    <!-- syntax -->
    <distributionManagement>  
        <repository_type>
            <id>nexus_id</id> <!-- confugured in settings.xml -->
            <name>name_for_the_repo</name>
            <url>repo_url</url>
        </repository>	
    </distributionManagement>
    ```
    eg
    ```xml
    <distributionManagement>  
        <repository>
            <id>nexus</id>
            <name>idp Releases Nexus Repo</name>
            <url>http://3.83.18.198:8081/repository/com-idp-release/</url>
        </repository>
        
        <snapshotRepository>
            <id>nexus</id>
            <name>idp Snapshots Nexus Repo</name>
            <url>http://3.83.18.198:8081/repository/com-idp-snapshot/</url>
        </snapshotRepository>	
    </distributionManagement>
    ```
3. Once these details are configured then we can run below maven goal to upload build artifacts to Nexus Server

    ``` $ mvn clean deploy ```

When we execute maven deploy goal, internally it will execute 'compile + test + package + install + deploy' goals.

    compile : convert .java files into .class 
    test    : Execute Unit Test cases
    package : Create a build file like JAR or WAR File
    install : Copy Build file to local repository 
    deploy  : Copy Build file to Artifact Repository.

- you can specify which repo(release/snaopshot) to deploy the war file by mentioning it in the version tag in pom.xml
- if the version has the keyword "SNAPSHOT" in it , it will alwsys deploy to the snapshot repo
```xml
  <groupId>com.ashwin</groupId>
  <artifactId>maven-flip-app</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>war</packaging>
```
- if the string "SNAPSHOT" is not present in the version , they it will alwsys deploy to the release repositoty
``` xml
<!-- all of the below version will be deployed to release repo-->
  <version>1.0</version>
  <version>1.0-GA</version>
  <version>1.0-release</version>
  <version>9.0-snap</version>
```

``` sample repo : https://github.com/javabyraghu/maven-flip-app.git ```


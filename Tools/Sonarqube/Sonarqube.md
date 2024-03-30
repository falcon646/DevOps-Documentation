
### SonarQube Server Setup (without external DB)
- os : ubuntu 20.04
```bash
# change to root
sudo su -
# install java 11
apt install -y openjdk-11-jdk 
# or if java 17 is needed (prefered)
apt install openjdk-17-jdk -y
# download the binary to /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip -P /tmp 
# install unzip if not present
apt install unzip
# unzip to /tmp
unzip /tmp/sonarqube-8.9.10.61524.zip -d /opt
# move to /opt/sonarqube
mv /opt/sonarqube-8.9.10.61524/ /opt/sonarqube
# add sonar user
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
http://piblic-ip:9000/

# Default Credentials of Sonar User is admin & admin 
```

### Install Jenkins 
- os : ubuntu 20.04
```bash
# install java 11
sudo apt install -y openjdk-11-jdk
# or if java 17 is needed  (prefered)
sudo apt install openjdk-17-jdk

# add the repository key to your system:
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# append the Debian package repository address to the server’s sources.list:
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
# run apt update so that apt will use the new repository.
sudo apt-get update
# install jenkins
sudo apt-get install jenkins

# enable and start jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status Jenkins
sudo systemctl stop Jenkins
```

## SonarScanner

The SonarQube Scanner is a command-line tool provided by SonarSource, the company behind SonarQube, to analyze code and send the results to a SonarQube server for processing and visualization. It is used to perform static code analysis on software projects, identify code quality issues, and provide insights into code maintainability, reliability, and security.

- **Code Analysis**: The SonarQube Scanner analyzes source code for various programming languages, including Java, JavaScript, Python, C/C++, and many others. It scans the codebase to detect bugs, vulnerabilities, code smells, and security vulnerabilities based on predefined rules and quality profiles.
- **Integration**: The SonarQube Scanner integrates seamlessly with continuous integration (CI) and continuous delivery (CD) pipelines, enabling developers to automate code analysis as part of their build process. It can be integrated with popular CI/CD tools like Jenkins, Azure DevOps, Bamboo, and GitLab CI.
- **Configurability**: The SonarQube Scanner provides configuration options to tailor the analysis process to the specific needs of the project. Developers can customize settings such as project key, project name, source code directory, analysis parameters, and more.
- **Reporting**: After analyzing the code, the SonarQube Scanner generates detailed reports containing information about code quality issues, code metrics, code duplications, and other insights. These reports are sent to the SonarQube server, where they are processed and displayed in the SonarQube dashboard for further analysis.
-  **Compatibility**: The SonarQube Scanner is compatible with SonarQube Community Edition, SonarQube Developer Edition, and SonarQube Enterprise Edition. It can be used with both self-hosted SonarQube instances and SonarCloud, a cloud-based version of SonarQube provided by SonarSource.

There are different SonarScanners available depending on the programming languages and the build tools you use. 
Here are some commonly used SonarScanners and instructions on how to install and use them:

    1. Gradle - SonarScanner for Gradle
    2. Maven - SonarScanner for Maven
    3. Jenkins - SonarQube Scanner Extension for Jenkins
    4. Azure DevOps - SonarQube Extension for Azure DevOps
    5. .NET - SonarScanner for .NET
    6. Anything else - SonarScanner CLI

### SonarScanner CLI

SonarQube’s code scanner is a separate package that can be installed in a machine that is different from the one on which the SonarQube server is operating, like your local development workstation or a continuous delivery server.
#### Installation 
- os : ubuntu 20.04
Pre requisiste: 
- java 17
- for analysis of JavaScript/TypeScript/CSS code base , apart from java 17 , the Node.js runtime environment is also necessary. If your architecture is Linux x64, Windows x64, no Node.js installation is required

```bash
# java 17 is required
sudo apt install openjdk-17-jdk -y
# for analysis of JavaScript/TypeScript/CSS code base
# download the binary   
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip /tmp
# unzip the file
unzip /tmp/sonar-scanner-cli-5.0.1.3006-linux.zip -d /opt
# move to /opt/sonar-scanner
mv /opt/sonar-scanner-5.0.1.3006-linux /opt/sonar-scanner

# add /opt/sonar-scanner/bin/sonar-scanner to PATH env variable
echo 'export PATH="/opt/sonar-scanner/bin:$PATH"' >> ~/.bashrc source ~/.bashrc

# generate a symbolic link to call the scanner without specifying the path
ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner 

# or to run the sonar-scanner command give its full path 
/opt/sonar-scanner/bin/sonar-scanner

# verify your installation by executing the command 
sonar-scanner -h
```
If you need more debug information, you can add one of the following to your command line: `-X`, `--verbose`, or `-Dsonar.verbose=true`

- usage: `sonar-scanner [options]`

        -D,--define <arg>     Define property
        -h,--help             Display help information
        -v,--version          Display version information
        -X,--debug            Produce execution debug output

#### Running a Scan via SonarScanner CLI
You can manually trigger the scanning using the sonarscanner cli using the `sonar-scanner` command. Make sure the sonar-scanner binary is added to the PATH env variable to invoke it from anywhere or you can also create a soft link for it. The path for the binary file is `<installation-path>/bin/sonar-scanner`
Prerequisite : 
- Project should already be created on the Sonarqube UI
- You should have the projectkey and token

Sample projects for testing : https://github.com/SonarSource/sonar-scanning-examples/tree/master/sonar-scanner/src

```bash
# trigger a scan by providing the options
sonar-scanner -Dsonar.projectKey=PROJECTKEY -Dsonar.sources=. -Dsonar.host.url=http://<ip>:9000 -Dsonar.login=TOKEN

# example for a java project
sonar-scanner -Dsonar.projectKey=test -Dsonar.sources=. -Dsonar.host.url=http://40.71.219.219:9000 -Dsonar.login=4468fa484711093975b573513add51767a90a5a4 -Dsonar.exclusions=**/*.java
```
- Rather than passing the options via the command everytime , you can configure them in `sonar-project.properties`. This file has to be placed in the root diretory of the project
```bash
# create the sonar-project.properties file
vi sonar-project.properties

# add the necessary options and values
sonar.projectKey=test01
sonar.projectName=testname
sonar.projectVersion=1.0
sonar.host.url=http://40.71.219.219:9000
sonar.exclusions=**/*.java
sonar.sources=.

# start the scan
sonar-scanner -Dsonar.login=e9d1eb57abba1ec84c30e96476c4c7db8b8a0b12
```
- you can configure some of the default options like host url in `/opt/sonar-scanner/conf/sonar-scanner.properties` file , so that you do not have to pass it explictly for each project
```bash
# edit the /conf/sonar-scanner.properties file
vi <installation-path>/conf/sonar-scanner.properties
# add below line

#----- Default SonarQube server
sonar.host.url=http:<IP>:9000

```

- Alternatively, instead of passing the token via the command , you can create the SONAR_TOKEN environment variable and set the token as its value before you launch the analysi,  or you can configure it in the `sonar-project.properties` file as well


#### Running SonarScanner CLI from the Docker image
To scan using the SonarScanner CLI Docker image, use the following command:

```bash
docker run \
    --rm \
    -e SONAR_HOST_URL="http://${SONARQUBE_URL}" \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${YOUR_PROJECT_KEY}" \
    -e SONAR_TOKEN="myAuthenticationToken" \
    -v "${YOUR_REPO}:/usr/src" \
    sonarsource/sonar-scanner-cli
```

## SonarScanner for Maven
The SonarScanner for Maven is recommended as the default scanner for Maven projects.

- The ability to execute the SonarQube analysis via a regular Maven goal makes it available anywhere Maven is available (developer build, CI server, etc.), without the need to manually setup SonarScanner.
- Prerequisites
    - Maven 3.2.5+ installed
    - At least the minimal version of Java supported by your SonarQube server is in use
- Edit the `settings.xml` file, located in <MAVEN_HOME>/conf or ~/.m2, to set the plugin prefix and optionally the SonarQube server URL.*

```xml
<settings>
    <pluginGroups>
        <pluginGroup>org.sonarsource.scanner.maven</pluginGroup>
    </pluginGroups>
    <profiles>
        <profile>
            <id>sonar</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <!-- Optional URL to server. Default value is http://localhost:9000 -->
                <sonar.host.url>
                  http://<ip>:9000
                </sonar.host.url>
            </properties>
        </profile>
     </profiles>
</settings>
```
- Configure the options under `<properties/>` tag in `pom.xml`
```xml
  <properties>
    <sonar.host.url>http://public-ip:9000/</sonar.host.url>
    <sonar.login>ff4d464eda3eccdea05d77b742767c777545863e</sonar.login>
  </properties>
```
- **Running a scan using SonarScanner for Maven**

    Analyzing a Maven project consists of running the maven goal `sonar:sonar` from the directory that holds the `pom.xml`. You need to pass an authentication token using one of the following options: 
    - `mvn sonar:sonar -Dsonar.token=y<token>`
    - `mvn clean verify sonar:sonar -Dsonar.token=<token>`

    In some situations you may want to run the sonar:sonar goal as a dedicated step. Be sure to use install as first step for multi-module projects
    ```bash
    mvn clean install
    mvn sonar:sonar -Dsonar.token=myAuthenticationToken
    ```

## SonarScanner for Jenkins (Integrating Sonarqube on Jenkins)
Simillar to other SonarScanners , Jenkins can also function as a sonarscanner using a plugin.
`SonarQube Scanner plugin` allows easy integration in Jenkins projects of SonarQube. Plugin URL : https://plugins.jenkins.io/sonar/
This plugin lets you centralize the configuration of SonarQube server connection details in Jenkins global configuration. Then you can trigger SonarQube analysis from Jenkins using standard Jenkins Build Steps or Jenkins Pipeline DSL to trigger analysis with:
- SonarScanner CLI
- SonarScanner for Maven
- SonarScanner for Gradle
- SonarScanner for .NET

Once the job is complete, the plugin will detect that a SonarQube analysis was made during the build and display a badge and a widget on the job page with a link to the SonarQube dashboard as well as quality gate status.

#### Setup Sonarqube Server and SonarScanner In Jenkins
- Install the Jenkins Extension for SonarQube via the Jenkins Update Center. `SonarQube Scanner plugin` : https://plugins.jenkins.io/sonar/
- **Configure the SonarQube server:**
    - Add the Sonarqube server details under Manage Jenkins > System configuration in "system" 
    - Scroll down to the SonarQube configuration section, Enable injection of SonarQube server configuration as build environment variables & then click Add SonarQube.
    - Povide name for sonarqube server > Provide the entire url for sonarqube server (eg http://40.76.58.179:9000/)
    - The sonarqube/project authentication token should be created seperately as a Secret Text credential, once created select the token here
- **Configure the SonarScanner Envirnoment:**
    - Configire Sonarqube Scanner under Manage Jenkins > Tool Configuration > Go to Tool > Sonarqube Scanner > Add Sonarqube Scanner -> Provide a name > Select Install automatically > Select version
### Running Scans through the SonarScanner Plugin for Jenkins
- **For Freestyle Project**
    - Select the Git url : https://github.com/SonarSource/sonar-scanning-examples
    - Add a build step > Execute Sonar Scanner 
    - Add the below options in the  "Analysis Properties" section
        ```properties
        sonar.projectKey=<projectkeyfromsonarproject>
        sonar.login=<username>
        sonar.password=<password>
        sonar.exclusions=vendor/**, storage/**, resources/**,, **/*.java
        sonar.sources=/var/lib/jenkins/workspace/<jenkins-project-name>   # /var/lib/jenkins/workspace/ is jenkins workspace dir
        sonar.host.url=<sonar_server_url>
        ```
    - Build the job
    -   *Note : configuring the SonarScanner Envirnoment on jenkins is not mandatory for freestyle jobs*
- **For Jenkins Pipeline Projects**
    - The plugin provide  `withSonarQubeEnv` block that allows you to select the SonarQube server you want to interact with. Connection details that you have configured in Jenkins global configuration will be automatically passed to the scanner.
    - If needed you can override the credentialsId, or if you don't want to use the one defined in global configuration (for example if you define credentials at the folder level).
    - If you only need the SonarQube environment variables to be expanded in the build context then you can override the envOnly flag.
        ```groovy
        withSonarQubeEnv('My SonarQube Server', envOnly: true) {
        // This expands the evironment variables SONAR_CONFIG_NAME, SONAR_HOST_URL, SONAR_AUTH_TOKEN that can be used by any script.
        println ${env.SONAR_HOST_URL} 
        }
        ```
    - **For running a scan using SonarScanner for Maven project**
        - make sure the pox.xml is congifured with the host url and login values
        ```xml
        <properties>
            <sonar.host.url>http://public-ip:9000/</sonar.host.url>
            <sonar.login>username</sonar.login>
        </properties>
        ```        
        ```groovy
        node {
        stage('SCM') {
            git 'https://github.com/foo/bar.git'
            }
        stage('Build') {
            withMaven(maven: 'MavenToolName') {
                    // Run Maven commands here
                sh 'mvn clean package'
            }
        stage('SonarQube analysis') {
            withSonarQubeEnv(credentialsId: 'f225455e-ea59-40fa-8af7-08176e86507a', installationName: 'My SonarQube Server') { 
                withMaven(maven: 'MavenToolName') {
                    // Run Maven commands here
                    sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        ``` 
        - you can also manually pass the token with `-Dsonar.token=<token>` option
    - **For running a scan using SonarScanner for any kind of project**
        ```groovy
        node {
        stage('SCM') {
            git 'https://github.com/foo/bar.git'
            }
        stage('SonarQube analysis') {
            def scannerHome = tool '<scanner-name-configured>';
            withSonarQubeEnv('<sonarqube-name-configured>') {
                sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        ```
        - As mentioned in the scanner cli section above, make sure that your project has a `sonar-project.properties` file in the root directory with all the options configured
        - Else you can also provide the full options in the sonar-scanner command 
            ```groovy
                stage('Sonarqube Analysis'){
                    def scannerHome = tool '<scanner-congigured-name>';
                    withSonarQubeEnv('<sonarserver-configured-name>'){
                    sh "${scannerHome}/bin/sonar-scanner \
                        -D sonar.login=<name> \
                        -D sonar.password=<pass> \
                        -D sonar.projectKey=<project-key> \
                        -D sonar.host.url=http://40.76.58.179:9000/"
                    }
                }
            ```
### Pause pipeline until the quality gate is computed (https://www.youtube.com/watch?v=ep05R_FNBtM)
he waitForQualityGate step will pause the pipeline until SonarQube analysis is completed and returns Quality Gate status.

Prerequisites:
- Configure a webhook in your SonarQube server pointing to `<jenkins-ip:port>/sonarqube-webhook/`
- Use withSonarQubeEnv step in your pipeline (so that SonarQube taskId is correctly attached to the pipeline context).

- Scripted pipeline example:
```groovy
node {
  stage('SCM') {
    git 'https://github.com/foo/bar.git'
  }
  stage('SonarQube analysis') {
    withSonarQubeEnv('My SonarQube Server') {
      sh 'mvn clean package sonar:sonar'
    } // submitted SonarQube taskId is automatically attached to the pipeline context
  }
}
  
// No need to occupy a node
stage("Quality Gate"){
  timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
    def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
    if (qg.status != 'OK') {
      error "Pipeline aborted due to quality gate failure: ${qg.status}"
    }
  }
}
```
- declarative
```groovy
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
```
- Thanks to the webhook, the step is implemented in a very lightweight way: no need to occupy a node doing polling, and it doesn't prevent Jenkins to restart (the step will be restored after restart). Note that to prevent race conditions, when the step starts (or is restarted) a direct call is made to the server to check if the task is already completed.

### Running multiple analyses in the same pipeline

If you want to run multiple analyses in the same pipeline and use waitForQualityGate, you have to do everything in order:

```groovy
pipeline {
    agent any
    stages {
        stage('SonarQube analysis 1') {
            steps {
                sh 'mvn clean package sonar:sonar'
            }
        }
        stage("Quality Gate 1") {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
        stage('SonarQube analysis 2') {
            steps {
                sh 'gradle sonarqube'
            }
        }
        stage("Quality Gate 2") {
            steps {
                waitForQualityGate abortPipeline: true
            }
        }
    }
}
```  


---


# Jenkins Project with SonarQube Integration

1. **FreeStyle Project for .Net App (https://www.youtube.com/watch?v=tbr_PeAGdfo)**
- Pre-requisites 
    - SonarQube plugin installed and setup
    - Sonarqube server and Sonarscanner configuration setup in Jenkins
    - Project created on Sonarqube , projectkey and token handy 
- Steps
    - create new frestyle project
    - select the git url as : https://github.com/shazforiot/MSBuild_firstproject.git
    - add build step -> Execute Sonar Scanner
    - add the below in the Analysis properties section
        ```properties
        sonar.projectKey=<projectkeyfromsonarproject>
        sonar.login=<username>
        sonar.password=<password>
        sonar.sources=/var/lib/jenkins/workspace/<jenkins-project-name>   # /var/lib/jenkins/workspace/ is jenkins workspace dir
        sonar.host.url=<sonar_server_url>
        ```
    - Build the project
    - *note : here we saw an error becuase jenkins was running on java 11. When we update jenkins to java 17 , then the error was resolved `sudo apt install openjdk-17-jdk`*
        ```bash
        Error: LinkageError occurred while loading main class org.sonarsource.scanner.cli.Main
            java.lang.UnsupportedClassVersionError: org/sonarsource/scanner/cli/Main has been compiled by a more recent version of the Java Runtime (class file version 61.0), this version of the Java Runtime only recognizes class file versions up to 55.0
        ```
**2. Simple freestyle project integrating sonarqube for Java**
- Pre-requisites 
    - SonarQube plugin installed and setup
    - Sonarqube server and Sonarscanner configuration setup in Jenkins
    - Project created on Sonarqube , projectkey and token handy 
- Steps
    - create new frestyle project
    - select the git url as : https://github.com/SonarSource/sonar-scanning-examples
    - add build step -> Execute Sonar Scanner
    - add the below in the alayisis properties section
        ```properties
        sonar.projectKey=<projectkeyfromsonarproject>
        sonar.login=<username>
        sonar.password=<password>
        sonar.exclusions=vendor/**, storage/**, resources/**,, **/*.java
        sonar.sources=/var/lib/jenkins/workspace/<jenkins-project-name>   # /var/lib/jenkins/workspace/ is jenkins workspace dir
        sonar.host.url=<sonar_server_url>

        # actual values
        sonar.projectKey=testabc
        sonar.login=admin
        sonar.password=9669
        sonar.sources=/var/lib/jenkins/workspace/sonartest 
        sonar.exclusions=vendor/**, storage/**, resources/**, **/*.java
        sonar.host.url=http://40.76.58.179:9000/
        ```
    - Build the project

3. **Jenkins Pipeline Project (https://www.youtube.com/watch?v=4AEW-yR_Biw&t=57s)**
- Repo link : https://github.com/shazforiot/GOL.git
- Pre-requisites 
    - SonarQube plugin installed and setup
    - Sonarqube server and Sonarscanner configuration setup in Jenkins
    - Project created on Sonarqube , projectkey and token handy 
- Steps 
    - create new project on sonarqube , note the project key and token a908a7ea27c104cf78bbe73de4cb7a131e095e85
    - create a pipeline project in jenkins and write the jenkinsfile as below
        ```groovy
        node{
            stage("Checkout"){
                git 'https://github.com/shazforiot/GOL.git'
            }
            stage('Sonarqube Analysis'){
                def scannerHome = tool '<sonar-tool-congigured-name>';
                withSonarQubeEnv('<sonarserver-configured-name>'){
                sh "${scannerHome}/bin/sonar-scanner \
                    -D sonar.login=<name> \
                    -D sonar.password=<pass> \
                    -D sonar.projectKey=<project-key> \
                    -D sonar.host.url=http://40.76.58.179:9000/"
                }
            }
        }
        ```

    - **`def scannerHome = tool 'sonar';`**: This line uses the `tool` step to retrieve the path to the SonarQube scanner tool configured in the Jenkins Global Tool Configuration with the name 'sonar'. The path is stored in the `scannerHome` variable.
    - **`withSonarQubeEnv('sonarserver') { ... }`**: This block sets up the environment for SonarQube analysis using the credentials and configuration specified for the SonarQube server named 'sonarserver'.
    - the exclusion property does not work properly in the pipeline script, hence you need to manually add the below exclusion in sonar ui settings
    sonar.exclusions=vendor/**, storage/**, resources/**, **/*.java \
      



### Confuguring different JDK versions to be used with Sonarqube in Jenkins
- You can define a new JDK in Manage Jenkins > Global Tool Configuration, if you have the JDK Tool Plugin installed.

- Declarative pipelines
    - If you are using a declarative pipeline with different stages, you can add a 'tools' section to the stage in which the code scan occurs. This will make the scanner use the JDK version that is specified.
    ```groovy
    stage('SonarQube analysis') {
        tools {
            jdk "jdk17" // the name you have given the JDK installation in Global Tool Configuration
        }
        environment {
            scannerHome = tool 'SonarQube Scanner' // the name you have given the Sonar Scanner (in Global Tool Configuration)
        }
        steps {
            withSonarQubeEnv(installationName: 'SonarQube') {
                sh "${scannerHome}/bin/sonar-scanner -X"
            }
        }
    }
    ```
    - If you are analyzing a Java 11 project, you probably want to continue using Java 11 to build your project. The following example allows you to continue building in Java 11, but will use Java 17 to scan the code:
    ```groovy
    stage('Build') {
    tools {
            jdk "jdk11" // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
        }
        steps {
            sh 'mvn compile'
        }
    }
    stage('SonarQube analysis') {
        tools {
            jdk "jdk17" // the name you have given the JDK installation using the JDK manager (Global Tool Configuration)
        }
        environment {
            scannerHome = tool 'SonarQube Scanner' // the name you have given the Sonar Scanner (Global Tool Configuration)
        }
        steps {
            withSonarQubeEnv(installationName: 'SonarQube') {
                sh 'mvn sonar:sonar'
            }
        }
    }
    ```
    This example is for Maven but it can be easily modified to use Gradle.

- Classical pipelines
    - Set Job JDK version
        - You can easily set the JDK version to be used by a job in the General section of your configuration. This option is only visible if you have configured multiple JDK versions under Manage Jenkins > Global Tool Configuration.
        - Set 'Execute SonarQube Scanner' JDK version
        - If you are using the Execute SonarQube Scanner step in your configuration, you can set the JDK for this step in the configuration dialog. By using this approach, you can use JDK 17 only for the code scanning performed by SonarQube. All the other steps in the job will use the globally configured JDK.
- Java 11 projects
    - Jenkins does not offer functionality to switch JDKs when using a Freestyle project or Maven project configuration. To build your project using Java 11, you have to manually set the JAVA_HOME variable to Java 17 when running the analysis.
    - To do this use the Tool Environment Plugin. This plugin lets expose the location of the JDK you added under Manage Jenkins > Global Tool Configuration. The location of the JDK can then be used to set the JAVA_HOME variable in a post-step command, like this:
    - export JAVA_HOME=$OPENJDK_17_HOME/Contents/Home
    - mvn $SONAR_MAVEN_GOAL
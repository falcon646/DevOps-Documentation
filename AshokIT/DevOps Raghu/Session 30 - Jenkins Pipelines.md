## Jenkins Pipeline Projects

### PROJECT-1: GITHUB + MAVEN

```groovy 
pipeline {
    agent any
    
    environment {
        PATH="${PATH}:/opt/maven/bin"
    }

    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', credentialsId: 'GitHub-Credentials', url: 'https://github.com/javabyraghu/maven-web-app.git'
            }
        }
        
        stage('Maven Build') {
            steps {
                sh "mvn clean package"
            }
        }
    }
}
```

### PROJECT-2: GITHUB + MAVEN + TOMCAT
- Create EC2 Instance using below RAW Script (Paste Under Advanced Details > User data while creating EC2 Instance)
https://raw.githubusercontent.com/javabyraghu/EC2UserScripts/main/AmazonLinux2023Tomcat-9.sh

- Add SSH-Agent Plugin Jenkins Master

        1. Manage Jenkins  
        2. Manage Plugins 
        3. Choose Available Plugins
        4. Install SSH Agent Plugin without restart.
 
- Go to Pipeline Syntax and choose sshagent: SSH Agent.

        1. Select kind as SSH Username with Private key.
        2. Enter username as ec2-user and paste private key file. [__.pem file data]
        3. click on generate code.
    ```groovy
    pipeline {
        agent any
        
        environment {
            PATH="${PATH}:/opt/maven/bin"
        }

        stages {
            stage('Git Clone') {
                steps {
                    git branch: 'main', credentialsId: 'GitHub-Credentials', url: 'https://github.com/javabyraghu/maven-web-app.git'
                }
            }
            
            stage('Maven Build') {
                steps {
                    sh "mvn clean package"
                }
            }
            
            stage('Deploy to tomcat') {
                steps {
                    sshagent(['Tomcat-SSH-ID']) {
                        sh 'scp -o StrictHostKeyChecking=no target/01-maven-web-app.war ec2-user@3.108.63.142:/opt/tomcat/webapps/'
                    }
                }
            }
        }
    }
    ```

### PROJECT-3: GITHUB + MAVEN +  SONARQUBE + NEXUS + TOMCAT
- Create SonarQube EC2 Instance using below RAW Script (Paste Under Advanced Details > User data while creating EC2 Instance)
https://raw.githubusercontent.com/javabyraghu/EC2UserScripts/main/AWS2023Sonarqube7.sh

- Create Nexus EC2 Instance using below RAW Script (Paste Under Advanced Details > User data while creating EC2 Instance)
https://raw.githubusercontent.com/javabyraghu/EC2UserScripts/main/AWS2023SonatypeNexus.sh

- Add SonarQube Scanner and Nexus Artifact Uploader Plugins Jenkins Master'

        1. Manage Jenkins  
        2. Manage Plugins 
        3. Choose Available Plugins
        4. Search and select “SonarQube Scanner and Nexus Artifact Uploader”.
        5. Install SSH Agent Plugin for tomcat.
        6. Install without restart.

- Add SonarQube Server Details to Jenkins System.

        1. Manage Jenkins 
        2. Configure System
        3. SonarQube Servers
        4. Add SonarQube Server
        5. Name: Sonar-Server-7.8
        6. Server URL: http://3.110.153.105:9000/ (Give your sonar server URL here)
        7. Add Sonar Server Token (Token we should add as secret text)
        8. Save it.
 
- Add Nexus Details to Job

        1. Create one Repository (ex: 4.0-SNAPSHOT) Under Nexus Server.
        2. Choose nexusArtifactUploader under Jenkins Pipeline Syntax Generator (in Jenkins)
        3. Add Nexus Credentials as username and password.
        4. Enter Details as shown below. 
- Final Pipeline script
    ```groovy
    pipeline {
        agent any
        
        environment {
            PATH="${PATH}:/opt/maven/bin"
        }

        stages {
            stage('Git Clone') {
                steps {
                    git branch: 'main', credentialsId: 'GitHub-Credentials', url: 'https://github.com/javabyraghu/maven-web-app.git'
                }
            }
            
            stage('Maven Build') {
                steps {
                    sh "mvn clean package"
                }
            }
            
            stage('SonarQube') {
                steps {
                    withSonarQubeEnv('SonarQube-7.8') {
                        sh "mvn sonar:sonar"
                    } 
                }
            }
            
            stage('Upload to Nexus') {
                steps {
                    nexusArtifactUploader artifacts: [[artifactId: 'myweb-app', classifier: '', file: 'target/01-maven-web-app.war', type: 'war']], credentialsId: 'Nexus-Login', groupId: 'com.app', nexusUrl: '13.233.184.156:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'raghu-snapshot-repo', version: '4.0-SNAPSHOT'
                }
            }
            
            stage('Deploy to tomcat') {
                steps {
                    sshagent(['Tomcat-SSH-ID']) {
                        sh 'scp -o StrictHostKeyChecking=no target/01-maven-web-app.war ec2-user@13.233.104.21:/opt/tomcat/webapps/'
                    }
                }
            }
        }
    }
    ```

## INTEGRATING JENKINS WITH GIT USING WEBHOOKS
- WEBHOOKS:

    Webhooks allows external services to be notified when certain events happen. When the specified events happen, we’ll send POST request to each of the URLs you provide.

Steps to be followed:

    1.	Go to GitHub repository and click on ‘Settings’.
    2.	Click on Webhooks and then click on ‘Add webhook’.
    3.	In the ‘Payload URL’, paste your Jenkins environment URL. At the end of this URL add /github-webhook/. In the ‘Content type’ select: ‘application/json’ and leave the ‘Secret field empty.
    4.	In this page ‘Which events would you like to trigger this webhook?’ choose ‘Let me select individual events. ‘Then, check ‘pull requests’ and ‘Pushes’. At the end of this option, make sure that the ‘active’ option is checked and click on ‘Add webhook’.
 
Configuring Jenkins:

    5.	In Jenkins, Click on ‘New Item’ to create a new project
    6.	Give your project a name, then choose ‘Freestyle project’ and finally, click on ‘OK’.
    7.	Click on Source Code Management’ tab
    8.	Click on Git and paste your GitHub repository URL 
    9.	Click on the Build Triggers’ tab and then on the ‘GitHub hook trigger for GITScm polling’ or choose the trigger of your choice.
    10.	Now Apply & save.
    11.	Your GitHub repository is integrated with your Jenkins project. With this Jenkins GitHub integration, you can now use any file found in the GitHub repository and trigger the Jenkins job to run with every code commit.
    12.	Go back to your GitHub repository, edit the file and commit changes. We will now see how Jenkins ran the script after the commit.
    13.	Go back to your Jenkins project and you’ll see that a new job was triggered automatically form the commit we made at the previous step. Click on the little arrow next to the job and choose ‘Console Output’.
    14.	You can see that Jenkins was able to pull the updated file and run it.
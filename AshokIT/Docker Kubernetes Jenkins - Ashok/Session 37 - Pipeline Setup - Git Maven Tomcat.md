# Jenkins Pipeline to deploy a maven app to tomcat

Createing  a jenkins pipeline project
- create new job -> select pipeline -> save n apply -> configure
- select pipeline from left menu -> select pipeline script from dropdown
- the pipeline block is declared using below :
   ```yaml
    pipeline{
        agent any
        stages{
            stage (""){}
            stage (""){}
        }
    }
    ```
Configuring different stages in pipeline

- Cloning git repo
    - add git credts in jenkins
    - in the pipeline script box -> select pipeline syntax in new window
    - in the sample text dropdown , select git -> provide git url , branch and creds
    - select generate pipeline script and copt the script generated
    - paste the scrip inside a new stage block under steps
    ```groovy
    stage('Clone repo'){
        step{
            git credentialsId: 'github-pass', url: 'https://github.com/ashokitschool/maven-web-app.git'
        }
    }
    ```

- Maven build stage
    - make sure maven is setup in jenkins
    - add below code in steps
        ```groovy
        stage('Maven Clean Build') {
            steps {
                script {
                    def mavenHome = tool name: "maven-3.9.1", type: "maven"
                    def mavenCMD = "${mavenHome}/bin/mvn"
                    sh "${mavenCMD} clean package"
                }
            }
        }
        ```
    - Notice the addition of the script block around the mavenHome and mavenCMD definitions. 
    - The script block is used to wrap Groovy code that is not part of a declarative step. 
    - In this case, the tool step is not a declarative step, so it needs to be inside a script block.

- Deploy to tomcat server stage
    - make sure tomcat server is up and the "deploy to conatiner" plugin is installed
    - to deploy out application , we need to copy and move the war file from jenkins master/slae to tomcat server
    - to copy a file from one macine to another we woul need a plugin called as "ssh agent"
    - goto pipeline syntax , select "ssh agent"
    - select the "tomcat server agent creds" (add it if not already added)
    - generate pipeline script
    - the script that is generated is used to communicate with the tomcat server
        ```groovy
        sshagent(['tomcat-server-agent']) {
            // some block
        }
        ```
    - we have only configured the ssh agent rght now. to move files to the tomcat server we need to write the command inside the ssh sgent block
        ```groovy
        sh 'scp -o StrictHostKeyChecking=no -i <path/to/file> user@remote-server:/path/on/remote/server'
        ```
    - so , the complete deploy block is 
    ```groovy
    stage ('Deploy to tomcat'){
        steps {
            sshagent(['tomcat-server-agent']) {
                sh 'scp -o StrictHostKeyChecking=no -i <path/to/file> user@remote-server:/path/on/remote/server'
                //sh 'scp -o StrictHostKeyChecking=no  target/01-maven-web-app.war ubuntu@34.239.247.16:apache-tomcat-9.0.83/webapps/'
        }
        }
    }
    ```

- Complete Jenkinsfile
```groovy
pipeline {
    agent { label '!master' }
    stages {
        stage ('Clone repo'){
            steps {
                git credentialsId: 'github-pass', url: 'https://github.com/ashokitschool/maven-web-app.git'
            }
        }
        
        stage ('Maven Clean Build') {
            steps {
                script {
                    def mavenHome = tool name: "maven-3.9.1", type: "maven"
                    def mavenCMD = "${mavenHome}/bin/mvn"
                    sh "${mavenCMD} clean package"
                }
            }
        }
        
        stage ('Deploy to tomcat'){
            steps {
                sshagent(['tomcat-server-agent']) {
                    sh 'scp -o StrictHostKeyChecking=no target/01-maven-web-app.war ubuntu@172.31.24.213:/home/ubuntu/apache-tomcat-9.0.83/webapps/'
                }
            }
        }
    
    }
}
```
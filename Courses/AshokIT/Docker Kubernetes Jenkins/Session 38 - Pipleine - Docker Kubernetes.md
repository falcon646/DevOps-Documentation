# Jenkins Pipeline for Docker and Kubernetes integration

**Project Setup using below tools**
1. Maven
2. Git Hub
3. Jenkins
4. Docker
5. Kubernetes

## Jenkins Docker Kubernetes Server setup
- ### Step - 1 : Jenkins Server Setup
    - refer jenkins server installation steps
    - (optional) - master slave setup
- ### Step - 2 : Install Maven & Git in Jenkins
    - install maven with below command (why do we need to install it in jenkins server ? we only comfigured iton jenkins dashboard for previos projects)
    - sudo apt install maven -y
    - install git with command : `sudo apt install git -y` 
- ### Step - 3 : Setup Docker in Jenkins
    - install docker : `curl -fsSL get.docker.com | /bin/bash`
    - Add Jenkins user to docker group : `sudo usermod -aG docker jenkins`
    - Restart Jenkins: `sudo systemctl restart jenkins`
    - Verify docker installation: `sudo docker version`
- ### Step - 4 : Create EKS Management Host in AWS 
    - Launch new Ubuntu VM using AWS Ec2 ( t2.micro )	  
    - Connect to machine and install kubectl using below commands  
        ```bash
        curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin
        kubectl version --short --client
        ```
    - Install AWS CLI latest version using below commands 
        ```bash
        $ sudo apt install unzip
        $ cd
        $ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        $ unzip awscliv2.zip
        $ sudo ./aws/install
        $ aws --version
        ```

    - Install eksctl using below commands
        ```bash
        $ curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
        $ sudo mv /tmp/eksctl /usr/local/bin
        $ eksctl version
        ```

- ### Step - 5 : Create IAM role & attach to EKS Management Host & Jenkins Server #
    - Create New Role using IAM service ( Select Usecase - ec2 ) 	
    - Add below permissions for the role
	    - IAM - fullaccess
	    - VPC - fullaccess
	    - EC2 - fullaccess
	    - CloudFomration - fullaccess
	    - Administrator - acces
    - Enter Role Name (eksroleec2) 
    - Attach created role to EKS Management Host (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 
    - Attach created role to Jenkins Machine (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 
  
- ### Step - 6 : Create EKS Cluster using eksctl
    ```bash
    eksctl create cluster --name cluster-name  \
    --region region-name \
    --node-type instance-type \
    --nodes-min 2 \
    --nodes-max 2 \ 
    --zones <AZ-1>,<AZ-2>
    ```

    Example: `eksctl create cluster --name ashokit-cluster4 --region us-east-1 --node-type t2.medium  --zones us-east-1a,us-east-1b`

    - Note: Cluster creation will take 5 to 10 mins of time (we have to wait). After cluster created we can check nodes using below command.	
    `kubectl get nodes`  

- ### Step - 7 : Install AWS CLI in JENKINS Server
    - URL : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html  
        ```bash
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        aws --version
        ```
- ### Step - 8 : Install Kubectl in JENKINS Server #
    - Execute below commands in Jenkins server to install kubectl
        ```bash
        $ curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl 
        $ chmod +x ./kubectl
        $ sudo mv ./kubectl /usr/local/bin
        $ kubectl version --short --client
        ```
- ### Step - 9 : Update EKS Cluster Config File in Jenkins Server
	
    - Execute below command in Eks Management host & copy kube config file data `cat .kube/config`
    - Execute below commands in Jenkins Server and paste kube config file
        ```bash
        cd /var/lib/jenkins
        sudo mkdir .kube
        sudo vi .kube/config
        ```
    - check eks nodes `kubectl get nodes` 
    - Note: We should be able to see EKS cluster nodes here
- ### Step - 10 : Create Jenkins CI Job #
    - **Stage-1 : Clone Git Repo** <br/> 
    - **Stage-2 : Build** <br/>
    - **Stage-3 : Create Docker Image** <br/>
    - **Stage-4 : Push Docker Image to Registry** <br/>
    - **Stage-5 : Trigger CD Job** <br/>
    - note :Pipeline is given below
	
- ### Step - 11 : Create Jenkins CD Job 
    - **Stage-1 : Clone k8s manifestfiles** <br/>
    - **Stage-2 : Deploy app in k8s eks cluster** <br/>
    - **Stage-3 : Send confirmatin email** <br/>
    - note :Pipeline is given below

- ### Step - 12 : Trigger Jenkins CI Job #
    - **CI Job will execute all the stages and it will trigger CD Job** <br/>
    - **CD Job will fetch docker image and it will deploy on cluster** <br/>
	
- ### Step - 13 : Access Application in Browser #
    - **We should be able to access our application** <br/>
    - URL : http://Node-public-ip:NodePort/context-path
		
- #### Note : After your practise, delete Cluster and other resources we have used in AWS Cloud to avoid billing

---------------
### Pipeline Setup to build docker image , push to docker hub and deploy to kubernetes


- Cloning git repo (same as previous class)
    - add git credentials in jenkins
    - in the pipeline script box -> select pipeline syntax in new window
    - in the sample text dropdown , select git -> provide git url , branch and creds
    - select generate pipeline script and copt the script generated
    - paste the scrip inside a new stage block under steps
        ```yaml
        stage('Clone repo'){
            step{
                git credentialsId: 'github-pass', url: 'https://github.com/ashokitschool/maven-web-app.git'
            }
        }
        ```
- Maven build stage
    - unlike previos session/setup , we are not providing maven as a global configuration tool
    - instead , we have installed maven directly on the jenkins server (if using slave , install there as well)
    - so we will directly run the maven commands with `sh` command
    - add below code in steps
        ```yaml
        stage('Maven Clean Build') {
            steps {
                sh "mvn clean package"
            }
        }
        ```
- build docker image
    - make sure docker is instal with proper permission
        ```yaml
        stage('Docker build image') {
            steps {
                sh "sudo docker build -t falcon646/ashwin-mvn-app ."
            }
        }
        ```
- Push image to docker hub
    - to push to docke hub you need to login throught cli
    - to do so you need to provide creds amn we never provide crds directly on the script 
    - hence we will generate pipeline syntax using "withCredetitials" -> select "secret text" in the bindings drop down
    - follow usual steps to add credentials -> generate the syntax
        ```yaml
        withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerpass')]) {
        // some block
        }
        ```
    - use the credtails to push to docker hub 
        ```yaml
        stage('Push image to dockerhub') {
            steps {
                script {
                        withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerpass')]) {
                            sh "sudo docker login -u falcon646 -p ${dockerpass}"
                            sh "sudo docker push falcon646/ashwin-mvn-app"
                    }
                }
            }
        }
        ```

### Note : didnt complete deploy to kubernetes pipeline, you need to complete it
- Pipline until now
```groovy
pipeline {
    agent  { label 'slave-1' }
    stages {
        stage ("checkout ") {
            steps {
                git credentialsId: 'github-pass', url: 'https://github.com/ashokitschool/maven-web-app.git'
            }
        }
        
        stage('Maven Clean Build') {
            steps {
                sh "mvn clean package"
            }
        }
        
        stage('Docker build image') {
            steps {
                sh "sudo docker build -t falcon646/ashwin-mvn-app ."
            }
        }
        
        stage('Push image to dockerhub') {
            steps {
                script {
                        withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerpass')]) {
                            sh "sudo docker login -u falcon646 -p ${dockerpass}"
                            sh "sudo docker push falcon646/ashwin-mvn-app"
                    }
                }
            }
        }
    }
}
```
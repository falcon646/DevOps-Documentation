## Jenkins Setup as a Pod 

### 1. Installation

Follow below setups to install jenkins pod in kubernetes
- ServiceAccount.yaml
    - Create a 'serviceAccount.yaml' file and copy the following admin service account manifest.
    - The 'serviceAccount.yaml' creates a 'jenkins-admin' clusterRole, 'jenkins-admin' ServiceAccount and binds the 'clusterRole' to the service account.
    - The 'jenkins-admin' cluster role has all the permissions to manage the cluster components. You can also restrict access by specifying individual resource actions.
```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins-admin
rules:
  - apiGroups: [""]
    resources: ["*"]
    verbs: ["*"]
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins-admin
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: default
```
- Deployment.yaml
    - Jenkins listens on 2 ports , one is `8080` , to access jenkins dashboard via http , and the other `50000` is the `jnlpport` which are used by the agent pods to conect to the jenkins master pod 
    - 'securityContext' for Jenkins pod to be able to write to the local persistent volume.
    - Liveness and readiness probe to monitor the health of the Jenkins pod.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: default
  labels:
   app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      securityContext:
            fsGroup: 1000
            runAsUser: 1000
      serviceAccountName: jenkins-admin
      containers:
        - name: jenkins
          image: jenkins/jenkins:jdk17
          resources:
            limits:
              memory: "2Gi"
              cpu: "1000m"
            requests:
              memory: "500Mi"
              cpu: "500m"
          ports:
            - name: httpport
              containerPort: 8080
            - name: jnlpport
              containerPort: 50000
          livenessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 90
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5
          readinessProbe:
            httpGet:
              path: "/login"
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
```
- Service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
  namespace: default
  labels:
    app: jenkins
spec:
  selector:
    app: jenkins
  type: LoadBalancer
  ports:
    - name: httpport
      port: 8080
      targetPort: 8080
    - name: jnlpport
      port: 50000
      targetPort: 50000
```
- Apply the serviceaccount.yaml , deployment.yaml and & service.yaml in same order
```bash
kubectl apply -f serviceAccount.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
- Once all the above yamls are applied , access the jenkins app using the loadbalancer external ip of the jenkins service
- Complete the jenkins setup by following the steps mentioedn in the UI
  - get the initial password from `var/jenkins_home/secrets/initialAdminPassword`
    - In our setup , we are running jenkins as a pod in kubernetes , so we will need to go inside the pod and get then only the inidtial passorwd
    - exec into pod : `kubectl exec -it <pod-name> -- /bin/bash`
  - install suggested plugins
  - add username and other defaults or skip this step
  - provide the jenkins url in cases you have mappeded it to a domain name , else leave it as the default value
  - you can modift the pod lables as well. keep a not of what lable you added

### 2. Configure Agent Pods

Follow belo steps to configure agent pod that will run for each job
  - **Install the "kubernets" plugin**
    - Goto Manage Jenkins -> Manage Plugin -> Select Available tab -> search "Kubernetes" -> Install the plugin named only [**Kubernetes**](https://plugins.jenkins.io/kubernetes/)
    - [Official Jenkins Plugin Repo](https://plugins.jenkins.io/)
  - **Configure Agent**
    - Manage Jenkins -> Configure Cloud -> Add new Cloud -> Select Kubernetes -> Click Kubernets Cloud Details -> fill out the following details
      - **Kubernets URL** : specify the jenkins master should create the agent pod in which kuberntes cluster
      - **Kubernets Service certficate key**
      - **namespace**
      - **jnlp docker registry** : the registry to pick up the agent pod image
      - But our agent pod needs to run on the same cluster as the jekins master pod and the service account we created before will provide the details the above details to jenkins master pod   , so we can leave thes empty
      - Click on **Test connection** to verify
      - **Jenkins URL** : provide the following url **`http://<jenkins-service-name>:8080`**
      - keep a note of the pod label key value pair or provide your own , we will use it later in out demo
      - save & exit
  - **Create Build Agent Pod Image**
    - Use the below Dockerfile to build and image and push into your repo
    - make sure you have generated the ssh keys and placed them in the same folder as the docker file and also added the keys to bitbucket
    - We do not need kubectl and heml for this image as this image is for the agent pod which build only build an image so that can be omited from the dockerfile
    - you need to use the amazonlinux image version 2 to use extra package "amazon-linux-extras"
      ```Dockerfile
      FROM amazonlinux:2

      ENV JAVA_HOME /opt/java/jdk11
      ENV PATH $PATH:$JAVA_HOME/bin
      ENV M2_HOME /opt/maven

      RUN yum install git -y && \
          yum install wget -y && \
          yum install tar -y && \
          yum install gzip -y && \
          amazon-linux-extras install docker -y

      RUN mkdir /root/.ssh && \
          mkdir -p /opt/java && \
          mkdir /opt/app

      COPY ./id_rsa /root/.ssh/id_rsa

      RUN chmod 700 /root/.ssh && \
          chmod 600 /root/.ssh/id_rsa && \
          chmod -R root:root /root/.ssh && \
          ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

      RUN wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz && \
          tar xzf openjdk-11+28_linux-x64_bin.tar.gz -C /tmp && \
          mv /tmp/jdk-11 $JAVA_HOME && \
          rm openjdk-11+28_linux-x64_bin.tar.gz
      
      RUN wget  https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz && \
          tar xzf apache-maven-3.8.6-bin.tar.gz -C /tmp && \
          mv /tmp/apache-maven-3.8.6 $M2_HOME && \
          rm apache-maven-3.8.6-bin.tar.gz

      RUN curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl && \
          chmod +x kubectl && \
          mv kubectl /usr/local/bin/

      RUN wget  https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz && \
          tar xzf helm-v3.7.0-linux-amd64.tar.gz -C /tmp && \
          mv /tmp/linux-amd64/helm /usr/local/bin/ && \
          rm helm-v3.7.0-linux-amd64.tar.gz
      RUN /usr/local/bin/helm plugin install https://github.com/belitre/helm-push-artifactory-plugin --version v0.3.0

      WORKDIR /opt/app
      CMD ["docker","-g","daemon off;"]
      ```
       - `docker build -t <repo-name>/<image-name>:<version> .`
       - 

  - **Create Jenkins Job use to trigger an agent pod**
    - #### Freestyle Jenkins Job
      - New Item  -> fresstyle project 
      - under general section -> check "restrict where this project can run" -> provide the pod lable you noted in the previous steps (if you skip this , the jobs will run on the master jenkins pod itself)
      - We will not use fresstyle jobs , because they are not modular , hence we will use Jenkins pipeline project ie. Jenkinsfile
    - #### Jenkins Pipeline Project
      - In the Jenkinsfile , we need to provide the following details
        - Build Steps : (ie from git clone to helm push)
        - Pod Template : specifies how to create the agent pods to deploy our application with the image of our agent pod
      - Create new Job -> Select Pipleine and provide the below Jenkinsfile 
      - Jenkinsfile
      - Before you run the below pipeline , make sure you have the jenkins service account created , if not use the jenkins-admin-sa.yaml to create it
```groovy
def namespace = "default"
def service_account = "jenkins-admin"
def label = "build"
podTemplate(
  name: label,
  label: label,
  namespace: namespace,
  serviceAccount: service_account,
  containers: [
    containerTemplate(
      name: "build",
      image: "<image-name>",
      comand: "cat",
      ttyEnabled: "true",
      workingDir: "/home/jenkins",
      alwaysPullImage: "false",
    )
  ]
)
{
  node (label) {

        stage ('Checkout SCM'){
          git url: 'https://falcon646@bitbucket.org/falcon646/dpt06-login-integration-jenkins.git', branch: 'master'
          container('build') {
                stage('Build a Maven project') {
                    sh '/opt/maven/bin/mvn package'             
                }
            }
        }

        stage ('Docker Build'){
          container('build') {
                stage('Build Image') {
                    docker.withRegistry( 'https://registry.hub.docker.com', 'docker' ) {
                    def customImage = docker.build("dpthub/webapp")
                    customImage.push()             
                    }
                }
            }
        }
}
```
      - Run the job and observer the logs , view where the job is running , explore the pod created , exec into the pod and inspect the directory "/home/jenkins"
      - this pipeline is incomplete and will throw and error at the moment

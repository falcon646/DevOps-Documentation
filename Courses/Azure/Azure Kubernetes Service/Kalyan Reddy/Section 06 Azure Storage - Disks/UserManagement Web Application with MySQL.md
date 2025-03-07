### Deploy UserManagement Web Application with MySQL Database

**Step-00: Introduction**
- We are going to deploy a **User Management Web Application** which will connect to MySQL Database schema **webappdb** during startup.
- Then we will test the following APIs
  - Create Users
  - List Users
  - Delete User


| Resource | YAML File |
| ------------- | ------------- |
| Deployment  | 05-UserMgmtWebApp-Deployment.yml  |
| Environment Variables  | 05-UserMgmtWebApp-Deployment.yml  |
| Init Containers  | 05-UserMgmtWebApp-Deployment.yml  |
| Load Balancer Service  | 06-UserMgmtWebApp-Service.yml  |

**Step-01: Reuse the MySqlApp Setup we created before this**

**Step-02: Create User Management Web Application k8s Deployment manifest**
- Environment Variables to be used

    | Key Name  | Value |
    | ------------- | ------------- |
    | DB_HOSTNAME  | mysql |
    | DB_PORT  | 3306  |
    | DB_NAME  | webappdb  |
    | DB_USERNAME  | root  |
    | DB_PASSWORD | dbpassword11  |  

- **Problem Observation:** 
  - If we deploy all manifests at a time, by the time mysql is ready our `User Management Web Application` pod will be throwing error due to unavailability of Database. 
  - To avoid such situations, we can apply `initContainers` concept to our User management Web Application `Deployment manifest`.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-webapp
  labels:
    app: usermgmt-webapp
spec:
    replicas:
    selector:
      matchLabels:
        app: usermgmt-webapp
    strategy:
    template:
        metadata:
          labels:
            app: usermgmt-webapp
        spec:
          initContainers:
            - name: init-db
              image: busybox:1.31
              command: ['sh', '-c', 'echo -e "Checking for the availability of MySQL Server deployment"; while ! nc -z mysql 3306; do sleep 1; printf "-"; done; echo -e "  >> MySQL DB Server has started";'] 
          containers:
            - name: usermgmt-webapp
              image: stacksimplify/kube-usermgmt-webapp:1.0.0-MySQLDB
              imagePullPolicy: Always
              ports:
                - containerPort: 8080
              env:
                - name: "DB_HOSTNAME"
                  value: "mysql"
                - name: "DB_PORT"
                  value: "3306"
                - name: "DB_NAME"
                  value: "webappdb"
                - name: "DB_USERNAME"
                  value: "root"
                - name: "DB_PASSWORD"
                  value: "dbpassword11"
```
**Step-03: Create User Management Web Application Load Balancer Service manifest**
```yaml
apiVersion : v1
kind: Service
metadata:
  name : usermgmt-webapp-service
  labels:
    app: usermgmt-webapp
spec:
  type: LoadBalancer
  selector: 
    app: usermgmt-webapp
  ports:
  - port: 80
    targetPort: 8080
```
**Step-04: Apply the manifest files**
```sh
kubectl apply -f kube-manifests/

# List Pods
kubectl get pods

# Verify logs of Usermgmt Web Application Pod
kubectl logs -f <pod-name> 
# If we have only 1 pod, below commnad works well for getting the logs
kubectl logs -f $(kubectl get po  | egrep -o 'usermgmt-webapp-[A-Za-z0-9-]+')

# Verify sc, pvc, pv
kubectl get sc,pvc,pv
```

**Access Application**
```
# List Services
kubectl get svc

# Access Application
http://<External-IP-from-get-service-output>
Username: admin101
Password: password101
```

**Step-05: Test User Management Web Application using Browser**
- Usecase-1: Login, List Users and Logout
  - Username: admin101
  - Password: password101
- Usecase-2: Login, Create New User and Logout and login with new user
  - Username: admin101
  - Password: password101
  - Create New User 
    - User Details: admin102, password102, fname102, lname102, admin102@gmail.com, ssn102
  - Login with newly user and list users
      - Username: admin102
      - Password: password102    

**Step-06: Verify Users in MySQL Database**
```sh
# Connect to MYSQL Database
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11

# Verify webappdb schema got created which we provided in ConfigMap
mysql> show schemas;
mysql> use webappdb;
mysql> show tables;
mysql> select * from user;
```

**Step-07: Clean-Up**
- Delete all k8s objects created as part of this section
```
# Delete All
kubectl delete -f kube-manifests/

# List Pods
kubectl get pods

# Verify sc, pvc, pv
kubectl get sc,pvc,pv

# Delete PV Exclusively
kubectl get pv
kubectl delete pv <PV-NAME>

# Delete Azure Disks 
Go to All Services -> Disks -> Select and Delete the Disk
```

# AKS Storage -  Storage Classes, Persistent Volume Claims

**Step-00: Introduction**
- We are going to create a MySQL Database pod with persistence storage using **Azure Disks** 

| Kubernetes Object  | YAML File |
| ------------- | ------------- |
| Storage Class  | 01-storage-class.yml |
| Persistent Volume Claim | 02-persistent-volume-claim.yml   |
| Config Map  | 03-UserManagement-ConfigMap.yml  |
| Deployment, Environment Variables, Volumes, VolumeMounts  | 04-mysql-deployment.yml  |
| ClusterIP Service  | 05-mysql-clusterip-service.yml  |

**Step-01: Create Custom Storage Class & PVC manifest**

- **Storage Class**
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-premium-retain-sc
provisioner: disk.csi.azure.com
reclaimPolicy: Retain  # Default is Delete, recommended is retain
volumeBindingMode: WaitForFirstConsumer # Default is Immediate, recommended is WaitForFirstConsumer
allowVolumeExpansion: true  
parameters:
  skuName: Premium_LRS # or we can use Standard_LRS
   kind: managed # Default is shared (Other two are managed and dedicated)
```

- **Peristnant Volume claim**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azure-managed-disk-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: managed-premium-retain-sc
  resources:
    requests:
      storage: 5Gi 
```

```bash
# List Storage Classes
kubectl get sc
# List PVC
kubectl get pvc 
# List PV
kubectl get pv
```
**Step-02: Create ConfigMap manifest**
- We are going to create a `webappdb` database schema using a script in the configmap during the mysql pod creation
- **Confimap** - Conatins the script to run the db for the mysql pod
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: usermanagement-dbcreation-script
data: 
  mysql_usermgmt.sql: |-
    DROP DATABASE IF EXISTS webappdb;
    CREATE DATABASE webappdb; 
```

**Step-03: Create MySQL Deployment manifest**
- Environment Variables
- Volumes
- Volume Mounts
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: mysql
spec:
    replicas: 1
    selector:
        matchLabels:
            app: mysql
    strategy:
        type: Recreate
    template:
        metadata:
            labels:
              app: mysql
        spec: 
            containers:
            - name: mysql
              image: mysql:5.6
              env:
                - name: "MYSQL_ROOT_PASSWORD"
                  value: "dbpassword11"
              ports:
              - containerPort: 3306
                name: mysql
              volumeMounts:
              - name: mysql-persistent-storage
                mountPath: /var/lib/mysql   
              - name: usermanagement-dbcreation-script
                mountPath: /docker-entrypoint-initdb.d #https://hub.docker.com/_/mysql Refer Initializing a fresh instance 
            volumes:
            - name: mysql-persistent-storage
              persistentVolumeClaim : 
                claimName: azure-managed-disk-pvc
            - name: usermanagement-dbcreation-script
              configMap:
                name: usermanagement-dbcreation-script
```

**Step-04: Create MySQL ClusterIP Service manifest**
- At any point of time we are going to have only one mysql pod in this design so `ClusterIP: None` will use the `Pod IP Address` instead of creating or allocating a separate IP for `MySQL Cluster IP service`.   
- **Service**
```yaml
apiVersion: v1
kind: Service
metadata: 
  name: mysql
spec:
  selector:
    app: mysql 
  ports: 
    - port: 3306  
  clusterIP: None # This means we are going to use Pod IP    
```
**Step-05: Connect to MySQL Database**
```bash
# Connect to MYSQL Database
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -pdbpassword11
# Verify usermgmt schema got created which we provided in ConfigMap
mysql> show schemas;
```
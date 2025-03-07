**Custom Storage Class**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: my-azurefile-sc
provisioner: file.csi.azure.com
parameters:
    skuName: Standard_LRS
reclaimPolicy: Retain
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=1000
  - gid=1000
  - mfsymlinks
  - cache=strict
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

**Persistant volume Claim**
```yaml
apiVersion: v1
kind:  PersistentVolumeClaim
metadata: 
  name: my-azurefile-pvc
spec:
  storageClassName: my-azurefile-sc
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

**Deployment**
- We use 4 replias here so that we can show that the file share can be shared amoong multiple pods
```yaml
apiVersion: apps/v1
kind: Deployment 
metadata:
  name: azure-files-nginx-deployment
  labels:
    app: azure-files-nginx-app
spec:
  replicas: 4
  selector:
    matchLabels:
      app: azure-files-nginx-app
  template:  
    metadata:
      labels: 
        app: azure-files-nginx-app
    spec:
      containers:
        - name: azure-files-nginx-app
          image: stacksimplify/kube-nginxapp1:1.0.0
          imagePullPolicy: Always
          ports: 
            - containerPort: 80         
          volumeMounts:
            - name: my-azurefile-volume
              mountPath: "/usr/share/nginx/html/app1"
      volumes:
        - name: my-azurefile-volume
          persistentVolumeClaim:
            claimName: my-azurefile-pvc 
```
**Service**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: azure-files-nginx-service
  labels: 
    app: azure-files-nginx-app
spec:
  type: LoadBalancer
  selector:
    app: azure-files-nginx-app
  ports: 
    - port: 80
      targetPort: 80
```

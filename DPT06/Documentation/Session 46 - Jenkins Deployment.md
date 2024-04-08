## Jenkins Setup as a Pod 
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
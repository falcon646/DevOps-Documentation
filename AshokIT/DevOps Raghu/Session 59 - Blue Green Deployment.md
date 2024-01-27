## Blue Green Deployment 

Blue-green deployment is a deployment strategy used in software development and release management, particularly in the context of deploying applications to production environments. The primary goal of a blue-green deployment is to minimize downtime and risk associated with deploying new versions of an application.

This model uses two similar production environments (blue and green) to release software updates. The blue environment runs the existing software version, while the green environment runs the new version. Only one environment is live at any time, receiving all production traffic. Once the new version passes the relevant tests, it is safe to transfer the traffic to the new environment. If something goes wrong, traffic is switched to the previous version.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/0c7e96a4-4790-4332-86ba-e5cb42043af7)


The deployment process typically involves the following steps:

- `Initial State`: The blue environment is active, serving user traffic, and running the current version of the application (version 1.0). The green environment is inactive.

- `Deployment`: The new version (version 2.0) of the application is deployed to the green environment. This deployment includes configuring the environment, deploying the application code, and ensuring that the environment is ready to serve user traffic.

- `Testing` : Once the green environment is successfully deployed and ready, testing is performed to verify that the new version of the application behaves as expected. This testing phase can include functional testing, performance testing, and any other relevant tests.

- `Switch` : Once testing is complete and the new version is deemed stable, traffic routing is switched from the blue environment to the green environment. This switch is typically achieved by updating the load balancer or DNS configuration to direct incoming traffic to the green environment.

- `Validation` : After the traffic switch, the application's behavior and performance are monitored closely to ensure that the new version is functioning correctly and meeting performance expectations. This validation phase helps identify any issues that may have occurred during or after the switch.

- `Rollback` (if necessary): In case of any issues or unexpected behavior with the new version, a rollback to the previous version (blue environment) can be quickly initiated. This rollback process involves switching traffic back to the blue environment and addressing any issues that led to the rollback.

- `Completion` : Once the new version has been validated and proven to be stable and reliable, the green environment becomes the new production environment, and the blue environment can be decommissioned or used for future deployments.

### Example

- Blue Environment Setup:
  - Create Blue Environment Deployment and configure service for that.
```
# sudo nano blue-deploy.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-boot-demo-deployment-blue
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: k8s-boot-demo
      version: v1
      color: blue
  template:
    metadata:
      labels:
        app: k8s-boot-demo
        version: v1
        color: blue
    spec:
      containers:
        - name: k8s-boot-demo
          image: javabyraghu/java-web-app:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
```
`kubectl apply -f blue-deploy.yml`
```yaml
# sudo nano service-live.yml
apiVersion: v1
kind: Service
metadata:
  name: k8s-boot-live-service
spec:
  type: NodePort
  selector:
    app: k8s-boot-demo
    version: v1
  ports:
    - name: app-port-mapping
      protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30002
```
`kubectl apply -f service-live.yml`

  After creating the service access our application using below URL
  		http: // node-ip : 30002 / java-web-app/

  - Configure Green Environment using Deployment and new service file
```yaml
# sudo nano green-deploy.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-boot-demo-deployment-green
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: k8s-boot-demo
      version: v2
      color: green
  template:
    metadata:
      labels:
        app: k8s-boot-demo
        version: v2
        color: green
    spec:
      containers:
        - name: k8s-boot-demo
          image: javabyraghu/maven-web-app:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 8080
```
`kubectl apply -f green-deploy.yml`
```yaml
# sudo nano service-prepod.yml
apiVersion: v1
kind: Service
metadata:
  name: k8s-boot-service-preprod
spec:
  type: NodePort
  selector:
    app: k8s-boot-demo
    version: v2
  ports:
    - name: app-port-mapping
      protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: 30092
```
`kubectl apply -f service-prepod.yml`

Access the application using pre-prod service
		http://node-ip:30092/maven-web-app/

- Note: Once pre-prod testing completed then v2 pods we need to make live.
- Q) How can we make Green PODS as Live?
	- Go to service-live.yml and change selector to 'v2' and apply
- kubectl apply -f service-live.yml
	- After applying live service with v2 then our live service will point to green pods (latest code)
	URL : http://node-ip:30002/maven-web-app/


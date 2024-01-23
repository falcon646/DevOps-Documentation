# Deployment
Deployments are one of the most commonly used resources in Kubernetes for managing application deployments and scaling. They provide an abstraction layer that simplifies the management and updates of pods, making it easier to ensure the desired state of your application.

Deployment is a resource object that provides declarative updates to applications. It allows you to describe the desired state for your application, including the number of replicas, the Docker image to use, and the way to update the application. Deployments are part of the "Apps" API group in Kubernetes

Key features and concepts associated with Deployments:

- Declarative Updates: Deployments enable you to declare the desired state of your application. You specify the number of replicas, the container image, and other configuration details in a declarative manner.

- Replica Sets: Under the hood, a Deployment manages Replica Sets. A Replica Set ensures that a specified number of replicas (Pods) are running at all times.

- Rolling Updates and Rollbacks: Deployments support rolling updates, allowing you to update your application without downtime. It gradually replaces old Pods with new ones to ensure a smooth transition.
If there are issues with the update, you can perform rollbacks to a previous version of the application.

- Scalability: You can easily scale the number of replicas up or down using Deployments. Scaling up increases the number of Pods, while scaling down decreases them.

- Pod Template: Deployments use a Pod template to create new Pods or update existing ones. The template specifies the desired state for the Pods, including container images, labels, and other configuration.

- High-Level Abstraction: Deployments provide a higher-level abstraction compared to directly managing Replica Sets. They simplify the management of rolling updates, rollbacks, and scaling operations.

- Self-Healing: Deployments continuously monitor the state of the Pods. If a Pod fails or is terminated, the Deployment automatically replaces it to maintain the desired number of replicas.

- Selectors: Deployments use selectors to match Pods managed by the Deployment. This allows the Deployment to keep track of which Pods it should manage and update.

- Annotations and Labels: You can use annotations and labels to add metadata to your Deployment. This metadata can be used for organization, filtering, and integration with other tools.

- Revision History: Deployments maintain a revision history, allowing you to view and rollback to previous versions. Each update creates a new revision, preserving the state of the Deployment at that point in time.

## Deployment Yaml

Writing a Deployment YAML in Kubernetes involves specifying the desired state of your application, including details about the container images, replicas, labels, and potentially other settings. Below are the key components and important parts you might include in a Deployment YAML:
- A basic deployment yaml is exactly same as ReplicSet yaml which container the replicas , seldctor and pod template section. the only differenec is the kind would be Deployment
- Basic Structure:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
spec:
  replicas: 3  # Number of desired replicas
  selector:
    matchLabels:
      app: my-app  # Label to select Pods belonging to this Deployment
  template:
    metadata:
      labels:
        app: my-app  # Label applied to Pods created by this Deployment
    spec:
      containers:
        - name: my-app-container
          image: my-app:latest  # Container image and version
          ports:
            - containerPort: 80  # Port the container listens on
```
Components and Explanation:
- apiVersion and kind:
  - Specify the API version (apps/v1) and the kind (Deployment) of the Kubernetes object.
- metadata:
  - Contains metadata for the Deployment, such as the name (my-app-deployment).
- spec: Describes the desired state of the Deployment.
  - replicas: 
    - Specifies the desired number of replicas (Pods) to run (e.g., 3).
  - selector:
    - Defines how the Deployment selects which Pods to manage. It uses labels to match Pods.
  - matchLabels: 
    - Specifies the label(s) that identify Pods managed by this Deployment.
  - template:
    - Contains the template for creating Pods.
  - metadata.labels: 
    - Labels applied to Pods created by this template.
  - spec.containers: Describes the containers within each Pod.
    - name: Name of the container.
    - image: Container image and version.
    - ports: Specifies the ports the container exposes.

### Sample Deployment File
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deploy
  labels:
    name: my-deploy
spec:
  replicas: 4
  selector:
    matchLabels:
      apptype: web-backend
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        apptype: web-backend
    spec:
      containers:
        - name: my-app
          image: javabyraghu/maven-web-app
          ports:
            - containerPort: 8080
```

### Deployment Commands
```bash
# use this for more options
kubectl create deployment --help

# Create Deployment using command (Not recommended)
kubectl create deployment <name> --image <image-name> --replicas <count>
kubectl create deployment my-depl --image nginx --replicas 3

# create Deployment from YAML file
kubectl create -f web-deploy.yml
# apply modifucations to yaml file
kubectl apply -f web-deploy.yml

# Completely Modify Pod Template
kubectl replace –f web-deploy.yml

# list Deployments
kubectl get deployments
kubectl get deploy
kubectl get deploy -o wide
kubectl get deploy <deployment-name> -o json
kubectl get deploy <deployment-name> -o yaml

# View Deployment Description 
kubectl describe deploy <deployment-name>

# edit existing deployment
kubectl edit deploy <deployment-name>

#scale replica count of deployment
kubectl scale deploy <deployment-name> --replicas=<desired-replica-count>

# Delete Deployment
kubectl delete deploy <deployment-name>
kubectl delete -f web-deploy.yml

# to generate YAML file without wiring it manually
kubectl create deployment my-deploy --image nginx --replicas 4 --dry-run -o yaml > test-deployment.yml
# Then apply the yaml
kubectl apply -f test-deployment.yml

# update the container image version of the deployment /deploy a new image
kubectl set image deployment/<deploy-name> <container-name>=<image>
kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1
```

## Deployment Strategy
Deployments offer built-in support for rolling updates, allowing you to update your application while minimizing downtime. You can define strategies for how many new pods to create and how many old pods to terminate at each step of the update.

The two primary deployment strategies are:

- Rolling Update:

    A rolling update gradually replaces old Pods with new ones, ensuring that a specified number of replicas are running at all times.
    It minimizes downtime and ensures continuous availability during the update process.

    How It Works:
        
    - New Pods are gradually created alongside existing ones.
    - Old Pods are gradually terminated as new Pods become ready.
    - The process continues until all old Pods are replaced by new ones.

```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 25%
```
- Recreate:

    In a recreate deployment, all existing Pods are terminated before new ones are created.
    This strategy results in a temporary downtime during the update.

    How It Works:
    - All existing Pods are terminated.
    - New Pods are then created to match the desired state.
```yaml
spec:
  strategy:
    type: Recreate
```
## Deployment Models

- Blue-Green Deployment:
    - Blue-Green Deployment involves maintaining two separate environments (blue and green) and switching traffic between them.
    - This strategy allows for testing the new version in a production-like environment before directing traffic to it.

    How It Works:
    
    - Two environments (e.g., two Deployments) are maintained: blue and green.
    - Initially, traffic is directed to the "blue" environment (the currently active version).
    - The new version is deployed to the "green" environment.
    - After testing, traffic is switched from "blue" to "green"
    - command: `kubectl apply -f blue-deployment.yaml / kubectl apply -f green-deployment.yaml`

    ```yaml
    # Blue Deployment
    metadata:
      name: blue-deployment
    spec:
      ...
    ---
    # Green Deployment
    metadata:
      name: green-deployment
    spec:
      ...
    ```

- Canary Deployment:
    - A Canary Deployment introduces the new version of the application to a subset of users or traffic.
    - It allows for gradual testing and monitoring of the new version's performance.
    
    How It Works:
    
    - A small percentage of traffic is directed to the new version (canary).
    - The deployment is gradually scaled up if the canary performs well.
    - Command: `kubectl apply -f deployment.yaml`
     
    ```yaml
    spec:
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxUnavailable: 0
          maxSurge: 25%
    ```
- A/B Testing
    - A/B Testing involves running multiple versions of a feature concurrently and directing different users or traffic to each version.
    - It helps assess the impact of changes on user behavior or system performance.
    
    How It Works:
    - Multiple versions of the application are deployed.
    - Users are randomly assigned to different versions.
    - Command: `kubectl apply -f version-a-deployment.yaml / kubectl apply -f version-b-deployment.yaml`
    - Example Deployment YAML:
    
    ```yaml
    # Version A
    metadata:
      name: version-a
    spec:
    ...
    ---
    # Version B
    metadata:
      name: version-b
    spec:
    ...
    ```

### Deployment Lifecycle Management
- Updates: Managing the process of updating application versions or configurations
    - Updates refer to the process of modifying the state of a Deployment to a new desired state. This can include changes to the container image, environment variables, labels, and other specifications.
    - Behavior: Deployments support rolling updates, ensuring that the application is updated gradually without causing downtime. Old Pods are replaced with new ones, maintaining a specified number of replicas
    - Command : `kubectl apply -f deployment.yaml`
    - Strategy : Rolling Update, Recreate, Blue-Green, Canary, A/B Testing.

- Rollback: Reverting to a previous known stable state in case of issues with an update.
    - Rollbacks involve reverting a Deployment to a previous version or revision. - This is useful in case an update introduces issues, and you need to return to a known stable state.
    - Command: `kubectl rollout undo deployment <deployment-name> --to-revision=<revision-number>`
    - Behavior: When a rollback is initiated, Deployments automatically replace the current Pods with the Pods from the previous revision, effectively undoing the recent update. 

- Pause :  Temporarily halting the update process for inspection, adjustments, or controlled progression.
    - Pausing a Deployment temporarily stops the rolling update process, preventing further changes to Pods. 
    - This is useful for inspection, validation, or making manual adjustments during an update.
    - Command: `kubectl rollout pause deployment <deployment-name>`
    - Behavior: Once paused, the Deployment maintains the current state without progressing through the update. You can inspect the state of Pods or make necessary adjustments.

- Resume :  Resuming the update process after it has been paused
    - Resuming a Deployment restarts the rolling update process after it has been paused. This allows the update to continue from where it left off.
    - Command: `kubectl rollout resume deployment <deployment-name>`
    - Behavior: Once resumed, the Deployment proceeds with the rolling update, replacing old Pods with new ones according to the defined strategy.

- History: Maintaining a record of revisions and updates to a Deployment over time.
    - Deployment history refers to the record of revisions and updates made to a Deployment over time. It allows users to view the details of each revision and facilitates rollbacks to specific points in history.
    - Command : `kubectl rollout history deployment <deployment-name>`
    - Behavior: The history includes details such as revision number, status, and changes made in each update. Users can choose to rollback to a specific revision based on this history.

- A Deployment's rollout is triggered if and only if the Deployment's Pod template (that is, .spec.template) is changed, for example if the labels or container images of the template are updated. Other updates, such as scaling the Deployment, do not trigger a rollout.
- Deployment ensures that only a certain number of Pods are down while they are being updated. By default, it ensures that at least 75% of the desired number of Pods are up (25% max unavailable).
commands
```bash
# Trigger an update
kubectl apply -f deployment.yaml

# see the Deployment rollout status
kubectl rollout status <deployment-name>

# View rollout history
kubectl rollout history deployment <deployment-name>

# rollback to the last reviosion
kubectl rollout undo deployment/nginx-deployment
# Rollback to a specific revision
kubectl rollout undo deployment <deployment-name> --to-revision=<revision-number>

# Pause and resume a deployment
kubectl rollout pause deployment <deployment-name>
kubectl rollout resume deployment <deployment-name>

# To see the details of each revision, run:
kubectl rollout history deployment/nginx-deployment --revision=2

# restart all pods associated with a deployment
kubectl rollout restart deployment <deployment-name>

```


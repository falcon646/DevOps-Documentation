## Deployment Rollouts

A Deployment Rollout in Kubernetes refers to the process of updating or modifying the state of a Deployment, ensuring a smooth transition from the current version of the application to a new one. The rollout is a controlled and gradual process that aims to minimize disruption and maintain the availability of the application during updates.

Here are key aspects of a Deployment Rollout:

- Triggering the Rollout:
    -A rollout is initiated when there is a change in the Deployment's configuration, such as updating the container image, adjusting replicas, or modifying other settings.
    - Common commands to trigger a rollout include `kubectl apply -f deployment.yaml` for configuration changes and `kubectl set image deployment/<deployment-name> <container-name>=<new-image>` for updating container images.
- Rolling Update Strategy:
    - The default rollout strategy for Deployments is often a rolling update.
    - In a rolling update, new Pods are gradually created to replace the old ones, ensuring continuous availability of the application.
    - The number of old Pods that can be unavailable at any given time is controlled by the maxUnavailable setting in the Deployment configuration.
- Monitoring the Rollout:
    - Kubernetes provides commands to monitor the progress of a rollout. For example:
        - `kubectl rollout status deployment <deployment-name>`: Monitors the status of a rollout.
        - `kubectl get pods` or `kubectl describe deployment <deployment-name>`: Inspects the state of individual Pods.
- Rollback Mechanism:
    - In case issues are detected during the rollout or monitoring phase, Kubernetes supports a rollback mechanism.
    - The kubectl rollout undo command can be used to roll back to a previous revision, restoring the application to a known stable state.
- Deployment Revisions:
    - Each time a change is made to a Deployment, a new revision is created to represent the updated configuration.
    - Revisions allow for tracking and managing different states of the Deployment over time.
- Configuration Drift and History:
    - The rollout process ensures that the desired state specified in the updated configuration is gradually applied to the running Pods.
    - Kubernetes maintains a history of the rollout, allowing you to see the details of each revision and the associated changes.

Deployment rollouts are integral to maintaining the health and evolution of applications in a Kubernetes cluster. They provide a controlled mechanism for applying changes, and the rolling update strategy allows for updates with minimal impact on application availability.


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
kubectl rollout status  deployment <deployment-name>

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
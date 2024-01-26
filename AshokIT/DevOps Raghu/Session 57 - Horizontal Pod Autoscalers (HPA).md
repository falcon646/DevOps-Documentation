#  Scaling in Kubernetes

One of the most powerful features of Kubernetes is autoscaling, as it’s vital that we find the correct balance when scaling resources in our infrastructures. Scale up more than needed, and you will have unused resources which you must pay for. Scale down more than required and your application will not be performant.

Autoscaling is a method of automatically scaling K8s workloads up or down based on historical resource usage. Autoscaling in Kubernetes has three dimensions:

- Horizontal Pod Autoscaler (HPA): adjusts the number of replicas of an application.
- Cluster Autoscaler: adjusts the number of nodes of a cluster.
- Vertical Pod Autoscaler (VPA): adjusts the resource requests and limits of a container.

The different autoscalers work at one of two Kubernetes layers

- Pod level: The HPA and VPA methods take place at the pod level. Both HPA and VPA will scale the available resources or instances of the container.
- Cluster level: The Cluster Autoscaler falls under the Cluster level, where it scales up or down the number of nodes inside your cluster.

## Horizontal Pod Autoscaler (HPA)

HPA is a form of autoscaling that increases or decreases the number of pods in a replication controller, deployment, replica set, or stateful set based on CPU utilization—the scaling is horizontal because it affects the number of instances rather than the resources allocated to a single container.

- Metrics: HPA monitors the resource utilization of the target pods, typically focusing on CPU utilization. It uses metrics provided by the Metrics Server, which collects resource usage data from the Kubernetes API server.
- Target resource: HPA is configured to scale based on a specific resource metric, typically CPU utilization, but it can also use custom metrics. CPU utilization is expressed as a percentage of the total available CPU resources across all nodes.
- Scaling behaviour: HPA adjusts the number of replica pods based on the observed resource utilization compared to the defined target. If the utilization exceeds the target, HPA increases the number of replicas. If the utilization is below the target, HPA reduces the number of replicas.
- Integration with deployments: HPA works in conjunction with deployments, replication controllers, or replica sets, where it manages the scaling of pods. It adjusts the replica count within the specified minimum and maximum limits.

HPA can make scaling decisions based on custom or externally provided metrics and works automatically after initial configuration. All you need to do is define the MIN and MAX number of replicas.

Once configured, the Horizontal Pod Autoscaler controller is in charge of checking the metrics and then scaling your replicas up or down accordingly. By default, HPA checks metrics every 15 seconds.

To check metrics, HPA depends on another Kubernetes resource known as the Metrics Server. The Metrics Server provides standard resource usage measurement data by capturing data from “kubernetes.summary_api” such as CPU and memory usage for nodes and pods. It can also provide access to custom metrics (that can be collected from an external source) like the number of active sessions on a load balancer indicating traffic volume.

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/4918c4d9-4759-4efa-b928-fe9578366d06)

While the HPA scaling process is automatic, you can also help account for predictable load fluctuations in some cases. For example, you can:

- Adjust replica count based on the time of the day.
- Set different capacity requirements for weekends or off-peak hours.
- Implement an event-based replica capacity schedule (such as increasing capacity upon a code release).

### How does HPA work?

![image](https://github.com/falcon646/DevOps-Documentation/assets/35376307/64ef348a-7912-4fd0-ad12-8060244abad0)
Overview of HPA

In simple terms, HPA works in a “check, update, check again” style loop. Here’s how each of the steps in that loop work.

- HPA continuously monitors the metrics server for resource usage.
- Based on the collected resource usage, HPA will calculate the desired number of replicas required.
- Then, HPA decides to scale up the application to the desired number of replicas.
- Finally, HPA changes the desired number of replicas.
- Since HPA is continuously monitoring, the process repeats from Step 1.

### Limitations of HPA
While HPA is a powerful tool, it’s not ideal for every use case and can’t address every cluster resource issue. Here are the most common examples:

- One of HPA’s most well-known limitations is that it does not work with DaemonSets.
- If you don’t efficiently set CPU and memory limits on pods, your pods may terminate frequently or, on the other end of the spectrum, you’ll waste resources.
- If the cluster is out of capacity, HPA can’t scale up until new nodes are added to the cluster. Cluster Autoscaler (CA) can automate this process. We have an article dedicated to CA; however, below is a quick contextual explanation.
- Cluster Autoscaler (CA) automatically adds or removes nodes in a cluster based on resource requests from pods. Unlike HPA, Cluster Autoscaler doesn't look at memory or CPU available when it triggers the autoscaling. Instead, Cluster Autoscaler reacts to events and checks for any unscheduled pods every 10 seconds.

## Metric Server

The Metric Server in Kubernetes is a component that collects and provides resource utilization metrics for nodes and pods in a Kubernetes cluster. It exposes these metrics through the Kubernetes Metrics API, which can be queried by other components, tools, or users. The Metric Server helps enable features such as autoscaling based on resource usage and provides insights into the performance of the cluster.

Key features and aspects of the Metric Server include:

- Metrics Collection: The Metric Server collects metrics related to CPU and memory usage for nodes and pods in the Kubernetes cluster. These metrics are essential for understanding resource utilization and making decisions related to scaling and performance.
- Resource Metrics API: The Metric Server exposes the collected metrics through the Kubernetes Metrics API. This API provides a standardized way to query resource usage metrics for pods and nodes in the cluster.
- Scalability: The Metric Server is designed to scale horizontally with the cluster. Multiple replicas of the Metric Server can be deployed to handle larger clusters and higher query loads.

### Deploying a Metric Server in the Kubernetes Cluster
To deploy the Metric Server, you can use YAML manifests provided by the Kubernetes community or included with your Kubernetes distribution. These manifests define the necessary Deployments, Services, and RBAC configurations for the Metric Server components.

`kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`

### Structure of a HPA yaml
Below is a simplified example of an HPA YAML manifest:
```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: example-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1         #
    kind: Deployment            # Mapping our hpa to the desiried deployment
    name: example-deployment    # 
  minReplicas: 1                # min count of replicas
  maxReplicas: 10               # maximim possible count for replicas
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```
Explanation :

- `scaleTargetRef`: This field specifies the reference to the resource (usually a Deployment or ReplicaSet) that the HPA will scale. In this example, it points to a Deployment named example-deployment.
- `minReplicas`: The minimum number of replicas that the HPA should scale down to. This ensures that even during low utilization, a minimum number of pods are maintained. In this example, the minimum number of replicas is set to 1.
- `maxReplicas` : The maximum number of replicas that the HPA can scale up to. This prevents the autoscaler from creating an excessive number of pods. In this example, the maximum number of replicas is set to 10.
- `metrics` : The metrics field is an array that defines the metrics used by the HPA for scaling decisions. In this example, there is one metric specified.
- `Metric Definition`: Each metric definition includes the type of metric and the details of the metric. In this case, the metric type is Resource, indicating a resource metric (such as CPU or memory).
  - `resource`: The resource field specifies the particular resource (CPU or memory) being targeted.
  - `target` : The target field specifies the target type and value for the metric. In this example:
  - `type` : Utilization: Indicates that the target is based on resource utilization.
  - `averageUtilization`: 50: Specifies the target average CPU utilization percentage. The autoscaler will try to maintain the average CPU utilization of the pods at or below 50%.

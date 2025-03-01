# Prometheus Setup  in Kubernetes
Setting up **Kubernetes monitoring using Prometheus and Grafana** can be done in multiple ways, depending on your infrastructure and level of automation. Here are the different approaches:
- Prometheus Operator (kube-prometheus-stack) – Best Practice for Production
- Using Helm to Install Prometheus & Grafana Separately
- Manual Deployment Using YAML Manifests
- Using Managed Prometheus & Grafana (Cloud Solutions)

### **1. Using Prometheus Operator (Recommended)**
The **Prometheus Operator** simplifies deploying and managing Prometheus, Grafana, and Alertmanager in Kubernetes.
- **Pros:**
  - Easy to deploy and manage  
  - Comes with predefined dashboards and alerts  
  - Handles Prometheus, Alertmanager, and Grafana configurations automatically  
  - Provides an automated way to deploy and manage Prometheus, Grafana, and Alertmanager.
  - Supports service discovery and auto-scaling out-of-the-box.
  - CRDs (Custom Resource Definitions) allow dynamic configuration of Prometheus.
  - Pre-built dashboards & alerts for Kubernetes monitoring.
  - Used in large-scale deployments like Red Hat OpenShift, Rancher, and enterprises using Kubernetes.
  - Who uses it?
    - Enterprises running self-managed Kubernetes clusters (bare metal or cloud).
    - Cloud providers offering managed Kubernetes solutions often use this internally.
- **Cons:**
  - Might be overkill for small clusters  
  - More complex than standalone Prometheus  
  - Requires managing storage, HA (High Availability), and scaling Prometheus for large clusters.
  - High memory consumption at scale (needs remote storage like Thanos, Cortex, or Mimir).

### **2. Using Helm to Install Prometheus & Grafana Separately**
Instead of using **Prometheus Operator**, you can install **Prometheus** and **Grafana** as separate Helm charts.
- **Pros:**
  - More control over Prometheus and Grafana configurations  
  - Lighter than using the Prometheus Operator  
- **Cons:**
  - Requires manual setup of alert rules and service discovery  
  - No automatic dashboards  

### **3. Manual Deployment Using YAML Manifests**
For complete control, you can deploy Prometheus and Grafana manually using Kubernetes YAML manifests.
- **Pros:**
  - Full control over configurations  
  - No dependency on Helm or Operators  
- **Cons:**
  - Requires manual setup of scraping rules, dashboards, and alerts  
  - More effort than using Helm or Operators  


#### **4. Using Managed Prometheus & Grafana (Cloud Solutions)**
If running in **AWS, Azure, or GCP**, use their managed solutions:
- **AWS Managed Prometheus & Grafana**
  - **Amazon Managed Service for Prometheus (AMP)**
  - **Amazon Managed Grafana**
  - No need to run Prometheus inside the cluster.
- **Azure Monitor & Grafana**
  - **Azure Monitor for Containers**
  - **Azure Managed Grafana**
- **GCP Cloud Monitoring & Managed Prometheus**
  - **GCP Cloud Monitoring**
  - **GCP Managed Prometheus**
- **Pros:**
  - No need to manage Prometheus/Grafana manually  
  - Scalable and secure  
  - Offloads Prometheus scaling, HA, and storage to cloud providers.
  - No need to manage Prometheus servers.
  - Secure, integrates well with IAM-based access control.
- **Cons:**
  - Expensive for large-scale monitoring  
  - Vendor lock-in  (metrics are not portable across cloud providers).

## **Which Approach to Choose?**
| Method | Ease of Use | Customization | Maintenance Effort |
|--------|------------|---------------|-------------------|
| **Prometheus Operator (Helm)** | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Helm (Separate Install)** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **Manual YAML Deployment** | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Managed Prometheus & Grafana** | ⭐⭐⭐⭐⭐ | ⭐ | ⭐ |

---

# Prometheus Monitering in Kubernetes
https://www.youtube.com/watch?v=6xmWr7p5TE0

**Prometheus** is an open-source monitoring tool. In this session, we will focus on deploying a **Prometheus instance** onto a **Kubernetes cluster** and configuring it to monitor both the cluster itself and any applications running within it.  

If you have previously deployed Prometheus on a **bare metal server** or a **virtual machine (VM)**, the process differs when deploying it on a **Kubernetes cluster**. Instead of managing configurations manually, we will use the **Prometheus Operator**, which simplifies deployment and management (there are other ways of installing , refer the section **Setup Prometheus in Kubernetes**).  

- **Why Use the Prometheus Operator?**  
The **Prometheus Operator** introduces **Custom Resource Definitions (CRDs)** that allow us to define Prometheus configurations using standard **Kubernetes objects**. Instead of modifying the Prometheus configuration file directly, we define everything through Kubernetes-native resources.  

- **Why Deploy Prometheus on Kubernetes Instead of a Separate Server?**  
While it is possible to deploy Prometheus on a separate server to monitor **Kubernetes workloads**, it is generally better to **run Prometheus within the cluster itself**. The key benefits include:  
  - **Proximity to Targets:**  : Keeping Prometheus **close to the monitored applications** reduces network latency and improves metric collection efficiency.  
  - **Leveraging Kubernetes Infrastructure:**  : Running Prometheus within Kubernetes eliminates the need for a dedicated server or VM. Instead, Prometheus can **utilize Kubernetes’ built-in networking, storage, and scheduling features**.
  - By deploying Prometheus **inside the Kubernetes cluster**, monitoring becomes **more efficient and scalable**, leveraging Kubernetes' capabilities for **service discovery and resource management**.


### **Monitoring Applications and the Kubernetes Cluster**  

To effectively monitor a Kubernetes cluster, the following components should be tracked:
- **Applications deployed within Kubernetes.** (ex: web app , webserver etc) 
- **The Kubernetes cluster itself, including its infrastructure metrics.** 
  - `Control-Plane components` (api-server , codedns, kube-scheduler)
    - API Server – The core component handling all Kubernetes API requests.
    - kube-scheduler – Responsible for scheduling pods onto available worker nodes.
    - CoreDNS – Handles DNS resolution within the cluster.
  - `kubelet(cAdvisor)` : The kubelet process runs on each worker node and exposes container-level metrics. It provides functionality similar to cAdvisor (Container Advisor), which collects resource usage statistics from running containers.
  - `Cluster-Level Metric:` By default, Kubernetes does not expose cluster-level metrics such as those related to deployments, pods, and services.  The `kube-state-metrics` component must be installed as a container within the cluster. This component is responsible for collecting and exposing cluster-wide metrics about various Kubernetes objects, making them available for Prometheus to scrape. 
  - `Node-Level Metrics ` : `node_exporter` is used to collect node-level metrics such as CPU, memory, disk usage, and network performance

**kube-state-metrics**
- By default, Kubernetes does not expose cluster-level metrics such as pod status, deployments, or service availability. To gain access to these metrics:
- The **`kube-state-metrics container` must be deployed** within the Kubernetes cluster.
Once deployed, it collects and exposes these metrics for Prometheus to scrape and store.

**node_exporter**  

To collect **CPU, memory, and network-related metrics** from every node in a **Kubernetes cluster**, each node must run a **node_exporter** service. There are multiple ways to achieve this:  

1. **Manual Installation:**  The Node Exporter binary can be manually installed and configured on each node.   This method is not ideal for dynamic environments, as it requires manual intervention whenever a new node is added.  

2. **Customizing the Base Image:**  The **node_exporter** process can be included in a custom-built **base image** used for Kubernetes nodes.  While this ensures that all new nodes have **Node Exporter** pre-installed, it introduces additional maintenance overhead when updating images.  

3. **Using a Kubernetes DaemonSet (Recommended Approach):**  
  - **Kubernetes provides a built-in resource called a DaemonSet**, which ensures that a specific **pod runs on every node** in the cluster.   A **DaemonSet** can be used to deploy a **Node Exporter pod** on every node automatically. 
  - Featurs of daemonsets 
    - Ensures that every node **automatically** runs a Node Exporter instance.  
    - When new nodes are added to the cluster, **Kubernetes automatically deploys** the Node Exporter pod to them.  
    - Eliminates the need to **manually install** Node Exporter on each node.  


#### **Service Discovery in Kubernetes for Prometheus**  

In a **Kubernetes-based** environment, prometheus **service discovery** is used to dynamically **discover and scrape monitoring targets** without requiring manual configuration.  It makes sure new workloads and infrastructure components are **automatically monitored** without requiring configuration changes.

**How Service Discovery Works in Prometheus**  
- **Accessing the Kubernetes API :**   Prometheus integrates with the **Kubernetes API server** to dynamically retrieve a list of monitoring targets.  
   - These targets include:  
     - **Kubernetes control plane components** (e.g., API server, scheduler, CoreDNS).  
     - **Node Exporters** running on each node (for system-level metrics).  
     - **kube-state-metrics** (for Kubernetes object metrics like pods, deployments, and services).  
- **Automatic Discovery of Targets:**  Instead of manually defining **static endpoints** for each component, **Prometheus uses Kubernetes service discovery** to **automatically** detect and update its list of monitoring targets.  
- **Service Monitors for Scraping Targets:**   **ServiceMonitors** (a custom resource provided by the **Prometheus Operator**) specify which services Prometheus should scrape. These objects define the **selectors** and **endpoints** for Prometheus to discover monitoring targets.  

##### **Deploying Prometheus with Service Discovery**  

When deploying Prometheus in Kubernetes, **service discovery is enabled by default**. By configuring **ServiceMonitors**, Prometheus can seamlessly discover and scrape metrics from **Kubernetes resources**, **Node Exporters**, and **kube-state-metrics** without requiring manual intervention.

### **Prometheus Operator in Kubernetes**  

The **kube-prometheus-stack** Helm chart utilizes the **Prometheus Operator** to simplify the deployment and management of Prometheus within a **Kubernetes** environment.  

- **What is a Kubernetes Operator?**  
A **Kubernetes Operator** is an **application-specific controller** that extends the **Kubernetes API** to automate the deployment, configuration, and management of complex applications. Operators allow Kubernetes to **handle the full lifecycle** of applications like Prometheus, including:  
  - **Initialization:** Deploying and setting up the application.  
  - **Configuration Management:** Applying and updating configurations dynamically.  
  - **Customization:** Adjusting settings to match specific requirements.  
  - **Self-Healing:** Restarting the application if needed, ensuring high availability.  

- **How the Prometheus Operator Works**  
The **Prometheus Operator** manages **Prometheus instances** inside a **Kubernetes cluster**.  
  - It watches for **custom resources** (e.g., `Prometheus`, `ServiceMonitor`, `Alertmanager`) and automatically **provisions and manages** them.  
  - Any changes made to the **Prometheus configuration** are automatically applied **without manual intervention**.  
  - It ensures **Prometheus instances are restarted** when necessary, such as after configuration updates.  

- **Using the Prometheus Operator with Helm**  
The **kube-prometheus-stack** Helm chart installs the **Prometheus Operator** along with the **Prometheus monitoring stack** (Prometheus, Alertmanager, Grafana, and exporters).  
  - Although the operator is included in the Helm chart, it can also be deployed **independently** for experimentation and deeper understanding.  

#### **Custom Resources Provided by the Prometheus Operator**  
The **Prometheus Operator** introduces several **Custom Resource Definitions (CRDs)** that simplify the deployment and management of Prometheus within a **Kubernetes cluster**. These resources provide a **higher-level abstraction** over standard Kubernetes objects, eliminating the need to manually create **Deployments, StatefulSets, or ConfigMaps** for Prometheus.  Below are thr crd's provided by Prometheus Operator
- **Prometheus (`Prometheus` CRD)**  
  - This resource defines and manages a Prometheus instance in Kubernetes.  
   - Instead of manually creating a **StatefulSet**, the `Prometheus` resource allows users to declaratively configure Prometheus via the Kubernetes API.  
   - Users can specify **storage, replicas, retention policies, and scrape configurations** within this resource.  
- **Alertmanager (`Alertmanager` CRD)**  
   - Manages the deployment and configuration of **Alertmanager**, which is responsible for handling **alerts** generated by Prometheus.  
   - Similar to Prometheus, it abstracts the need for a manual **Deployment** or **StatefulSet**.  
- **PrometheusRule (`PrometheusRule` CRD)**  
   - Allows users to define **alerting and recording rules** that Prometheus should evaluate.  
   - This CRD ensures that alerting rules are automatically applied without modifying Prometheus configurations directly.  
- **ServiceMonitor (`ServiceMonitor` CRD)**  
   - Defines the **services** in Kubernetes that Prometheus should scrape for metrics.  
   - Instead of manually specifying target endpoints, users can create `ServiceMonitor` resources to dynamically discover services within the cluster.  
- **PodMonitor (`PodMonitor` CRD)**  
   - Similar to `ServiceMonitor`, but used for **scraping individual pods** rather than services.  
   - This is useful for monitoring **pod-level metrics** without requiring a separate service.  

#### **Installing Prometheus Operator (kube-prometheus-stack) in a Kubernetes Cluster**
- **Prerequisites:**  **Helm** and **kubectl installed**installed  
- **Step 1️: Add the Helm Repo**
    ```sh
    # Add the Prometheus community Helm chart.
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    # Update the Helm repository
    helm repo update
    ```
- **Step 2️: Install kube-prometheus-stack**
    - Before the installation of the operator, we need to get the values file of the helm chart so that we can make configuration changes if we want.
        ```sh
        # To get the values file, use the following command. Use this file to modify configurations
        helm show values prometheus-community/kube-prometheus-stack > values.yaml
        # install the Prometheus Operator using the Helm
        helm install prometheus prometheus-community/kube-prometheus-stack --namespace prometheus-operator --create-namespace
        ```
        - This deploys **Prometheus, Grafana, Alertmanager, and exporters**.

#### **Analysing the resources created by kube-prometheus-stack**

Let's take a look at what was actually created. Running `kubectl get all` will display all the Kubernetes resources
```sh
controlplane ~ ➜  kubectl get all -n moniter
NAME                                                         READY   STATUS                 RESTARTS   AGE
pod/alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running                0          4m50s
pod/prometheus-grafana-68589f687c-rg82c                      3/3     Running                0          5m
pod/prometheus-kube-prometheus-operator-79d968d85f-bc68w     1/1     Running                0          5m
pod/prometheus-kube-state-metrics-dfd547559-hs26w            1/1     Running                0          5m
pod/prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running                0          4m49s
pod/prometheus-prometheus-node-exporter-clztg                1/1     Running  		    0          5m
pod/prometheus-prometheus-node-exporter-ndq9v                1/1     Running  		    0          5m
pod/prometheus-prometheus-node-exporter-qnwft                1/1     Running                0          5m

NAME                                              TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
service/alertmanager-operated                     ClusterIP      None             <none>        9093/TCP,9094/TCP,9094/UDP      4m51s
service/prometheus-grafana                        ClusterIP      172.20.253.18    <none>        80/TCP                          5m1s
service/prometheus-kube-prometheus-alertmanager   ClusterIP      172.20.38.178    <none>        9093/TCP,8080/TCP               5m1s
service/prometheus-kube-prometheus-operator       ClusterIP      172.20.222.50    <none>        443/TCP                         5m1s
service/prometheus-kube-prometheus-prometheus     LoadBalancer   172.20.129.169   <pending>     9090:31569/TCP,8080:30266/TCP   5m1s
service/prometheus-kube-state-metrics             ClusterIP      172.20.20.210    <none>        8080/TCP                        5m1s
service/prometheus-operated                       ClusterIP      None             <none>        9090/TCP                        4m50s
service/prometheus-prometheus-node-exporter       ClusterIP      172.20.12.202    <none>        9100/TCP                        5m1s

NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/prometheus-prometheus-node-exporter   3         3         0       3            0           kubernetes.io/os=linux   5m1s

NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prometheus-grafana                    1/1     1            1           5m1s
deployment.apps/prometheus-kube-prometheus-operator   1/1     1            1           5m1s
deployment.apps/prometheus-kube-state-metrics         1/1     1            1           5m1s

NAME                                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/prometheus-grafana-68589f687c                    1         1         1       5m1s
replicaset.apps/prometheus-kube-prometheus-operator-79d968d85f   1         1         1       5m1s
replicaset.apps/prometheus-kube-state-metrics-dfd547559          1         1         1       5m1s

NAME                                                                    READY   AGE
statefulset.apps/alertmanager-prometheus-kube-prometheus-alertmanager   1/1     4m51s
statefulset.apps/prometheus-prometheus-kube-prometheus-prometheus       1/1     4m50s
```

- **StatefulSets**
  - `prometheus-prometheus-kube-prometheus-prometheus` represents the actual **Prometheus server**, which runs the Prometheus instance. When connecting to the Prometheus server, the connection is made to this container.  
  - `alertmanager-prometheus-kube-prometheus-alertmanager` is a  **StatefulSet** for **Alertmanager**, which manages alerting.  
- **Deployments**
  - **prometheus-grafana**: This deployment includes **Grafana**, a graphical UI tool used to visualize data stored in the Prometheus time-series database. The **Helm chart** automatically installs Grafana, allowing it to connect to Prometheus easily. 
  - **prometheus-kube-prometheus-operator**: This operator manages the **lifecycle** of the Prometheus instance. It handles configuration updates, restarts the process when configurations change, and performs other management tasks.  
  - **prometheus-kube-state-metrics**: This deployment is responsible for exposing **Kubernetes object metrics**, such as deployments, services, and pods. Since Kubernetes does not expose these metrics by default, a running container is needed to collect and expose this data.  
- **DaemonSet**
  - **prometheus-prometheus-node-exporter** is a **DaemonSet** ensures that a specific pod runs on every node in the cluster. The **node-exporter** collects host-level metrics. These metrics are then exposed so that Prometheus can collect them.  example  
    - **CPU utilization**  
    - **Memory usage**  
    - **File system statistics**  
- **Pod**  
  - The **Prometheus server pod**  
  - The **Alertmanager pod**  
  - The **Grafana pod**  
  - The **Prometheus operator pod**  
  - The **kube-state-metrics pod**  
  - Two **node-exporter pods** (one on each node)  
- **Service**
  - here , services corresponding to these pods are listed. All services currently have a **ClusterIP** type, meaning they are only accessible within the cluster. To access **Prometheus or Grafana externally**, one of the following configurations is needed:  
    - **Ingress**  
    - Modifying the service type to **LoadBalancer**  
    - Using a **port-forwarding proxy**  


- **Analysing Statefulset `prometheus-prometheus-kube-prometheus-prometheus`**
  - `kubectl describe statefulset prometheus-prometheus-kube-prometheus-prometheus -n <namespace>`
  - **containers**
    - The first container is an **init container** named **init-config-reloader**.  
      - This container appears responsible for creating the initial Prometheus configuration.  
      - It uses a **Prometheus config reloader** image.  
      - Various arguments are passed to it, but the key detail is that it ensures Prometheus starts with the correct initial configuration.  
    - 2nd Container , ie the main **Prometheus container** is defined.  
      - The container runs a specific **Prometheus image**.  
      - Key arguments passed to the container include:  
        - The **configuration file path**  
        - The **time-series database path**  
        - Paths for the **console and console libraries**  
    - 3rd container named **config-reloader**.  
      - This container monitors changes to the Prometheus configuration.  
      - If any modifications are detected, it automatically reloads the Prometheus instance to apply the changes.  
  - **mounts** 
    - The **Prometheus configuration file** is mounted at: `/etc/prometheus/config` . This maps to the **`prometheus.yaml`** configuration file.  
    - The **Prometheus rules files** are stored at:  `/etc/prometheus/rules`. These rule files define alerting and recording rules.  
  - **volumes** 
    - A volume named **config** is mapped from a **Kubernetes secret** name `prometheus-prometheus-kube-prometheus-prometheus` which mounts the file at `/etc/prometheus/config` . This is the main config file discussed just above this. Describe the secret reveals the presence of a compressed configuration file **`prometheus.yaml.gz`**, which contains the Prometheus configuration.
    - The **rules volume** comes from a **ConfigMap** named `prometheus-prometheus-kube-prometheus-prometheus-rulefiles-0` which contains a **standard Prometheus rule file**.  
  - *Note : How can the Prometheus configuration be modified?*  
    - When using the **Prometheus Operator**, configuration changes do not require direct modifications to `prometheus.yaml`.  
    - Instead, standard **Kubernetes manifests** can be used to generate and apply Prometheus configurations dynamically.  
    - This approach simplifies management and eliminates the need to manually edit configuration files.  

- **Analysing Deployment `prometheus-kube-prometheus-operator`**
  - `kubectl describe deployment prometheus-kube-prometheus-operator`
  - **containers** section:  
    - The deployment includes a container named **`kube-prometheus-stack`**.  
    - It runs the **Prometheus Operator image**.  
    - Several command-line arguments are automatically provided to configure the operator for proper functionality.  
  - **mounts**:  
    - The only mounted resource is a **TLS certificate**, which ensures secure communication.   


####  Kubernetes Service Discovery for Prometheus 
It is important to understand how Prometheus uses **Kubernetes Service Discovery**, which enables **automatic discovery** of scrape targets within a cluster.

Kubernetes provides **built-in service discovery** mechanisms that allow Prometheus to dynamically discover targets for monitoring. There are multiple ways Prometheus can discover targets:
- documentaion : https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config

1. **Node Discovery**  
   - Discovers all **nodes** within the Kubernetes cluster.  
   - Retrieves metadata such as **node name**, **provider ID**, and **labels**.  
   - Targets the **Kubelet's HTTP port** by default.

2. **Service Discovery**  
   - Identifies all **services** in the cluster along with their **respective ports**.  
   - Useful for monitoring services via their **ClusterIP** or **external endpoints**.

3. **Pod Discovery**  
   - Discovers all **pods** running in the cluster.  
   - Exposes **each container** as an individual monitoring target.  
   - Extracts pod-level metadata such as **labels**, **annotations**, and **IP addresses**.

4. **Endpoint Discovery (Most Flexible)** : With this role we acam basically discover pods Services nodes and everything else using the endpoints 
because everything is going to have an endpoint or a service assigned to it. Think of an 
endpoint as just an IP address and a port tied to some resource , it doesn't matter what that resource is it could be a pod , service or node it 
could be really anything.  So everything technically has an endpoint and with that we can just get everything all pods , all nodes , all services,  we can get everything in our  cluster and then we can set up filters so that we can scrape targets that match certain labels s
   - Discovers targets from **service endpoints**.  
   - Retrieves all **pods, services, and nodes** dynamically.  
   - Every resource in Kubernetes (pods, nodes, services) has an **endpoint (IP + port)**, making this method highly flexible.  
   - Enables **fine-grained filtering** by applying **label selectors** to select specific targets.
   - The default **Prometheus configuration** provided by the Helm chart primarily uses **endpoint discovery**. This approach ensures that **all necessary resources**—nodes, services, and pods—are discovered without requiring multiple discovery mechanisms.

### Prometheus Scrape Configurations  

With the **Prometheus server** and **web UI** running, navigate to **Status > Configuration** to inspect the automatically generated configurations. The **global settings** can be ignored for now, as the focus is on the **scrape configurations**.  

Scrolling down to the **scrape configs** section, several job names are listed, such as:  
- `ServiceMonitor/default/Prometheus`  
- `kube-prometheus-stack-alertmanager` : This  configuration is responsible for scraping the **Alertmanager**. 

At the bottom of the configuration, the **Kubernetes service discovery** section can be found. It utilizes the **endpoints role**, which ensures that all endpoints within the Kubernetes cluster are discovered. No additional configurations are required beyond this.  

To ensure that **only the Alertmanager** is targeted and to prevent unnecessary scraping, **relabeling configurations** are applied. These configurations filter and retain specific labels. One key section in the configuration checks for:  
- `__meta_kubernetes_service_label_app`  
- `__meta_kubernetes_service_labelpresent_app`  

A **regex pattern** is used to match **`kube-prometheus-stack-alertmanager`**, ensuring that only the correct **Alertmanager endpoint** is scraped. The action specified is `keep`, meaning only this instance is retained for monitoring.  

Other relabeling configurations follow a similar pattern. For example:  
- `__meta_kubernetes_service_label_release`  
- `__meta_kubernetes_service_labelpresent_release`  

These labels indicate that a service should be monitored by Prometheus. The label value is expected to be `Prometheus`, and only targets with this label are scraped.  

Beyond the **Alertmanager**, additional configurations handle other key Kubernetes components, including:  
- **Kubernetes API server** – Responsible for scraping API server metrics  
- **CoreDNS** – Ensures DNS metrics are collected  
- **Kube Controller Manager, Etcd, Kube Proxy** – Various control plane components  

Each of these components follows the same approach:  
1. **Service discovery** identifies the relevant endpoints  
2. **Relabeling rules** ensure only the necessary targets are retained  
3. **Prometheus scrapes the filtered targets**  

The **Service Discovery section** in the Prometheus UI lists all discovered targets, such as:  
- **Alertmanager**  
- **Kubelet instances (e.g., kubelet-0, kubelet-1, kubelet-2)**  
- **Prometheus Operator**  
- **Prometheus Server**  
- **Kube-State-Metrics**  
- **Node Exporter**  
- **API Server**  
- **CoreDNS**  

The **Targets section** confirms that all targets are in an **UP state** and are being successfully scraped.  

### Configuring Prometheus to Monitor an Custom Application Using Prometheus Operator  

When **Prometheus is installed using the Prometheus Operator**, it can be configured to **monitor an application running on a Kubernetes cluster**. To demonstrate this, a we'll a simple nodejs application that exposes its metrics using the swagger-stats library at `/swagger-stats/metrics`

- **Application Overview**  
  - Repo : [node-swagger-stats-demo](https://github.com/falcon646/node-swagger-stats-demo)
  - The application is built using the **Express** framework, allowing it to expose an API.  
  - The application runs on **port 3000**, meaning any Kubernetes service created for it must be configured to **forward traffic to port 3000**.  
  - **Prometheus metrics** are exposed at:  `/swagger-stats/metrics`. This is the **endpoint Prometheus should scrape** to collect metrics from the application. 
  - Conatinerize the application to be used as a image in kubernets manifests

- **Kubernets Manifests**  
  - Creating and deploy Kubernetes **manifests** for deployment using the docker image. (`api-deployment.yaml`)  
  - Exposing the application via a **Service** to allow Prometheus to scrape metrics. (`api-service.yaml`)

- **Setup Promethetus to scrape this application**
This setup ensures that the Prometheus Operator can dynamically discover and monitor the application running in Kubernetes.

-------------
remaining part

-------
so we got our application deployed onto kubernetes uh now it's time to set up the Prometheus configuration so that 
it's aware of these new targets and there's two different ways of doing this and I don't want to say one way is the 
wrong way and one way is the right way I would say that one way is the less ideal weight and the other way is the more 
optimal way that the Prometheus operator would like you to configure it so I'm going to show you the the less preferred 
way first we're not going to run through all of the steps I just want to give you a high level overview of what to change 
and it's pretty straightforward and then in the next video we'll take a look at how we can make use of service monitors which is the more ideal way of adding 
new targets to Prometheus and so when we first covered Helm I mentioned that we 
have the values file which allows us to tweak the configuration of your Helm chart and so what we want to do is we 
want to do Helm show values again and this is going to be the name of the repo we have to pass in so this is going 
to be Prometheus Dash community slash Cube Prometheus stack 
and then we want to pipe this into a values.yaml file so this will show you all of the different things that we can configure and modify 
and in here what we want to do is we want to search for something called additional 
scrape config so if you search for additional scrape you'll see a section here called additional scrape configs 
and it's going to go over what it means so the documentation is actually pretty good and so here the additional scrape 
configs allow specifying additional Prometheus scrape configurations so that's pretty much exactly what we're looking for 
but it does give you a couple of disclaimers it says that scrape configs are appended the user is responsible to 
make sure it's valid it's not going to perform any kind of validation for you and note that using this feature may 
expose the possibility to break upgrades of Prometheus and so that's why I said this is the less ideal way of doing 
things it'll work but you know could potentially lead to some issues so all you have to do is under this section 
right here you can see additional scrape configs all you have to do is just provide a list of jobs and so this has 
an example job right here and you'll notice the configs are exactly the same as a Prometheus configuration it's just 
like configuring a job on your Prometheus server no different so you're just basically passing a list of new jobs and so you could just uncomment 
this remove this and then provide all your jobs so this 
is just one job in this case and then after you have that what we can do is do a Helm upgrade so 
we would do Helm upgrade and then the name of the release which 
is Prometheus then the name of the chart and I'm just going to copy the name from the chart from right here 
and then you want to do a dash F which is to pass in a file and you want to pass in the values.yaml file so this is 
going to contain the the configuration and then the upgrade is going to make any of the changes that are necessary from our previous uh deployment and that 
should update the configuration and then Prometheus should now be aware of the new targets and like I said this is the 
less ideal way and so in the next video we're going to cover how to use service monitors so that we can more 
declaratively apply new scrape configs for Prometheus 
thank you so now let's move on to seeing how we can add targets to the scrape 
 
list using the service monitor method and so first I want to talk about crds or custom resource definitions so the 
Prometheus operator that we have running comes with several custom resource definitions that provide a high level 
abstraction for deploying Prometheus as well as configuring it and we could take a look at all of the crds by running the 
command cubectl get crd and so there's several different crds we could see at the top we've got one for alert manager 
config we've got one for alert manager but the two that we want to focus on are Prometheus so this one is used to 
actually create a Prometheus instance so you could provide various details regarding how you want it configured 
when you deploy it and then specifically for this video we have the service monitor crd so this is what we're going 
to use or create so that we can add additional targets for Prometheus to scrape and a crd is going to act like 
any other Prometheus object we're going to configure it like any other kubernetes resource and I'm going to 
show you how easy it is to get a new set of targets added to your scrape list using the service monitors so what is a 
service monitor a service monitor defines a set of targets for Prometheus to Monitor and scrape 
and so what it does is it allows you to avoid having to touch the Prometheus configs directly and it gives you a 
declarative kubernetes syntax to Define targets so instead of modifying the Prometheus configs what you're doing is 
actually creating kubernetes resources that update the list of targets that you should be scraping so it's going to look 
like you're creating regular kubernetes resources you won't really even be able to tell that you're touching the 
Prometheus configs so we had previously deployed a our app and we deployed a 
deployment as well as a service this is what our service looks like now a service monitor is going to reference a 
service someplace in our application so if we want to scrape our API that we 
created we're going to have to reference the service that we created for our API 
and we're going to create a service Monitor and if you take a look at it it's basically like any other kubernetes 
resource under kind we just set it to service monitor so it's our own custom resource that we defined for our 
application and there's a couple of things that I want to point out first of all we've got the name right here this 
is just some arbitrary name you can name it then we've got a couple of labels these do matter but we'll cover that in 
a bit but really what we want to focus on is this endpoint section so here we provide some information as to you know 
what is the scrape interval so this is going to scrape a specific Target every 30 seconds and then the path so you know 
by default it's going to be slash metrics but I told you our application is going to be running on slash Swagger Dash stats metric so that's why you see 
that like this now how do we actually get our service monitor to point to a specific service that our application is 
using it's very simple there's a couple of things first of all under the selector match labels you're going to provide a label which is going to be the 
label that you gave your service so in this case app service 
API happens to match up with app service API of our service so it tells it what service we're referencing and then we 
have to tell it which specific Port that we're going to forward um or or which specific Port we're going 
to scrape and so in this case we set Port web and that's going to match up with the name that we gave it here which happens to be web 
and so that's going to tell it to scrape Port 3000 in this case because it's referencing this specific port 
and then finally um by default the job label for this um 
for this target is going to be the name of the service so it's going to default 
to API service if you want to customize it you can add this job label property so the job label tells uh Prometheus 
that we should look for a label called job on the service and then whatever 
value of that label is that's going to be the name of our job so in this case we can see its job here so they match up 
here job job and then the value here is going to be the job name so the job name is going to be node Dash API if I had 
changed this job label to be my label then I would have to change the job to be my label and then whatever value here 
is going to be the new job name and so that's all you have to do to configure a service monitor you just 
specify the selector as well as the port and then any other extra configuration when it comes to the interval as well as 
the path and you can add an optional job label property as well and that's going to let Prometheus know that it should 
scrape whichever Target is behind the specific service now there's one thing we have to add so 
if I do kubectl get and then the name of the crd for Prometheus not the one 
for the service Monitor and we do Dash oh yeah well we can see the configs there's one property that I want to go 
over and that's this service monitor selector and so it provides a label here in this case it's release Prometheus and 
so this label allows Prometheus to find service monitors in the cluster and register them so that it can start 
scraping the application the service monitor is pointing to and so by default Prometheus doesn't know which service 
monitors to look for but if you give a service monitor a this specific label it knows to automatically add that to the 
Target list and so if we go to the configs of our service monitor we need to make sure 
that same label is under the label section and then Prometheus can dynamically add that so that's the final 
requirement okay so let's take a look at our crd so if I do kubectl get crd 
we should see a list of our crds and there's two main crds we want to focus on like I said the Prometheus one as 
well as the service monitor one so the Prometheus one this is going to actually be responsible for creating the Prometheus instance and the service 
monitors are there so that we can add extra targets and jobs and we're going to do a kubectl get crd 
or get and then we'll pass in the name of Prometheus and I'm going to do Dash o yaml let's 
just make sure that we check to see what that selector label is and so if I go up to service monitor 
selector we can see that the match labels is set to release Prometheus so when we create a service monitor we want to make sure 
that this label is present and by the way the label that the helm chart added this is completely customizable by 
updating the values.yaml file so if you ever wanted to change that you can just modify that in the chart 
so we have that so what we're going to do is we're going to go to our API depot.yaml and we're going to go ahead and add our 
service monitor at the bottom and I'm going to paste this in again 
and it's going to be basically the same thing that we saw in these slides so I've got it gave it a name of API 
service monitor I've got the release Prometheus so we need that so that Prometheus can dynamically discover this service 
monitor I'm going to give this uh the job label is going to be set to a value of job so if I go up to my service job 
is set to node API so this is going to be the job label endpoints this is going to have 30 
second scrape interval with this following path and it's going to point to a port of web and if we can see web 
is going to go to this specific one right here and then match labels api-service or app 
API service is going to match up with app API 
and I realized uh this is just called API so I'm just going to change this to API so remember they got a match 
okay and that's all we need so I'm going to pull up the terminal again and I'm going to do a kubectl apply 
Dash f API Dash depot.yaml 
and it's now successfully created a service Monitor and if you wanted to take a look at this we could do kubectl 
get service monitor and we can see all of the service monitors and so there's some 
pre-existing ones that are Helm chart created so that's why we have uh all of those targets that are already being 
scraped we already have all of these defined the helm tried that this is going to be the one that we just created 
okay so now that we have that configured let's verify if Prometheus is actually scraping that so I'm going to go to 
status and I'm going to go to targets and we could see that right at the top we could see our API service Dash 
Monitor and so we can take a look and we can see that there's two here and that's because we have the replica count was 
set to two in our deployment so it makes sense that there's two of them and on top of that we can take a look at the job we can see it got properly set to 
node API and if we go back to the main Prometheus 
what we can do is just do a quick query I'm going to do job equals node API 
let's just verify if we're actually getting metrics and we can see that we are in fact successfully getting metrics so we've 
now configured um a new set of Targets in our Prometheus instance using service 
monitors and if you want to take a look at the uh 
the final configs it actually generates on the Prometheus side we can go there as well so if we go to configuration and 
then we can search for api-service we could see the final configs that were created 
and that's going to be set right here and so you can see that it looks like under meta kubernetes service label app 
we can see that the value is set to API and it looks like we're going to keep that and that looks like that's where 
it's actually matching um the specific service in in this service Discovery actually 
and you can actually see the um the label here kubernetes endpoint Port name we can see that it's set to web so 
all of the configs that we did in the service monitor they're all lining up with the relabel configs for this 
specific scrape job 
so we went over how we can add new targets using service monitors let's now take a look at how we can add rules 
 
now to add rules the Prometheus operator has a crd called Prometheus rules which handles registering new rules to a 
Prometheus instance and so the way this is going to look like is it's going to be pretty similar to the service monitor 
except the kind is going to be a Prometheus Rule and then when we go under spec we just configure our rules 
like we normally would inside a prometheus.yaml file so you can see we have a group section and then we provide 
the name of the group and then we specify all of the rules so that's all it is it's just a standard yaml file 
with a standard kubernetes resource called Prometheus rules and then you just specify all of your groups and 
rules like you normally would nothing else is really any different one other 
thing to point out if we do a kubectl get Prometheus we can see that there is this rule selector of property 
in the output and so what this does is very similar to the service monitor 
selector but this label allows Prometheus to find the Prometheus rules in the cluster and register to them 
dynamically so we will have to add that same 
specific label to our configs just to make sure that our Prometheus instance 
is able to find them so let's add some rules to our um deployment and so I'm going to create 
a new file I'm just going to call this rules.yaml and I'm just going to paste the same 
configs that we had from the slides and we'll just quickly go over them so 
we've got uh one group called API and then there's just one rule which just checks to see if a node or instance is 
down but most importantly under the labels we can see that we have our release Prometheus so Prometheus should 
dynamically detect this and register this rule and I'm going to do a kubectl 
apply Dash f rules.yaml 
and I realized I forgot to save it so now it's successfully created 
and we can do a kubectl get Prometheus rule just to see if it got created 
and we can see all of the pre-existing rules but we want to find our API Rule and we can see that it was created 52 
seconds ago okay so now if we go to the Prometheus UI and we go to status and rules 
let's take a look and we can see our group API here and we can see that we've 
got our rules successfully registered and in an okay State and so that's all you have to do to register a rule all 
you have to do is just create a new Prometheus rule object and then specify all of your rules and that's all you 
have to do [Music] 
 
okay so to add alert manager rules the Prometheus operator has another crd 
called alert manager config which handles registering new rules to the alert manager and so this is an example 
config and the alert manager config is also pretty straightforward we have the 
kind set to alert manager config and then if you take a look at the configuration under spec this is just 
going to be standard alert manager config so you've got your route your group by your group weight and then you 
have your receiver here and then your list of receivers so it's actually no different than configuring a regular 
alert manager rule now one thing to point out is that once 
again if we do a kubectl get alert managers and then take a look at the config there's this one property called 
alert manager config selector so just like we saw with Prometheus when we're setting up a rule or a service monitor 
this label allows alert manager to find alert manager config objects in the cluster and register them 
but the important distinction here is that the helm chart by default does not specify a label so we don't actually 
have a label that we're supposed to specify on our alert manager config so that it can be registered so we'll actually have to go into the chart and 
update this value so that we have a label that we could use now when it comes to the standard 
alertmanager.yaml configuration file that you have on a alert manager instance that isn't deployed on 
kubernetes it's going to be a little bit different than the alert manager config for the custom resource that's defined 
within kubernetes using the Prometheus operator and I want to highlight what some of the differences are because I got stuck on this for a little bit and I 
want to make sure that you guys don't waste any unnecessary time trying to figure out what are the errors so the 
first thing that I want to point out is when you're defining configurations like group by or group weight or group 
interval you're going to see that on the standard alertmanager.yaml configuration it's going to make use of snake case in 
snake cases whenever you have a property with multiple words like group weight or group interval the two words are group 
and weight you're going to separate them by a underscore that's called snake case now when we move to the alert manager 
config file it's going to be a little bit different instead of using snake case we're going to make use of camel 
case and so with camel case the two words are not separated by an underscore 
instead they're combined together as one word but you capitalize the first letter of the second word so group weight is 
group and then capital W weight and the same thing goes for all the other properties 
and the only other difference that I want to point out is when you're setting up a matcher let's say that you have a 
job label with the value of kubernetes when you move to the 
alert manager configuration on kubernetes the difference is going to be that 
instead of just specifying job kubernetes as your label you have to split it up so that you specify the name of the label which is going to be job 
and then you have to specify the value of the label which is going to be kubernetes so instead of just putting in 
job kubernetes you have to say name is job and then values kubernetes now to upgrade the helm chart the first thing 
that we want to do is we want to get all the value for the helm chart so we'll do a Helm show values then we do the chart name and then we'll pipe it to a file 
called values.yaml and then we want to update this property called alert manager config selector and then we pass 
in a property of match labels and then here you're going to specify your labels you can use any label you want I just 
use the same one that we've been using which is resource Prometheus but keep in mind it doesn't have to be the same one 
and then we're going to run the command Helm upgrade then the release name then the chart name and then we have to pass 
in the dash F flag for values.yaml so that's going to update the chart and the configs will get updated accordingly 
okay so let's take a look at the crd so uh so I'm going to do kubectl get crd 
and we're going to just take a look at the alert manager crd and I'll do kubectl get 
and I'll do a dash o yaml so we could take a look at the configs 
and like we saw in the slides the thing that we want to verify is the alert manager config selector has nothing set 
so this is where we're going to have to update the chart so to update the chart we're going to do 
a Helm show values and I'm going to just copy the chart name because it's fairly long 
and then we want to pipe the output of this to a file called values.yaml so we can update it 
Okay so we've got our values.yaml and what we want to do is find that property so there's a alert manager 
config selector so this is going to be right here I'm going to delete these two curly braces 
and I'm going to say match labels 
and then we'll do resource Prometheus like I said this can be any 
value you want but I'm just going to use the same ones make sure to save it and then now we can do a Helm upgrade so 
I'll do Helm upgrade we do the release name 
and then the chart name and then we have to pass in the dash F flag so we can pass in the values.yaml 
okay so the helm chart has been upgraded so let's actually go and run that same 
command where we check where we take a look at the alert manager config and if we take a look at the alert 
manager config selector we can see that it was successfully updated and so now we can actually create a rules file for 
our alert manager so I'm just going to create a new file I'll call this alert Dot yaml 
and I'm going to paste that example config 
and so from this configuration um the only thing that we really need to focus on is the label so I've got the 
resource Prometheus label so it should automatically get picked up and uh in this case we're grouping all 
of our alerts by severity a label called severity and we've got one receiver called webhook 
and so I'm going to save this and now we can just do a kubectl apply 
Dash f and then alert date yaml 
okay and now we've successfully uh created that alert manager config and we can verify that by doing kubectl get 
alert manager config 
and we can see our alert Dash config that we just created 
okay so now to verify that everything worked let's get access to the alert 
manager so we're going to set up port forwarding again so we'll do kubectl get services 
and we'll do kubectl Port Dash forward service slash alert manager operator 
that's the one we want and it's going to be listening on Port 1993 
and after it's listening on Port 1993 then we're going to access it and we'll just double check the configs just to 
verify that everything looks good and so if we go to this status page here we can take a look at the configs and we can 
see my web hook alert config webhook example and we can see all the configs there and 
then we can see the receivers for this as well down here so it looks like it worked and that's all we have to do to 
add configs or rules to an alert manager all right guys so that's going to wrap 
 
things up for today uh if you want to learn more about Prometheus head on over to codecloud.com and you can take my 
Prometheus course um this course starts from the absolute Basics so if there's anything that was a little confusing or if you didn't 
understand this course will start from the absolute beginning I will go over what is Prometheus why we need it what 
is the purpose of this monitoring tool how does it fit within the overall observability stack and then we'll take a look at how to get it deployed on a uh 
you know a VM first we'll start off with the absolute basic scenarios and then we'll move on to more complex scenarios 
uh just like this scenario where we take a look at how to deploy it on a kubernetes cluster and we've got plenty 
of other sections where we go over the different features like prom ql the different built-in dashboarding and 
visualization solutions that come with Prometheus and just like with any other code Cloud course there's going to be 
plenty of Hands-On left so every section is going to have at least one Hands-On lab where we allow you to practice all 
of the things that you just learned during the lectures so that you get a chance to really reinforce all of the 
ideas that you've learned and I think that's just a better way of learning so if you guys are interested in this 
definitely take a look at the course and at the end of the course we also have a couple of mock exams if you guys decide 
to ultimately pursue the Prometheus certified associate exam this will help you prepare for that as well and so I'll 
see you guys in the next one 
 - Generated with https://kome.ai
----------------
---
# **Prometheus Exporters in Kubernetes** (needs verification !!)

In a **Kubernetes system**, Prometheus **exporters** are configured to expose metrics from various components, applications, and infrastructure resources. These exporters **collect, transform, and expose metrics** in a format that Prometheus can scrape.

**How Exporters are Configured in Kubernetes**
- **1️. Exporters as Sidecars**
    - Runs as a **sidecar container** within the same pod as the application.  
    - Ideal for **custom applications** that need additional metric exposure. 
    - The exporter collects stats and exposes them to **Prometheus** on port `9102`. 
    - **Example: Node.js App with Prometheus Exporter Sidecar**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: app
          image: my-app:latest
        - name: prometheus-exporter
          image: prom/statsd-exporter
          ports:
            - containerPort: 9102
```
- **2️. Exporters as DaemonSets**
    - Runs **one instance per node** to collect **node-specific metrics**.  
    - Used for monitoring **host-level system metrics** (CPU, Memory, Disk, Network, etc.).  
    -  **Example: Deploying Node Exporter as a DaemonSet**
        - This deploys **Node Exporter** on every Kubernetes node.
```sh
kubectl apply -f https://raw.githubusercontent.com/prometheus/node_exporter/main/examples/k8s-node-exporter-daemonset.yaml
```

- **3️. Exporters as Separate Deployments**
    - Used for **services running independently** in the cluster.  
    - Suitable for **databases, messaging queues, APIs, etc.**  
    - **Example: Deploying PostgreSQL Exporter** : This exposes **PostgreSQL metrics** for Prometheus to scrape.
```sh
helm install prometheus-postgres-exporter prometheus-community/prometheus-postgres-exporter --namespace monitoring
```

- **4️. Exporters as Built-in Features**
    - Some applications have **built-in Prometheus endpoints**.  
    - No need for an external exporter.  
    - **Example: Exposing Metrics in an Nginx Ingress Controller** : The Ingress controller automatically exposes metrics at **`/metrics`**.
```yaml
controller:
  metrics:
    enabled: true
    serviceMonitor:
      enabled: true
```

**Common Exporters Used in Kubernetes**
| **Exporter** | **Purpose** | **Installation Method** |
|-------------|------------|----------------|
| **Node Exporter** | CPU, Memory, Disk, Network | DaemonSet |
| **Kube State Metrics** | Kubernetes object metrics (Pods, Deployments) | Deployment |
| **cAdvisor** | Container resource usage | Built-in (part of kubelet) |
| **Nginx Exporter** | Nginx Ingress stats | Built-in |
| **PostgreSQL Exporter** | PostgreSQL performance | Helm |
| **MySQL Exporter** | MySQL database stats | Helm |
| **JMX Exporter** | Java applications (JVM metrics) | Sidecar |
| **Blackbox Exporter** | External HTTP/TCP monitoring | Deployment |



### **How to Configure Prometheus to Scrape Exporters**
After deploying an exporter, update **Prometheus scrape configs**. This tells **Prometheus to scrape metrics** from Node Exporter & kube-state-metrics.

```yaml
scrape_configs:
  - job_name: "node-exporter"
    static_configs:
      - targets: ["node-exporter.monitoring.svc.cluster.local:9100"]

  - job_name: "kube-state-metrics"
    static_configs:
      - targets: ["kube-state-metrics.monitoring.svc.cluster.local:8080"]
```

### **Best Practices for Configuring Exporters in Kubernetes**
The **best method for exporter** depends on **what you are monitoring**. Below is a breakdown of industry best practices:


#### **DaemonSet-Based Exporters (Best for Node-Level Metrics)**
- **Recommended for:** System-level metrics (CPU, memory, disk, network).
- **Why?** Runs **one exporter per node**, ensuring efficient and **centralized data collection**.
- **Best Practice Implementation**
    - **Use** `Node Exporter` for node metrics.
    - **Use** `cAdvisor` (built into Kubelet) for container-level stats.
    - **Use** `Kube State Metrics` for Kubernetes resource metadata.
- **Example Deployment**
    ```sh
    helm install node-exporter prometheus-community/prometheus-node-exporter --namespace monitoring
    ```
- **Best Practice:**
    - Deploy **Node Exporter** and **Kube State Metrics** as **DaemonSets**.
    - Use **Kubelet’s built-in cAdvisor** instead of running a separate container.

#### **Sidecar-Based Exporters (Best for Custom Application Metrics)**
- **Recommended for:** Applications that do not natively expose Prometheus metrics.
- **Why?** Running the exporter **inside the same pod** prevents **network overhead**.
- **Best Practice Implementation**
    - **Use** `JMX Exporter` for Java apps.
    - **Use** `StatsD Exporter` for microservices emitting StatsD metrics.
- **Example: Adding Prometheus Exporter to a Node.js App**
```yaml
containers:
  - name: my-app
    image: my-app:latest
  - name: statsd-exporter
    image: prom/statsd-exporter
    ports:
      - containerPort: 9102
```
- **Best Practice:**
    - If the app supports **Prometheus natively**, **avoid** sidecars and expose `/metrics` directly.

#### **Standalone Deployment-Based Exporters (Best for Database & Third-Party Services)**
- **Recommended for:** Databases, load balancers, messaging queues.
- **Why?** Running exporters as separate deployments **ensures scalability**.
- **Best Practice Implementation**
    - **Use** `PostgreSQL Exporter` for PostgreSQL.
    - **Use** `MySQL Exporter` for MySQL.
    - **Use** `Blackbox Exporter` for external endpoint monitoring.
- **Example: Deploying MySQL Exporter via Helm**
    ```sh
    helm install mysql-exporter prometheus-community/prometheus-mysql-exporter --namespace monitoring
    ```
- **Best Practice:**
    - **Ensure proper resource limits** on exporters to prevent high memory usage.
    - **Use ServiceMonitors** (if using Prometheus Operator) instead of static scrape configs.


#### **Built-in Metrics Exposure (Best for Kubernetes Native Components)**
- **Recommended for:** Nginx Ingress, API servers, CoreDNS, etc.
- **Why?** No need for extra containers—just enable built-in metrics.
- **Best Practice Implementation**
    - **Enable metrics for Ingress Controllers, CoreDNS, and API Server.**
    - **Use Prometheus Operator’s ServiceMonitors** for auto-discovery.
- **Example: Enable Metrics for Nginx Ingress**
```yaml
controller:
  metrics:
    enabled: true
```
- **Best Practice:**
    - **Avoid unnecessary exporters** for applications that already expose Prometheus-compatible metrics.

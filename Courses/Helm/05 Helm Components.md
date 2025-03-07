
### Components of Helm  

Helm consists of several key components that work together to **simplify Kubernetes application management**. These components include the **Helm CLI**, **charts**, **releases**, **revisions**, **chart repositories**, and **metadata storage**.  

#### 1. **Helm CLI**  
The **Helm command-line utility** is installed on a local system and is used to perform Helm actions such as **installing charts, upgrading applications, rolling back changes, and managing releases**.  
- It allows users to:  
    - Install applications using **charts**  
    - Upgrade or roll back deployments  
    - Manage **releases** and track their **revisions**  

#### 2. **Helm Charts**  
A **Helm chart** is a **collection of files** that defines how an application should be deployed in Kubernetes. These charts contain all the required instructions and configurations to create the necessary Kubernetes objects. When a chart is applied, Helm effectively **installs** an application into the cluster.
- A Helm chart combines YAML files and templates to create configuration files based on specific parameters. You can customize these configuration files for different environments and create configurations that are reusable across multiple deployments. Additionally, you can version and manage each Helm chart individually, making it easier to maintain multiple versions of an application with different configurations  
- **Key Components of a Chart:**  
    - `Chart.yaml` → Contains metadata about the chart (name, version, description).  
    - `values.yaml` → Holds configurable parameters (e.g., replica count, image version).  
    - `templates/` → Stores Kubernetes object definitions as templated YAML files. 

#### 3. **Releases**  
A **release** is an instance of a **Helm chart deployed in a Kubernetes cluster**. Each time a chart is installed, a unique release is created. Multiple releases can exist for the same chart, each representing a separate deployment of the application.  
- If a **chart is installed**, a **release** is created.  
-  Multiple releases of the same chart can exist with different configurations.  
    - For example, installing a MySQL database with different names:  
        ```sh
        helm install db1 bitnami/mysql
        helm install db2 bitnami/mysql
        ```
    - Here , each MySQL deployment is **a separate release**.

#### 4. **Revisions**  
Each release maintains **multiple revisions**, similar to snapshots. Whenever a modification is made to an application—such as upgrading an image, changing replicas, or updating configurations—a **new revision** is generated. These revisions allow Helm to track changes over time and provide the ability to **rollback** if necessary.  
- Every time an update is made to a release (e.g., changing replicas, upgrading an image), Helm **creates a new revision**.  
- **Example of revisions:**  
    - **Install WordPress** → `helm install my-wordpress bitnami/wordpress`  
    - **Upgrade WordPress image** → `helm upgrade my-wordpress bitnami/wordpress --set image.tag=6.0`  
    - **Rollback to the first revision** → `helm rollback my-wordpress 1`  
- Each revision acts as a **snapshot**, allowing users to **roll back** to previous states if needed.

#### 5. **Chart Repositories**  
Helm allows users to **discover and download prebuilt charts** from public and private **chart repositories**. These repositories function similarly to **Docker Hub** for container images, or `npm` , `apt`. providing a centralized location to share Helm charts.  

- **Public Repositories**  
    - `https://artifacthub.io/` – Official Helm charts repository  
    - `bitnami/wordpress` – Popular chart for WordPress deployment  
    - `bitnami/mysql` – Chart for MySQL database  
        ```sh
        # Adding a Repository
        helm repo add bitnami https://charts.bitnami.com/bitnami
        helm repo update

        # Searching for a Chart 
        helm search repo mysql

        # Installing from a Repository  
        helm install my-database bitnami/mysql
        ```

#### 6. **Metadata Storage**  
To keep track of installed releases, Helm stores **metadata** about deployments. Instead of storing this data locally—where it would be inaccessible to other team members—Helm **stores metadata directly in the Kubernetes cluster** as **Kubernetes secrets**. This ensures that:  
- Metadata persists as long as the cluster exists.  
- Multiple team members can manage Helm releases without requiring local copies of metadata.  
- Helm can track **all actions performed in the cluster** and retain historical information. 
- Helm **tracks all deployments** using **metadata**, which includes:  
    - Installed **releases**  
    - Chart versions  
    - Values used for deployment  
    - Revision history   
- Because metadata is stored **inside Kubernetes**, all team members can access the same Helm history and continue managing releases seamlessly.
- **Checking Helm Metadata:**  
    ```sh
    kubectl get secrets -n kube-system
    kubectl get secret sh.helm.release.v1.my-app.v1 -o yaml
    ```

### **Summary**  

| **Component**       | **Description** |
|---------------------|---------------|
| **Helm CLI**       | Command-line tool to install, upgrade, and manage Kubernetes applications. |
| **Helm Charts**    | Prepackaged Kubernetes manifests that define application resources. |
| **Helm Releases**  | A deployed instance of a chart inside a Kubernetes cluster. |
| **Helm Revisions** | Versioned snapshots of a release that allow rollbacks. |
| **Chart Repositories** | Online sources for sharing and downloading Helm charts. |
| **Metadata (K8s Secrets)** | Stores Helm-related data, allowing shared access and tracking. |

## **Creating a Helm Chart from Scratch**  

Helm charts simplify Kubernetes application deployment by managing configurations, packaging, and templating.  

Creating Helm charts allows for the automation of Kubernetes package installations. A Helm chart consists of a structured directory containing essential files, such as values.yaml, Chart.yaml, and a templates directory.

- **Step 1: Generate the Helm Chart Structure**   : 
    - This generates a skeleton structure with predefined sample files. These files can be modified or replaced based on specific requirements.Helm charts follow a predefined directory structure. Instead of creating this manually, use:  
        ```bash
        helm create nginx-chart
        ```
    - This command creates a skeleton Helm chart inside the `nginx-chart` directory with:  
        - `Chart.yaml`: Metadata about the chart.  
        - `values.yaml`: Default values for templates.  
        - `templates/`: Contains Kubernetes YAML manifests.  
- **Step 2: Customize Chart.yaml**  
    - when creating an Nginx-based "Hello World" application, the automatically generated Chart.yaml file will contain sample metadata, including the chart name, description, and version details. The description can be customized, and additional properties such as a maintainer’s contact email, homepage URL, or icon path can be added.
    - Modify `Chart.yaml` to include meaningful details. For example:  
        ```yaml
        apiVersion: v2
        name: nginx-chart
        description: A Helm chart for deploying an Nginx-based web application
        type: application
        version: 1.0.0
        appVersion: 1.21.4
        maintainers:
        - name: Admin Team
            email: support@example.com
        home: https://www.example.com/nginx-chart
        ```
        - This metadata helps users understand the purpose of the chart.  

- **Step 3: Configuring the Templates folder**
    - The templates directory contains sample Kubernetes manifests, which can be removed if they are not required. Instead, the application's deployment and service YAML files should be placed in this directory. Once these files are added, the Helm chart is technically ready for deployment using the helm install command.
    - Helm auto-generates sample YAML files inside `templates/`. Remove them using:  `rm -rf nginx-chart/templates/*`
    - Then, move the actual application files (`deployment.yaml`, `service.yaml`) into `templates/` 

- **Step 4: Convert Static Values into Templates**  
    - **Problem:** The default YAML files contain static values like deployment names and replica counts. If multiple instances of the same chart are installed, they will conflict. This approach causes conflicts when attempting to install multiple releases of the same chart, as Kubernetes does not allow duplicate names for resources. 
      - **Solution:** Use Helm’s templating language to make values dynamic.  
    - **Parameterize the Yaml Files**  : Modify `deployment.yaml` inside `templates/`:  
        ```yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: {{ .Release.Name }}-nginx
        spec:
        replicas: {{ .Values.replicaCount }}
        selector:
            matchLabels:
            app: {{ .Release.Name }}-nginx
        template:
            metadata:
            labels:
                app: {{ .Release.Name }}-nginx
            spec:
            containers:
                - name: nginx
                image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
                ports:
                    - containerPort: 80
        ```
        - `{{ .Release.Name }}` ensures unique deployment names.  
        - `{{ .Values.replicaCount }}` references the value from `values.yaml`.  
    - To address this issue, Helm’s templating language should is used. The deployment name can be dynamically assigned based on the release name specified during installation. By using `{{ .Release.Name }}`, Helm ensures that each deployment gets a unique name, such as `hello-world-1-nginx`, allowing multiple releases of the same chart to coexist without conflicts.

- **Step 5: Update `values.yaml` to Define Default Values**  
    - This allows customization at install time without modifying `deployment.yaml`. 
        ```yaml
        replicaCount: 2
        image:
            repository: nginx
            tag: "1.21.4"
        ```
- **Step 6: Install the Chart**  
    - Run the following command to install the Helm chart with a custom release name:  
        - Both deployments will coexist without naming conflicts.  
            ```bash
            helm install hello-world-1 ./nginx-chart # This dynamically assigns names and values based on the `values.yaml` file.  
            helm install hello-world-2 ./nginx-chart # This dynamically assigns names and values based on the `values.yaml` file.  
            ```




## **Understanding Helm Templating and Built-in Objects**  

Helm uses templating to dynamically generate Kubernetes resource configurations. The `{{ .Release.Name }}` directive replaces placeholders with actual values when deploying a chart.  

#### **How Helm Templating Works**  
In a Helm template, placeholders like `{{ .Release.Name }}` get replaced during installation.  
- For example, in `deployment.yaml`:  
    ```yaml
    metadata:
    name: {{ .Release.Name }}-nginx
    ```
- If the release name is `hello-world-1`, the rendered output becomes:  
    ```yaml
    metadata:
    name: hello-world-1-nginx
    ```
    - This ensures unique names for different releases.  

#### **Common Built-in Objects in Helm Templates**  
Helm provides several built-in objects to access metadata and Kubernetes details:  

| **Object**                | **Description** |
|---------------------------|---------------|
| `Release.Name`            | Name of the Helm release |
| `Release.Namespace`       | Namespace where the release is deployed |
| `Release.IsUpgrade`       | `true` if this is an upgrade |
| `Chart.Name`              | Name of the Helm chart (`Chart.yaml`) |
| `Chart.Version`           | Chart version (`Chart.yaml`) |
| `Capabilities.KubeVersion` | Kubernetes version of the cluster |
| `Capabilities.APIVersions` | List of available API versions in the cluster |
| `Capabilities.HelmVersion` | Version of Helm being used |

These objects allow templates to adjust configurations dynamically based on the environment.  

#### **Accessing User-Defined Values from `values.yaml`**  
Any property from `values.yaml` can be referenced using `Values.<property>`:  
- Example `values.yaml`:  
    ```yaml
    replicaCount: 2
    image:
    repository: nginx
    tag: "1.21.4"
    ```
- Corresponding `deployment.yaml` template:  
    ```yaml
    spec:
    replicas: {{ .Values.replicaCount }}
    containers:
        - name: nginx
        image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
    ```
    - These placeholders pull values dynamically from `values.yaml` during deployment.  

#### **Case Sensitivity in Helm Templates**  
Helm follows specific case conventions for built-in and user-defined objects:  
- **Built-in objects (`Release`, `Chart`, `Capabilities`)** → Second part starts with an uppercase letter (e.g., `Release.Name`, `Chart.Version`).  
- **User-defined values (`Values`)** → Uses lowercase (e.g., `Values.replicaCount`, `Values.image.tag`).  



### **Conclusion**  


Understanding these conventions ensures Helm charts remain flexible, reusable, and scalable.

### **Helm Chart Summary**  
- **Helm charts use a structured directory format** to package Kubernetes applications.  
- **Templates convert static configurations into dynamic ones** using Helm’s templating engine.  
- **Release names ensure multiple instances of the same chart can be deployed without conflicts.** 
- Helm templates dynamically inject values from the release and `values.yaml`.  
- Built-in objects provide metadata about the release and cluster.  
- User-defined values follow a lowercase naming convention and can be freely customized.  
- Proper case usage is essential for avoiding errors in templates.   

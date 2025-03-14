## **Exploring Helm Commands**  

With Helm installed, various operations can be performed using the Helm command-line interface (CLI). Simply running the `helm` command or using `helm help` displays a list of available commands and their descriptions. This serves as a quick reference to recall specific commands without searching online.  Additionally, subcommands have their own help sections. 
- Example : Running `helm repo help` provides details on repository-related actions, such as adding, listing, or removing repositories.  

#### **Helm Help Commands**
```bash
# Shows the installed HELM version.
helm version
# Displays help for HELM commands.
helm --help
# displays opions and documentations for the subcommand
helm <sub-command> --help
# Get details of the helm reo command
helm repo --help
```

#### **Searching for Helm Charts**  

To deploy applications, Helm charts can be obtained from repositories. Consider a scenario where a WordPress website needs to be deployed in Kubernetes. Since charts are hosted on **Artifact Hub** (`artifacthub.io`), searching for a chart manually ensures access to high-quality, official, or verified publisher charts.  

Each chart page provides detailed information, including installation commands, software components, and configurable settings. Alternatively, charts can be searched directly from the CLI using:  

```bash
helm search repo <chart-name>	# Searches for a chart in the configured repositories.
helm search hub <chart-name>	# Searches for a chart in the HELM Hub.
helm search hub wordpress
helm search repo wordpress
```
- `helm search hub` <chart-name> : lists all WordPress-related charts available on **Artifact Hub**. However, to search within a specific repository, use the repo subcommand
- `helm search repo <chart-name>` : searches for the chart is specified repo

### **Deploying a Chart to Kubernetes Cluster**  

- Once the appropriate chart is identified, deploying the application requires only two steps. 
    - adding the repository to local
    - Deploying the chart from local

1. #### **Addinng Repository to local**  
    - Helm must know where to retrieve the chart from before installation. The Bitnami repository can be added using:  
        ```bash
        helm repo add <repo-name> <repo-url>	# Adds a new HELM repository.
        helm repo add bitnami https://charts.bitnami.com/bitnami # adds the bitnami repo to locall
        ```
    - This adds the bitnami repository on our local system. 
    - *Note: bitnami is a repository. it contanis multiple charts inside it , wordpress would be one of it. Also these are just metadata, not the actual charts. The actual charts gets pulled when you run helm install or helm pull*
        ```bash
        helm search repo <repo-name>
        helm search repo bitnami  # this will list down all the charts present in the repo

        # output

        # bitnami/wavefront-prometheus-storage-adapter    2.3.3           1.0.7           DEPRECATED Wavefront Storage Adapter is a Prome...
        # bitnami/whereabouts                             1.2.7           0.8.0           Whereabouts is a CNI IPAM plugin for Kubernetes...
        # bitnami/wildfly                                 23.0.4          35.0.1          Wildfly is a lightweight, open source applicati...
        # bitnami/wordpress                               24.1.16         6.7.2           WordPress is the worlds most popular blogging ...
        # bitnami/wordpress-intel                         2.1.31          6.1.1           DEPRECATED WordPress for Intel is the most popu...
        # bitnami/zipkin                                  1.3.0           3.5.0           Zipkin is a distributed tracing system that hel...
        # bitnami/zookeeper                               13.7.4          3.9.3           Apache ZooKeeper provides a reliable, centraliz...
        ```
    - Repo management commands
        ```bash
        helm repo list   # Lists all added HELM repositories.
        helm repo update # Updates the local cache of HELM charts from repositories.
        helm repo remove <repo-name>  # Removes a repository.
        ```
2. #### **Deploying a WordPress Chart**  
    - After adding the repository, deploy WordPress with:  the `install` subcommand
        ```bash
        helm install <release-name> <chart> # Installs/deploys a HELM chart as a release in Kubernetes.
        helm install my-release bitnami/wordpress
        ```
    - This command installs WordPress using the Bitnami chart. Once the deployment is complete, Helm provides relevant details on how to access and manage the installed application. These instructions are generated by the chart itself, offering guidance on post-installation steps.  
    - **Listing Helm Releases**  : After deploying a chart, it is managed as a **release** in Helm. To view all existing releases, use:  
        ```bash
        helm list # Lists all deployed releases in the current namespace.
        helm list --all-namespaces	#  Lists all releases across all namespaces.helm list --all-namespaces	Lists all releases across all namespaces.
        ```
        - This command helps track installed applications and identify outdated releases that require updates.

#### **Uninstalling a Helm Release**  
Manually removing all components of an application from Kubernetes can be tedious, requiring the deletion of multiple objects one by one. However, Helm simplifies this process with a single command:  

```bash
helm uninstall <release-name>	# removes all Kubernetes objects associated with the release.
helm uninstall <release-name> --namespace <namespace>	# Removes a release from a specific namespace.
helm delete <release-name>	# Alias for helm uninstall.
```

#### **Managing Helm Repositories**  
Helm repositories store and distribute charts. Several commands are available for managing these repositories:  
  ```bash
  # Add a repository*  
  helm repo add bitnami https://charts.bitnami.com/bitnami # This registers the Bitnami repository locally. 

  helm repo list # This displays all Helm repositories added to the system
  helm repo update # Update repository information (refreshes local repository metadata to reflect the latest changes from the remote source)
  ```

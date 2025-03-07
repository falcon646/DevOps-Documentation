## **Lifecycle Management with Helm**  

### **Understanding Releases**  
In Helm, a **release** is an instance of a deployed chart. Each release consists of multiple Kubernetes objects, which Helm tracks and manages. Since Helm knows which objects belong to which release, it can:  
- Upgrade applications seamlessly  
- Roll back to a previous version if needed  
- Uninstall releases cleanly  


### **Why Use Helm for Upgrades?**  
- Helm tracks all objects within a release, ensuring consistency  
- It upgrades all objects in a controlled manner, avoiding manual updates  
- Configuration changes (e.g., environment variables or secrets) are applied automatically  

### **Installing a Specific Chart Version**  
When deploying a Helm chart, a specific version can be installed using the `--version` flag. For example, to install an older version of the **Nginx** chart:  

```bash
helm install my-nginx-release bitnami/nginx --version 8.5.1
```

This allows control over the exact version of software being deployed.  

### **Upgrading a Release**  
Over time, new chart versions are released with bug fixes, security patches, and feature enhancements. Upgrading a release ensures that all Kubernetes objects associated with it are updated accordingly
- **Step 1: Check the Current Nginx Version**  `kubectl describe pod <nginx-pod-name>`
    - In the output, look for the **image** field, which displays the Nginx version (e.g., `nginx:1.19.2`). 
- **Step 2: Upgrade the Nginx Release with Helm** 
    - Use the `helm upgrade` command, specifying the release name and chart repository:  
        ```bash
        helm upgrade my-nginx-release bitnami/nginx --version 1.21.4
        ```
        - Helm allows upgrading an existing release while maintaining its configuration. 
- **Step 3: Check the Revision History**  
    - Helm tracks changes using revision numbers. After the upgrade, revision **1** is replaced by **revision 2**. To verify the revision history:  
        ```bash
        helm history my-nginx-release
        ``` 
- **Step 4: Verify the Upgrade**  : Run the `kubectl describe pod <new-nginx-pod-name>` command again to inspect the newly created pod: 
    - The **image** field should now display **Nginx 1.21.4**, confirming a successful upgrade. 

### **Rolling Back a Helm Release**  

Helm maintains a record of previous release states. When a release is updated, Helm assigns a new revision number while preserving the history of previous revisions. For example, if the original revision number was one and an update was performed, the new revision number would be two.  

- To view the current releases, the `helm list` command can be executed. This displays all active releases, including their names and revision numbers. However, in collaborative environments where multiple team members manage releases, this output alone may not provide sufficient context about the release history.  
    - To check all Helm-managed applications, use:  
        ```bash
        helm list # This command displays active releases along with their **revision number**. 
        ```
- To gain deeper insights, the `helm history` command can be used. This command provides detailed information about a release, including:  
    - The chart version used in each revision  
    - The application version associated with each revision  
    - The action that triggered each revision (e.g., install, upgrade, or rollback)  
        ```bash
        helm history my-nginx-release # get a detailed history of a specific release
        ```
        - This output provides:  
            - **Revision numbers**  
            - **Chart version** used in each revision  
            - **App version** running in each revision  
            - **Actions** (install, upgrade, rollback)  
    - This historical data helps track the evolution of a release and provides a clear overview of its lifecycle.  

- If an upgrade introduces unintended changes, Helm provides a rollback feature to restore a release to a previous state. To roll back to revision one, the following command can be executed:  
    - **Identify the Revision Number**  : From the `helm history` output, determine the revision you want to roll back to. 
    - **Rollback to revision 1** : 
        ```bash
        helm rollback my-nginx-release 1
        ```
    - **Verify the Rollback** : Run the `helm history` command again to confirm:  
        ```bash
        helm history my-nginx-release
        ```
        - This restores the configuration from **revision 1** and applies it as **revision 3** (since Helm does not truly revert but creates a new revision).
        - The output now includes **revision 3**, with a note stating **"Rollback to revision 1"**  

    > - It is important to note that Helm does not revert the release directly to revision one. Instead, it creates a new revision (revision three) with the same configuration as revision one. This approach ensures that rollback actions are tracked as part of the release history.  

### **Handling Complex Upgrades**  

Certain Kubernetes packages may require additional steps during an upgrade. While Nginx upgrades smoothly with Helm, more complex applications such as WordPress may require extra parameters to complete the upgrade process.  

For example, attempting to upgrade a previously deployed WordPress release without providing the necessary credentials would result in an error message. This occurs because Helm requires administrative access to components such as the database and the WordPress application itself to apply the required changes. The issue can be resolved by supplying the necessary parameters as specified in the error message.  

Rollback functionality in Helm is similar to a backup restore operation but with some limitations. Helm rollbacks restore only the Kubernetes object declarations (manifest files) and do not include application data stored in persistent volumes or external databases.  

For example, if a MySQL database server is rolled back using Helm, the MySQL pods and software versions will revert to their previous states, but the actual database content will remain unchanged. Helm does not automatically back up or restore persistent data.  

To ensure data consistency, dedicated backup solutions should be used before performing upgrades or rollbacks. Helm provides a mechanism known as *Chart Hooks*, which can be used to automate pre-upgrade backups and post-rollback restores. This topic will be covered in more detail later in the course.  

For hands-on experience, proceed to the labs to practice these concepts in a real environment.


### **Helm Lifecycle Management Summary**  
- **Helm tracks all installed releases** and their history.  
- **Helm upgrades replace outdated components** with updated ones while keeping configurations intact.  
- **Each upgrade creates a new revision**, allowing rollback if needed.  
- **Helm automates application management**, making Kubernetes deployments more maintainable.  

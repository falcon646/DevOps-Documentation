helm pull bitnami/wodpress # pulls the charts in .tar format
helm pull --untar bitnami/wordpress # pull the chart .tar file and untars it as well

helm install <release-name> ./<chart_path> # deploy the local chart





## **Customizing Chart Parameters in Helm**  

By default, Helm installs charts with predefined values. However, customizing these values is often necessary. For example, the default WordPress installation sets the blog name to *User’s Blog*. This value is defined in the **values.yaml** file, which Helm uses to configure the deployment.  

### **Modifying Values Using the `--set` Option**  
Since Helm `helm install` command installs the charts instantly, there is no opportunity to modify **values.yaml** before deployment. However, values can be overridden using the `--set` flag during installation.  

- For example, to change the blog name and user email:  
   ```bash
   helm install my-release bitnami/wordpress \
   --set wordpressBlogName="Helm Tutorials" \
   --set wordpressEmail="john@example.com"
   ```
   - The `--set` flag allows multiple values to be overridden directly from the command line.  

### **Using a Custom `values.yaml` File**  
When multiple values need to be customized, passing them as command-line arguments can become cumbersome. Instead, a custom **values.yaml** file can be created.  

1. **Create a custom values file (`custom-values.yaml`)**:  
   ```yaml
   wordpressBlogName: "Helm Tutorials"
   wordpressEmail: "john@example.com"
   ```

2. **Install the chart using the custom values file**:  
   ```bash
   helm install my-release bitnami/wordpress -f custom-values.yaml
   ```
   - Helm will now use `custom-values.yaml`, overriding the default **values.yaml** file from the chart.  

### **Manually Modifying `values.yaml` Before Installation**  

If modifying the chart’s built-in **values.yaml** is preferred, the chart can be **pulled/downloaded** locally before installation:  

#### **Pulling the Chart and Modifying the `values.yaml` file**  
- To modify the **values.yaml** file before installation, the Helm chart must first be pulled from the repository. This can be done using the `helm pull` command:  
   ```bash
   helm pull bitnami/wordpress  
   ```
   - By default, this pulls the chart as a compressed archive (`.tgz` file).
- The pulled archive needs to be extracted before making modifications. This can be done manually or by using the `--untar` flag to extract it automatically:  
   ```bash
   helm pull bitnami/wordpress --untar
   ```
   - This creates a **wordpress/** directory containing all the files that make up the Helm chart. Inside this directory, the **values.yaml** file can be found and modified as needed.  
   - Open **values.yaml** in any text editor and update the desired configuration parameters.  
- **Installing from the Local Directory**  : Once the necessary changes have been made, install the chart from the local directory instead of the remote repository:  
   ```bash
   helm install my-release ./wordpress
   ```
   - Here, `./wordpress` specifies the path to the local chart directory.  
- Note:
   >   - When installing from a **remote chart repository**, specify the repository name:  `helm install my-release bitnami/wordpress`
   >   - When installing from a **local directory**, specify the local path for the chart : `helm install my-release ./wordpress` 
 












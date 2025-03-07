# Create a new Jenkins VM node, and run your Jenkins agent as a service

- If using **Docker** as agents , you can set it up so the agent restarts on its own if the system reboots.  
- But if you use **`Dockerfile: true`**, you can't rely on Docker to restart it automatically. Instead, you have to start the agent manually using a **Java command** for security reasons.  
- The problem is, if the system restarts or you close the terminal, the agent will **stop running** unless you take extra steps (like using `nohup` to keep it running in the background).  
- The tutorial will show how to fix this by setting up **systemd**, which allows Linux to manage the agent as a service, so it restarts automatically when needed.

### Pre-requisites
To get an agent working, we’ll need to do some preparation. Java is necessary for this process, and Docker allows us to use Docker for our agents instead of installing everything directly on the machine.
- Install jdk17 or jdk21
```bash
sudo apt-get update
sudo apt install -y --no-install-recommends openjdk-17-jdk-headless
```
- Create `Jenkins User`
    ```sh
    sudo adduser --home /home/jenkins --shell /bin/bash --ingroup jenkins jenkins
    ```
    - --home /home/jenkins → Sets /home/jenkins as the home directory.
    - --shell /bin/bash → Assigns /bin/bash as the default shell.
    - --ingroup jenkins → Ensures the user is added to the existing jenkins group.
    - jenkins → Specifies the username.

- Install Docker : check local docomentation
- Provide jenkins user access to docker and sudo
```bash
sudo usermod -aG docker jenkins
sudo usermod -aG sudo jenkins
```
### Jenkins Agent Setup
We will now create a new node in Jenkins, using our Ubuntu machine as the node, and then launch an agent on this node.

- Node creation in the UI
    - Go to your Jenkins dashboard
    - Go to Manage Jenkins option in the main menu
    - Go to Manage Nodes and clouds item
    - Go to New Node option in the side menu
    - Fill in the Node name  and type (Permanent Agent )
    - Click on the Create button
    - Set the number of executors for this node . (usually number of CPU cores)
    - As Remote root directory, enter the directory where you want to install the agent (`/home/jenkins`)
    - Enter the labels you want to assign to the node (eg ubuntu linux docker). This will help you group multiple agents into one logical group
    - The last thing to set up now: choose Launch agent by connecting it to the controller . That means that you will have to launch the agent on the node itself and that the agent will then connect to the controller. That’s pretty handy when you want to build Docker images, or when your process will use Docker images… 
        - *Note : You could also have the controller launch an agent directly via Docker remotely, but then you would have to use Docker in Docker, which is complicated and insecure.*
    - Save and apply
### Jenkins Agent Node configuration
The Save button will create the node within Jenkins, and lead you to the Manage nodes and clouds page. Your new node will appear brown in the list, and you can click on it to see its details.The details page displays your java command line to start the agent . like defined below
- Donwload the `agent.jar` file and run it like below
    ```bash
    curl -sO http://my_ip:8080/jnlpJars/agent.jar
    java -jar agent.jar -jnlpUrl http://my_ip:8080/computer/My%20New%20Ubuntu%2022%2E04%20Node%20with%20Java%20and%20Docker%20installed/jenkins-agent.jnlp -secret my_secret -workDir "/home/jenkins"
    ```
    - You can now go back into Jenkins’ UI, select the Back to List menu item on the left side of the screen, and see that your new agent is running.
- Run your Jenkins agent as a service
    - Createa new dir at `/usr/local/jenkins-service`
    - Provide permissons to jenkins user for this dir
    - Move the agent.jar file that you downloaded earlier with the curl command to this directory.
        ```bash
        sudo mkdir -p /usr/local/jenkins-service
        sudo chown jenkins /usr/local/jenkins-service
        mv agent.jar /usr/local/jenkins-service
        ```
    - Now `/usr/local/jenkins-service` create a `start-agent.sh` file with the Jenkins java command we’ve seen earlier as the file’s content.
        ```bash
        #!/bin/bash
        cd /usr/local/jenkins-service
        # Just in case we would have upgraded the controller, we need to make sure that the agent is using the latest version of the agent.jar
        curl -sO http://my_ip:8080/jnlpJars/agent.jar
        java -jar agent.jar -jnlpUrl http://my_ip:8080/computer/My%20New%20Ubuntu%2022%2E04%20Node%20with%20Java%20and%20Docker%20installed/jenkins-agent.jnlp -secret my_secret -workDir "/home/jenkins"
        exit 0
        ```
    - Make the script executable by executing `chmod +x start-agent.sh`
    - Create a `/etc/systemd/system/jenkins-agent.service` file with the following content
        ```bash
        [Unit]
        Description=Jenkins Agent

        [Service]
        User=jenkins
        WorkingDirectory=/home/jenkins
        ExecStart=/bin/bash /usr/local/jenkins-service/start-agent.sh
        Restart=always

        [Install]
        WantedBy=multi-user.target
        ```
    - Enable the daemon `sudo systemctl enable jenkins-agent.service`
    - Start the daemon `sudo systemctl start jenkins-agent.service`
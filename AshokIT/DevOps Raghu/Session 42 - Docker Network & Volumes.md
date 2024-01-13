## Docker Networking
Docker networking allows containers to communicate with each other and with the outside world. Docker provides several networking options to facilitate communication between containers and between containers and the host system

1. Bridge Network (Default): By default, Docker creates a bridge network named bridge. Containers attached to this network can communicate with each other using IP addresses. Docker assigns IP addresses automatically to containers on this network.
    - Docker allows you to create user-defined bridge networks. 
    - These networks enable containers to communicate with each other using container names as hostnames. 

   
    ```bash
    # Viewing Default Networks
    docker network ls

    #Inspecting a Network:
    docker network inspect bridge
    ```


2. Host Network : Containers can share the network namespace of the host using the --network=host option. This option allows containers to use the host's network stack.

    Using Host Networking:
    ```bash
    docker run --network=host myimage
    ```
3. Overlay Networks: Docker supports overlay networks for multi-host communication in swarm mode. Overlay networks enable containers running on different hosts to communicate securely.
    ```bash
    # Creating an Overlay Network:
    docker network create --driver=overlay myoverlay
    # Running a Service on an Overlay Network:
    docker service create --name myservice --network myoverlay myimage
    ```
4. Macvlan: Macvlan networks allow containers to have their own MAC address and appear as separate physical devices on the network.
    ```bash
    # Creating a Macvlan Network:
    docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 mymacvlan
    # Running a Container on a Macvlan Network:
    docker run --network=mymacvlan --ip=192.168.1.10 myimage
    ```

5. Null Network: Null means no network will be provided by our Docker containers.

Docker provides several networking commands to manage network-related aspects of containers. 
Here are some commonly used Docker networking commands:

### Creating a Custom Bridge Network:
Creating a custom bridge network allows containers to communicate using container names or service names, providing better isolation.

```bash
# Creating a Bridge Network:
docker network create --driver bridge mynetwork
# Running a Container on a Custom Network:
docker run --network=mynetwork --name=mycontainer -d myimage
```

## Docker Network commands
Docker provides several networking commands to manage network-related aspects of containers. 
Here are some commonly used Docker networking commands:

```bash
# Creates a new Docker network.
docker network create <network_name> # by deatult bridge network is created
docker network create --driver <network-type> <network_name>

# Lists the available Docker networks.
docker network ls

# Provides detailed information about a Docker network.
docker network inspect <network_name>

# Connects a container to a Docker network.
docker network connect <network_name> <container_name_or_id>

# Disconnects a container from a Docker network.
docker network disconnect <network_name> <container_name_or_id>

# Removes a Docker network.
docker network rm <network_name>

# Removes all unused Docker networks.
docker network prune

# Creates an overlay network for swarm services.
docker network create --driver overlay <network_name>

# Creates a bridge network for containers to communicate on the same host.
$ docker network create --driver bridge <network_name>
```
- Notes:
  - Containers can be connected to multiple networks simultaneously. Each network provides a different communication context for the container.
  - When you connect a container to a network, it gains access to the network's DNS resolution, allowing it to communicate with other containers using their names.
  - Connections to networks are persistent; even if the container is stopped and restarted, it remains connected to the networks it was connected to before.

## task
``` bash
# Lab Task:
# create a n/w
docker network create bank-network 
# list
docker network ls
# inspect the n/w and see the containers atached to it
docker network inspect <network-id>
# create a ubuntu container
$ docker run -d --network bank-network ubuntu sleep 5000
# inspect the container to see the n/w attached to it
docker inspect <container-id>
# inspect the n/w and see the containers atached to it
docker network inspect <network-id>
# run a nginx contianer
docker run -d --network host nginx  # (runs on port 80 default)
# inspect the container to see the n/w attached to it
docker inspect <container-id>
# disconnect the continaer from the n/w
$ docker network disconnect bank-network <container-id>
# inspect the n/w and see the containers atached to it
docker network inspect <network-id>
# remove the n/w
$ docker network remove bank-network
```

# Docker Volumes

### Stateful Containers Vs Stateless Containers:
- Stateless Container means container will not persist data after destroying and creating a new one. 
- When we re-create the new container, we will lose old data.
- By default, docker containers are stateless containers.
- If we deploy the latest code or if we re-create the containers, we should not lose our old data. 
- Our data should remain in the database/directories.
- If we don't want to lose the data even if we re-create the container, then we need to make our Docker Container as Stateful Container.
- To make Docker Containers stateful, we need to use Docker Volumes.


### Docker Volumes:
Docker volumes are a feature that allows you to persist and share data between Docker containers. They provide a way to store and manage data generated by containers, even if the containers are stopped, removed, or replaced.

- We use docker volumes for file systems, databases, and object storage servers.
- Application will store data in database, even if we delete application container or Database container data should be available.
- To make sure data is available even after the container is deleted then we need to use Docker Volumes concept.


Volumes are the preferred mechanism for persisting data generated by and used by Docker containers.

```bash
# Delete all dangling volumes
docker volume rm $(docker volume ls -q -f dangling=true);

# Create Docker volume
docker volume create <vol-name>

# Display all docker volumes
docker volume ls

# Inspect Docker Volume
docker volume inspect <vol-name>

# Delete docker volume
docker volume rm <vol-name>

# To remove all unused volumes (those not connected to any containers
docker volume prune

# Delete all docker volumes
docker system prune --volumes

# Volumes can be mounted in containers using the -v option
docker run -v myvolume:/path/in/container myimage

# mount host directories as volumes using the -v option:
docker run -v /host/path:/path/in/container myimage

```

Docker has 3 types of volumes,

    1. Anonymous Volumes (without name)
    2. Named Volumes (Will have a name) ** Recommended
    3. Bind Mounts ( Storing on Host Machine )


1. Anonymus Volumes

    Anonymous volumes in Docker are volumes that are created implicitly when a container is run and a volume is specified without giving it a specific name. Anonymous volumes are not named and are managed by Docker. They are often used when the exact details of the volume, such as its name or location, are not critical to the user.

    - Anonymous volumes are retained even after the associated container is removed. Docker does this to prevent accidental data loss.
    - If you restart a container that uses the same anonymous volume, the data in the volume is still accessible.

    ```bash
    # using an anonymous volume
    docker run -v /path/in/container myimage
    # In this command, an anonymous volume is created, and the content of /path/in/container in the container is stored in this anonymous volume. The volume is managed by Docker, and you don't explicitly give it a name.
    ```
2. Named Volumes

    Named volumes in Docker are volumes that are explicitly created and given a specific name by the user. Unlike anonymous volumes, named volumes have a user-defined name, making them easier to manage and reference. Named volumes are useful when you want more control over the volume's lifecycle, visibility, and when you need to share data between containers.

    - Data stored in named volumes persists across container restarts and removals.
    - Users have more control over the lifecycle of named volumes, including when to create, remove, or reuse them.
    - Named volumes are more straightforward to back up, share, and manage compared to anonymous volumes.

    ```bash
    # Creating a Named Volume:
    docker volume create myvolume

    # Using a Named Volume in a Container:
    docker run -v myvolume:/path/in/container myimage
    # The above command runs a container and mounts the myvolume volume into the container at the specified path (/path/in/container).

    # Inspecting a Named Volume:
    docker volume inspect myvolume
    ```


    Use Case Example:
    Consider a scenario where you have a database container and a separate container running an application. By using a named volume, you can ensure that the database data persists even if you recreate or update the application container.

    ```bash
    # Create a named volume for the database data
    docker volume create db_data

    # Run the database container with the named volume
    docker run -v db_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest

    # Run the application container, connecting to the same named volume
    docker run -v db_data:/app/data -d myapp:latest
    Named volumes provide a convenient and manageable way to handle data persistence in Docker containers.
    ```

3. Bind Mounts

    Bind mounts in Docker are a way to mount a file or directory from the host machine into a Docker container. Unlike volumes, bind mounts are based on the host filesystem, and changes made in the container or on the host are immediately reflected in both locations. Bind mounts are useful when you need to share data between the host and the container in real-time.


    - Bind mounts are dependent on the host filesystem. Changes made on the host are immediately reflected in the container and vice versa.
    Read-Write by Default:
    - They are read-write by default, allowing both the host and the container to modify the shared files.
    Direct File Access:
    - Bind mounts allow direct access to files and directories on the host
    - The host path specified in the bind mount must exist on the host. Docker does not create the host path if it doesn't exist.


    ```bash
    #  Basic Bind Mount:
    docker run -v /host/path:/container/path myimage
    # In this example, the directory /host/path on the host machine is mounted into the container at /container/path.

    # Read-Only Bind Mount:
    docker run -v /host/path:/container/path:ro myimage
    # Adding :ro makes the bind mount read-only, preventing changes in the container from affecting the host.

    # Binding a File:
    docker run -v /host/file:/container/file myimage

    # mount the current directory on the host into the container.
    docker run -v $(pwd):/container/path myimage
    # $(pwd) is used to dynamically get the current working directory.

    # Mounting Docker Socket , it allows a container to communicate with the Docker daemon on the host. This is often used for Docker-in-Docker scenarios.
    docker run -v /var/run/docker.sock:/var/run/docker.sock myimage
    ```

### Dangling volume in Docker ?
The volumes which are created but not associated to any container are called as Dangling Volumes



- Notes:
    - Volumes are typically used to persist data that needs to survive the container's lifecycle, such as databases, logs, and user uploads.
    - When a named volume is removed, the data it contains is not immediately deleted. Docker retains the data to prevent accidental data loss.
    - Anonymous volumes are automatically removed when the associated container is removed.


## Practical Senario -  Persisting data in docker volumes for mysql application


The objective of the lab task is to showcase the usage of Docker volumes with a MySQL container. By creating, binding, and reusing a named volume (mysql_data), the task demonstrates how to persistently store MySQL data. This approach ensures data consistency across different container instances, allowing for the creation, destruction, and recreation of MySQL containers without losing data integrity.


```bash
# View existing docker volumes
docker volume ls

# Create a new Docker volume
docker volume create mysql_data

# Create a MySQL Container with above volume binding (-v volume_name:/path/in/container)
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=root -v mysql_data:/var/lib/mysql mysql:8.0

# get shell inside the sql container to exec below commands
docker exec -it mysql bash 

# login mysql , create database, table, then insert few rows
mysql -u root -p 
CREATE DATABASE raghudb; 
USE raghudb; 
CREATE TABLE users (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50)); 
INSERT INTO users (name) VALUES ('Raghu'), ('Raju'), ('Ramu');
SELECT * FROM users;

# exit the shell and remove this MySQL Container.
docker rm -f mysql

# Create a new MySQL container by mounting the same volume
docker run -d --name mysql_two -e MYSQL_ROOT_PASSWORD=root -v mysql_data:/var/lib/mysql mysql:8.0

# get the container shell access to check if the data from previos container is persisted 
$ docker exec -it mysql_two bash
mysql -u root -p 
USE raghudb; 
SELECT * FROM users;
```

# Docker Compose
Docker Compose is a tool for defining and running multi-container Docker applications. It allows you to describe the services, networks, and volumes in a docker-compose.yml file and then start and manage the entire application stack with a single command. Docker Compose simplifies the process of orchestrating complex applications by providing a clear and human-readable configuration.

## Key Concepts:
- docker-compose.yml File:
This YAML file defines the services, networks, and volumes for a Docker application. It specifies the configuration, dependencies, and relationships between the containers.

- Services:
Each service in the docker-compose.yml file corresponds to a container. Services define how each container should behave, including the image to use, environment variables, volumes, and ports.

- Networks:
Networks allow containers to communicate with each other. Docker Compose automatically creates a default network for the application, and you can define additional custom networks.

- Volumes:
Volumes provide persistent storage for containers. You can define volumes in the docker-compose.yml file to store data that needs to persist beyond the lifecycle of a container.

- docker-compose.yml structure

    - <u> Version </u> : Specifies the version of the Docker Compose file format to use. This determines which features and syntax are available.

    - <u> Services </u>: Defines the services or containers that make up your application. Each service specifies an image, environment variables, volumes, ports, and other configuration options.

    - <u> Networks </u>: Specifies custom networks for the containers to communicate with each other. By default, Docker Compose creates a default network for the application.

    - <u> Volumes </u>: Defines volumes for persistent storage. Volumes can be used to store data that needs to persist beyond the container's lifecycle.
        ```yaml
        version: '3'

        services:
          web:

          db:

        network:
          mynetwork:
            driver: bridge

        volumes:
          myvolume:
        ```
## Docker-Compose Setup
```bash
# download docker compose
$ sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Allow Execution permission 
sudo chmod +x /usr/local/bin/docker-compose
# check docker compose is installed or not
docker-compose --version
```

### Commands
```bash
# start the application containers using Docker Compose.
docker-compose up -d   # Builds, (re)creates, starts, and attaches to containers based on the docker-compose.yml file

# start the application containers with custom file name.
docker-compose -f <filename> up -d

# Display Containers created by Docker Compose.
docker-compose ps  # Lists the containers defined in the docker-compose.yml file along with their status.

#  Display docker compose images.
docker-compose images

# restart the containers created by docker compose.
docker-compose restart

# Stop & remove the containers created by docker compose.
docker-compose down # Stops and removes containers, networks, and volumes defined in the docker-compose.yml file.

# Executes a command in a running container.
docker-compose exec <service_name> <command>

# displays the logs of the containers defined in the docker-compose.yml file.
docker-compose logs

# build all the images mentioned in the docker-compose yaml
docker-compose build
# build only specific images mentioned in docker-compose
docker-compose build <app-name-1> <app-name-2> 
```

### Sample Appliation using Docker Compose
Consider a simple docker-compose.yml file for a web application with a web server and a database:
```yaml
version: '3'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
  database:
    image: postgres:latest
    environment:
      POSTGRES_PASSWORD: mysecretpassword
```
- Running docker-compose up will start an Nginx web server and a PostgreSQL database container.

- docker-compose down will stop and remove the containers.

## Services Section
The services section in a Docker Compose file is a critical part where you define the individual containers (services) that make up your application. Each service has various configurations and options. Here are some important parts commonly found in the services section:

1. Image:

Specifies the Docker image to use for the service. It can be an official image from a registry or a custom image built from a Dockerfile.

```yaml
services:
  web:
    image: nginx:latest
```
2. Build:

Specifies the build context and optionally the Dockerfile for building a custom image. Useful when you want to customize the image.

```yaml
services:
  web:
    build:
      context: ./web
      dockerfile: Dockerfile.dev
```
3. Ports:

Maps container ports to host ports, allowing external access to the service. The format is "HOST_PORT:CONTAINER_PORT".

```yaml
services:
  web:
    ports:
      - "8080:80"
```
4. Volumes:

Mounts volumes to the container for persistent storage. The format is "HOST_PATH:CONTAINER_PATH".

```yaml
services:
  web:
    volumes:
      - "/path/on/host:/path/in/container"
```
5. Environment Variables:

Sets environment variables for the service. Useful for configuring container behavior.

```yaml
services:
  database:
    environment:
      POSTGRES_PASSWORD: mysecretpassword
```
6. Command:

Specifies the command to run inside the container.

```yaml
services:
  web:
    command: ["nginx", "-g", "daemon off;"]
```
7. Depends_on:
Specifies dependencies between services. It ensures that one service starts only after its dependent services are up.

```yaml
services:
  web:
    depends_on:
      - database
```
8. Networks:

Associates services with custom networks. Containers within the same network can communicate with each other.

```yaml
services:
  web:
    networks:
      - mynetwork
```
9. Labels:

Adds metadata to the service. Labels can be used for various purposes, including documentation and organization.

```yaml
services:
  web:
    labels:
      - "com.example.description=This is a web service."
```

10. Logging:

Configures logging options for the service.

```yaml
services:
  web:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
```

## Network Section

The `networks` section in a Docker Compose file allows you to define custom networks for your services. Networks enable communication between containers within the same network, and they provide isolation between different parts of your application. Here are the key components of the `networks` section:

- Defining: define custom networks under the `networks` section. Each network can have its own driver, and you can specify additional options.
- Driver : Specify the network driver to use. The default driver is `bridge`, but other options include `host`, `overlay`, and `macvlan`. The driver determines how containers communicate with each other.

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    networks:
      - frontend
  database:
    image: postgres:latest
    networks:
      - backend
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```

- In this example, two networks (`frontend` and `backend`) are defined. The `web` service is connected to the `frontend` network, and the `database` service is connected to the `backend` network.

- External Network : You can also connect your services to existing (external) networks using the `external` key.

```yaml
networks:
  existing_network:
    external: true
```

- This allows your Docker Compose services to communicate with containers outside the scope of your Compose file.

- Aliases: Assign aliases to services within a network. This can be useful for easier inter-container communication.

```yaml
services:
  web:
    networks:
      frontend:
        aliases:
          - webserver
```
- In this example, the `web` service is given the alias `webserver` within the `frontend` network.

## Volume Section
The volumes section in a Docker Compose file allows you to define named volumes, which provide persistent storage for your containers. Volumes are used to store and share data between containers or between the host machine and containers. Here are the key components of the volumes section:

- Defining volumes under the volumes section. Each volume can have a user-defined name.

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    volumes:
      - myvolume:/app/data
volumes:
  myvolume:
```
- In this example, a volume named myvolume is defined. The web service is configured to use this volume, mounting it to the path /app/data in the container.

- External Volumes:
You can also reference external volumes or volumes created outside the scope of your Compose file.

```yaml
volumes:
  existing_volume:
    external: true
```
- This allows your Docker Compose services to use volumes that were created separately.

- Volume Options:
Specify options for volumes, such as read-only access or custom driver options.

```yaml
volumes:
  myvolume:
    driver: local
    driver_opts:
      type: 'nfs'
      o: 'addr=192.168.1.1,rw'
      device: ':/path/on/nfs/server'
    external: true
```
- This example shows how to specify a local volume with custom driver options, such as using NFS.

- Volume Bind Mounts: Use volume bind mounts to mount a path from the host machine to a container. This is an alternative to named volumes.

```yaml
version: '3'
services:
  web:
    image: nginx:latest
    volumes:
      - /path/on/host:/app/data
```
- In this example, the /path/on/host directory on the host machine is mounted to the /app/data path in the web container.



# SpringBoot + MYSQL DB Application using Docker Compose
- github repo url : https://github.com/javabyraghu/spring-boot-mysql-docker-compose

```bash
# clone repo
git clone https://github.com/javabyraghu/spring-boot-mysql-docker-compose.git
# Build the app using Maven 
cd spring-boot-mysql-docker-compose
mvn clean package

# Create Docker image. Use only if the dockerfile path is not added under services in the docker-compose
$ docker build -t spring-boot-mysql-app .


# Run the compose file
docker-compose up -d

# Test Application (Open PORT 8080 on Security Group)
http://EC2-PUBLIC-IP:8080

# Verifying the data in db
# Connect to Database container
docker exec -it <db-container-name> /bin/bash
# Login to database and check table data
mysql -u root -p
show databases;
use springdb ;
show tables;
select * from book;
```

- use the below `docker-copmose.yml` file
```yaml
version: '3'
services:
  mysqldb:
    image: mysql:8.0 # the image that will be pulled from docker hub
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: springdb
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - mynetwork

  app:
    image: spring-boot-mysql-app:latest # explicitly specify a name for the image , becuase the docker-compose will build the image from dockerfile henec it is not pulling an image 
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - 8080:8080
    depends_on:
      - mysqldb
    networks:
      - mynetwork

networks:
  mynetwork:

volumes:
  mysql-data:
```
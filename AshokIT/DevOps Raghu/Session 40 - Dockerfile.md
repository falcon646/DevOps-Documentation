# Dockerfile
A Dockerfile is a text file that contains a set of instructions used to build a Docker image. Docker images are the building blocks of containers, providing a lightweight and portable way to package and distribute applications.

It provides a way to automate the process of creating a Docker container image, specifying the base image, adding application code, defining runtime settings, and more. Dockerfiles follow a simple syntax and are typically named "Dockerfile" with no file extension.
- In Dockerfile we will use DSL (Domain Specific Language) keywords
- Docker engine will process Dockerfile instructions from top to bottom.

### Dockerfile Instruction 
[documentation](https://docs.docker.com/engine/reference/builder/#overview)

In a Dockerfile, an instruction is a command or operation that is used to build a Docker image layer. Each instruction in the Dockerfile corresponds to a step in the image creation process. Docker uses a layered file system, and each instruction creates a new layer, contributing to the final image. Here are some commonly used instructions in a Dockerfile:

 - <u>**FROM**</u> : Specifies the base image to use for the Docker image. It defines the starting point of the image.

    ```dockerfile
    FROM <base-image>:<tag>
    FROM java:jdk-1.8
    FROM tomcat:9.5
    FROM mysql:6.8
    FROM python:3.3
    ```

 - <u>**RUN**</u> : Executes commands in the shell of the container during the image build process. It is used to install packages, set up dependencies, and perform other build-time actions.

    ```dockerfile
    #syntax
    RUN <command> 
    RUN <command-1> && \
        <command-2>

    # Update package lists and install necessary packages
    RUN apt-get update && \
        apt-get wget -y 
    
    # Install ansible packages using pip
    RUN pip install ansible

    # Download a file from the internet & extract it
    RUN wget https://example.com/myfile.tar.gz -O /tmp/myfile.tar.gz && \
        tar -xzf /tmp/myfile.tar.gz -C /tmp/

    # Add a new user
    RUN useradd -ms /bin/bash newuser

    # make it script executable
    RUN chmod +x /usr/local/bin/myscript.sh
    ```

 - <u>**COPY**</u> : Copies files and directories from the host machine into the container's file system. COPY is preferred for copying local files
    ```dockerfile
    # Syntax:
    COPY <source-location>  <destination-location>
    # Copy a single file from the host to the image
    COPY myfile.txt /app/
    # Copy the entire contents of a directory from the host to the image
    COPY ./myapp /app/
    # Copy multiple files from the host to the image
    COPY requirements.txt app.py /app/
    # Copy all text files from the host to the image
    COPY *.txt /app/
    # Copy with Relative Path
        # Set the working directory in the container
        WORKDIR /app
        # Copy a file from a relative path in the build context
        COPY src/myfile.txt .

    ```
 
 - <u>**ADD**</u> : Similar to COPY, but with additional features such as automatic decompression of compressed files and remote URL support.
    ```dockerfile
    # Syntax:
    ADD <source-location>  <destination-location>
    ADD <url>  <destination-location>

    # Add a single file from the host to the image
    ADD myfile.txt /app/
    # Add the entire contents of a directory from the host to the image
    ADD ./myapp /app/
    # Add and extract a local tarball from the host to the image
    ADD myfiles.tar.gz /app/
    # Add a file from a URL to the image
    ADD https://example.com/myfile.txt /usr/share/nginx/html/
    # Add a file from the host and set permissions
    ADD --chown=user:group myfile.txt /app/
    # Add multiple files from the host to the image
    ADD requirements.txt app.py /app/
    # Add and extract a remote tarball to the image
    ADD https://example.com/myfiles.tar.gz /app/
    ```

 - <u>**WORKDIR**</u> : Sets the working directory for any subsequent instructions. It affects the context for commands like RUN, CMD, and COPY.

    By setting the working directory early in the Dockerfile, subsequent instructions are executed in that directory, and the resulting layers are smaller and more efficient.
    ```dockerfile
    # syntax
    WORKDIR /<path>
    # Set the working directory to /app
    WORKDIR /app

    # Set an environment variable nad use it to set workdir
    ENV APP_HOME=/app
    WORKDIR $APP_HOME
    ```

 - <u>**ENV**</u> : Sets environment variables inside the container. These variables can be accessed by the application running in the container.
    ```dockerfile
    # Syntax to Set an environment variable
    ENV MY_VARIABLE=myvalue
    
    # Set multiple environment variables
    ENV USER_NAME=john \
        USER_ID=1001 \
        HOME_DIR=/home/john
    # Use the environment variables in a subsequent instruction
    RUN echo "User: $USER_NAME, ID: $USER_ID, Home: $HOME_DIR"

    # Using Environment Variables in CMD
    ENV APP_NAME=myapp  # Set an environment variable
    CMD ["python", "app_$APP_NAME.py"] # Set the default command using the environment variable

    # Clear the environment variable in a subsequent instruction
    RUN unset MY_VARIABLE
    ```

 - <u>**EXPOSE**</u> : Informs Docker that the container will listen on the specified network ports at runtime. It does not actually publish the ports , you need to use the -p flag when running the container to do that . this is only used for documentation purpose.

    ```dockerfile
    # Expose port 80 for HTTP traffic
    EXPOSE 80
    # Expose ports 3000 for the application and 8080 for debugging
    EXPOSE 3000 8080
    # Expose a range of ports
    EXPOSE 8080-8090
    ```

 - <u>**CMD**</u> : Specifies the default command to run when the container starts. It provides the primary functionality of the container.
     - It can be specified in two forms:
       - shell form : ```CMD command param1 param2```
       - Exec form (preferred) : ```CMD ["command", "param1", "param2"]```
    ```dockerfile
    # Set the default command using the shell form
    CMD echo "Hello, Docker!"
    # Set the default command using the exec form
    CMD ["echo", "Hello, Docker!"]
    # Set the default command to start the nginx web server
    CMD ["nginx", "-g", "daemon off;"]
    # Set the default command to run the Python script
    CMD ["python", "/app/myscript.py"]
    # Set the default command with arguments
    CMD ["echo", "This is", "a Dockerfile", "CMD example"]
    # Combined with entry point
    ENTRYPOINT ["echo", "Hello,"] # Set the entrypoint
    CMD ["Docker!"] # Set default arguments using CMD
    # Set the default command to start a Node.js service
    CMD ["npm", "start"]
    # Set the default command to run the Java application
    CMD ["java", "-jar", "/app/myapp.jar"]
    ```

    Note: If we write multiple CMD instructions, also docker will process only the last CMD instruction. There is no use of writing multiple CMD instructions in one Dockerfile.

 - <u>**ENTRYPOINT**</u> : Like CMD, but it specifies the executable to run as the entry point of the container. It is often used for defining a command that cannot be overridden.
     - It can be specified in two forms:
       - shell form : ```ENTRYPINT command param1 param2```
       - Exec form (preferred) : ```CMD ["command", "param1", "param2"]```

    ```dockerfile
    # Set the entrypoint to echo a greeting using shell form
    ENTRYPOINT echo "Hello, Docker!"
    # Set the entrypoint to echo a message with arguments in exec form
    ENTRYPOINT ["echo", "Docker is awesome!"]

    # Set the entrypoint to run the Python script
    ENTRYPOINT ["python", "/app/myscript.py"]

    # Combined with cmd
    ENTRYPOINT ["echo", "Hello,"] # Set the entrypoint
    CMD ["Docker!"] # Set default arguments using CMD

    # Set the entrypoint to nginx executable
    ENTRYPOINT ["nginx", "-g", "daemon off;"]

    # Set the entrypoint to run the Java application
    ENTRYPOINT ["java", "-jar", "/app/myapp.jar"]
    ```
    Note:
    When ENTRYPOINT is specified in exec form, it does not invoke a command shell. When specified in shell form, it invokes a command shell.
 - <u>**VOLUME**</u> : Creates a mount point to attach a persistent storage volume to the container. It is used to persist data across container restarts. They allow data to be shared between the host machine and the container or between multiple containers.
    ```dockerfile
    FROM ubuntu:20.04
    # Create a volume at /data
    VOLUME /data
    WORKDIR /app
    COPY . .
    CMD ["./myapp"]
    ```
    In this example, the VOLUME instruction creates a mount point at /data inside the container. This directory becomes a volume, and data written to it is stored outside the container.

    When you run a container based on this image, you might use the following command: ```docker run -v /host/path:/data myimage```.
    Here, /host/path is a directory on the host machine that is mounted to the /data volume inside the container. Any data written to /data in the container will be persisted on the host machine at /host/path.

    Note:
    - The VOLUME instruction is often used to handle data that should persist across container instances or that needs to be shared among multiple containers.
    - Data in volumes persists even if the container is removed, making it suitable for storing application data, configuration files, and other persistent data.
    - It's common to use volumes for databases, logs, and any data that needs to survive the container's lifecycle.

 - <u>**ARG**</u> : Defines variables that users can pass at build-time to the builder with the docker build command. They are used to parameterize the build process.

   ```dockerfile
   # Define a build-time variable with a default value
   ARG APP_VERSION=1.0

   # Use the build-time variable in labels and environment variables
   LABEL version=$APP_VERSION
   ENV APP_VERSION=$APP_VERSION
   ```
   When building the image, users can override the default value of APP_VERSION using the --build-arg option:

   ```bash
   docker build --build-arg APP_VERSION=2.0 -t myimage .
   ```

   Note:

      - Build-time variables defined with ARG are only available during the build process and are not stored in the final image.
      - If you don't provide a value for the build-time variable during the build, the default value specified in the Dockerfile will be used.
      - ARG values can be used in various instructions such as FROM, RUN, ENV, LABEL, ADD, COPY, and CMD.
 - <u>**LABEL**</u> : Adds metadata to the Docker image. It is typically used for providing information about the maintainer, version, or other identifying details.

```dockerfile
# Set metadata labels
LABEL version="1.0"
LABEL maintainer="John Doe <john.doe@example.com>"
LABEL description="A simple Python application."

# Set multiple metadata labels
LABEL version="2.0" \
      description="Node.js application" \
      author="Jane Doe <jane.doe@example.com>"

# Set custom metadata labels
LABEL com.example.vendor="Example Inc." \
      com.example.release-date="2024-01-15"

# Set metadata labels with a multi-line description
LABEL version="3.0" \
      description="This image runs a web server.\n\
      It includes Nginx for serving web pages.\n\
      Additionally, it has PHP support for dynamic content."

```

 - <u>**USER**</u> : The USER instruction sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for the remainder of the current stage. The specified user is used for RUN instructions and at runtime, runs the relevant ENTRYPOINT and CMD commands.

    It is often used to switch from the default root user to a less privileged user for security reasons. Here are some examples demonstrating the use of the USER instruction
    ```dockerfile
    #In this example, a non-root user named myuser is created using the adduser command. The USER instruction then switches to this non-root user, and subsequent instructions are executed with the permissions of this user
    # Create a non-root user
    RUN adduser -D myuser
    # Set the user to run subsequent commands
    USER myuser

    # Set the user by UID
    USER 1001
    ```
    Note:
    - If the user specified by USER does not exist, Docker will throw an error during the build process.
    -  It's good practice to create a dedicated non-root user and use it for running the application inside the container to enhance security.
    -   The USER instruction can be used in combination with other instructions such as RUN, WORKDIR, and CMD to configure the runtime behavior of the container.
    - the user can also be specified at runtime, overriding the user set in the Dockerfile. ```docker run -u myuser myimage```


What is the difference between RUN and CMD in Dockerfile ?

      RUN is used to execute instructions while creating images.
      CMD is used to execute instructions while creating Container.

      We can write multiple RUN instructions in Dockerfile, docker will process all those instructions one by one.
      If we write multiple CMD instructions in Dockerfile, docker will process only the last CMD instruction.

What is the difference between CMD and ENTRYPOINT ?

      We can override CMD instructions in runtime while creating container.
      We can't override ENTRYPOINT instructions.

```bash
# to build an image from Dockerfile
# syntax
docker build -t <image-name> /path/to/dockerfilr 
docker build -t  <image-name>  .
#Ex
docker build -t  myfirstimage  .
# providing custom dockerfile
docker build -f <dockerfile-custom-name> -t <image-name> /path/to/file
# login with dockerhub
docker login
# tag a docker image.
docker tag  <image-name> <dockerhub-username>/<repo-name>:<version/tag>
#Ex:
docker tag myfirstimage falcon646/myfirstimage:v1
# push docker image to Docker hub .
docker push <tag-name>
# ex:
docker push falcon646/myfirstimage:v1
# pull image from Docker hub.
docker pull falcon646/myfirstimage:v1
# to run a container from docker image.
docker run falcon646/myfirstimage:v1
# delete all unused images and stopped containers
docker system prune -a
```


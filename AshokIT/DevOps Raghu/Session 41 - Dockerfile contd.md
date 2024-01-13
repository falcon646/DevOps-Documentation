### Running container in detached mode
when we run a container, by default our terminal will be blocked when the container starts, we can't execute any other command. To execute other commands, we need exit the shell using exit .By doing this even though the terminal open up for our commands, but the container gets stopped.

To overcome the above problem we can pass '-d' to run container in detached mode. When we run a conatiner in detached mode the container keeps running i the background and the terminal will not be blocked

```bash
$ docker run -d -p 8080:8080 sb-app  
```


## Dockeringzing a SpringBoot Application
- prerequisites
    - Spring Boot provides embedded server ( ie internal server will be available, we no need to configure web server for execution)
    - Spring Boot application will be packaged as jar file  
    - To run spring boot applications, we just need to run  jar file eg ```java -jar <boot-app-jar-file>```

- Spring Boot App GitHub Repository URL : https://github.com/javabyraghu/spring-boot-docker-app.git
    ```bash
    # instal git maven
    sudo yum install git maven -y
    # Clone GitHub Repo
    $ git clone https://github.com/javabyraghu/spring-boot-docker-app.git
    # build the app with maven to generate the .jar/.war
    cd spring-boot-docker-app
    mvn clean package

    # write the dockerfile and generate docker image from it
    docker build -t sb-app .
    # Run docker image with port mapping
    $ docker run -d -p 8080:8080 sb-app
    ```
- writing the dockerfile
    ```dockerfile
    FROM openjdk:11 # specify the base image
    # move the .jar generated from maven to the /usr/app in the container
    COPY target/spring-boot-docker-app.jar /usr/app 
    # set the working directory for the app
    WORKDIR /usr/app/
    # set the entrypoint to run when the container starts
    ENTRYPOINT ["java", "-jar", "spring-boot-docker-app.jar"]
    ```

## Dockerizing Java Web Application (Not Springboot)
- prerequisites
    - To run java web app we need Java(JRE) & Tomcat as dependencies
    - Java web apps are packaged as .war.
    - To execute the .war , we need to deploy war file in Tomcat server , /tomcat/webapps/ directory

- Java Web Application GitHub Repository : https://github.com/javabyraghu/maven-web-app.git

    ```bash
    # instal git maven
    sudo yum install git maven -y
    # Clone Repository
    $ git clone https://github.com/javabyraghu/maven-web-app.git
    # clean and Build as WAR file
    cd maven-web-app
    mvn clean package

    # Create Docker Image from Dockerfile
    docker build -t maven-web-app .
    # Run Docker container in Detached Mode.
    docker run -d -p 8080:8080 maven-web-app

    # To access The Application  
    http://ec2-vm-public-ip:host-port/maven-web-app/
    # maven-web-app" is called as context path
    # name of the war file will become context path
    ```
- writing docker file
    ```dockerfile
    FROM tomcat:8.0.20-jre8 # we use tomcat iamge since we need webserver
    COPY target/01-maven-web-app.war  /usr/local/tomcat/webapps/maven-web-app.war
    # copying the .war generated using maven in webapps directory under the catalina_home location from the base image (/usr/local/tomcat/)
    # we didnt require entrypoint here since the base image is tomcat and base image is by default configured to start the tomcat sevrver when the container runs
    ```

## Dockerizing Python Flask Application
- prerequisites
    - Python is a general-purpose scripting language.
    - Python programs will have .py as extension.
    - Compilation is not required for python programs. To run them just use ```python <file-name>.py```

- Python Flask application GitHub Repository URL:
https://github.com/javabyraghu/python-flask-docker-app.git

    ```bash
    # clone repo
    $ git clone https://github.com/javabyraghu/python-flask-docker-app.git

    # build image from dockerfile
    cd python-flask-docker-app
    docker build -t python-flask-app .

    # run container from the image created
    $ docker run -d -p 5000:5000 python-flask-app
    ```
- Dockerfile
    ```dockerfile
    FROM python:3.6
    MAINTAINER "ax025u"
    COPY . /app # copy all contents from current local dir to /app inside container
    WORKDIR /app # set the working dir for the container
    EXPOSE 5000 # for documentation
    RUN pip install -r requirements.txt # install all the required dependencies
    ENTRYPOINT ["python", "app.py"] # run the app.py file when the container runs
    ```



## Dockerizing Angular Application
- prerequisites
    - Angular is a TypeScript-based, free, and open-source single-page web application framework
    - It runs on nodejs , hence base image shdoulbe of nodejs
    - The default port number is 4200, but we have mapped to 80 (inside the app code) using nginx.

- Angular application GitHub Repository URL:
https://github.com/javabyraghu/angular-docker-app.git
    ```bash
    # clone repo
    git clone https://github.com/javabyraghu/angular-docker-app.git
    # build image from dockerfile
    cd angular-docker-app
    docker build -t angular-docker-app  .
    # run container from image
    docker run -d -p 80:80 angular-docker-app
    ```
- Dockerfile
    ```dockerfile
    FROM node:alpine                        # Use an official Node.js runtime as the base image
    WORKDIR /app                            # Set the working directory in the container
    COPY package.json package-lock.json ./  # Copy package.json and package-lock.json to the working directory
    RUN npm install                         # Install project dependencies
    COPY . .                                # Copy the project files for local to the working directory
    RUN npm run  build                      # Build the Angular app
    EXPOSE 80                               # Expose port 80 for the container
    CMD [ "node", "server.js" ]             # Define the command to run the app when the container starts
    ```

# Dockerfile
A Dockerfile is a text file that contains a set of instructions used to build a Docker image. Docker images are the building blocks of containers, providing a lightweight and portable way to package and distribute applications.

It provides a way to automate the process of creating a Docker container image, specifying the base image, adding application code, defining runtime settings, and more. Dockerfiles follow a simple syntax and are typically named "Dockerfile" with no file extension.
- In Dockerfile we will use DSL (Domain Specific Language) keywords
- Docker engine will process Dockerfile instructions from top to bottom.

### Dockerfile Instruction 
[documentation](https://docs.docker.com/engine/reference/builder/#overview)

In a Dockerfile, an instruction is a command or operation that is used to build a Docker image layer. Each instruction in the Dockerfile corresponds to a step in the image creation process. Docker uses a layered file system, and each instruction creates a new layer, contributing to the final image. Here are some commonly used instructions in a Dockerfile:

 - <u>**FROM**</u> : Specifies the base image to use for the Docker image. It defines the starting point of the image.

 - <u>**RUN**</u> : Executes commands in the shell of the container during the image build process. It is used to install packages, set up dependencies, and perform other build-time actions.

 - <u>**COPY**</u> : Copies files and directories from the host machine into the container's file system. COPY is preferred for copying local files
 
 - <u>**ADD**</u> : Similar to COPY, but with additional features such as automatic decompression of compressed files and remote URL support.

 - <u>**WORKDIR**</u> : Sets the working directory for any subsequent instructions. It affects the context for commands like RUN, CMD, and COPY.

 - <u>**ENV**</u> : Sets environment variables inside the container. These variables can be accessed by the application running in the container.

 - <u>**EXPOSE**</u> : Informs Docker that the container will listen on the specified network ports at runtime. It does not actually publish the ports , you need to use the -p flag when running the container to do that . this is only used for documentation purpose.

 - <u>**CMD**</u> : Specifies the default command to run when the container starts. It provides the primary functionality of the container.

 - <u>**ENTRYPOINT**</u> : Like CMD, but it specifies the executable to run as the entry point of the container. It is often used for defining a command that cannot be overridden.

 - <u>**VOLUME**</u> : Creates a mount point to attach a persistent storage volume to the container. It is used to persist data across container restarts.

 - <u>**ARG**</u> : Defines variables that users can pass at build-time to the builder with the docker build command. They are used to parameterize the build process.

 - <u>**LABEL**</u> : Adds metadata to the Docker image. It is typically used for providing information about the maintainer, version, or other identifying details.

 - <u>**USER**</u> : The USER instruction sets the user name (or UID) and optionally the user group (or GID) to use as the default user and group for the remainder of the current stage. The specified user is used for RUN instructions and at runtime, runs the relevant ENTRYPOINT and CMD commands.
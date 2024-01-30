## Jenkinsfile

A Jenkinsfile is a text file that contains the definition of a Jenkins Pipeline. It is written using a Groovy-based Domain Specific Language (DSL) and resides in the root directory of your project's source code repository.

The Jenkinsfile defines the entire build process as a series of stages and steps, providing a declarative or scripted syntax to define how the software should be built, tested, and deployed.

There are two main types of Jenkinsfiles:

- `Declarative Pipeline (New)`: Declarative Pipelines offer a more structured and simpler syntax for defining pipelines. They aim to provide a more human-friendly way of authoring complex build configurations.

    - Uses the pipeline block to define the entire pipeline.
    - Provides a more structured and human-friendly syntax.
    - Requires specific keywords like agent, stages, and steps.
    - Each stage is defined using the stage block, and steps are defined within the steps block.

    Example of a Declarative Pipeline:

    ```groovy
    pipeline {
        agent any

        stages {
            stage('Build') {
                steps {
                    echo 'Building...'
                }
            }
            stage('Test') {
                steps {
                    echo 'Testing...'
                }
            }
            stage('Deploy') {
                steps {
                    echo 'Deploying...'
                }
            }
        }
    }
    ```
- `Scripted Pipeline (groovy)` : Scripted Pipelines offer more flexibility and power by allowing the use of Groovy scripting directly within the Jenkinsfile. They are suitable for more complex build configurations that cannot be expressed easily in the declarative syntax.
    - Uses the node block to define the execution environment.
    - Allows direct usage of Groovy scripting within the pipeline script.
    - Offers more flexibility and power but can be less readable for complex pipelines.
    - Each stage is defined within its own block, and steps are written directly inside the stage block.

    Example of a Scripted Pipeline:

    ```groovy
    node {
        stage('Build') {
            echo 'Building...'
        }
        stage('Test') {
            echo 'Testing...'
        }
        stage('Deploy') {
            echo 'Deploying...'
        }
    }
    ```

### Syntax comparison
When Jenkins Pipeline was first created, Groovy was selected as the foundation to provide advanced scripting capabilities for admins and users alike. Additionally, the implementors of Jenkins Pipeline found Groovy to be a solid foundation upon which to build what is now referred to as the "Scripted Pipeline" DSL.

As it is a fully featured programming environment, Scripted Pipeline offers a tremendous amount of flexibility and extensibility to Jenkins users. The Groovy learning-curve isn’t typically desirable for all members of a given team, so Declarative Pipeline was created to offer a simpler and more opinionated syntax for authoring Jenkins Pipeline.

The two are both fundamentally the same Pipeline sub-system underneath. They are both able to use steps built into Pipeline or provided by plugins. Both are able utilize Shared Libraries.

Where they differ however is in syntax and flexibility. 

- `Flexibility`: Scripted Pipeline offers more flexibility due to the ability to use Groovy scripting directly, while Declarative Pipeline provides a more structured and opinionated syntax.
- `Readability`: Declarative Pipeline is often more readable and easier to understand, especially for simpler pipelines, whereas Scripted Pipeline can become verbose for complex scenarios.
- `Error Handling`: Declarative Pipeline provides built-in error handling and post-action directives, while Scripted Pipeline requires explicit error handling using Groovy constructs.
- Declarative limits what is available to the user with a more strict and pre-defined structure, making it an ideal choice for simpler continuous delivery pipelines. 
- Scripted provides very few limits, insofar that the only limits on structure and syntax tend to be defined by Groovy itself, rather than any Pipeline-specific systems, making it an ideal choice for power-users and those with more complex requirements. 
- As the name implies, Declarative Pipeline is encourages a declarative programming model. Whereas Scripted Pipelines follow a more imperative programming model


## Declarative Pipeline

Declarative syntax in Jenkins Pipeline is a way to define continuous integration and continuous delivery (CI/CD) pipelines using a structured and human-friendly syntax. It aims to provide a simpler and more concise way to define pipelines compared to the Scripted syntax.

- Rules :
    - The top-level of the Pipeline must be a block, specifically: pipeline { }
    - No semicolons as statement separators. Each statement has to be on its own line
    - Blocks must only consist of declarative sections, declarative directives, declarative steps, or assignment statements.
    - A property reference statement is treated as no-argument method invocation. So for example, input is treated as input()

- `Pipeline block` :
In Declarative pipeline, the Jenkinsfile start with pipeline block (Mandatory)

    ```groovy
    pipeline {

    }
    ```
    The pipeline block is used to define the entire pipeline. It serves as the top-level container for defining stages and other pipeline-related configurations.

    - Inside pipeline block we have agent block (Mandatory) and stages block (Mandatory)
    - Inside satges block we should have atleast one stage block
    - Inside stage block we should have steps block
    - Inside steps block we should have atleast one step(inbuild function name) eg:
        - sh step to execute any shell commands
        - echo step to print some data

- `Agent Directive` :
The agent directive specifies the execution environment for the pipeline (specifies where the entire Pipeline, or a specific stage), such as a Docker container, Jenkins agent, or any available executor in the Jenkins environment.
    ```groovy
    pipeline {
        agent any
        // Stages and steps go here
    }
    ```

    By default it executes in the same Jenkins instance. If we have configures slaves for Jenkins, then we can use this agent block to tell the Jenkins to execute the Job in particular slave.

- `Stages`: Stages represent different phases of your pipeline, such as building, testing, and deploying. Each stage typically corresponds to a specific task in your CI/CD process.

- `Stage` : The stage block is used to define individual stages within the pipeline.
Each stage typically represents a specific task or action in the CI/CD process
Inside the stage block, you can define one or more steps to be executed as part of that stage
They allow for parallel execution of independent tasks, improving pipeline efficiency.

    ```groovy
    pipeline {
        agent any
        stages {
            stage('Build') { /* Steps for the build stage */  }
            stage('Test') { /* Steps for the test stage */ }
            // Additional stages 
        }
    }
    ```
- `Steps` : Steps are the individual tasks or actions performed within each stage. They can include shell commands, script executions, or Jenkins-specific steps for interacting with the Jenkins environment.
Basically , defines a series of steps to be executed in a given stage directive.

    ```groovy
    pipeline {
        stages {
            stage('Build') {
                steps {
                    // Shell command example
                    sh 'mvn clean package'
                    // echo command
                    echo 'Hello World'
                }
            }
            // Additional stages and steps go here
        }
    }
    ```

- `Post Actions` : allows you to define post actions, such as notifications or cleanup tasks, to be executed after the pipeline has completed, regardless of the pipeline result.
    ```groovy
    pipeline {
        agent any

        stages {
            stage ('Print') {
                steps {
                    echo "Hello Devops Engineers"
                }
            }
        }
        // Stages ends here
        post {
            always {
                // Cleanup tasks
            }
            success {
                // Notification for successful build
            }
            failure {
                // Notification for failed build
            }
        }
    }
    ```
    Even if some stages failed, post block will be executed always. In post block we have three important blocks always, success, failure

    - always - If we trigger a job, whether the stage is success or failure, this block will be always executed.
    - success - This block will be executed only if all the stages are passed.
    - failure - This block will be executed if any one of the stage is failed.
    - unstable - Only run if the current Pipeline has an "unstable" status, usually caused by test failures, code violations etc
    - changed - Only run if the current Pipeline run has a different status from the previously completed Pipeline.

- `Envirnomnet Block `:  used to specify a sequence of key-value pairs which will be defined as environment variables for all steps, or stage-specific steps, depending on where the environment block is located within the Pipeline or within the stage . These variables can be used to store configuration values or pass data between stages.

    ```groovy
    pipeline {
        environment {
            // Define environment variables
            JAVA_HOME = '/usr/java/jdk'
            MAVEN_HOME = '/usr/local/maven'
        }
        // Stages and steps go here
    }
    ```

    - An environment directive used in the top-level pipeline block will apply to all steps within the Pipeline.
    - An environment directive defined within a stage will only apply the given environment variables to steps within the stage.
    - Use the syntax `${VARIABLE_NAME}` to reference the value of an environment variable.
    - You can override environment variables at different stages of the pipeline by redefining them within specific stages or steps.

    ```groovy
    // at stage level
       stages {
        stage ('Print') {
            environment { 
                MESSAGE = 'Hello Devops Engineers'
            }
            steps {
                echo "$MESSAGE"
            }
        }
    ```

- `Parameter Block` : s used to define input parameters that can be passed to a pipeline job when it is triggered. This allows users to customize the behavior of the pipeline and provide input values dynamically. Here's an overview of the parameters block.
These parameters can be configured when triggering the pipeline manually or through automated triggers like webhooks or scheduled builds.
```groovy
pipeline {
    agent any
    parameters {
        // Define input parameters
    }
    stages {
        // Define pipeline stages
    }
}
```
- Types : Jenkins supports various types of input parameters, including:
    - String Parameter: A simple text input. eg `parameters { string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: '') }`
    - Boolean Parameter: A checkbox for true/false values.
    - Choice Parameter: A dropdown menu with predefined options.
    - File Parameter: Allows users to upload a file as input.
    - Password Parameter: Securely accepts sensitive information like passwords.
    ```groovy
    pipeline {
        agent any
        parameters {
            string(name: 'VERSION', defaultValue: '1.0', description: 'Enter the version number')
            booleanParam(name: 'DEBUG', defaultValue: false, description: 'Enable debug mode')
            choice(name: 'ENVIRONMENT', choices: ['dev', 'test', 'prod'], description: 'Select target environment')
        }
        stages {
            // Define pipeline stages
        }
    }
    ```
    - Once defined, the input parameters can be accessed within the pipeline script like environment variables.
    - They allow users to customize pipeline behavior, such as specifying version numbers, enabling debug mode, or selecting target environments.
- Triggering Pipelines with Parameters:
    - When triggering the pipeline manually, users will be prompted to provide values for the defined parameters.
    - Automated triggers like webhooks or scheduled builds can also provide parameter values dynamically.

- `Tools Directive` : is used to define and configure tools that are required for the execution of the pipeline. This directive allows you to specify tools such as JDKs, Maven, Node.js, or any other tool configured in the Jenkins Global Tool Configuration. The defined tools are auto installed and added on the `PATH`. This is ignored if agent `none` is specified.
    ```groovy
    // Declarative //
    pipeline {
        agent any
        tools {
            maven 'apache-maven-3.0.1'  // // Reference Maven configured in Jenkins Global Tool Configuration
            jdk 'jdk8' // // Reference JDK configured in Jenkins Global Tool Configuration
            nodejs 'nodejs-14'
            git 'git'
            docker 'docker'
            kubernetesCli 'kubectl'
            python 'python3'
        }
        stages {
            stage('Tools useage') {
                steps {
                    // Use the tools  added above 
                    sh 'java -version' // Use JDK tool configured above
                    sh 'mvn --version' // Use Maven tool configured above
                    sh 'node --version' // Use Node.js tool
                    sh 'git --version' // Use Git tool
                    sh 'docker --version' // Use Docker tool
                    sh 'kubectl version --client' // Use Kubectl tool
                    sh 'ant -version' // Use Ant tool
                    sh 'python --version' // Use Python tool
                }
            }
         }
    }
    ```
    - Inside the tools block, you specify the tools required for the pipeline execution.
    - You can reference tools defined in the Jenkins Global Tool Configuration by their tool names and versions.
    - Jenkins will automatically ensure that the specified tools are available in the pipeline environment before executing the pipeline steps.
    - Before using the tools directive, ensure that the necessary tools are configured in the Jenkins `Global Tool Configuration`.
    - Go to "Manage Jenkins" > "Global Tool Configuration" to configure JDKs, Maven, Node.js, and other tools.
    - To use the tools,  you can simply reference the tool by its actual name

- `When` : allows you to conditionally execute a stage or step based on certain conditions. It provides flexibility in controlling the flow of your pipeline based on environment variables, build parameters, previous stage outcomes, or other conditions.

    - The when directive enables you to specify conditions under which a stage or step should be executed.
    - It allows you to define logic to control the flow of your pipeline based on specific criteria.

    ```groovy
    stage('Example') {
        when {
            // Condition(s) for executing the stage
        }
        steps {
            // Steps to execute if the condition is met
        }
    }
    ```
- Jenkins Pipeline supports various conditions for the when directive, including:
    - branch: Execute the stage when the branch being built matches the branch pattern given, for example: `when { branch 'production' }`
    - environment: Execute the stage with respect to env vars, ex: 
        ```groovy
        stage('Deploy') {
                when {
                    environment name: 'DEPLOY_ENV', value: 'production'
                }
                steps {
                    sh 'kubectl apply -f production.yaml'
                }
            }
        ```
    - expression: Execute the stage if the specified Groovy expression evaluates to true.
    - beforeAgent: Execute the stage before allocating an agent.
    - beforeInput: Execute the stage before waiting for user input.
    - buildingTag: Execute the stage only if the build is triggered by a tag.
    - changeRequest: Execute the stage only if the build is a change request (e.g., pull request).
    - changeset: Execute the stage if changes matching specified criteria are detected.
    - environment: Execute the stage based on the value of an environment variable.
    - not: Negate the condition.
    - allOf: Execute the stage if all specified conditions are met.
    - anyOf: Execute the stage if any of the specified conditions are met.

- `Script Section` : is used to execute arbitrary Groovy code within a specific context, typically within a stage or step of the pipeline. It allows you to write custom Groovy code to perform complex logic, interact with Jenkins APIs, or manipulate data during pipeline execution.
 
    - The script block allows you to execute Groovy code inline within your pipeline script.
    - It provides flexibility to perform custom operations that are not directly supported by Jenkins Pipeline syntax.
    - Inside the script block, you can write any valid Groovy code to perform specific tasks or operations.
    - You can use the full power of Groovy language features, including variables, loops, conditionals, method calls, and more.
    - Common use cases for the script block include interacting with Jenkins APIs, manipulating files, processing data, calling external services, or performing conditional logic.
    - For most use-cases, the script step should be unnecessary in Declarative Pipelines, but it can provide a useful "escape hatch." script blocks of non-trivial size and/or complexity should be moved into Shared Libraries instead.

        ```groovy
            stages {
                stage('Example') {
                    steps {
                        echo 'Hello World'
                        // script block
                        script {
                            def browsers = ['chrome', 'firefox']
                            for (int i = 0; i < browsers.size(); ++i) {
                                echo "Testing the ${browsers[i]} browser"
                            }
                        }
                    }
                }
                // Example 2: example of how to use the script block to perform custom Groovy operations within a pipeline stage
                stage('Example 2') {
                    steps {
                        script {
                            def message = 'Hello, Jenkins!'
                            echo message
                            // Perform additional Groovy operations
                        }
                    }
                }
            }
        ```





## Agent Directive 
Supported parameters for agent directive parameters can be applied at the top-level of the pipeline block, or within each stage directive.
    
- `any`: Runs the pipeline on any available agent in the Jenkins environment. syntax : `agent any`
- `none`: Disables agent allocation, allowing you to run the pipeline without an agent. This is useful for defining purely scripted pipelines that don't require an execution environment. `agent none`
- `label` : Specifies the label of the Jenkins agent(s) to run the pipeline on. You can use labels to categorize agents based on their capabilities or characteristics.
```groovy
agent {
    label 'linux'
}
```
- `node` :  behaves the same as `label `, but node allows for additional options (such as customWorkspace). 
```groovy
agent { 
    node { 
        label 'labelName' 
    } 
}
```
- `docker`: Runs the Pipeline/stage, in a Docker which will be dynamically provisioned on a node pre-configured to accept Docker-based Pipelines, or on a node matching the optionally defined label parameter. 

    ```groovy
    agent {
        docker {
            image 'maven:3.8.1'
        }
    }
    ```
    docker also optionally accepts an args parameter which may contain arguments to pass directly to a docker run invocation. 
    ```groovy
    agent {
        docker {
            image 'maven:3-alpine'
            label 'my-defined-label'
            args  '-v /tmp:/tmp'
        }
    }
    ```

- `dockerfile` : Builds a Docker image dynamically using the provided Dockerfile and runs the pipeline inside the resulting container.
```groovy
agent {
    dockerfile {
        filename 'Dockerfile'
        dir 'path/to/dockerfile'
    }
}
```
- `kubernetes`: Runs the pipeline inside a Kubernetes pod. You can specify a Kubernetes YAML manifest or use inline configuration to define the pod template.
```groovy
agent {
    kubernetes {
        yaml """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            app: my-app
        spec:
          containers:
          - name: my-container
            image: maven:3.8.1
            command: ['cat']
            tty: true
        """
    }
}
```

## Environment Block

This directive supports a special helper method credentials() which can be used to access pre-defined Credentials by their identifier in the Jenkins environment. For Credentials which are of type "Secret Text", the credentials() method will ensure that the environment variable specified contains the Secret Text contents. For Credentials which are of type "Standard username and password", the environment variable specified will be set to username:password and two additional environment variables will be automatically be defined: MYVARNAME_USR and MYVARNAME_PSW respective.

```groovy
// Declarative //
pipeline {
    agent any
    environment { 
        CC = 'clang'
    }
    stages {
        stage('Example') {
            environment { 
                AN_ACCESS_KEY = credentials('my-prefined-secret-text') 
            }
            steps {
                sh 'printenv'
            }
        }
    }
}
```

- Using Built-in Environment Variables:

    Jenkins provides several built-in environment variables that you can use in your pipeline scripts, such as BUILD_NUMBER, GIT_COMMIT, JOB_NAME, etc.
    These variables are automatically populated by Jenkins during pipeline execution.
```groovy
steps {
    // Access built-in environment variable
    echo "Current build number: ${BUILD_NUMBER}"
}
```
- Here are some commonly used built-in environment variables:

    - BUILD_NUMBER: The current build number of the job. Incremented by Jenkins for each new build.
    - BUILD_ID: A unique identifier for the current build, typically in the format YYYY-MM-DD_hh-mm-ss.
    - BUILD_TAG: A combination of JOB_NAME and BUILD_NUMBER, typically in the format jobname-buildnumber.
    - BUILD_URL:  The URL of the current build in Jenkins.- JOB_NAME: The name of the job or pipeline being executed.
    - NODE_NAME: The name of the node or agent where the build is running.
    - WORKSPACE: The absolute path to the workspace directory for the current build.
    - GIT_COMMIT: The Git commit hash of the current build, if the pipeline is triggered by a Git SCM change.
    - GIT_BRANCH: The Git branch name of the current build, if the pipeline is triggered by a Git SCM change.
    - CHANGE_ID, CHANGE_URL, CHANGE_TITLE: Information about the SCM change that triggered the build, such as ID, URL, and title.
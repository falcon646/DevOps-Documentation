## Scripted Pipeline
Scripted Pipeline is a domain-specific language (DSL) that allows you to define your CI/CD pipeline using Groovy scripting syntax. Unlike Declarative Pipeline, which provides a more structured and opinionated syntax, Scripted Pipeline gives you more flexibility and control over the execution flow of your pipeline

### Syntax

- `Pipeline Definition` : In Scripted Pipeline, you define your pipeline using a node block to specify where the pipeline will execute. You can also use a def keyword to define variables and functions.
```groovy
node {
    // Pipeline steps go here
}
```
- `Stages and Steps` : You define stages and steps using Groovy statements within the node block. Stages are delineated by the stage keyword, and steps are executed using built-in or custom Groovy methods.
```groovy
node {
    stage('Build') {
        // Steps within the 'Build' stage
        sh 'mvn clean package'
    }
    stage('Test') {
        // Steps within the 'Test' stage
        sh 'mvn test'
    }
}
```
- `Shell Commands` : You can execute shell commands within steps using the sh method. This method allows you to run shell scripts or commands on the Jenkins agent where the pipeline is executing.
```groovy
node {
    stage('Build') {
        sh 'mvn clean package'
    }
}
```
- `Variables and Functions` : You can define variables and functions using the def keyword. These variables and functions can be used throughout your pipeline script to store values or perform calculations.
```groovy
node {
    def projectName = 'my-project'
    def getArtifactName() {
        return "${projectName}-1.0.0.jar"
    }
    stage('Build') {
        sh "mvn clean package -DartifactName=${getArtifactName()}"
    }
}
```
- `Conditional Statements and Loops` : Scripted Pipeline supports standard Groovy conditional statements (e.g., if, else, switch) and loops (e.g., for, while). These can be used to implement complex logic within your pipeline script.
```groovy
node {
    stage('Build') {
        if (env.BRANCH_NAME == 'master') {
            sh 'mvn clean package -Denv=prod'
        } else {
            sh 'mvn clean package -Denv=dev'
        }
    }
}
```
- `Error Handling` : You can handle errors and exceptions using Groovy's built-in exception handling mechanisms, such as try, catch, and finally. This allows you to gracefully handle errors that occur during pipeline execution.
```groovy
node {
    stage('Build') {
        try {
            sh 'mvn clean package'
        } catch (Exception e) {
            echo "Build failed: ${e.message}"
            currentBuild.result = 'FAILURE'
        }
    }
}
```
- `Interpolation` : You can use string interpolation to insert variables or expressions within double-quoted strings. This allows you to dynamically generate command arguments or log messages based on variable values.
```groovy
node {
    def version = '1.0.0'
    stage('Deploy') {
        sh "kubectl apply -f deployment-${version}.yaml"
    }
}
```
- `Shared Libraries` : Scripted Pipeline allows you to define and use shared libraries, which are reusable Groovy scripts stored in source control repositories. These libraries can contain common functions, utilities, or pipeline steps that you want to share across multiple pipeline scripts.
```groovy
@Library('my-shared-library') _
node {
    stage('Build') {
        myCustomFunction()
    }
}
```
- `Parallel Execution`: You can execute multiple stages or steps in parallel using the parallel keyword. This allows you to speed up pipeline execution by running independent tasks concurrently.
```groovy
node {
    stage('Tests') {
        parallel(
            'Unit Tests': {
                sh 'mvn test'
            },
            'Integration Tests': {
                sh 'mvn integration-test'
            }
        )
    }
}
```
- `Post-Build Actions`: Similar to Declarative Pipeline, Scripted Pipeline also supports post-build actions using the post directive. You can define actions such as email notifications, artifact archiving, or clean-up tasks to be executed after the pipeline has completed.
```groovy
node {
    stage('Build') {
        // Build steps
    }
    post {
        success {
            mail to: 'team@example.com', subject: 'Build Success', body: 'The build was successful.'
        }
        failure {
            mail to: 'admin@example.com', subject: 'Build Failed', body: 'The build failed.'
        }
    }
}
```
- `Groovy Libraries and Extensions`: Scripted Pipeline allows you to leverage the full power of Groovy language features, including libraries and extensions. You can import external libraries, use Groovy closures, or implement custom DSLs to extend the functionality of your pipeline scripts.
```groovy
@Grab('com.example:my-library:1.0.0')
import com.example.MyUtility

node {
    stage('Build') {
        MyUtility.doSomething()
    }
}
```
-  `Integration with Jenkins Plugins`: Scripted Pipeline integrates seamlessly with Jenkins plugins, allowing you to leverage a wide range of plugins to extend the capabilities of your pipeline. You can use plugins for source code management, build triggers, notifications, artifact management, and more within your pipeline script.
```groovy
node {
    stage('Build') {
        git url: 'https://github.com/example/my-project.git'
        sh 'mvn clean package'
    }
}
```

### Sections
- `Agent` : In a Jenkins scripted pipeline, the “agent” section is used to specify the agent on which the pipeline will run. The agent section is optional, but if specified, it determines the machine executing the stages defined in the pipeline.

    The agent section can be defined at the top level of the pipeline script, or it can be specified within individual stages.

    ```groovy
    agent {
        <label> 
        <node> 
        <customWorkspace>
    }
    ```
- `Options`:
The options section in a Jenkins scripted pipeline allows you to specify options for the entire pipeline, such as timeouts, notifications, and environment variables. The options section is optional, but if specified, it can provide additional control and customization for the pipeline execution.

    Some of the options that can be specified in the options section include:

    - timeout
    - timestamps
    - buildDiscarder(logRotator)
    - environment

    Below is an example of how the options section can be used in a scripted pipeline:

    ```groovy
    node {
    agent any
    options {
        timeout(2h)
        timestamps
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    stage('Build'){
        // build code
    } 
    }
    ```

- `Stage` : A stage in Jenkins scripted pipeline represents a phase in the software development lifecycle. Stages help to break down the pipeline into smaller, manageable steps that can be executed in parallel or sequentially.

    Below is an example of a stage in a Jenkins scripted pipeline:
    ```groovy
    node {
    agent any
    stage('Build'){
        // build code
    }
    stage('test'){
        // test code
    }  
    }
    ```
- `Post` : The “post” section is used to specify steps that should be executed after all stages have been completed. The “post” section is optional.

    Below is an example of how the “post” section can be used in a scripted pipeline.

    ```groovy
    node {
    agent any
    stage('Build'){
        // build code
    }
    post{
        success {
            echo 'Project build successfully!'
        }
        failure {
            echo 'Project build failed!'
        }
    }  
    }
    ```
- `Parameter` : In a scripted pipeline, we can pass parameters by using properties. Below is the working example of a simpleScripted Pipeline with parameters

    ```groovy
    node(){
        properties([
            parameters([
                string(defaultValue: 'world', name: 'Name')
                ]
        sh "hello ${Name}"
    }
    ```
    Jenkins pipeline supports many parameters like string, boolean, file, etc. 

- `Environment Variable` : environments variable can be set using the withEnv keyword in a scripted Pipeline.
    ```groovy
    node{
        withEnv(['FName=Naive','LName=skill']) {
            stage('Build') {
                sh 'echo $FName $LName'
            }
        }
    ```

https://naiveskill.com/jenkins-scripted-pipeline/

https://www.scaler.com/topics/scripted-pipeline-in-jenkins/
## Jenkins Pipelines

In jenkins we can create jobs in 2 ways
- FreeStyle (gui)
- Pipeline (code) : Pipeline is a set of steps that automate build and deployment

- there are 2 types of pipeline code
    - scripted (programming language)
    - declarative (straight forward)

Pipeline code is started in a file called as Jenkinsfile , it is a part of the application reository

### Jenkins Declarative pipeline with stages syntax
```jenkinsfile
pipeline{
    agent any
    stages{
        stage("clone Repo"){
            steps{
                // clone repo
            }
        }
        stage("Maven build"){
            steps{
                // build with maven
            }
        }
        stage("Sonar Analysis"){
            steps{
                // run sonar analysis
            }
        }
        stage("Upload artifact"){
            steps{
                // upload the artifact generated
            }
        }
        stage("deploy to server"){
            steps{
                // deploy artifact
            }
        }
        stage("notify"){
            stage{
                // notify users
            }
        }
    }
}
```
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


## Continous Integration and Continous Delivery
- CI : continousintegration (build)
    - clone
    - maven build
    - create docker img
    - push image to hub
    - trigger CD job

- CD : continous deleviery (deploy)
    - git clone (for the manifest files etc)
    - deploy to kubernetes/server


Note : once the build job is completed it should automatically trigger the deploy job , then it is conisderd as Continous Integration and Continous Delivery


- ### Step 1 . Create CI job
    - add script for the folowing tasks (same as of session 38)
        - clone
        - maven build
        - create docker img
        - push image to hub
        - trigger CD job
    - steps :
        - open pipeline syntax generator - select "build a job" from drop down
        - fill the name of the job you want to trigger in the "project to build" feild
        - generate the script and copt it -> scrit will be line -> build `<name of job>``
        - add this script in a new stage after the push to hub stage
        ```groovy
        stage ("Trigger Deploy job"){
            steps {
                build '<name of job>'
            }
        }
        ```
- ### Step 2 : Create CD job

    - git clone (for the manifest files etc)
        ```groovy
        stage ("Deploy to kubernetes") {
            steps {
                sh "kubectl delete deploy <deploy_name>"
                sh "kubectl apply -f new-deploy.yml"
            }
        }
        ```
            
## Delpoy application to Kubernetes Cluster
Diferenet ways
- Using sshagent plugin
-
-


### Using sshagent plugin
In this menthod , we wil use ssh and scp to copy the yaml file to the kubernetes cluster
- install the "sshagent" plugin
- add the privte key in gloal credentails in jenkins
- generate the code using pipeline syntax  (to copy the yaml files to the server (which has kuberctl installed)  using the ssh agent
```groovy
 sshagent(['<cred-id>']) {
            sh "scp -o StrictHostKeyChecking=no nodejsapp.yaml <user-name>@<ip>:<directory>"
 }
``` 
- once the required files are moves to the cluster then , apply/create the resource
- The try-catch block ensures that if the resource does not exist then we need to create.
- it is added inside the script block at try-catch is groovy script
```groovy
steps{
  sshagent(['<cred-id>']) {
            sh "scp -o StrictHostKeyChecking=no nodejsapp.yaml <user-name>@<ip>:<directory>"
            script{
                try{
                    sh "<user-name>@<ip> kubectl apply -f ."
                }
                catch(error){
                    sh "<user-name>@<ip> kubectl create -f ."
                }
            }
  }
}

``` 

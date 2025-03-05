# Integrating Terraform with Jenkins

Integrating **Terraform** into a **Jenkins CI/CD pipeline** allows infrastructure as code (IaC) deployments to be automated. 

This integration can be done in 2 ways
- Insatll the terraform binary on the jenkins host/agent systemwide
- Insatll the terraform binary on the jenkins on the fly


### **1. Install Terraform on Jenkins Agent systemwide**
- Terraform needs to be installed on the Jenkins agent that will execute Terraform commands.
    - **For Installation on  Ubuntu/Debian-based Jenkins Agent:** Check local Documention
    - If using master slave archicture, terraform should be installed on the agent nodes
- **Provide Jenkins User Access to Terraform**
    Ensure the Jenkins user has permission to run Terraform:
    ```bash
    sudo chown -R jenkins:jenkins /usr/local/bin/terraform
    sudo chmod +x /usr/local/bin/terraform
    ```
- **Install Terraform Plugin in Jenkins**
    1. Open **Jenkins Dashboard**.
    2. Navigate to **Manage Jenkins → Manage Plugins**.
    3. Search for **"Terraform Plugin"** and install it.
    4. Restart Jenkins after installation.
- **Configure Terraform in Jenkins Global Tool Configuration**
    1. Go to **Manage Jenkins → Global Tool Configuration**.
    2. Scroll to **Terraform** and click **Add Terraform**.
    3. Provide a **name** (e.g., `Terraform-1.6.0`).
    4. Set the installation directory (eg `/usr/local/bin/`)
    5. Save the configuration.
- **Create a Jenkins Pipeline for Terraform**
    - You can define a **Jenkinsfile** to automate Terraform deployment:
    ```groovy
    pipeline {
        agent {
            label 'name' // if using master slave archicture
        }
        stages {
            stage('Checkout Code') {
                steps {
                    git 'https://github.com/your-repo/terraform-config.git'
                }
            }

            stage('Initialize Terraform') {
                steps {
                    sh '''
                    terraform init
                    '''
                }
            }

        }
    }
    ```

- **(Optional) Use Terraform with Azure, AWS, or GCP**
    - **Azure:** Install `az cli` and use `az login`. Make sure the jenkins user has access to az cli
    - **AWS:** Install AWS CLI and use `aws configure`.
    - **GCP:** Install Google Cloud SDK and authenticate.

### **2. Install Terraform on Jenkins Agent Dynamically**
Instead of installing terraform directly on the henkins agenty , you can dynamically install the binaryies directly usinthe terrrafrom plug when running the job
- **Install Terraform Plugin in Jenkins**
    1. Open **Jenkins Dashboard**.
    2. Navigate to **Manage Jenkins → Manage Plugins**.
    3. Search for **"Terraform Plugin"** and install it.
    4. Restart Jenkins after installation.
- **Configure Terraform in Jenkins Global Tool Configuration**
    1. Go to **Manage Jenkins → Global Tool Configuration**.
    2. Scroll to **Terraform** and click **Add Terraform**.
    3. Provide a **name** (e.g., `Terraform-1.10.0`).
    4. Check 'Install automatically'
    5. Select the version (`Terraform 1.10.5 linux (amd64)`) under `install from bintray.com`
    6. Save the configuration.
        - This will install the terraform binary when the pipeline executes for the firt time and is reused after that for all pipleines
        - This will only be installed in the jenkins workspaces directory
- **Create a Jenkins Pipeline  Terraform**
    - Defne the terrafrom tool before the stages
    ```groovy
    pipeline {
        agent {
            label 'name' // if using master slave archicture
        }
        tools {
            terraform 'terrafrom1.0.6'
        } 
        stages {
            stage('Checkout Code') {
                steps {
                    git 'https://github.com/your-repo/terraform-config.git'
                }
            }

            stage('Initialize Terraform') {
                steps {
                    sh '''
                    terraform init
                    '''
                }
            }

        }
    }
    ```


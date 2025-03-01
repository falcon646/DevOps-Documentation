### Jenkins Organization Folder and Multi-Branch Pipeline

This session explains the **Organization Folder** and **Multi-Branch Pipeline** project types in Jenkins. These options are useful when multiple repositories, branches, and pull requests need automated Jenkins pipeline creation and management.

#### **Purpose of Organization Folder and Multi-Branch Pipeline**
- Allows Jenkins to automatically create, update, and delete jobs based on repositories and branches detected in a **Source Code Management (SCM)** system like GitHub, Bitbucket, or GitLab.
- Automates the discovery of new repositories, branches, and pull requests, eliminating manual job creation.
- Supports **GitHub Organizations, Bitbucket Teams, and GitLab Groups** for automatic pipeline management.
- Detects new repositories or branches and sets up pipeline jobs automatically when a `Jenkinsfile` is found.

### **Configuring an Organization Folder in Jenkins**
1. **Create an Organization Folder**
   - Navigate to Jenkins **Dashboard** → **New Item**.
   - Enter a name (e.g., `GT Organization`).
   - Select **Organization Folder** as the project type and click **OK**.

2. **Set Up Repository Source**
   - Click **Add** under **Repository Sources**.
   - Choose **GitHub**, **Bitbucket**, or **GitLab** as the SCM provider.
   - Configure repository discovery options, including:
     - **Branch Discovery**: Detects new branches.
     - **Pull Request Discovery**: Detects new PRs.
     - **Fork Discovery**: Identifies forks from external repositories.

3. **Project Recognition and Pipeline Configuration**
   - Jenkins automatically looks for a `Jenkinsfile` in the repository root.
   - If found, it creates a pipeline job for the repository.
   - The pipeline can also be located in a custom path if configured.

4. **Set Scan Intervals**
   - Configure **scan frequency** to detect new repositories and branches.
   - Default is **one day** but can be adjusted based on requirements.

5. **Save and Scan Organization**
   - Once saved, Jenkins performs an **organization scan**, listing repositories and branches.
   - If a repository contains a `Jenkinsfile`, a pipeline is created.

### **Scanning and Job Creation Process**
After saving the organization folder:
- Jenkins performs an **initial scan** of the repositories.
- It detects repositories containing a `Jenkinsfile` and creates jobs accordingly.
- Logs display:
  - Discovered repositories.
  - Branches containing a `Jenkinsfile`.
  - Created jobs for valid repositories.
  - Ignored repositories with no `Jenkinsfile`.

For example:
- **Repository: `Parameterized Pipeline Job`** (contains a `Jenkinsfile`).
  - Jenkins creates a job for this repository.
  - It detects **two branches** (`main` and `test`), creating separate pipeline jobs.
- **Repository: `Solar System`** (no `Jenkinsfile`).
  - No job is created.

### **Webhook Integration for Automatic Pipeline Triggering**
Jenkins automatically sets up **webhooks** in the repository to trigger pipelines when changes occur.

- Webhook URL:  
  ```
  http://<Jenkins-Server-IP>:<Jenkins-Port>/github-webhook/
  ```
- The webhook listens for:
  - **Repository events** (creation, deletion, updates).
  - **Branch events** (new branches, tags, merges).
  - **Pull request events** (opened, merged, closed).
  - **Push events** (commits to existing branches).

#### **Testing the Webhook**
1. Make a small change in the repository (e.g., edit `README.md`).
2. Commit and push the change.
3. The webhook triggers Jenkins, initiating a new pipeline build.
4. Jenkins logs show:
   - Webhook received the event.
   - Pipeline triggered automatically.

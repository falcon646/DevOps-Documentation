### Integrate a existing remote repo and local repo
```bash
# 1. create working dir
mkdir <name>
# 2. initialise git
git init

## 3. configure developer info
git config user.name <name>
git config user.email <email>

# 4. configure remote repo
git remote add  <remote_repo_name> <remote_repo_url>
git remote add  origin https://falcon646@bitbucket.org/falcon646/test.git

# 5. verifyy the remote repo config 
git remote -v

# 6. pull changes/code from remote to local
git pull <remote_repo_name> <branch_name_to_tp_pulled>
git pull origin master
```
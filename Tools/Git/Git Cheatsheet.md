### **Connect a Remote to an Existing Local Repository**
```bash
# Initialize Git (If Not Already Done)**
git init

# Add a Remote Repository**  
git remote add origin <remote-repo-URL>
### `origin` is the **default name** for the remote repository.  

# Check if your local repository is connected to the remote  
git remote -v
# or
git remote show origin

## Push an Existing Local Repository to the Remote
git add .
git commit -m "Initial commit"
git push -u origin main  # Use 'master' if your branch is named master
### The `-u` flag sets **upstream tracking** so that future `git push` and `git pull` commands work without specifying the branch name.

### Pull Latest Changes from Remote (If Needed)**
# If the remote repository already has files, pull them to **sync** your local repo, This prevents conflicts if both local and remote have different histories.  
git pull origin main --allow-unrelated-histories
```

```bash
# to update the remote repo url
git remote set-url origin <repo-url.git>
```


#### Configure username and email locally and globally
```bash
# To configure your Git username and email globally, 
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"


# If you want to configure them only for a specific repository, navigate to the repository folder and run:
git config user.name "Your Name"
git config user.email "your.email@example.com"

# To verify the configuration, use:  
git config --global --list   # For global settings
git config --list            # For repository-specific settings
```

#### Pull from a newly connected local and remote repo
```bash
# when you need to pull from a remote repo where local repository was initialized (git init) separately and then you added a remote repository
git pull <remote-repo-name> <remote-branch> --allow-unrelated-histories
```

#### Deleting a branch locally and remote
```bash
# Delete the Local Branch (Safely)**
# Before deleting a branch locally, ensure that:  
# - **All work is merged into the main branch** (or another relevant branch).
# - **No other developers are actively using the branch**.
git branch -d branch-name
# use -D to forecefulllt delete
git branch -D branch-name

## after that Delete the Remote Branch**
git push origin --delete branch-name
```

#### **Upstream Tracking in Git**  
also called **tracking branches**, is a Git feature that links a local branch to a remote branch. This allows Git to automatically determine where to pull and push changes without requiring manual specification of the remote branch each time.

**What Happens If There's No Upstream?**
- If you try to pull or push without setting upstream, you'll get this error:
```bash
fatal: The current branch my-branch has no upstream branch.
To push the current branch and set the remote as upstream, use:

git push --set-upstream origin my-branch
```
This means Git doesn't know where to push/pull, so you must specify the remote manually.

**Setting Upstream**
```bash
# Set Upstream While Pushing for the First Time
git push --set-upstream origin my-branch
```
This command does two things:
1. Pushes `my-branch` to `origin`
2. Links `my-branch` to `origin/my-branch`, so future `git push` and `git pull` commands work without specifying the branch name.

```bash
# Set Upstream for an Existing Local Branch
# If you already have a local branch and want to link it to a remote branch:
git branch --set-upstream-to=origin/my-branch

# Create a New Local Branch That Tracks a Remote Branch**
git checkout -b my-branch origin/my-branch
# newer syntax in Git (This creates a new local branch `my-branch` and sets it to track `origin/my-branch)
git switch --track origin/my-branch

## To check if your local branch is tracking a remote branch:
git branch -vv
# Example output:
# * feature-login  b123abc [origin/feature-login] Added login feature
#   main           d456def [origin/main] Latest updates
# Here, `feature-login` is tracking `origin/feature-login`, and `main` is tracking `origin/main`.

# If you want to **unlink** a local branch from tracking a remote branch. This removes the tracking information but keeps the local branch.
git branch --unset-upstream
```

### Working with Remote Repositories
| Action | Command |
|---------|----------------------------|
| **Add a remote repo** (origin is the default name for the remote repository)  | `git remote add origin <remote-URL>` |
| **View remote repos** | `git remote -v` |
| **Fetch changes from remote** (updates your local copy of the remote branches but does not merge) | `git fetch origin` |
| **Pull latest changes** (equivalent to running git fetch followed by git merge) | `git pull origin main` |
| **Push local changes** | `git push origin main` |
| **Push local changes for the first time** | `git push --set-upstream origin main` |
| **Rename a remote** | `git remote rename origin upstream` |
| **Remove/disconnet a remote** | `git remote remove origin` |
| **Change remote URL** | `git remote set-url origin <new-URL>` |
| **Show remote details** | `git remote show origin` |
| **Prune stale branches** | `git remote prune origin` |
| **Delete a remote branch** | `git push origin --delete branch-name` |
| **Track a remote branch** | `git checkout -b local-branch origin/remote-branch` |


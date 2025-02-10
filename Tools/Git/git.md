```bash
# to update the remote repo url
git remote set-url origin <repo-url.git>


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
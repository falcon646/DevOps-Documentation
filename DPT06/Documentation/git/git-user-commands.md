```bash
# To check the configured user name and email:
git config user.name
git config user.email


# To check both the name and email together:
git config --get-regexp user


# set developer username and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# to check the configured values for a specific repository,  use the --local flag:
git config --local user.name
git config --local user.email


# to merge the unrelated histories, use --allow-unrelated-histories option
git pull origin master --allow-unrelated-histories


# to set the upstream branch without pushing changes use the --set-upstream 
git push --set-upstream origin <branch-name>
git push --set-upstream origin master
# This is useful when you want to establish a connection between your local branch and a remote branch without actually pushing any changes immediately.
```

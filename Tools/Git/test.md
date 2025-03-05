How To Manage Multiple GitHub Accounts In VSCode Using SSH Keys. | One-Time Process
At present VSCode supports only one account logged in at a time. When you have multiple GitHub accounts, you have to log out of one account to work with another. However, it is a tedious process. It…

At present VSCode supports only one account logged in at a time. When you have multiple GitHub accounts, you have to log out of one account to work with another. However, it is a tedious process. This can be solved with a one-time solution using an SSH key. It is possible that you have tried many other solutions that tell you to use different custom domain names for different accounts while cloning the repository. But this has 2 problems:

Every time you clone you need to remember custom domain names.
And you manually need to update git-config files. However, In this article, we automatically do all these processes for you.


1. Open git bash and goto .ssh
cd ~/.ssh

2. Check if you already have an SSH key.
ls -al ~/.ssh
#it ends with .pub extention.

If you have an SSH key then use that or else generate a new one.

3. Generate a new SSH key.
#execute one by one
ssh-keygen -t ed25519 -C "personal_email_address" -f "personal_github_username"
ssh-keygen -t ed25519 -C "company_email_address" -f "company_github_username"

-C: It is a comment used to identify the SSH key.
-f: It is a filename where the SSH key gets saved. It asks for a passphrase just leave it empty and press enter.
4. Start SSH-agent
eval `ssh-agent -s`

Then you get an output similar toAgent pid 1576

5. Add SSH keys to SSH-agent
#execute one by one
ssh-add -K ~/.ssh/personal_github_username  #personal SSH key
ssh-add -K ~/.ssh/company_github_username   #Company SSH key

6. Adding the public SSH key to GitHub.
Open the .pub file on VScode or Vim and then copy the keys.
#execute one by one
code ~/.ssh/personal_github_username.pub
code ~/.ssh/company_github_username.pub

Then goto Github → Settings → Keys or https://github.com/settings/keys and click on the New SSH key.adding new ssh key on github
7. Create config file.
#execute one by one
touch config
code config           # to open this in VS code.

Add the below content inside the config file.

#inside ~/.ssh
Host *
  IgnoreUnknown AddKeysToAgent,UseKeychain
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/<personal_github_username> # Default key (You can also use company key)

This accepts all the custom domains and checks the .gitignore file for any path match.

8. Goto the root directory and create below three files.
cd ~
touch .gitignore
touch .gitignore.company
touch .gitignore.personal

If you have any other account create a .gitignore file for that also. Open three files in VS code and add the below code.

#inside ~/.gitignore.company
[user]
email = Your_company_email_address
name = Your name

[github]
user = "company_github_username" #should be inisde double quote.

[core]
sshCommand = "ssh -i ~/.ssh/company_github_username" #should be inisde double quote.

#inside ~/.gitignore.personal
[user]
email = Your_personal_email_address
name = Your name

[github]
user = "personal_Github_username" #should be inisde double quote.

[core]
sshCommand = "ssh -i ~/.ssh/personal_github_username" #should be inisde double quote.

#inside ~/.gitignore
[includeIf "gitdir:C:/Users/<user_name>/Personal/"] # include for all .git projects under Personal/
path = ~/.gitconfig.personal

[includeIf "gitdir:C:/Users/<user_name>/Comapny/"] # include for all .git projects under Company/
path = ~/.gitconfig.company

[core]
excludesfile = ~/.gitignore      # Ignore .gitignore files valid everywhere

By doing this now you don't worry about the custom domain and all.
Now when you clone a project inside the personal folder or Company folder the IncludeIf inside.gitignorematches the location and executes respective sshCommand.
Done now you can try to clone
An example is given below (Best ways to test by creating private repositories).

git clone git@github.com:mohanas/test.git #my personal
git clone git@github.com:mohanas-company/test.git #my company

#these repositories are not exist, you can try your own repository.
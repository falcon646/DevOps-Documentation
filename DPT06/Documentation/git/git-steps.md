```bash
## 1. initiallise git
git init

## 2. configure developer info
git config user.name <name>
git config user.email <email>

## 3. compare working copy with local copy
git status
    
## 4. add files to staging area to be commited to local copy
# add specific file
git add <file_name>
# add all files
git add .

# 5. commit the files in staging area to local copy
git commit -m "commit message"

## 6. get history of git commits (from local copy)
git log
```
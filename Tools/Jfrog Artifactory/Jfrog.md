- Self Hosted Setup Jfrog Atifactory OOS (free version) (ubuntu 22)
```bash
# install jdk
sudo apt install default-jdk -y

# add jfrog to ubuntu repo
sudo echo "deb https://releases.jfrog.io/artifactory/artifactory-debs xenial main" | tee -a /etc/apt/sources.list.d/artifactory.list
sudo curl -fsSL  https://releases.jfrog.io/artifactory/api/gpg/key/public|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/artifactory.gpg

# update repo cache
sudo apt update -y
# install jfrog artifactory 
sudo apt install jfrog-artifactory-oss

# start and enable the JFrog Artifactory service:
sudo systemctl start artifactory.service 
sudo systemctl enable artifactory.service
systemctl status artifactory.service 

# jfrog runs at port 8082
ss -antpl | grep 8082
# Access JFrog Artifactory Web UI at port 8082
http://<public-ip>:8082

# default credeintails
username=admin
password=password
```
- Install MariaDB as the default DB (Optional)
```bash
# run below command before starting the jfrog artifactory service

# add the MariaDB repository 
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s --

# update the repository and install the MariaDB package
sudo apt update
sudo apt install mariadb-server mariadb-client -y

#  start and enable the MariaDB service.
sudo systemctl start mariadb
sudo systemctl enable mariadb

# run below commands after starting the jfrog service

# log in to the MariaDB shell with
mysql
# import the Artifactory data to the MariaDB database.
source /opt/jfrog/artifactory/app/misc/db/createdb_mariadb.sql;
# exit from the MariaDB shell.
exit;

# Access JFrog Artifactory Web UI at port 8082
http://<ip>:8082
```
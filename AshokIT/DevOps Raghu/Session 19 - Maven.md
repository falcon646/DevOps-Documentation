## Maven
- free and open java build tool , used to perform build Automation for java projects
- maven can resolve project dependencies automatically, which are specified  in pom.xml
- used to package the applications to jar , war , ear etc

#### installation : (Using RHEL/CentOS)

```bash
# Step1 Check Java and Maven are installed
    $ java -version
    $ mvn --version
# Step 2 Install wget if not exist
    $ sudo yum install wget -y
# Step 3 Install Java 11 Software (JRE)
    $ sudo yum install wget java-11-openjdk -y
    $ java -version
# Step 4 Download Maven Software
    $ cd /tmp
    $ sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.1/binaries/apache-maven-3.9.1-bin.tar.gz
# Step 5 Extract to a folder
    $ sudo tar xvzf apache-maven-3.9.1-bin.tar.gz -C /opt/
    $ cd /opt
    # rename to a short folder name
    $ sudo mv apache-maven-3.9.1 maven
# Step 6 Set Maven Home Directory
    # Optional if execute permissions are given
    $ sudo chmod +x /etc/profile.d/maven.sh 
    $ sudo vi /etc/profile.d/maven.sh
    # paste the below lines into the and save it 
    export M2_HOME=/opt/maven
    export PATH=${M2_HOME}/bin:${PATH}

# Step 7 Reload Profiles for updating path
    $ source /etc/profile.d/maven.sh
# Step 8  Check Maven Installation
    $ mvn -version
# Step 9 Remove TAR ZIP File
    $ sudo rm -f /tmp/apache-maven-3.9.1-bin.tar.gz
```
#### to install java
```bash
$ sudo apt install openjdk-11-jdk openjdk-11-jre -y # ubuntu
$ sudo yum install java-11-amazon-corretto-devel -y # amazon linux
$ sudo yum install java-11-openjdk -y # Redhat Linux
```

### Maven Terms:

- **Archteype** :  represents what type of project we want to create . common archtypes are listed below
    - maven-archetype-quickstart : It represents java standalone application
    - maven-archetype-webapp : It represents java web application
- **groupId** :  represents company name or project provider name
- **artifactId** :  represents project name or project module name
- **packaging** :  represents how we want to package our java application (jar or war)
- **version** :  represents project version

#### Maven Repositiory :
Maven will download dependencies from repository . We have 3 types of repositories
1. Central Repository: central repository ( ie maven website repo)
2. Remote/Private Repository: organistaional private repos eg . acr , nexux , jfrog 
3. Local Repository: repo in our local system 
    - C:/users/< username >/.m2
    - /home/< username >/.m2

- When we add dependency in pom.xml, maven will search for that dependency in local repository. If it is available it will add to project build path. <br>
- If dependency not available in local repository then maven will connect to Central Repository or Remote Repository based on our configuration. <br>

- By default maven will connect with central repository. If you want to use remote repository, then you need to configure that

#### Maven Goals:
the following goals are provided to build projects :
- clean :   used to delete the existing files inside target dir
- compile : used to compile project source code , which is stored in target 
- test :    used to execute unit test (JUnit code)
- package : used to generate jar or war (speficied in pom.xml) in target.
- install : used to install our project as a dependency in maven local repository.

whenerver you run a particulat goal , all the previos goals will also run ie <br>
mv package = compile + test  + package
Syntax : mvn  goal-name
- mvn clean : delete all files in target directory
- mvn package : download dependencies , complie , test , build
- mvn clean package
- mvn clean compile


Note: Every maven goal is associated with maven plugin. When we execute maven goal then respective maven plugin will execute to perform the operation.

Note: We need to execute maven goals from project folder (where pom.xml exist)



Github URL for sample maven-app : https://github.com/javabyraghu/maven-web-app



# Deploy a Maven app to Tomcat

- Objective : To build a java spring application as a war file with help of maven and then deploy it to a apache tomcat server
- Prerequisite : jenkins ec2 machine and tomcat ec2 machine

### Steps

- create a new freestyle job
- configure the git url in sourcecodemanagemnet block and provide the branch 
- scroll down to build steps -> select "Invoke top-level Maven targets" - select version that you configured (how to at bottom) - > add "clean package" in goals -> save n apply
- (Install the plugin "Deploy to container" and then proceed)
- scroll down to post build actions -> select "Deploy war/ear to a container" - > in the WAR/EAR files feild give the complete path and name of the war file that will be generated if you are aware 
else give "**/*.war" - > give any contect path eg "Context path" -> click on add container and select version -> provide the manager user credentials (admin,admin) and the provide the complete url of tomcat 
ie http://<ec2-ip>:8080 -> save and apply
- build now


### Setup maven in jenkins

- note : you do not need to install maven in the jenkins ec2 machine , you can direct specify the config in jenkins and it will handle all maven related activities

- Go to manage jenkins -> tools -> scroll to the botton to maven installation -> add name "maven-x-x-x"
-> check install automatically -> select the maven version from the drop down -> save n apply
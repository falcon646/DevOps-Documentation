# Apache tomcat installation #

1) install jdk </br>
    $ sudo apt-get update <br/>
    $ sudo apt-get install default-jdk <br/>

2) download tomcat tar </br>
    $ wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.83/bin/apache-tomcat-9.0.83.tar.gz </br>

3) extract tar </br>
    $ tar -xvzf <file-name> </br>

4) To deploy applications into Tomcat server we will use Host Manager </br>
By default, the Host Manager is only accessible from a browser running on the same
machine as Tomcat. If you wish to modify this restriction, you'll need to edit the Host
Manager's context.xml file. </br>

File Location: <tomcat-folder>/webapps/manager/META-INF/context.xml
In Manager context.xml file, change <Valve> section "allow" key value to ".*"
    ie , replace --> allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1"
        with     --> allow=".*"

5) Adding Users in Tomcat Server  </br> 
    We need to add users in tomcat server to perform admin activities </br>
    File Location: <tomcat-folder>/conf/tomcat-users.xml </br>
    Add below Roles and Users in tomcat-users.xml file </br>

<role rolename="manager-gui" />
<role rolename="manager-script" />
<role rolename="admin-gui" />
<user username="tomcat" password="tomcat" roles="manager-gui" />
<user username="admin" password="admin" roles="manager-gui,admin-gui,manager-script"/>

6) Starting tomcat server
    cd to bin directort of the tomcat server and use "sh startup.sh" to start the tomcat service

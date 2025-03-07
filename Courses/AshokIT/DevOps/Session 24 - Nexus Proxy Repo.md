
## Nexus Proxy Repo & Sharing Artifacts

### Nexus Maven Proxy:
A Nexus Maven Proxy Repository is a feature of Sonatype Nexus that allows you to **proxy and cache** remote Maven repositories. It acts as an intermediary between your build environment and the external Maven repositories, providing faster and more reliable access to dependencies.

1. **Configuration**: In Nexus, you create a Proxy Repository and configure it to point to a remote Maven repository, such as Maven Central or other public or private repositories. You specify the remote repository's URL and other relevant details.

2. **Proxying Remote Repositories**: When your Maven build requests a dependency, Nexus checks if it already has the requested artifact in its local cache. If the artifact is available in the cache, Nexus serves it directly. If not, Nexus acts as a proxy and retrieves the artifact from the remote repository, caching it locally for future requests.

3. **Caching and Performance**: By proxying remote repositories, Nexus reduces the network overhead and improves build performance. Subsequent requests for the same artifact are served directly from the local cache, eliminating the need to download it from the remote repository every time.

4. **Dependency Management**: Nexus Maven Proxy provides centralized control and management of dependencies. You can configure access rules, security settings, and content filtering to ensure only authorized artifacts are allowed into your build environment. This helps maintain consistency, reliability, and security across your projects.

5. **Offline Mode**: Nexus Proxy Repository allows you to work in offline mode. If the remote repository is temporarily unavailable, Nexus can serve artifacts from its cache, enabling continued build and development activities even when the external repository is inaccessible.

Using a Maven Proxy Repository with Nexus reduces build times, minimizes external dependencies, and enhances build reliability and repeatability. It helps to create a more efficient and controlled build environment by caching dependencies and providing a single, centralized source for dependency management.

#### Configure and using of Nexus Maven Proxy: 
1. Create a Proxy type using maven connected to Maven Central 

    • Click on Server and Administration Icon (looks like Setting button) <br>
    • Choose Repositories option (from left pane) <br>
    • Click on Create Repository <br>
    • Choose Maven2 Proxy <br>
    • Specify details (Example given below)
```
    Name: com-idp-proxy-repo
    Version Policy: mixed
    Remote Storage (under proxy):  https://repo.maven.apache.org/maven2/
    Use Nexus Repository Trust Store: [v] choose checkbox and add [View Certificate > Add Certificate]
    Create Repository
```

2. Copy URL of remote repo created: <br>
Ex: http://<PublicIP>:8081/repository/com-idp-proxy-repo/

3. add below configuration in maven conf/settings.xml file 
 under ```<mirrors>``` tag
``` xml
  <mirror>
    <id>nexus</id>
    <url>http://<PublicIP>:8081/repository/com-idp-proxy-repo/</url>
    <mirrorOf>central</mirrorOf>
  </mirror>
```
make sure ```<server>``` tags are added, under ```<servers>``` tag
```xml
  <server>
      <id>nexus</id>
      <username>admin</username>
      <password>admin</password>
   </server>
```
4. Generate a new maven project using below command

```bash
mvn archetype:generate -DgroupId=com.ashwin -DartifactId=my-test-app -Dversion=1.0 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

#### Go to Project folder and run clean and package, then see downloading from nexus message.
```
$ cd my-test-app
$ mvn clean package
```

### Nexus Remote/Organization Repository:
We can create and use our organization remote repository to share Artifacts for multiple projects/developers. 

Follow below steps to do that.

1. Create Remote Repository in Nexus (Mixed Type for better usage).

    •	Click on Server and Administration Icon (looks like Setting button) <br>
    •	Choose Repositories option (from left pane) <br>
    •	Click on Create Repository <br>
    •	Choose Maven2 Hosted <br>
    •	Specify details (Example given below) <br>
```
Name: ashwin-remote-repo
Version Policy: mixed
Deployment Policy: Allow redeploy
Create Repository
```

- Copy Repository URL:
http://<PublicIP>:8081/repository/ashwin-remote-repo/

2. Generate a new maven project to generate jar for it
```
mvn archetype:generate -DgroupId=com.ashwin -DartifactId=otp-service -Dversion=1.0 -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- Create A build file (.jar) for above project
``` bash
cd otp-service
mvn clean package
```

3. Upload JAR file to Nexus Remote Repository [ashwin-remote-repo]

    •	Go to Browse Server contents (looks like Cube symbol) <br>
    •	Choose Browse and select remote repository <br>
    •	Click on Upload Component and fill details <br>
    •	Upload JAR From otp-service target folder <br>
    •	Enter Group: com.ashwin , Artifact: otp-service-app and version:1.0 <br>
    •	Click on Upload and Click View it now <br>

you'll see the maven dependency tag like below , copy it
``` xml
<dependency>
  <groupId>com.ashwin</groupId>
  <artifactId>otp-service-app</artifactId>
  <version>1.0</version>
</dependency>
```

4 . Access the Dependency in another Maven Project
- Add below details in your pom.xml file [create new maven project and try]
```xml
<repositories>
  <repository>
    <id>nexus</id>
    <name>Ashwin Remote Repository</name>
    <url>http://<PublicIP>:8081/repository/ashwin-remote-repo/</url>
  </repository>
</repositories>
```
- Then paste the depencency copied from the nexus repo jar , under ```<dependencies>``` tag
``` xml
<dependency>
  <groupId>com.ashwin</groupId>
  <artifactId>otp-service-app</artifactId>
  <version>1.0</version>
</dependency>
```

- Now try to do clean and package, you can find downloading otp-service-app from nexus.
``` mvn clean package ```

- Note: comment the maven-default-http-blocker <mirror> tag in settings.xml if you facing issue while clean package, usually occurs in newer version of apache maven




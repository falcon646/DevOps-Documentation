

## SONARQUBE QUALITY PROFILE AND QUALITY GATEWAY:

- Rule: In SonarQube, a rule represents a specific code quality issue or best practice that needs to be enforced. It defines a particular coding pattern or behaviour that is considered either a bug, vulnerability, or code smell. For example, a rule might check for the use of hardcoded passwords, the absence of unit tests, or the presence of unused variables. SonarQube provides a wide range of pre-defined rules, but you can also create custom rules to address specific requirements.

- Quality Profile: A quality profile in SonarQube is a collection of rules that are applied to analyse the source code of a project. It defines which rules should be active or inactive for a particular project or programming language. SonarQube supports multiple programming languages such as Java, C#, JavaScript, Python, and more. Each quality profile can be customized to include or exclude specific rules based on the project's requirements and coding standards. By associating a quality profile with a project, SonarQube ensures that the defined rules are enforced during code analysis.

- Quality Gate: A quality gate is a set of predefined conditions or thresholds that must be met for a project's code quality to be considered acceptable. It acts as a checkpoint during the software development process, helping to ensure that code quality remains within the defined limits. A quality gate is associated with one or more metrics, such as code coverage, code duplication, number of bugs, vulnerabilities, and maintainability issues. When code is analysed in SonarQube, the results are evaluated against the defined quality gate conditions. If any of the conditions are not met, the quality gate fails, indicating that the code does not meet the desired quality standards.

- We can provide our custom Quality profile and Quality Gate details in maven project using pom.xml properties 
    - for older version of SonarQube 6.1 or before
    ``` xml
    <properties>
    ….
    <sonar.profile>your-custom-profile-name</sonar.profile>
    <sonar.qualitygate>your-custom-quality-gate-name</sonar.qualitygate>
    </properties>
    ```

    - In latest version we need to specify directly in sonar server under project settings.

- If Application is non-spring boot then it is recommended to add Sonar plugin inside pom.xml as
    ```xml
    <build>
    <plugins>
        <plugin>
        <groupId>org.sonarsource.scanner.maven</groupId>
        <artifactId>sonar-maven-plugin</artifactId>
        <version>3.9.1.2184</version>
        </plugin>
    </plugins>
    </build>
    ```

### User Management in Sonarqube
To add a user in SonarQube, you need to have administrative privileges. 

    1. Log in to your SonarQube server with an account that has administrative access.
    2.	select "Administration" from the menu. 
    3.	under the "Security" section, click on "Users." You will see a list of existing users.
    4.	To add a new user, click on the "Create User" button.
    5.	Fill in the required information for the new user in the provided fields. The mandatory fields usually include:

    Login: The unique username for the user.
    Name: The full name of the user.
    Password: The password for the user. You can choose to generate a password or set one manually.
    Confirm Password: Re-enter the password for confirmation.
    Email: The email address of the user.

    6.	Optionally, you can assign the user to specific groups by selecting the desired groups from the "Groups" field. This determines the user's access rights and permissions within SonarQube.
    7.	Once you have filled in the required information, click on the "Create" button to add the user.

    The new user will now be added to the SonarQube server with the specified login, name, and assigned groups. The user can use the provided credentials to log in to SonarQube and access the features based on their assigned permissions.

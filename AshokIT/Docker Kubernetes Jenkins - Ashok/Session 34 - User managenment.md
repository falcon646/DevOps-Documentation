
## User Management In Jenkins


- In Our Project multiple teams will be available
	- Development team
	- Testing team
	- Operations Team
- For every Team member Jenkins login access will be provided. 
- Note: Every team members will have their own user account to login into jenkins.
- Operations team members are responsible to create / edit / delete / run jenkins jobs
- Dev and Testing team members are only responsible to run the jenkins job.

### How to create users and manage user permissions

- Go to Jenkins Dashboard
- Manage Jenkins -> Manage Users
- Create Users
- Go to Configure Global Security
- Manage Roles & Assign Roles
- Note: By default admin role will be available and we can create custom role based on requirement
- In Role we can configure what that Role assigned user can do in jenkins
- In Assign Roles we can add users to particular role

### Excercise
	create 1 account for DevOps team member 
	Create 1 account for Development team member
	Configure Roles for DevOps team member and Development team member
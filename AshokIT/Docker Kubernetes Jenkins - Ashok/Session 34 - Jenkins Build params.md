# Build Params in Jenkins

- Objective : Create Jenkins Jobs with Build Parameters

- Build Parameters are used to supply input to run the Job. Using Build Parameters we can avoid hard coding.

	Ex : We can pass branch name as build parameter.

Steps
```
-> Create New Item
-> Enter Item Name & Select Free Style Project
-> Select "This Project is parameterized" in General Section
-> Select Choice Parameter
-> Name : BranchName
-> Choices : Enter every branch name in nextline
-> in the branch selection we pass what the user has selected 
Branches to Build : */${BranchName}
```
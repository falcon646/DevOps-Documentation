- when you install git plugin , it gives us all the commands related to git(& not the tool itlsef) . But to run the command we still need the tool to be installed in the jenkins node
- for tools which require different version for different projects , installing the tool directly on the jenkins node is not a good approach since we can only install one version of a tool at a time
eg one project might need maven 3 , other might require maven 4 . In this case if we directly install the maven 3 tool on the jenkins node then the maven 4 project wont work and vice versa
- In this case better option is to install the tool with its specific version in the jenkins dasboard itself , ie `Global tool Configuration` . Here you will see your tool which you can configure different version. if your tool is not present then you need to install the plugin of the tool
- when you run a jenkins job , you need to mention the job about the configured maven version to be able to use it to run th job

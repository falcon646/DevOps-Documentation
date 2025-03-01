
### **Introduction to Node.js**

Node.js is an **open-source runtime environment** that enables developers to execute JavaScript code outside a web browser.  
With Node.js, developers can create both **frontend** and **backend** applications using JavaScript.  

Node.js is built on top of **Google Chrome's V8 JavaScript engine**, making it possible to build backend applications using the same programming language that developers are already familiar with.  
- When Node.js is installed, **NPM (Node Package Manager)** also gets installed automatically.

- **NPM :** : NPM is a package manager for JavaScript and Node.js applications. It is used to:
   - Discover, share, and distribute packages.
   - Manage dependencies for JavaScript-based projects.
   - Install external libraries required for development and deployment.

- **Exploring a Sample Node.js Project** : To understand how to **run and test** a Node.js application, let's explore a minimal example that simply prints "Hello, World!".  
   - A typical **Node.js project** consists of the following key files:
      1. **`package.json`**  
         - This file contains **metadata** about the project, such as:
         - Project name  
         - Version  
         - Dependencies  
         - Scripts for execution  
         - It is used for **dependency management**, allowing developers to specify external packages required for their application.

      2. **Installing Dependencies**
         - The dependencies defined in `package.json` can be installed using:
         ```sh
         npm install
         ```
         - Once the installation is complete, a `node_modules/` directory is created, containing all external JavaScript packages required by the project.

      3. **Application Logic (`index.js`)** : The **main business logic** is written inside the `index.js` file.

      4. **Testing (`test.js`)**
         - A `test.js` file is used to define **test cases** for the application.
         - The command to execute tests is:
         ```sh
         npm test
         ```
         - This command runs all test cases defined in the `test.js` file.

      5. **Starting the Application**
         - In a typical Node.js project, the following command is used to start the application:
         ```sh
         npm start
         ```
         - Once started, the application can be accessed in a web browser by making a request to the **assigned port number**.
---

### **Executing and Automating a Simple Node.js Application Deployment**  

In this session, the **Node.js-based application** named **Solar System** will be executed **manually** on a **local machine** or a **virtual machine**.

- **Application Overview** 
   - Repo : [falcon646/solar-system](https://github.com/falcon646/solar-system)
      - The **Solar System** application is currently hosted on **GitHub** 
      - The repository contains:  
      - **Frontend (HTML)**  
      - **Application logic (app.js, app.controller.js)**  
      - **Supporting files** such as configuration and dependencies  
      - **A README file** with details on running dependencies, unit testing, and code coverage  

- **Exploring the Repository**  
   - The directory structure includes:  
      - **package.json**: Contains metadata, dependencies, and scripts  
      - **Dependencies used**:  
      - `express`: For creating REST APIs  
      - `mocha`, `junit`: For unit testing  
      - `mongoose`: For MongoDB integration  
      - `nyc`: For code coverage reports  
      - `serverless-http`: For future AWS Lambda deployment  
      - **Scripts available in package.json**:  
      - `start`: Starts the application  
      - `test`: Runs unit tests  
      - `coverage`: Runs code coverage analysis  
      - The application requires **MongoDB credentials** (URI, username, and password), which will be passed as **environment variables**
- **Installing Dependencies and Running Unit Tests**  
   - **Install dependencies:**  `npm install` . This will create a `node_modules` directory containing the installed dependencies.  
   - **Run unit tests:**  `npm test` . If the MongoDB **URI, username, and password** are not set, the test will fail due to database connection issues. For demonstration, these values are **hardcoded** in the application. 
   - Update the value in app.js like below
      ```js
      mongoose.connect('mongodb+srv://supercluster.d83jj.mongodb.netsuperData', {
         user: 'superuser',
         pass: 'superPassword',
         useNewUrlParser: true,
         useUnifiedTopology: true
      }, function(err) {
         if (err) {
            console.log("error!! " + err)
         } else {
            //  console.log("MongoDB Connection Successful")
         }
      })
      ``` 
   - If successful, a file `test-results.xml` is generated, containing JUnit test reports.  
   - 

- **Running Code Coverage**  
   - **Execute code coverage analysis:**  `npm run coverage`
      - The `nyc` tool generates a **code coverage report**.  
      - The threshold for coverage is **90%** (as defined in `package.json`).  
      - If the actual coverage is **below 90%**, the command exits with **error code 1**,
   - **Check generated reports:**  Coverage reports are stored in the `coverage/` and `nyc-output/` directories.  

#### **Starting the Application**  
- **Run the application:**  `npm start`
   - The application runs on **port 3000** by default.  
   - If running on a **virtual machine**, replace `localhost` with the **VM's public IP address**.  
- **Access the application:**  `http://<VM-IP>:3000`
   - The **frontend** (index.js) displays **planetary details**.  
   - The **backend** fetches data from **MongoDB**.  
- **Application Endpoints**  
   - `/`: Returns the frontend UI  
   - `/planets/<number>`: Fetches planet details  
   - `/os`: Returns the **host name** (pod name in Kubernetes)  
   - `/live`: Liveness check  
   - `/ready`: Readiness check  

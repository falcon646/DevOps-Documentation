# **Azure Monitoring: Complete Guide**  

[Offical Blog - Must Read](https://learn.microsoft.com/en-us/azure/azure-monitor/overview)

Monitoring in Azure ensures the health, performance, and security of cloud resources. It involves **collecting, analyzing, and responding** to telemetry data from different Azure services, applications, and infrastructure components.


## **How Monitoring Works in Azure**
Azure monitoring follows a **four-stage process**:

1. **Collect** → Gather telemetry from Azure resources, applications, and users.  
2. **Analyze** → Process data using queries, logs, and insights.  
3. **Visualize** → Display metrics and logs in dashboards and reports.  
4. **Respond** → Take actions based on alerts and automation.  

Azure provides several services for monitoring **infrastructure, applications, security, and costs**.

## **Azure Monitor (Main Monitoring Service / The Parent Service)**
**Azure Monitor** is the central monitoring service that collects and analyzes data from all Azure resources.
- Azure Monitor is the umbrella service that collects metrics, logs, traces, and alerts across Azure services, including AKS, VMs, databases, and applications. It provides a centralized platform for all monitoring needs in Azure.
- Think of Azure Monitor as the "main monitoring hub" that collects data from various sources.
- **Features**
    - **Metrics** → Real-time numerical data (CPU %, memory usage, network traffic).  
    - **Logs** → Event-based data stored in structured logs.  
    - **Alerts** → Notifications triggered based on metric/log thresholds.  
    - **Dashboards** → Custom visualizations using metrics and logs.  


### **Azure Monitoring High level architecture**

![azure monitrr](images/azure-moniter.svg)

**1. Data Sources**
Azure Monitor collects data from various sources, which can be categorized as:

- **Application Monitoring**: Collects telemetry data from applications (e.g., using Application Insights).
- **Infrastructure Monitoring**:
  - **VMs**: Virtual machines running on Azure or on-premises.
  - **Containers**: Kubernetes clusters (e.g., Azure Kubernetes Service - AKS).
  - **Networks**: Network traffic analysis.
- **Other Logs & Metrics**: Logs and performance metrics from Azure resources.

**2. Data Platform (Azure Monitor Core)**
Once collected, data is processed and stored within Azure Monitor’s data platform:

- **Metrics**: Real-time numerical values that help track performance.
- **Logs**: Structured logs stored in Azure Monitor Logs.
- **Traces**: Distributed tracing for applications.
- **Change Tracking**: Monitors system configuration changes.

**3. Data Consumption**
Once collected, services consume monitoring data from the Azure Monitor data platform.:

- Insights : Some Azure resource providers have curated visualizations that provide a customized monitoring experience and require minimal configuration. Insights are large, scalable, curated visualizations.
    - VM Insights (For Virtual Machines)
    - Container Insights (For AKS & Containers)
    - Network Insights (For Network Monitoring)
    - Storage Insights (For Storage Accounts)
    - Application Insights (For App Monitoring)

**4. Analyze & Process Data**
Users can analyze data through different tools:

- **Metric Explorer**: Visualizes performance metrics.
- **Change Analysis**: Tracks system changes affecting performance.
- **Log Analytics**: Queries logs to extract insights.

**5. Visualization**
Data can be visualized using multiple tools:

- **Workbooks**: Custom dashboards for insights.
- **Dashboards**: Azure-native visualization for monitoring.
- **Grafana & Power BI**: Third-party integrations for advanced analytics.

**6. Response & Automation**
Azure Monitor enables automated responses to critical events:

- **Alerts & Actions**: Notifies administrators of issues.
- **Autoscale**: Dynamically adjusts resources based on demand.



Azure Monitor is at the top of the hierarchy. Below it, different services handle specific types of monitoring.


```
Azure Monitor (Top-Level Service)
   ├── Data Collection Targets (Data platform)
   │   ├── Metrics (Real-time performance data)
   │   ├── Logs (Event & diagnostic data)
   │   ├── Traces (Application-level telemetry)
   │   ├── Distributed Tracing (End-to-end request tracking)
   │   ├── Changes
   │
   ├── Monitoring Insights (Consumption)
   │   ├── VM Insights (For Virtual Machines)
   │   ├── Container Insights (For AKS & Containers)
   │   ├── Network Insights (For Network Monitoring)
   │   ├── Storage Insights (For Storage Accounts)
   │   ├── Application Insights (For App Monitoring)
   │   ├── 
   │   ├── 
   │  
   ├── Azure Network Monitor
   │   ├── Connection Monitor (VM/VNET Connectivity)
   │   ├── Network Performance Monitor (Latency & Packet Loss)
   │   ├── Traffic Analytics (NSG Flow Log Analysis)
   │   ├── Diagnose & Solve (Troubleshooting Network Issues)
   │  
   ├── Analysis & Querying
   │   ├── Log Analytics (Kusto Query Language - KQL)
   │   ├── Workbooks (Custom Dashboards)
   │
   ├── Alerting & Automation
   │   ├── Alerts (Threshold-based notifications)
   │   ├── Action Groups (Automated responses)
   │   ├── Auto-healing (Scale-out, Restart VMs)
   │
   ├── Security & Compliance
   │   ├── Microsoft Defender for Cloud (Threat Protection)
   │   ├── Azure Sentinel (SIEM - Security Information & Event Management)
   │
   ├── External Integrations
   │   ├── Prometheus (Custom Monitoring)
   │   ├── Grafana (Custom Dashboards)
   │   ├── Third-party tools (Splunk, New Relic, Datadog)

```

- **Data Collection / Data Sources (How Data is Gathered)**
    - Azure Monitor collects data through three main types of telemetry:
        - Metrics – Real-time numerical data (CPU usage, disk I/O, network latency).
        - Logs – Historical event-based data (errors, crashes, diagnostic logs).
        - Traces – End-to-end request tracking for applications.
        - Where Does This Data Come From?
            - Azure resources (VMs, databases, storage)
            - Applications (App Services, APIs, microservices)
            - Network traffic (Load Balancers, Firewalls)
            - Security logs (Threats, Intrusions)
    - **Azure Monitor Data Sources** :
        | Data Source | Description |
        |-------------|------------|
        | **Application Monitoring** | Performance and availability of apps (APM). |
        | **Virtual Machines (VMs)** | CPU, disk, memory, network monitoring. |
        | **Containers (AKS, ACI)** | Kubernetes performance metrics. |
        | **Databases** | Query performance, storage, replication health. |
        | **Networking** | Azure Load Balancer, Traffic Manager, ExpressRoute insights. |



### **Azure Monitor : `Monitoring Insights` (Pre-Built Monitoring for Different Services)**
Azure Monitor includes **pre-built monitoring dashboards** called **Insights** for specific Azure services.

- **VM Insights (For Virtual Machines)**
    - Monitors **CPU, memory, disk usage, and network traffic**.  
    - Provides **Live Process Monitoring** to see running applications inside VMs.  
    - Uses **Log Analytics** for storing VM logs.  
    - **Example:** Get an alert when VM CPU usage goes above 90% for 5 minutes.  
- **Container Insights (For AKS & Containers)**
    - Monitors **containerized applications** in AKS & Azure Container Instances.  
    - Uses **Azure Monitor for Containers** to collect pod-level data.  
    - **Example:** See the number of pod restarts in AKS.  
- **Network Insights (For Networking Resources)**
    - Monitors **Azure Load Balancer, Application Gateway, VPN, and NSGs**.  
    - Uses **Network Watcher** for deep packet inspection.  
    - **Example:** Identify packet loss in a VPN connection.  
- **Storage Insights (For Storage Accounts)**
    - Tracks **blob storage, file shares, and queue performance**.  
    - Provides **latency, throughput, and capacity reports**.  
    - **Example:** Detect slow storage performance affecting applications.  
- **Application Insights (For App Monitoring)**
    - Collects **application logs, performance metrics, and request tracing**.  
    - Supports **distributed tracing** for microservices.  
    - Uses **Application Performance Monitoring (APM)** features.  
    - **Example:** Find out why an API request took longer than usual.  

### **Azure Monitor : `Azure Network Monitor` (Networking Issues & Traffic Insights)**

Azure Network Monitor (or Network Performance Monitor - NPM) is a specialized network monitoring tool under Azure Monitor that helps track and diagnose networking issues across Azure and hybrid networks. It provides:
- Network connectivity monitoring (VMs, Azure VNETs, on-premises networks)
- Packet loss and latency detection
- Traffic flow insights
- Connection troubleshooting
- **Why Do You Need Azure Network Monitor?**
    - Detects packet loss and latency in Azure networks
    - Monitors hybrid connectivity (Azure + On-Prem)
    - Identifies NSG (Network Security Group) rule conflicts
    - Helps troubleshoot slow connections and dropped packets
    - Optimizes Azure network performance and costs

| **Feature** | **What It Does?** | **Example Use Case** |
|------------|------------------|---------------------|
| **Connection Monitor** | Checks connectivity between Azure VMs, on-premises, and external endpoints | Detect if two VMs in different VNETs can communicate |
| **Network Performance Monitor (NPM)** | Detects packet loss, latency, and jitter | Monitor network performance between an on-prem VPN and Azure |
| **Traffic Analytics** | Analyzes network traffic patterns from NSG flow logs | Detect abnormal traffic spikes in an AKS cluster |
| **Diagnose and Solve Problems** | Troubleshoots network issues with Azure networking tools | Investigate why a VM cannot reach a database |
- **Example:**  If a VM in **West US** is **failing to connect** to a database in **East US**, Azure Network Monitor can check:  
    - **Is there a routing issue?**  
    - **Is there an NSG blocking the connection?**  
    - **Is packet loss too high?**  

### **Azure Monitor : `Log Analytics` & `Workbooks` (Analysis , Visualization & Querying)**

Azure generates logs and performance data from virtual machines, databases, applications, networking components, and security services. To make sense of this data, analytics and querying tools like Azure Log Analytics and Kusto Query Language (KQL) are required.

- Analytics and querying are critical in Azure because they help in understanding, troubleshooting, and optimizing cloud environments. Without them, organizations would struggle to gain insights from the vast amounts of logs, metrics, and telemetry data generated by Azure resources.

    | **Key Need** | **Why It Matters?** |
    |-------------|---------------------|
    | **Troubleshooting Issues** | Find errors, failures, and root causes of system failures. |
    | **Performance Optimization** | Identify bottlenecks and improve system efficiency. |
    | **Security & Compliance** | Detect security threats, failed logins, and unauthorized access. |
    | **Cost Management** | Analyze resource usage and optimize spending. |
    | **Proactive Monitoring** | Set up alerts to prevent failures before they occur. |
    | **Auditing & Reporting** | Track who made changes and generate reports for compliance. |

    >💡 **Without analytics and querying, IT teams would have to manually sift through logs, making troubleshooting and monitoring nearly impossible in complex cloud environments.**

- `Log Analytics` and `Workbooks`are core components of Azure Monitor, used for analyzing and visualizing collected data. They provide a way to query logs, create dashboards, and generate reports from monitoring data across Azure resources.
    - Log Analytics and Workbooks are part of Azure Monitor, but they serve different purposes.
        ```
        Azure Monitor (Top-Level Service)
        ├── Data Collection
        │   ├── Metrics (Performance data)
        │   ├── Logs (Event & diagnostic data)
        │
        ├── Analysis & Visualization
        │   ├── Log Analytics (Query logs using KQL)
        │   │   ├── Log Analytics Workspaces (Stores logs)
        │   │   ├── Log Categories (Activity logs, Resource logs, Security logs)
        │   │   ├── Saved Queries (Reusable queries)
        │   │
        │   ├── Workbooks (Custom Dashboards & Reports)
        │       ├── Prebuilt Templates (Default reports for  VM Insights, AKS, Network Monitoring , Storage)
        │       ├── Custom Workbooks (User-defined dashboards)
        │
        ```
- #### Log Analytics
    - Log Analytics is a tool within Azure Monitor that queries logs stored in Log Analytics Workspaces. It is used to search, analyze, and troubleshoot logs from Azure resources.
    - Think of Log Analytics as a "search engine" for Azure logs.
    - `Why is Log Analytics Needed?`
        - Helps in troubleshooting issues by querying logs.
        - Provides detailed insights into Azure services (VMs, Kubernetes, Storage, Networking).
        - Allows advanced filtering, aggregation, and correlation of log data.
        - Supports real-time log monitoring and alerting.
    - `How Does Log Analytics Work?`
        - Azure resources (VMs, Containers, Apps) generate logs.
        - These logs are collected in Log Analytics Workspaces.
        - Users write Kusto Query Language (KQL) queries to analyze logs.
        - Data can be visualized in Workbooks or exported to alerts.
    - `What is a Log Analytics Workspace?`
        - A **Log Analytics Workspace** is a **centralized storage location** for logs collected from Azure resources.  **Azure Monitor Logs** are stored in **Log Analytics Workspaces**.
            - **Every Log Analytics query runs against a specific workspace**.  
            - A single Azure subscription can have **multiple workspaces**.  
            - It can store **Azure logs, custom logs, security logs, and performance data**.  
            - **Think of a workspace as a "database" for logs in Azure.**  
        - **Types of Logs Stored in Log Analytics Workspaces**
            | **Log Type** | **Description** |
            |-------------|----------------|
            | **Activity Logs** | Logs for Azure resource changes (who modified what). |
            | **Resource Logs** | Logs for VM performance, database queries, etc. |
            | **Security Logs** | Logs for failed login attempts, firewall changes. |
            | **Diagnostic Logs** | Logs from Azure services like Load Balancer, Storage. |

        - **Example Log Query in Log Analytics (Using KQL)** : Find failed logins in the last 24 hours:
            ```kql
            SigninLogs
            | where ResultType != 0
            | where TimeGenerated > ago(24h)
            | project UserPrincipalName, ResultType, TimeGenerated
            ```
- #### Workbook  (Custom Dashboards)
    - **Workbooks** are interactive dashboards that display data from Azure Monitor, Log Analytics, and Metrics. They allow users to **create custom reports and visualizations**.  
    - **Think of Workbooks as an "interactive report builder" for Azure Monitor.**  
    - `Why are Workbooks Needed?`
        - Provides **prebuilt monitoring dashboards** for VMs, AKS, Networking, and Storage.  
        - Allows users to **combine multiple data sources** (metrics, logs, and alerts) in one view.  
        - Supports **custom charts, graphs, and tables** for better data visualization.  
        - Helps teams **track real-time performance and trends**.  
    - `Types of Workbooks`
        | **Workbook Type** | **Purpose** |
        |------------------|------------|
        | **Prebuilt Workbooks** | Ready-made dashboards for Azure services (VMs, AKS, Storage). |
        | **Custom Workbooks** | User-created dashboards with custom queries. |
        | **Security Workbooks** | Built-in dashboards for Microsoft Defender & Sentinel. |
    - **Example: Creating a Custom Workbook**
        - Open **Azure Monitor** → Select **Workbooks**.  
        - Click **"New Workbook"**.  
        - Add a **Log Analytics query** (Example: Show failed login attempts).  
        - Add a **chart or table** to visualize the results.  
        - Save and pin it to the Azure dashboard. 

- #### **Differences Between Log Analytics & Workbooks**
    | **Feature** | **Log Analytics** | **Workbooks** |
    |------------|------------------|-------------|
    | **Purpose** | Query & analyze logs | Visualize & report data |
    | **Data Source** | Log Analytics Workspaces | Logs, Metrics, Alerts |
    | **Query Language** | Kusto Query Language (KQL) | Supports KQL & Metrics |
    | **Output Format** | Tables, raw data | Graphs, charts, dashboards |
    | **Use Case** | Debugging & troubleshooting | Reporting & monitoring |



### **Azure Monitor : `Alerting` & `Automation` (How Alerts & Actions Work)**
Alerting & Automation in Azure is a mechanism that monitors resources, detects issues, and triggers automatic responses to ensure system reliability, security, and efficiency.

- Without alerts and automation, IT teams would have to manually monitor logs and metrics, making it difficult to detect problems in real-time. Automation ensures that repetitive tasks are handled without human intervention, improving operational efficiency. Example: If a Virtual Machine's CPU usage exceeds 90%, an alert can be triggered to notify admins or automatically scale up the instance.
- Why Do We Need Alerting & Automation?
    - **Real-Time Issue Detection**	: Alerts notify admins immediately when an issue occurs.
    - **Minimizing Downtime**	: Automated responses help fix problems before they escalate.
    - **Security & Compliance**	: Detect unauthorized access attempts and take action.
    - **Cost Optimization**		: Automatically shut down unused resources to save costs.
    - **Operational Efficiency**	: Reduce manual work by automating repetitive tasks.

- ####  Alerts (Real-Time Notifications)
    - Azure uses Azure Monitor Alerts to notify users when certain conditions are met. These conditions are based on metrics, logs, or activity events.
    - Detects when a metric or log matches a predefined condition.
    - Sends alerts via Email, SMS, Webhook, or Teams.
        - Example: Alert when a VM is using 95% CPU for 10 minutes.
        - Example: If a Kubernetes pod restarts more than 3 times in 5 minutes, an alert can notify the DevOps team

- ####  Alerts Action Groups (Automated Responses)
    - Defines who gets notified and what actions should be taken when an alert is triggered.
    - Azure uses Azure Automation and Logic Apps to execute tasks automatically when an alert is triggered.
        - Example: Restart a VM when it crashes.
        - If an AKS cluster node is unhealthy, a Logic App can restart it automatically.

- ####  Auto-Healing (Self-Recovery Actions)
    - Automatically restarts VMs or scales out resources when thresholds are met.
        - Example: Automatically scale out an app when CPU usage reaches 80%.
- **Common Ways to Automate Responses**
    | **Automation Type** | **Purpose** | **Example** |
    |---------------------|------------|-------------|
    | **Auto-Scaling** | Scale up/down resources based on demand | Increase VM count when CPU > 80% |
    | **Azure Functions** | Run custom scripts on triggers | Restart a VM when it crashes |
    | **Logic Apps** | Create workflows for issue resolution | Notify a team on Slack when an alert fires |
    | **Runbooks** | Automate common admin tasks | Delete unused storage every 24 hours |



### **Azure Monitor : `Security & Compliance` (Security Monitoring & Threat Detection)**
- ####  **Microsoft Defender for Cloud**
    - Provides **threat detection and security recommendations** for Azure resources.  
    - Detects **malware, unauthorized access, and vulnerabilities**.  
        - **Example:** Detect if an Azure SQL Database is exposed to the internet.  

- ####  **Azure Sentinel (SIEM & Threat Hunting)**
    - A **Security Information and Event Management (SIEM) tool**.  
    - Collects **security logs from Azure, on-prem, and third-party services**.  
        - **Example:** Detect failed login attempts across multiple Azure services.  



### **Azure Monitor : `External Integrations`**
Azure Monitor can integrate with **third-party monitoring and visualization tools**.
- **Prometheus** (For custom metrics collection)  
- **Grafana** (For custom dashboards)  
- **Splunk, Datadog, New Relic** (For advanced log analysis)  
- **Example:** Use Grafana to display custom visualizations from Azure Monitor data.  


### **Azure Monitor : `Azure Service Health` (Azure Level Outage Monitoring)**
- Provides updates on **planned maintenance, incidents, and service disruptions**.
- Includes:
  - **Service Issues** (Azure outages)
  - **Planned Maintenance** (Scheduled updates)
  - **Health Alerts** (Notifications for resource failures)
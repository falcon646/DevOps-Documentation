# **Introduction to Prometheus: Architecture, Components, and Usage**  
Prometheus is one of the most widely used **open-source monitoring and alerting systems**. It was initially developed by **SoundCloud** and later became a **Cloud Native Computing Foundation (CNCF) project**. In 2018, it was promoted to a **graduated CNCF project**, making it a stable and trusted monitoring solution.  

Prometheus is **platform-agnostic**, meaning it can run on various operating systems and cloud environments. It is capable of monitoring **databases, hardware, messaging systems, Kubernetes clusters, storage systems, and cloud applications**. Its popularity grew significantly with the rise of **containerization** and **cloud-native ecosystems**.  

The core functionalities of Prometheus include:  
- **Time-series data collection and storage** using **TSDB (Time-Series Database)**.  
- **Monitoring and alerting** based on collected metrics.  
- **A powerful query language called PromQL** to filter and analyze data.  
- **Integration with various third-party visualization tools**, such as **Grafana**.  

### **Architecture of Prometheus**  
Prometheus consists of six major components:  
1. **Prometheus Server**  
2. **Exporters**  
3. **Push Gateway**  
4. **Alert Manager**  
5. **Visualization (Dashboards)**  
6. **Service Discovery**  


## **1. Prometheus Server: The Brain of the System**  
The **Prometheus Server** is the **central component** responsible for:  
- **Collecting and storing metrics** in a **time-series database (TSDB)**.  
- **Scraping metrics from various targets** at configured intervals.  
- **Processing and exposing metrics** for analysis and alerting.  
- It scrapes metrics from different sources (nodes, instances, services, etc.).
- Scraping Interval: By default, Prometheus scrapes metrics every 15 seconds.
- The collected metrics are ingested into the TSDB for querying and alerting.

### **Time-Series Data and Scraping**  
- **Prometheus stores data in TSDB**, where each metric is stored with a **timestamp**.  
- The process of **fetching metrics from monitored targets** is called **scraping**.  
- By default, Prometheus **scrapes data every 15 seconds**, but this interval can be adjusted.  

## **2. Exporters: Collecting Metrics from Systems and Applications**  
- **Exporters** are **agents** installed on systems to **collect and expose metrics** for Prometheus to scrape.  
- They act as **bridges between Prometheus and external systems** (e.g., databases, hardware, cloud services).  
- Some common **Prometheus exporters** include:  
  - **Node Exporter** → Collects system-level metrics (CPU, memory, disk, network).  
  - **MySQL Exporter** → Extracts performance metrics from MySQL databases.  
  - **Blackbox Exporter** → Monitors endpoints via HTTP, HTTPS, ICMP, etc.  
- Without exporters, **Prometheus cannot directly collect metrics from external applications**.  

## **3. Push Gateway: Handling Short-Lived Jobs**  
- Prometheus **scrapes data at fixed intervals** (default **15 seconds**).  
- Some jobs, such as **batch processes or cron jobs**, complete in **less than 15 seconds**.  
- **Push Gateway** acts as an **intermediary storage** for such short-lived metrics.  

### **How It Works**  
1. The short-lived job **pushes its metrics** to the **Push Gateway** before it terminates.  
2. The **Push Gateway stores** these metrics temporarily.  
3. During the next scrape interval, **Prometheus pulls** the stored metrics from the **Push Gateway**.  

### **Use Case Example**  
A batch job that **runs for 5 seconds** would be **missed by Prometheus** if scraped every 15 seconds. By **using the Push Gateway**, the job's metrics are stored and **retrieved later by Prometheus**.  


## **4. Alert Manager: Generating and Managing Alerts**  
- Prometheus is **not just a monitoring tool**; it also acts as an **alerting system**.  
- The **Alert Manager** is responsible for:  
  - **Processing alert rules** defined in Prometheus.  
  - **Grouping and de-duplicating alerts**.  
  - **Sending notifications** to different channels.  

### **Alerting Workflow**  
1. **Prometheus detects an issue** based on a threshold (e.g., CPU usage > 90%).  
2. **An alert is triggered** and sent to the **Alert Manager**.  
3. The **Alert Manager processes** the alert and **forwards notifications** via:  
   - **Email**  
   - **Slack**  
   - **PagerDuty**  
   - **Webhooks**  
4. Engineers receive alerts and can **take corrective actions** before issues escalate.  

**Example Alerts:**  
- **Server down**  
- **High memory usage**  
- **Database connection failure**  


## **5. Visualization: Dashboards and Querying Metrics**  
- **Metrics alone are not useful unless they can be visualized.**  
- Prometheus provides a **built-in Web UI**, but it has **limited visualization features**.  
- **Grafana** is commonly used for **advanced dashboards** and **real-time monitoring**.  

### **Why Grafana?**  
- **Rich visualization options** (graphs, heatmaps, tables, etc.).  
- **Custom dashboards with real-time data**.  
- **Alerting features** with notifications.  
- **Supports multiple data sources** beyond Prometheus.  

By integrating Prometheus with **Grafana**, users can **gain deeper insights** into system performance.  


## **6. Service Discovery: Automating Target Detection**  
- Manually configuring targets for Prometheus **is inefficient in dynamic environments**.  
- **Service Discovery** enables Prometheus to **automatically detect and monitor new targets**.  
- This is especially useful in **cloud environments** where **instances and containers are dynamically created and destroyed**.  

### **Supported Discovery Mechanisms**  
- **Static Configuration** → Manually define monitoring targets.  
- **Kubernetes Discovery** → Automatically discover pods, services, and nodes.  
- **Cloud Integrations** → AWS EC2, Azure, GCP, and other cloud platforms.  

**Example:** In a Kubernetes cluster, **new pods are frequently created and deleted**. With **Service Discovery**, Prometheus **automatically updates its target list** without manual intervention.  


## **Best Practices for Production Deployment**  
To ensure a **stable and scalable** Prometheus setup, consider the following best practices:  

 **Disaster Recovery (DR):** Implement backup and recovery strategies.  
 **High Availability:** Use multiple Prometheus instances to **prevent data loss**.  
 **Persistent Storage:** Use **external storage solutions** like Thanos, Cortex, or VictoriaMetrics.  
 **Scaling:** Deploy **federated Prometheus** for large-scale environments.  
 **Alerting Strategy:** Define **clear thresholds** and **alerting rules** to avoid unnecessary noise.  


## **Getting Started with Prometheus**  
1️⃣ **Install Prometheus** and configure the **server**.  
2️⃣ **Set up exporters** to collect system and application metrics.  
3️⃣ **Use Push Gateway** for capturing **short-lived job metrics**.  
4️⃣ **Configure Alert Manager** for real-time **issue notifications**.  
5️⃣ **Integrate Grafana** for **better visualization**.  
6️⃣ **Enable Service Discovery** for **automated target detection**.  

Prometheus provides a **comprehensive monitoring solution** for modern cloud-native applications. By **following best practices**, teams can **ensure high availability, observability, and proactive issue resolution**. 

### **Basic Terminologies in Prometheus**  

Prometheus introduces several key concepts, including:  
- **Prometheus Server**  
- **Target**  
- **Exporter**  
- **Job**  
- **Time Series Database (TSDB)**  
- **PromQL (Prometheus Query Language)**  
- **Data Types, Functions, and Operators**  
- **Recording Rules**  
- **Alerting Rules and Alerts**  
- **Client Libraries**  


### **Prometheus Server**  
At the core of Prometheus is the **Prometheus server**, which is responsible for collecting and storing metrics. The server does not receive data passively; instead, it actively **pulls** metrics from different sources. These sources could be various systems like Linux servers, Windows servers, or databases.  

However, these systems do not automatically send metrics to Prometheus. Instead, **exporters** are required to collect and expose the necessary data.  

---

### **Exporters**  
Exporters act as **agents** installed on the systems being monitored. Their primary role is to collect metrics and make them available for Prometheus to scrape. There are different types of exporters, each designed for a specific kind of data collection:  
- **Node Exporter**: Gathers system-level metrics such as CPU usage, memory usage, and disk I/O.  
- **Database Exporters**: Collects database-specific metrics, such as the number of active queries or connection pool statistics.  
- **Network Exporters**: Captures network-related data like packet loss, bandwidth utilization, and connection status.  

Each exporter runs as a process on the monitored system, exposing metrics over an HTTP endpoint. The Prometheus server then scrapes these metrics periodically.  

### **Jobs and Targets**  
Prometheus organizes monitoring tasks using **jobs** and **targets**.  

- A **job** is a logical grouping of related metrics sources.  
- Each job consists of one or more **targets**.  

#### **Example**  
Consider a scenario where two Linux servers are being monitored. If both servers need CPU, memory, and disk usage metrics, a **single job** can be created to monitor them, and each server will be a **target** within that job.  

A **target** is essentially the **endpoint (IP or hostname) of an exporter** that Prometheus scrapes data from. Multiple targets within a job indicate that Prometheus is collecting the same type of data from multiple sources.  



### **Time Series Database (TSDB)**  
Prometheus is fundamentally a **time series database (TSDB)**. This means that all collected metrics are stored with **timestamps**. The TSDB organizes data in a way that allows querying historical trends and patterns.  

Each stored metric consists of:  
- A **metric name** (e.g., `cpu_usage`)  
- A set of **labels** (e.g., `{instance="server1", job="linux-metrics"}`)  
- A **timestamp**  
- A **value** (e.g., `45.3` indicating 45.3% CPU usage)  

The TSDB structure makes it efficient for Prometheus to process and retrieve data over time, enabling trend analysis and alerting.  


### **PromQL (Prometheus Query Language)**  
Prometheus provides a specialized query language called **PromQL** to retrieve and analyze stored metrics. PromQL allows filtering, aggregating, and transforming time series data.  

PromQL includes:  
- **Data Types**: PromQL supports four primary data types for querying metrics.  
- **Operators**: Logical (`AND`, `OR`), arithmetic (`+`, `-`, `*`, `/`), and comparison (`>`, `<`, `==`) operators allow users to manipulate data.  
- **Functions**: Predefined functions in PromQL assist in calculations and aggregations (e.g., `rate()`, `avg()`, `sum()`).

#### **Example Query**  
Retrieve the CPU usage of a specific server:  
```promql
cpu_usage{instance="server1"}
```
Calculate the average CPU usage across all servers:  
```promql
avg(cpu_usage)
```
Find out how CPU usage is changing over time:  
```promql
rate(cpu_usage[5m])
```
PromQL enables advanced querying and filtering, making Prometheus a powerful monitoring tool.  

### **Recording Rules**  
A **recording rule** is used to create a new metric based on existing ones. This is useful when complex queries need to be reused frequently. Instead of recalculating a query every time, a recording rule stores the result as a new metric.  

#### **Example**  
If Prometheus is collecting memory usage metrics, but the raw data does not include a **percentage of free memory**, a recording rule can be defined:  
```yaml
groups:
  - name: memory_rules
    rules:
      - record: memory_free_percent
        expr: (free_memory / total_memory) * 100
```
Now, `memory_free_percent` is stored as a new metric that can be queried directly.  


### **Alerting Rules and Alerts**  
Monitoring is useful, but **alerting is crucial** to notify teams when an issue arises. Prometheus supports **alerting rules**, which generate alerts based on metric conditions.  

For example, an alert can be created if CPU usage remains above 90% for more than 5 minutes:  
```yaml
groups:
  - name: alert_rules
    rules:
      - alert: HighCPUUsage
        expr: avg(cpu_usage) > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High CPU usage detected"
```
Alerts can be sent to external notification systems like **Slack, PagerDuty, or email** via the **Alertmanager** component.  


### **Client Libraries**  
Not all applications have built-in exporters. In such cases, **client libraries** allow developers to expose application-specific metrics. Prometheus provides libraries for multiple programming languages:  
- **Go**  
- **Java**  
- **Python**  
- **Ruby**  

These libraries help developers instrument their own applications by defining custom metrics and exposing them to Prometheus.  

#### **Example in Python**  
```python
from prometheus_client import start_http_server, Counter

# Define a custom metric
REQUEST_COUNT = Counter('request_count', 'Total number of requests')

def handle_request():
    REQUEST_COUNT.inc()  # Increment counter on each request

if __name__ == "__main__":
    start_http_server(8000)  # Expose metrics on port 8000
    while True:
        handle_request()
```
This script exposes a metric (`request_count`) that increments each time a request is processed. Prometheus can then scrape it from `http://localhost:8000/metrics`.  


### **Summary**  
1. **Target** – A specific endpoint (usually an exporter) from which Prometheus scrapes metrics.  
2. **Exporter** – An agent that collects and exposes system metrics for Prometheus.  
3. **Job** – A logical grouping of multiple targets.  
4. **Time Series Database (TSDB)** – A database optimized for storing metrics over time.  
5. **PromQL** – The query language used to retrieve and manipulate Prometheus data.  
6. **Recording Rules** – Precomputed queries stored as new time series metrics.  
7. **Alerting Rules** – Conditions that generate alerts when thresholds are exceeded.  
8. **Client Libraries** – Custom metric collectors used when exporters are unavailable.  

---


### Prometheus Setup on a standalone server

The setup will take place on AWS using **Ubuntu 22.04** instances. However, the process is applicable to other platforms such as VMware, Azure, and Google Cloud. 

**Instance Provisioning**
Two new EC2 instances will be launched:
- **Prometheus Master**: This instance will host Prometheus and Grafana.
- **Prometheus Node**: This instance will serve as a monitored target using the node exporter.

Instance details:
- **AMI**: Ubuntu 22.04
- **Instance Type**: `t2.medium` (2 vCPUs, 4 GB RAM) to accommodate Grafana.
- **Storage**: 15 GB root volume.
- **Security Group**: Ports **9090** (Prometheus) and **9100** (node exporter) will be opened.

Once the instances are launched, their hostnames will be updated:
```sh
# for the Prometheus Master instance
sudo hostnamectl set-hostname prometheusserver

# for the node to be moniter
sudo hostnamectl set-hostname PinkN-Node1
```

#### **Prometheus Installation**

Prometheus will be installed on the master . The Prometheus package, available in Ubuntu’s default repository, installs both Prometheus Server and Node Exporter services.

- **Master Node Setup**
    ```sh
    sudo apt update
    sudo apt install prometheus -y
    ```
    - Once installed, Prometheus services can be checked using:
        ```sh
        systemctl status prometheus
        systemctl status prometheus-node-exporter
        ```
    - Prometheus will run on port **9090**, while the node exporter will run on **9100**.

- **Prometheus Dashboard Walkthrough** : Once Prometheus is installed, the web interface can be accessed by entering the Prometheus Master’s IP followed by port **9090** in a browser, `http://<prometheus_master_ip>:9090`
    - **Expression Console**: Allows users to run queries, e.g.: `up`
    This returns the status of monitored targets.
    - **Graph Section**: Displays time-series data in graphical format.
    - **Alerts**: No default alerting rules are present. Alerts can be configured in `prometheus.yml`.
    - **Status > Targets**: Displays active targets and their status.
    - **Status > Service Discovery**: Lists all discovered monitoring targets.
    - **Note :** Configuration files, such as `/etc/prometheus/prometheus.yml`, define job names, targets, and other configurations. 

- **Monitered Node Setup** : To add a node to be monitored, the Prometheus Node Exporter service should be installed on that node
    ```sh
    sudo apt update
    sudo apt install prometheus-node-exporter -y
    # check status
    systemctl status prometheus-node-exporter
    ```
    - The node exporter's metrics can be accessed via: `http://<node_ip>:9100/metrics` . This confirms that the node exporter is collecting system metrics.
    - **Adding the new Node to Prometheus** : To instruct Prometheus to monitor this new node, the **Prometheus configuration file (`prometheus.yml`)** must be updated on the **Prometheus Master**:
        - Edit the configuration file:
        ```sh
        sudo vi /etc/prometheus/prometheus.yml
        ```
        - Locate the `scrape_configs` section and add the new target:
            ```yaml
            scrape_configs:
            - job_name: 'node'
                static_configs:
                - targets: ['localhost:9100', '<node_ip>:9100']
            ```
            - Save the file and restart Prometheus: `sudo systemctl restart prometheus`
            - Verify the new target appears in the **Prometheus dashboard** under **Status > Targets**.
            - At this stage, the **Prometheus server** should be collecting metrics from both **itself/master** and the **new node**.
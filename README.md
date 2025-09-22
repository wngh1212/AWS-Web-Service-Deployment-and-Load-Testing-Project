# AWS Web Service Deployment and Load Testing Project

This project documents the process of deploying a web service on AWS, implementing a real-time monitoring system, and conducting load tests with JMeter to identify and resolve performance bottlenecks.

---


### USE 
- **Backend**: Python
- **Infrastucture**: AWS EC2, AWS RDS, AWS ALB
- **Monitoring**: Grafana, Prometheus
- **Etc**: Shell Script, Cron
- **test tool** : jmeter

Application Load Balancer<br>
<img width="1600" height="444" alt="image" src="https://github.com/user-attachments/assets/0a00117d-a4f0-4b19-8e8c-64cf17df598d" />
Application Load Balancer Resource Map<br>
<img width="1600" height="396" alt="image" src="https://github.com/user-attachments/assets/ec56e7cc-db83-47fd-8b05-55d26feb599f" />

***

## 1. Web Service Deployment Architecture

The web service is structured using several core AWS components to ensure scalability and availability.

* **Load Balancer**: An **Application Load Balancer (ALB)** distributes incoming traffic across the application servers. 
* **Application Servers**: Two **EC2 instances** host the web service application.
* **Database**: A **MySQL RDS instance** serves as the managed database.
* **Monitoring**: A dedicated **EC2 instance** runs the monitoring stack. 
* **Alerting**: System alerts are configured to be sent to a **Discord** channel.

<img width="486" height="324" alt="image" src="https://github.com/user-attachments/assets/e6770f49-b96f-4fc4-a425-a3a4d81a225d" /><br>
<img width="700" height="475" alt="image" src="https://github.com/user-attachments/assets/7ab3b109-33e3-42a2-af8d-eee53be8a1a7" />

 **Service URL**: `http://anfa-1094077877.ap-northeast-2.elb.amazonaws.com/`
 The site is currently closed


---

## 2. Monitoring System

 For monitoring, a **Prometheus + Grafana** stack was chosen over AWS CloudWatch. 

### Why Prometheus + Grafana?

* **Predictable Costs**: Running the stack on a single EC2 instance results in a fixed monthly cost, unlike CloudWatch where costs can be hard to predict.
* **Greater Control**: It allows for flexible adjustment of the metric collection frequency, enabling better control over server load and expenses.
* **No Limits on Dashboards/Alerts**: Create unlimited dashboards and alerts without incurring additional fees.

---

## 3. Failure and Load Testing

 The primary goal was to understand how the system behaves under significant user load. [cite: 27]  The tests were executed using **JMeter** across five progressive stages.

### Test Plan

The load was incrementally increased to stress the system.

| Stage | Virtual Users | Ramp-Up Time | Duration |
| :--- | :---: | :---: | :---: |
| **1** | 50  | 10 sec | 180 sec |
| **2** |100  | 10 sec  |180 sec  |
| **3** | 200  | 15 sec  | 180 sec  |
| **4** | 300  | 20 sec  | 180 sec  |
| **5** | 500 | 30 sec  | 300 sec  |

---

## 4. Test Analysis and Optimization

### Initial Problem

 During the first test cycle, the server's CPU and memory resources remained stable, but the application returned a massive **86.58% error rate**. The system accepted requests but failed to process them, sending no response back.<br>
 <img width="856" height="451" alt="image" src="https://github.com/user-attachments/assets/9546b460-ac90-423d-9cce-de27abf41d08" />
<img width="646" height="395" alt="image" src="https://github.com/user-attachments/assets/ec8bc620-2d5c-4dbf-85a4-8890264fd641" />

<img width="1062" height="415" alt="image" src="https://github.com/user-attachments/assets/f02c1c74-46a1-4bb2-bf66-77081025d6d4" />

### TMI
Fortunately, the service didn't collapse thanks to the ALB you configured, because it was connected to another EC2 that didn't conduct a load test <br>
<img width="640" height="394" alt="image" src="https://github.com/user-attachments/assets/ff223748-2e61-45fe-88c9-ae3d130541e4" />

### Root Cause

An analysis of the Nginx logs revealed the root cause: `768 worker_connections are not enough`.The default number of connections Nginx could handle simultaneously was too low for the test load.<br>
<img width="540" height="303" alt="image" src="https://github.com/user-attachments/assets/2054e609-f55d-4eb2-b3d5-0f5ef72879eb" />



### Solution

 The Nginx configuration file (`nginx.conf`) was updated to increase the connection limit from 768 to **4000**, and the service was restarted.
<img width="549" height="249" alt="image" src="https://github.com/user-attachments/assets/bfc09d12-5224-4ebb-8bc2-5358b8e1de60" />

 
### Performance Comparison: Before vs. After Tuning

| Metric | Before Tuning | After Tuning |
| :--- | :---: | :---: |
| **Error Rate** |  **86.58%**  |  **41.31%**  |
| **Samples Processed** |  5,715  |  1,329  |
| **Avg. Response Time** |  1,636 ms  |  6,774 ms  |
| **Max Response Time** |  203,486 ms |  30,173 ms  |
| **Throughput** |  26.9/sec  |  7.0/sec |

While the **error rate was significantly reduced**, other metrics like response time and throughput worsened. This indicates that fixing the initial connection bottleneck allowed more requests to be processed, which in turn revealed a new bottleneck deeper in the application or database layer.

---

## 5. Conclusion and Lessons Learned 

*  This project provided hands-on experience in the end-to-end process of cloud service deployment, monitoring, and performance tuning. 
*  The key takeaway is that the goal of testing isn't just to measure performance, but to **find and eliminate system bottlenecks**.
* It became clear that performance optimization goes beyond code.  **Infrastructure configuration**, like tuning Nginx, is equally critical for a stable service. 
*  Further testing was constrained by AWS Free Tier limits. <br>
prometheus configure file
```
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 10s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["172.31.34.52:9100"]
```








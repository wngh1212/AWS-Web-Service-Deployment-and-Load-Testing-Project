# AWS-service-moniotring
Architecture<br>
<img width="486" height="324" alt="image" src="https://github.com/user-attachments/assets/e6770f49-b96f-4fc4-a425-a3a4d81a225d" />
### USE 
- **Backend**: Python
- **Infrastucture**: AWS EC2, AWS RDS, AWS ALB
- **Monitoring**: Grafana, Prometheus
- **Etc**: Shell Script, Cron

Application Load Balancer<br>
<img width="1600" height="444" alt="image" src="https://github.com/user-attachments/assets/0a00117d-a4f0-4b19-8e8c-64cf17df598d" />
Application Load Balancer Resource Map<br>
<img width="1600" height="396" alt="image" src="https://github.com/user-attachments/assets/ec56e7cc-db83-47fd-8b05-55d26feb599f" />

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
      - targets: ["172.31.34.52:9100"]```

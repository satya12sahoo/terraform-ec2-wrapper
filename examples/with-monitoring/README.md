# EC2 Instances with Monitoring Example

This example demonstrates how to create EC2 instances with comprehensive CloudWatch monitoring using the `terraform-ec2-wrapper` module.

## Features

- **Multiple EC2 Instances**: Creates web, app, and database servers
- **Comprehensive Monitoring**: CPU, Memory, Disk, Network, and Status Check alarms
- **Custom Dashboards**: CloudWatch dashboards for each instance
- **Alerting**: SNS topic for email notifications
- **Flexible Configuration**: Different thresholds for different server types

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Server    │    │   App Server    │    │  Database       │
│   (t3.micro)    │    │   (t3.micro)    │    │  Server         │
│                 │    │                 │    │  (t3.micro)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  CloudWatch     │
                    │  Monitoring     │
                    │                 │
                    │ • CPU Alarms    │
                    │ • Memory Alarms │
                    │ • Disk Alarms   │
                    │ • Network Alarms│
                    │ • Dashboards    │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  SNS Topic      │
                    │  (Email Alerts) │
                    └─────────────────┘
```

## Monitoring Features

### 1. CPU Monitoring
- **Default Threshold**: 75%
- **Web Server**: 70% (more sensitive)
- **App Server**: 85% (higher tolerance)
- **DB Server**: 60% (conservative)

### 2. Memory Monitoring
- **Default Threshold**: 80%
- **Web Server**: 75%
- **App Server**: 90%
- **DB Server**: 70%

### 3. Disk Monitoring
- **Default Threshold**: 85%
- **Web Server**: 85%
- **App Server**: 90%
- **DB Server**: 80%

### 4. Network Monitoring
- **Network In**: 500 MB threshold
- **Network Out**: 500 MB threshold

### 5. Status Check Monitoring
- **Instance Status Check**: Monitors instance health
- **System Status Check**: Monitors underlying infrastructure

### 6. CloudWatch Dashboards
- **CPU & Network Metrics**: Real-time CPU, Network In/Out
- **System Metrics**: Memory and Disk utilization (requires CloudWatch Agent)

## Prerequisites

1. **AWS Account**: With appropriate permissions
2. **VPC and Subnet**: Existing VPC with public subnet
3. **EC2 Key Pair**: For SSH access
4. **CloudWatch Agent** (Optional): For memory and disk monitoring

## Usage

### 1. Clone and Navigate
```bash
cd terraform-ec2-wrapper/examples/with-monitoring
```

### 2. Configure Variables
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your values:
```hcl
aws_region = "us-east-1"
vpc_id     = "vpc-your-vpc-id"
subnet_id  = "subnet-your-subnet-id"
key_name   = "your-key-pair-name"
alert_email = "your-email@example.com"
```

### 3. Initialize and Deploy
```bash
terraform init
terraform plan
terraform apply
```

### 4. Verify Deployment
```bash
terraform output
```

## Configuration Options

### Monitoring Toggles
```hcl
defaults = {
  create_monitoring = true
  
  # Enable/disable specific alarms
  create_cpu_alarm = true
  create_memory_alarm = true
  create_disk_alarm = true
  create_network_in_alarm = true
  create_network_out_alarm = true
  create_status_check_alarm = true
  create_dashboard = true
}
```

### Custom Thresholds
```hcl
defaults = {
  # CPU monitoring
  cpu_threshold = 75
  cpu_evaluation_periods = 2
  cpu_period = 300
  
  # Memory monitoring
  memory_threshold = 80
  memory_evaluation_periods = 2
  memory_period = 300
  
  # Disk monitoring
  disk_threshold = 85
  disk_evaluation_periods = 2
  disk_period = 300
}
```

### Custom Alarm Names
```hcl
items = {
  web-server-1 = {
    cpu_alarm_name = "web-server-1-cpu-high"
    memory_alarm_name = "web-server-1-memory-high"
    disk_alarm_name = "web-server-1-disk-high"
  }
}
```

### Custom Dashboard Titles
```hcl
items = {
  web-server-1 = {
    dashboard_cpu_title = "Web Server 1 - CPU & Network Metrics"
    dashboard_system_title = "Web Server 1 - System Metrics"
  }
}
```

## CloudWatch Agent Setup (Optional)

For memory and disk monitoring, install the CloudWatch Agent on your instances:

### 1. Install CloudWatch Agent
```bash
# Amazon Linux 2
sudo yum install -y amazon-cloudwatch-agent

# Ubuntu
sudo apt-get update
sudo apt-get install -y amazon-cloudwatch-agent
```

### 2. Configure CloudWatch Agent
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

### 3. Start CloudWatch Agent
```bash
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent
```

## Outputs

After deployment, you'll get:

- **Instance IDs**: IDs of created EC2 instances
- **Public IPs**: Public IP addresses of instances
- **Monitoring Alarms**: ARNs and names of created alarms
- **Monitoring Dashboards**: Dashboard names and ARNs
- **Deployment Summary**: Overview of all created resources

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Troubleshooting

### 1. Memory/Disk Alarms Not Triggering
- Ensure CloudWatch Agent is installed and running
- Check CloudWatch Agent configuration
- Verify IAM permissions for CloudWatch Agent

### 2. Email Alerts Not Received
- Check SNS topic subscription
- Verify email address is correct
- Check spam folder

### 3. High False Positives
- Adjust alarm thresholds
- Increase evaluation periods
- Use different statistics (Average vs Maximum)

## Cost Considerations

- **EC2 Instances**: t3.micro instances (~$8/month each)
- **CloudWatch Alarms**: $0.10 per alarm metric per month
- **CloudWatch Dashboards**: $3.00 per dashboard per month
- **SNS**: $0.50 per million published messages

## Security Notes

- Security group allows SSH from anywhere (0.0.0.0/0)
- Consider restricting SSH access to specific IP ranges
- Ensure proper IAM roles and permissions
- Use VPC endpoints for CloudWatch if in private subnets

## Support

For issues or questions:
1. Check the main module documentation
2. Review CloudWatch documentation
3. Check AWS CloudWatch Agent documentation

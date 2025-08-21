# EC2 Instances with Logging Example

This example demonstrates how to create EC2 instances with comprehensive CloudWatch logging using the `terraform-ec2-wrapper` module.

## Features

- **Multiple EC2 Instances**: Creates web, app, and database servers
- **Comprehensive Logging**: Application, system, access, and error logs
- **Custom Log Groups**: Database and API specific log groups
- **Metric Filters**: Automatic error and access pattern detection
- **Log Alarms**: CloudWatch alarms for log rate monitoring
- **Alerting**: SNS topic for email notifications
- **Flexible Configuration**: Different logging settings for different server types

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Web Server    │    │   App Server    │    │ Database Server │
│   (web-server-1)│    │   (app-server-1)│    │(database-server-1)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Security Group │
                    │  (ec2-logging-sg)│
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  CloudWatch     │
                    │  Log Groups     │
                    │  • Application  │
                    │  • System       │
                    │  • Access       │
                    │  • Error        │
                    │  • Custom       │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  CloudWatch     │
                    │  Alarms         │
                    │  • Error Rate   │
                    │  • Access Rate  │
                    │  • Custom       │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  SNS Topic      │
                    │  (Alerts)       │
                    └─────────────────┘
```

## Logging Capabilities

### 1. **Application Logs**
- **Purpose**: Application-specific logs
- **Retention**: 30 days (configurable)
- **Stream**: Automatic log stream creation
- **Use Case**: Application debugging and monitoring

### 2. **System Logs**
- **Purpose**: Operating system and system service logs
- **Retention**: 30 days (configurable)
- **Stream**: Automatic log stream creation
- **Use Case**: System troubleshooting and security monitoring

### 3. **Access Logs**
- **Purpose**: Web server and application access logs
- **Retention**: 30 days (configurable)
- **Stream**: Automatic log stream creation
- **Use Case**: Traffic analysis and security monitoring

### 4. **Error Logs**
- **Purpose**: Error and exception logs
- **Retention**: 90 days (configurable)
- **Stream**: Automatic log stream creation
- **Use Case**: Error tracking and alerting

### 5. **Custom Log Groups**
- **Database Logs**: 60-day retention for database operations
- **API Logs**: 45-day retention for API calls
- **Flexible**: Add any custom log categories

## Metric Filters

### 1. **Error Detection**
- **Pattern**: `[timestamp, level=ERROR, message]`
- **Metric**: Error count per instance
- **Namespace**: `EC2/Logs`

### 2. **Access Pattern Detection**
- **Pattern**: `[timestamp, ip, method, path, status]`
- **Metric**: Access count per instance
- **Namespace**: `EC2/Logs`

### 3. **Custom Filters**
- **Database Errors**: `[timestamp, level=ERROR, database=*, message]`
- **API Errors**: `[timestamp, level=ERROR, api=*, message]`

## CloudWatch Alarms

### 1. **Error Log Alarms**
- **Threshold**: Configurable per instance
- **Web Server**: 3 errors per 5 minutes
- **App Server**: 5 errors per 5 minutes
- **Database Server**: 2 errors per 5 minutes

### 2. **Access Log Alarms**
- **Threshold**: Configurable per instance
- **App Server**: 300 requests per 5 minutes
- **Web Server**: 500 requests per 5 minutes

### 3. **Custom Alarms**
- **Database Errors**: 3 errors per 5 minutes
- **API Errors**: 5 errors per 5 minutes

## Prerequisites

1. **AWS CLI**: Configured with appropriate credentials
2. **Terraform**: Version 1.0 or later
3. **VPC and Subnet**: Existing VPC and subnet for EC2 instances
4. **EC2 Key Pair**: Existing key pair for SSH access
5. **SNS Email Subscription**: Email address for alerts

## Usage

### 1. **Clone and Navigate**
```bash
cd terraform-ec2-wrapper/examples/with-logging
```

### 2. **Configure Variables**
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. **Initialize Terraform**
```bash
terraform init
```

### 4. **Plan Deployment**
```bash
terraform plan
```

### 5. **Apply Configuration**
```bash
terraform apply
```

### 6. **Verify Deployment**
```bash
terraform output
```

## Configuration Options

### **Defaults Configuration**
```hcl
defaults = {
  # Enable logging
  create_logging = true
  
  # Log Group Settings
  create_application_log_group = true
  application_log_retention_days = 30
  
  create_system_log_group = true
  system_log_retention_days = 30
  
  create_access_log_group = true
  access_log_retention_days = 30
  
  create_error_log_group = true
  error_log_retention_days = 90
  
  # Metric Filters
  create_error_metric_filter = true
  create_access_metric_filter = true
  
  # Alarms
  create_error_log_alarm = true
  error_log_alarm_threshold = 5
  
  create_access_log_alarm = true
  access_log_alarm_threshold = 500
}
```

### **Instance-Specific Configuration**
```hcl
items = {
  web-server-1 = {
    name = "web-server-1"
    create_error_log_alarm = true
    error_log_alarm_threshold = 3
    tags = { 
      Role = "web-server"
      Component = "frontend"
    }
  }
}
```

## Outputs

### **Instance Information**
- `instance_ids`: Map of instance IDs
- `instance_public_ips`: Map of public IP addresses
- `instance_private_ips`: Map of private IP addresses

### **Logging Resources**
- `logging_log_groups`: Map of log group resources
- `logging_log_group_names`: Map of log group names
- `logging_log_group_arns`: Map of log group ARNs
- `logging_log_streams`: Map of log stream resources
- `logging_metric_filters`: Map of metric filter resources
- `logging_alarms`: Map of log alarm resources
- `logging_summaries`: Map of logging summaries

### **Security and Networking**
- `security_group_ids`: Map of security group IDs
- `eip_public_ips`: Map of EIP public IPs

## CloudWatch Agent Setup

To send logs from EC2 instances to CloudWatch, you'll need to install and configure the CloudWatch Agent:

### **1. Install CloudWatch Agent**
```bash
# Amazon Linux 2
sudo yum install -y amazon-cloudwatch-agent

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y amazon-cloudwatch-agent
```

### **2. Configure CloudWatch Agent**
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

### **3. Start CloudWatch Agent**
```bash
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent
```

### **4. Example Configuration**
```json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/application.log",
            "log_group_name": "web-server-1-application-logs",
            "log_stream_name": "web-server-1-application-stream",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "web-server-1-system-logs",
            "log_stream_name": "web-server-1-system-stream",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "web-server-1-access-logs",
            "log_stream_name": "web-server-1-access-stream",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "web-server-1-error-logs",
            "log_stream_name": "web-server-1-error-stream",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
```

## Monitoring and Alerting

### **1. CloudWatch Console**
- Navigate to CloudWatch > Logs to view log groups
- Check CloudWatch > Alarms for active alarms
- Use CloudWatch > Metrics to view custom metrics

### **2. SNS Notifications**
- Email notifications for log rate alarms
- Configure additional notification channels (SMS, Lambda, etc.)

### **3. Log Analysis**
- Use CloudWatch Logs Insights for querying logs
- Set up log-based metrics for custom dashboards
- Configure log retention policies

## Cleanup

### **1. Destroy Resources**
```bash
terraform destroy
```

### **2. Manual Cleanup**
- Delete any remaining CloudWatch log groups
- Remove SNS topic subscriptions
- Clean up any manual CloudWatch alarms

## Cost Considerations

### **CloudWatch Logs Pricing**
- **Ingestion**: $0.50 per GB ingested
- **Storage**: $0.03 per GB per month
- **Analysis**: $0.005 per GB scanned

### **CloudWatch Alarms**
- **Standard Resolution**: $0.10 per alarm metric per month
- **High Resolution**: $0.30 per alarm metric per month

### **SNS**
- **Publishing**: $0.50 per million requests
- **Delivery**: $0.06 per 100,000 notifications

## Security Notes

### **1. IAM Permissions**
- EC2 instances need CloudWatch Logs permissions
- Use least privilege principle for IAM roles

### **2. Log Encryption**
- Enable KMS encryption for sensitive logs
- Use customer-managed keys for compliance

### **3. Access Control**
- Restrict CloudWatch access to authorized users
- Use CloudTrail for API call logging

### **4. Data Retention**
- Configure appropriate retention periods
- Consider compliance requirements (GDPR, HIPAA, etc.)

## Troubleshooting

### **Common Issues**

1. **Logs Not Appearing**
   - Check CloudWatch Agent configuration
   - Verify IAM permissions
   - Check log file paths and permissions

2. **Alarms Not Triggering**
   - Verify metric filter patterns
   - Check alarm thresholds and periods
   - Ensure logs are being ingested

3. **High Costs**
   - Review log retention policies
   - Optimize metric filter patterns
   - Consider log sampling for high-volume logs

### **Useful Commands**
```bash
# Check CloudWatch Agent status
sudo systemctl status amazon-cloudwatch-agent

# View CloudWatch Agent logs
sudo tail -f /var/log/amazon/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log

# Test log ingestion
aws logs describe-log-groups --log-group-name-prefix "web-server-1"

# Check alarm status
aws cloudwatch describe-alarms --alarm-names "web-server-1-error-log-alarm"
```

## Support

For issues and questions:
1. Check the [terraform-ec2-wrapper documentation](../README.md)
2. Review CloudWatch Logs [AWS documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/)
3. Open an issue in the GitHub repository

## License

This example is provided under the same license as the terraform-ec2-wrapper module.

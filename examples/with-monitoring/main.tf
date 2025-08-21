# =============================================================================
# EC2 Instances with Monitoring Example
# =============================================================================
# This example demonstrates how to create EC2 instances with comprehensive
# CloudWatch monitoring including alarms and dashboards

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# =============================================================================
# EC2 INSTANCES WITH MONITORING
# =============================================================================

module "ec2_instances_with_monitoring" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  # =============================================================================
  # SHARED CONFIGURATION (DEFAULTS)
  # =============================================================================
  defaults = {
    # Basic EC2 Configuration
    instance_type = "t3.micro"
    ami           = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI (us-east-1)
    subnet_id     = var.subnet_id
    key_name      = var.key_name

    # Security Group Configuration
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    # Monitoring Configuration
    create_monitoring = true

    # CPU Alarm Configuration
    create_cpu_alarm = true
    cpu_threshold = 75
    cpu_evaluation_periods = 2
    cpu_period = 300
    cpu_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    # Memory Alarm Configuration (requires CloudWatch Agent)
    create_memory_alarm = true
    memory_threshold = 80
    memory_evaluation_periods = 2
    memory_period = 300
    memory_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    # Disk Alarm Configuration (requires CloudWatch Agent)
    create_disk_alarm = true
    disk_threshold = 85
    disk_evaluation_periods = 2
    disk_period = 300
    disk_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    # Network Alarm Configuration
    create_network_in_alarm = true
    network_in_threshold = 500000000  # 500 MB
    network_in_evaluation_periods = 2
    network_in_period = 300
    network_in_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    create_network_out_alarm = true
    network_out_threshold = 500000000  # 500 MB
    network_out_evaluation_periods = 2
    network_out_period = 300
    network_out_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    # Status Check Alarm Configuration
    create_status_check_alarm = true
    status_check_evaluation_periods = 2
    status_check_period = 60
    status_check_alarm_actions = [aws_sns_topic.monitoring_alerts.arn]

    # Dashboard Configuration
    create_dashboard = true
    dashboard_period = 300
    dashboard_stat = "Average"

    # Tags
    tags = {
      Environment = "production"
      Project     = "monitoring-demo"
      Owner       = "devops-team"
    }
  }

  # =============================================================================
  # INDIVIDUAL INSTANCE CONFIGURATIONS
  # =============================================================================
  items = {
    web-server-1 = {
      name = "web-server-1"
      
      # Instance-specific monitoring overrides
      cpu_threshold = 70  # Lower threshold for web server
      memory_threshold = 75
      
      # Custom alarm names
      cpu_alarm_name = "web-server-1-cpu-high"
      memory_alarm_name = "web-server-1-memory-high"
      
      # Custom dashboard title
      dashboard_cpu_title = "Web Server 1 - CPU & Network Metrics"
      dashboard_system_title = "Web Server 1 - System Metrics"
      
      # Instance-specific tags
      tags = {
        Role = "web-server"
        Tier = "frontend"
      }
    }

    app-server-1 = {
      name = "app-server-1"
      
      # Different thresholds for app server
      cpu_threshold = 85  # Higher threshold for app server
      memory_threshold = 90
      disk_threshold = 90
      
      # Custom alarm names
      cpu_alarm_name = "app-server-1-cpu-high"
      memory_alarm_name = "app-server-1-memory-high"
      disk_alarm_name = "app-server-1-disk-high"
      
      # Custom dashboard configuration
      dashboard_cpu_title = "App Server 1 - CPU & Network Metrics"
      dashboard_system_title = "App Server 1 - System Metrics"
      
      # Instance-specific tags
      tags = {
        Role = "app-server"
        Tier = "backend"
      }
    }

    db-server-1 = {
      name = "db-server-1"
      
      # Conservative thresholds for database server
      cpu_threshold = 60
      memory_threshold = 70
      disk_threshold = 80
      
      # Custom alarm names
      cpu_alarm_name = "db-server-1-cpu-high"
      memory_alarm_name = "db-server-1-memory-high"
      disk_alarm_name = "db-server-1-disk-high"
      
      # Custom dashboard configuration
      dashboard_cpu_title = "DB Server 1 - CPU & Network Metrics"
      dashboard_system_title = "DB Server 1 - System Metrics"
      
      # Instance-specific tags
      tags = {
        Role = "database"
        Tier = "data"
      }
    }
  }
}

# =============================================================================
# SECURITY GROUP
# =============================================================================

resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-monitoring-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Monitoring Security Group"
  }
}

# =============================================================================
# SNS TOPIC FOR ALERTS
# =============================================================================

resource "aws_sns_topic" "monitoring_alerts" {
  name = "ec2-monitoring-alerts"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.monitoring_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# =============================================================================
# OUTPUTS
# =============================================================================

output "instance_ids" {
  description = "IDs of created EC2 instances"
  value       = module.ec2_instances_with_monitoring.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs of created EC2 instances"
  value       = module.ec2_instances_with_monitoring.instance_public_ips
}

output "monitoring_alarms" {
  description = "Monitoring alarms created for each instance"
  value       = module.ec2_instances_with_monitoring.monitoring_alarms
}

output "monitoring_dashboards" {
  description = "Monitoring dashboards created for each instance"
  value       = module.ec2_instances_with_monitoring.monitoring_dashboards
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value       = module.ec2_instances_with_monitoring.deployment_summary
}

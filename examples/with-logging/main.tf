# =============================================================================
# EC2 Instances with Logging Example
# =============================================================================
# This example demonstrates how to create EC2 instances with comprehensive
# CloudWatch logging using the terraform-ec2-wrapper module.

# SNS Topic for logging alerts
resource "aws_sns_topic" "logging_alerts" {
  name = "ec2-logging-alerts"
  tags = {
    Environment = "production"
    Purpose     = "EC2 Logging Alerts"
  }
}

# SNS Topic Subscription for email notifications
resource "aws_sns_topic_subscription" "logging_email" {
  topic_arn = aws_sns_topic.logging_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-logging-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name        = "ec2-logging-security-group"
    Environment = "production"
    Purpose     = "EC2 Logging Demo"
  }
}

# EC2 Instances with Logging
module "ec2_instances_with_logging" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    ami           = "ami-0c02fb55956c7d316"
    subnet_id     = var.subnet_id
    key_name      = var.key_name
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    
    # Enable logging
    create_logging = true
    
    # Application Log Group Configuration
    create_application_log_group = true
    application_log_retention_days = 30
    create_application_log_stream = true
    
    # System Log Group Configuration
    create_system_log_group = true
    system_log_retention_days = 30
    create_system_log_stream = true
    
    # Access Log Group Configuration
    create_access_log_group = true
    access_log_retention_days = 30
    create_access_log_stream = true
    
    # Error Log Group Configuration
    create_error_log_group = true
    error_log_retention_days = 90
    create_error_log_stream = true
    
    # Metric Filter Configuration
    create_error_metric_filter = true
    error_metric_filter_pattern = "[timestamp, level=ERROR, message]"
    error_metric_namespace = "EC2/Logs"
    
    create_access_metric_filter = true
    access_metric_filter_pattern = "[timestamp, ip, method, path, status]"
    access_metric_namespace = "EC2/Logs"
    
    # Log Alarm Configuration
    create_error_log_alarm = true
    error_log_alarm_threshold = 5
    error_log_alarm_actions = [aws_sns_topic.logging_alerts.arn]
    
    create_access_log_alarm = true
    access_log_alarm_threshold = 500
    access_log_alarm_actions = [aws_sns_topic.logging_alerts.arn]
    
    # Custom Log Groups
    custom_log_groups = {
      database = {
        retention_days = 60
        tags = {
          LogType = "database"
          Environment = "production"
        }
      }
      api = {
        retention_days = 45
        tags = {
          LogType = "api"
          Environment = "production"
        }
      }
    }
    
    # Custom Log Streams
    custom_log_streams = {
      database_stream = {
        log_group_key = "database"
      }
      api_stream = {
        log_group_key = "api"
      }
    }
    
    # Custom Metric Filters
    custom_metric_filters = {
      database_errors = {
        pattern = "[timestamp, level=ERROR, database=*, message]"
        log_group_key = "database"
        metric_name = "database-error-count"
        metric_namespace = "EC2/Database"
      }
      api_errors = {
        pattern = "[timestamp, level=ERROR, api=*, message]"
        log_group_key = "api"
        metric_name = "api-error-count"
        metric_namespace = "EC2/API"
      }
    }
    
    # Custom Log Alarms
    custom_log_alarms = {
      database_errors = {
        comparison_operator = "GreaterThanThreshold"
        evaluation_periods = 2
        period = 300
        statistic = "Sum"
        threshold = 3
        alarm_description = "Database error rate alarm"
        alarm_actions = [aws_sns_topic.logging_alerts.arn]
        metric_name = "database-error-count"
        metric_namespace = "EC2/Database"
      }
      api_errors = {
        comparison_operator = "GreaterThanThreshold"
        evaluation_periods = 2
        period = 300
        statistic = "Sum"
        threshold = 5
        alarm_description = "API error rate alarm"
        alarm_actions = [aws_sns_topic.logging_alerts.arn]
        metric_name = "api-error-count"
        metric_namespace = "EC2/API"
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "logging-demo"
      ManagedBy   = "terraform"
    }
  }
  
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
    
    app-server-1 = {
      name = "app-server-1"
      create_error_log_alarm = true
      error_log_alarm_threshold = 5
      create_access_log_alarm = true
      access_log_alarm_threshold = 300
      tags = { 
        Role = "app-server"
        Component = "backend"
      }
    }
    
    database-server-1 = {
      name = "database-server-1"
      create_error_log_alarm = true
      error_log_alarm_threshold = 2
      error_log_retention_days = 120
      tags = { 
        Role = "database-server"
        Component = "database"
      }
    }
  }
}

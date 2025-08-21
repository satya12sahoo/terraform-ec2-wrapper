# Example: Using terraform-ec2-wrapper with infrastructure modules
# This demonstrates how to integrate the wrapper with autoscaling, load balancers, and monitoring

# =============================================================================
# EC2 Instances using the wrapper
# =============================================================================

module "ec2_instances" {
  source = "../../"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Security group configuration (handled by wrapper)
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
    }
    
    # IAM configuration (handled by wrapper)
    create_iam_instance_profile = true
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    
    tags = {
      Environment = "production"
      Project     = "my-project"
      ManagedBy   = "terraform-ec2-wrapper"
    }
  }

  items = {
    web-server-1 = {
      name = "web-server-1"
      
      # Instance-specific security group rules
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTP access"
        }
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTPS access"
        }
      }
      
      tags = {
        Role = "web-server"
      }
    }
    
    web-server-2 = {
      name = "web-server-2"
      
      # Same security group configuration as web-server-1
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTP access"
        }
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTPS access"
        }
      }
      
      tags = {
        Role = "web-server"
      }
    }
    
    database-server = {
      name         = "database-server"
      instance_type = "t3.small"
      
      # Database-specific security group rules
      security_group_ingress_rules = {
        postgres = {
          from_port   = 5432
          to_port     = 5432
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "PostgreSQL access from VPC"
        }
      }
      
      tags = {
        Role = "database"
      }
    }
  }
}

# =============================================================================
# Load Balancer (using terraform-aws-ec2-base/load-balancer)
# =============================================================================

module "load_balancer" {
  source = "../../../terraform-aws-ec2-base/load-balancer"
  
  # Use instance IDs from the wrapper
  instance_ids = values(module.ec2_instances.instance_ids)
  
  # Load balancer configuration
  create_load_balancer = true
  lb_name = "web-lb"
  lb_internal = false
  lb_type = "application"
  
  # Target group configuration
  target_group_name = "web-target-group"
  target_group_port = 80
  target_group_protocol = "HTTP"
  
  # Listener configuration
  listener_port = 80
  listener_protocol = "HTTP"
  
  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "my-project"
    Module      = "load-balancer"
  }
}

# =============================================================================
# Autoscaling Group (using terraform-aws-ec2-base/autoscaling)
# =============================================================================

module "autoscaling" {
  source = "../../../terraform-aws-ec2-base/autoscaling"
  
  # Use instance IDs from the wrapper
  instance_ids = values(module.ec2_instances.instance_ids)
  
  # Autoscaling configuration
  create_auto_scaling_group = true
  asg_name = "web-asg"
  desired_capacity = 2
  max_size = 5
  min_size = 1
  
  # Launch template (you would need to create this separately)
  launch_template_name = "web-launch-template"
  launch_template_version = "$Latest"
  
  # Health check configuration
  health_check_type = "ELB"
  health_check_grace_period = 300
  
  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "my-project"
    Module      = "autoscaling"
  }
}

# =============================================================================
# CloudWatch Monitoring (using terraform-aws-ec2-base/cloudwatch)
# =============================================================================

module "cloudwatch" {
  source = "../../../terraform-aws-ec2-base/cloudwatch"
  
  # Use instance IDs from the wrapper
  instance_ids = values(module.ec2_instances.instance_ids)
  
  # CloudWatch configuration
  create_cloudwatch_alarms = true
  create_cloudwatch_dashboard = true
  
  # CPU alarm configuration
  cpu_alarm_name = "web-cpu-alarm"
  cpu_alarm_threshold = 80
  cpu_alarm_period = 300
  
  # Memory alarm configuration
  memory_alarm_name = "web-memory-alarm"
  memory_alarm_threshold = 85
  memory_alarm_period = 300
  
  # Dashboard configuration
  dashboard_name = "web-dashboard"
  
  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "my-project"
    Module      = "cloudwatch"
  }
}

# =============================================================================
# VPC Endpoints (using terraform-aws-ec2-base/vpc-endpoints)
# =============================================================================

module "vpc_endpoints" {
  source = "../../../terraform-aws-ec2-base/vpc-endpoints"
  
  # VPC endpoints configuration
  create_vpc_endpoints = true
  vpc_id = "vpc-12345678"  # Replace with your VPC ID
  
  # S3 endpoint
  s3_endpoint_enabled = true
  
  # DynamoDB endpoint
  dynamodb_endpoint_enabled = true
  
  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "my-project"
    Module      = "vpc-endpoints"
  }
}

# =============================================================================
# Outputs
# =============================================================================

# Instance outputs
output "instance_ids" {
  description = "IDs of created instances"
  value       = module.ec2_instances.instance_ids
}

output "instance_public_ips" {
  description = "Public IP addresses of created instances"
  value       = module.ec2_instances.instance_public_ips
}

# Load balancer outputs
output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = module.load_balancer.load_balancer_dns_name
}

output "load_balancer_arn" {
  description = "ARN of the load balancer"
  value       = module.load_balancer.load_balancer_arn
}

# Autoscaling outputs
output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = module.autoscaling.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "ARN of the autoscaling group"
  value       = module.autoscaling.autoscaling_group_arn
}

# CloudWatch outputs
output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = module.cloudwatch.cloudwatch_dashboard_name
}

output "cloudwatch_alarm_names" {
  description = "Names of the CloudWatch alarms"
  value       = module.cloudwatch.cloudwatch_alarm_names
}

# VPC Endpoints outputs
output "vpc_endpoint_ids" {
  description = "IDs of the VPC endpoints"
  value       = module.vpc_endpoints.vpc_endpoint_ids
}

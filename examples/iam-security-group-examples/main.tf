# =============================================================================
# IAM Role and Security Group Examples
# =============================================================================
# This example demonstrates how terraform-aws-ec2-instance handles:
# 1. Creating IAM roles and security groups from scratch
# 2. Using existing IAM roles and security groups
# 3. Mixed scenarios (create one, use existing for the other)

# =============================================================================
# Example 1: Create Everything from Scratch
# =============================================================================

module "ec2_with_created_resources" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Create IAM role and instance profile from scratch
    create_iam_instance_profile = true
    iam_role_name = "ec2-instance-role"
    iam_role_description = "IAM role for EC2 instances"
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
      cloudwatch_agent = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    }
    
    # Create security group from scratch
    create_security_group = true
    security_group_name = "ec2-instance-sg"
    security_group_description = "Security group for EC2 instances"
    security_group_egress_rules = {
      all_traffic = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all outbound traffic"
        ip_protocol = "-1"
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "example"
      ManagedBy   = "terraform"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      
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
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
    }
  }
}

# =============================================================================
# Example 2: Use Existing Resources
# =============================================================================

# First, create existing IAM role and security group
resource "aws_iam_role" "existing_role" {
  name = "existing-ec2-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name = "existing-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "existing_role_policy" {
  role       = aws_iam_role.existing_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "existing_profile" {
  name = "existing-ec2-profile"
  role = aws_iam_role.existing_role.name
}

resource "aws_security_group" "existing_sg" {
  name        = "existing-ec2-sg"
  description = "Existing security group for EC2 instances"
  vpc_id      = "vpc-12345678"  # Replace with your VPC ID
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "SSH access from VPC"
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name = "existing-ec2-sg"
  }
}

module "ec2_with_existing_resources" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Use existing IAM instance profile
    create_iam_instance_profile = false
    iam_instance_profile = aws_iam_instance_profile.existing_profile.name
    
    # Use existing security group
    create_security_group = false
    vpc_security_group_ids = [aws_security_group.existing_sg.id]
    
    tags = {
      Environment = "production"
      Project     = "example"
      ManagedBy   = "terraform"
    }
  }

  items = {
    app-server = {
      name = "app-server"
      # No security group rules needed - using existing security group
    }
  }
}

# =============================================================================
# Example 3: Mixed Scenario - Create IAM, Use Existing Security Group
# =============================================================================

module "ec2_mixed_scenario" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Create IAM role and instance profile from scratch
    create_iam_instance_profile = true
    iam_role_name = "mixed-scenario-role"
    iam_role_description = "IAM role for mixed scenario"
    iam_role_policies = {
      s3_full_access = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    }
    
    # Use existing security group
    create_security_group = false
    vpc_security_group_ids = [aws_security_group.existing_sg.id]
    
    tags = {
      Environment = "production"
      Project     = "example"
      ManagedBy   = "terraform"
    }
  }

  items = {
    database-server = {
      name = "database-server"
      instance_type = "t3.small"
      # No security group rules needed - using existing security group
    }
  }
}

# =============================================================================
# Example 4: Mixed Scenario - Use Existing IAM, Create Security Group
# =============================================================================

module "ec2_mixed_scenario_2" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Use existing IAM instance profile
    create_iam_instance_profile = false
    iam_instance_profile = aws_iam_instance_profile.existing_profile.name
    
    # Create security group from scratch
    create_security_group = true
    security_group_name = "mixed-scenario-2-sg"
    security_group_description = "Security group for mixed scenario 2"
    security_group_egress_rules = {
      all_traffic = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all outbound traffic"
        ip_protocol = "-1"
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "example"
      ManagedBy   = "terraform"
    }
  }

  items = {
    monitoring-server = {
      name = "monitoring-server"
      
      # Instance-specific security group rules
      security_group_ingress_rules = {
        prometheus = {
          from_port   = 9090
          to_port     = 9090
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "Prometheus metrics endpoint"
        }
        grafana = {
          from_port   = 3000
          to_port     = 3000
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "Grafana dashboard"
        }
      }
    }
  }
}

# =============================================================================
# Example 5: Multiple Instances with Different Configurations
# =============================================================================

module "ec2_multiple_configurations" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Default: Create IAM role and security group
    create_iam_instance_profile = true
    iam_role_name = "multi-config-role"
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    
    create_security_group = true
    security_group_egress_rules = {
      all_traffic = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all outbound traffic"
        ip_protocol = "-1"
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "example"
      ManagedBy   = "terraform"
    }
  }

  items = {
    # Instance 1: Use defaults (create IAM and security group)
    web-server-1 = {
      name = "web-server-1"
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTP access"
        }
      }
    }
    
    # Instance 2: Use existing IAM, create new security group
    web-server-2 = {
      name = "web-server-2"
      create_iam_instance_profile = false
      iam_instance_profile = aws_iam_instance_profile.existing_profile.name
      # Will create its own security group with different rules
      security_group_ingress_rules = {
        https = {
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "HTTPS access"
        }
      }
    }
    
    # Instance 3: Use existing security group, create new IAM
    app-server = {
      name = "app-server"
      create_security_group = false
      vpc_security_group_ids = [aws_security_group.existing_sg.id]
      # Will create its own IAM role
      iam_role_policies = {
        dynamodb_access = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
      }
    }
    
    # Instance 4: Use existing IAM and security group
    monitoring-server = {
      name = "monitoring-server"
      create_iam_instance_profile = false
      iam_instance_profile = aws_iam_instance_profile.existing_profile.name
      create_security_group = false
      vpc_security_group_ids = [aws_security_group.existing_sg.id]
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

# Outputs for created resources example
output "created_resources_instance_id" {
  description = "Instance ID from created resources example"
  value       = module.ec2_with_created_resources.instance_ids["web-server"]
}

output "created_resources_iam_role_arn" {
  description = "IAM role ARN from created resources example"
  value       = module.ec2_with_created_resources.iam_role_arns["web-server"]
}

output "created_resources_security_group_id" {
  description = "Security group ID from created resources example"
  value       = module.ec2_with_created_resources.security_group_ids["web-server"]
}

# Outputs for existing resources example
output "existing_resources_instance_id" {
  description = "Instance ID from existing resources example"
  value       = module.ec2_with_existing_resources.instance_ids["app-server"]
}

# Outputs for mixed scenarios
output "mixed_scenario_instance_id" {
  description = "Instance ID from mixed scenario example"
  value       = module.ec2_mixed_scenario.instance_ids["database-server"]
}

output "mixed_scenario_2_instance_id" {
  description = "Instance ID from mixed scenario 2 example"
  value       = module.ec2_mixed_scenario_2.instance_ids["monitoring-server"]
}

# Outputs for multiple configurations
output "multiple_config_instances" {
  description = "All instance IDs from multiple configurations example"
  value       = module.ec2_multiple_configurations.instance_ids
}

# Existing resource outputs
output "existing_iam_role_arn" {
  description = "ARN of the existing IAM role"
  value       = aws_iam_role.existing_role.arn
}

output "existing_security_group_id" {
  description = "ID of the existing security group"
  value       = aws_security_group.existing_sg.id
}

# =============================================================================
# Scenario 1: IAM Role WITHOUT Instance Profile
# =============================================================================
# This example shows how to use the wrapper when you have an existing IAM role
# that doesn't have an instance profile. The wrapper will create the instance profile.

# =============================================================================
# Main Configuration
# =============================================================================

module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  # Default configuration for all instances
  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Toggle flag to enable instance profile creation for existing IAM roles
    create_instance_profiles_for_existing_roles = true
    
    # Use the instance profile created by the wrapper
    create_iam_instance_profile = false  # Don't create new IAM role/profile
    
    # Security group configuration
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
      ipv6_default = {
        cidr_ipv6   = "::/0"
        description = "Allow all IPv6 traffic"
        ip_protocol = "-1"
      }
    }
    
    # Metadata options
    metadata_options = {
      http_endpoint               = "enabled"
      http_put_response_hop_limit = 1
      http_tokens                 = "required"
    }
    
    # Common tags for all resources
    common_tags = {
      Environment = "production"
      Project     = "my-project"
      ManagedBy   = "terraform"
    }
    
    tags = {
      Environment = "production"
      Project     = "my-project"
      ManagedBy   = "terraform"
    }
  }

  # Individual instance configurations
  items = {
    web-server-1 = {
      name = "web-server-1"
      
      # Instance profile configuration for existing IAM role
      iam_role_name = "existing-web-server-role"  # Replace with your existing IAM role name
      instance_profile_name = "web-server-instance-profile"
      instance_profile_description = "Instance profile for web server IAM role"
      
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
      
      tags = {
        Role = "web-server"
      }
    }
    
    web-server-2 = {
      name = "web-server-2"
      
      # Instance profile configuration for existing IAM role
      iam_role_name = "existing-web-server-role"  # Same role as web-server-1
      instance_profile_name = "web-server-instance-profile"  # Same profile as web-server-1
      
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
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      tags = {
        Role = "web-server"
      }
    }
    
    database-server = {
      name         = "database-server"
      instance_type = "t3.small"
      
      # Instance profile configuration for existing IAM role
      iam_role_name = "existing-database-role"  # Replace with your existing IAM role name
      instance_profile_name = "database-instance-profile"
      instance_profile_description = "Instance profile for database IAM role"
      
      # Database-specific security group rules
      security_group_ingress_rules = {
        postgres = {
          from_port   = 5432
          to_port     = 5432
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "PostgreSQL access from VPC"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      tags = {
        Role = "database"
      }
    }
  }
}

# =============================================================================
# Outputs
# =============================================================================

# Instance Profile Outputs (created by wrapper)
output "instance_profile_names" {
  description = "Names of the created instance profiles"
  value       = module.ec2_instances.instance_profile_names
}

output "instance_profile_arns" {
  description = "ARNs of the created instance profiles"
  value       = module.ec2_instances.instance_profile_arns
}

# EC2 Instance Outputs
output "instance_ids" {
  description = "IDs of created instances"
  value       = module.ec2_instances.instance_ids
}

output "instance_public_ips" {
  description = "Public IP addresses of created instances"
  value       = module.ec2_instances.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IP addresses of created instances"
  value       = module.ec2_instances.instance_private_ips
}

output "iam_instance_profile_arns" {
  description = "IAM instance profile ARNs used by instances"
  value       = module.ec2_instances.iam_instance_profile_arns
}

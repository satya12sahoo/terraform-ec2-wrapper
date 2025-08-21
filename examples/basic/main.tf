# Basic example of using the terraform-ec2-wrapper module

module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Security group configuration
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server-1 = {
      name = "web-server-1"
      
      # Override security group for this instance
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
      
      # Use the same security group configuration as web-server-1
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
      
      # Override security group for database
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

# Output some useful information
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

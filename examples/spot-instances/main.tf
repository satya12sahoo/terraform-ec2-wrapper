# Spot instance example of using the terraform-ec2-wrapper module

module "ec2_spot_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Spot instance defaults
    create_spot_instance = true
    spot_type           = "persistent"
    spot_instance_interruption_behavior = "stop"
    
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
      Environment = "development"
      Project     = "my-project"
      InstanceType = "spot"
    }
  }

  items = {
    spot-instance-1 = {
      name = "spot-instance-1"
      spot_price = "0.01"
      
      # Basic security group for development
      security_group_ingress_rules = {
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      tags = {
        Role = "development"
      }
    }
    
    spot-instance-2 = {
      name = "spot-instance-2"
      spot_price = "0.015"
      instance_type = "t3.small"
      
      # Same security group as instance 1
      security_group_ingress_rules = {
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
      }
      
      tags = {
        Role = "development"
      }
    }
    
    spot-instance-3 = {
      name = "spot-instance-3"
      spot_price = "0.02"
      instance_type = "t3.medium"
      
      # Different security group for this instance
      security_group_ingress_rules = {
        ssh = {
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "SSH access from VPC"
        }
        web = {
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
          description = "Web application access"
        }
      }
      
      tags = {
        Role = "web-application"
      }
    }
  }
}

# Output spot instance information
output "spot_instance_ids" {
  description = "IDs of created spot instances"
  value       = module.ec2_spot_instances.instance_ids
}

output "spot_bid_statuses" {
  description = "Bid statuses of spot instances"
  value       = module.ec2_spot_instances.spot_bid_statuses
}

output "spot_request_states" {
  description = "Request states of spot instances"
  value       = module.ec2_spot_instances.spot_request_states
}

output "instance_public_ips" {
  description = "Public IP addresses of created instances"
  value       = module.ec2_spot_instances.instance_public_ips
}

output "instance_private_ips" {
  description = "Private IP addresses of created instances"
  value       = module.ec2_spot_instances.instance_private_ips
}

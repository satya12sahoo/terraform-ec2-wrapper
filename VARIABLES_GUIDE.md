# Terraform EC2 Wrapper - Variables Guide

This guide shows how to use all variables from `terraform-aws-ec2-instance` and `terraform-aws-ec2-base/iam` modules within the wrapper's `defaults` and `items` structure.

## Core Variables

The wrapper module has only 3 core variables:

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `defaults` | Shared configuration for all instances | `any` | `{}` |
| `items` | Individual instance configurations | `any` | `{}` |
| `create_instance_profiles_for_existing_roles` | Toggle for instance profile creation | `bool` | `false` |

## Using Variables in `defaults` and `items`

All variables from the underlying modules can be used in both `defaults` and `items`. The wrapper passes these through to the `terraform-aws-ec2-instance` module.

### Example Structure

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  # Toggle for instance profile creation
  create_instance_profiles_for_existing_roles = true

  # Shared configuration for all instances
  defaults = {
    # EC2 Instance variables
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Security Group variables
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
    }
    
    # IAM variables
    create_iam_instance_profile = false
    
    # Common tags
    common_tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  # Individual instance configurations
  items = {
    web-server-1 = {
      # Instance-specific variables
      name = "web-server-1"
      
      # IAM instance profile variables (for existing roles)
      iam_role_name = "existing-web-role"
      instance_profile_name = "web-instance-profile"
      
      # Security group variables
      security_group_ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
      
      # Instance-specific tags
      tags = {
        Role = "web-server"
      }
    }
  }
}
```

## Available Variables by Category

### EC2 Instance Variables

#### Basic Instance Configuration
```hcl
defaults = {
  # Core instance settings
  ami                    = "ami-12345678"
  ami_ssm_parameter      = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-12345678"
  availability_zone      = "us-west-2a"
  
  # Instance behavior
  disable_api_termination = false
  disable_api_stop        = false
  instance_initiated_shutdown_behavior = "stop"
  
  # Networking
  associate_public_ip_address = true
  private_ip                  = "10.0.1.100"
  source_dest_check           = true
  
  # Monitoring and metadata
  monitoring = true
  metadata_options = {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
}
```

#### Storage Configuration
```hcl
defaults = {
  # Root block device
  root_block_device = [{
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }]
  
  # Additional EBS volumes
  ebs_volumes = [{
    device_name = "/dev/sdf"
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }]
  
  # Ephemeral block devices
  ephemeral_block_device = [{
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }]
  
  # Volume tags
  volume_tags = {
    Backup = "true"
  }
}
```

#### Security Group Configuration
```hcl
defaults = {
  # Security group settings
  create_security_group = true
  security_group_name   = "my-security-group"
  security_group_description = "Security group for web servers"
  
  # Egress rules (outbound traffic)
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
}

items = {
  web-server = {
    # Ingress rules (inbound traffic)
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
```

#### IAM Configuration
```hcl
defaults = {
  # IAM instance profile settings
  create_iam_instance_profile = false  # Use existing or let wrapper create
  iam_instance_profile        = "existing-instance-profile"
  
  # IAM role settings (if creating new)
  iam_role_name        = "ec2-role"
  iam_role_description = "Role for EC2 instances"
  iam_role_path        = "/"
  iam_role_policies    = {
    s3_access = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }
}

items = {
  web-server = {
    # For existing IAM roles (when create_instance_profiles_for_existing_roles = true)
    iam_role_name = "existing-web-role"
    instance_profile_name = "web-instance-profile"
    instance_profile_description = "Instance profile for web server"
    instance_profile_path = "/"
    instance_profile_tags = {
      Purpose = "Web Server"
    }
  }
}
```

#### Spot Instance Configuration
```hcl
defaults = {
  # Spot instance settings
  create_spot_instance = true
  spot_price           = "0.05"
  spot_type            = "persistent"
  spot_instance_interruption_behavior = "stop"
  spot_launch_group    = "web-servers"
  spot_wait_for_fulfillment = true
}
```

#### Elastic IP Configuration
```hcl
defaults = {
  # EIP settings
  create_eip = true
  eip_domain = "vpc"
  eip_tags = {
    Purpose = "Web Server EIP"
  }
}
```

#### Advanced Configuration
```hcl
defaults = {
  # CPU options
  cpu_options = {
    core_count       = 2
    threads_per_core = 2
  }
  
  # Capacity reservation
  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }
  
  # Launch template
  launch_template = {
    id      = "lt-12345678"
    version = "$Latest"
  }
  
  # User data
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  
  # Timeouts
  timeouts = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
```

### IAM Instance Profile Variables (for Existing Roles)

When `create_instance_profiles_for_existing_roles = true`, you can use these variables in `items`:

```hcl
items = {
  web-server = {
    # Required variables
    iam_role_name = "existing-web-role"
    instance_profile_name = "web-instance-profile"
    
    # Optional variables
    instance_profile_description = "Instance profile for web server"
    instance_profile_path = "/"
    instance_profile_tags = {
      Purpose = "Web Server"
      Environment = "Production"
    }
    enable_instance_profile_rotation = false
    instance_profile_permissions_boundary = "arn:aws:iam::123456789012:policy/PermissionsBoundary"
  }
}
```

## Variable Precedence

Variables are resolved in this order:
1. `items[each.key].variable_name` (instance-specific)
2. `defaults.variable_name` (shared defaults)
3. Module's default value

## Common Patterns

### Multiple Instances with Shared Configuration
```hcl
defaults = {
  instance_type = "t3.micro"
  subnet_id     = "subnet-12345678"
  create_security_group = true
  create_iam_instance_profile = false
}

items = {
  web-server-1 = {
    name = "web-server-1"
    # Uses defaults for instance_type, subnet_id, etc.
  }
  web-server-2 = {
    name = "web-server-2"
    # Uses defaults for instance_type, subnet_id, etc.
  }
  database-server = {
    name = "database-server"
    instance_type = "t3.small"  # Override default
    # Uses defaults for other settings
  }
}
```

### Instance Profile Creation for Existing Roles
```hcl
defaults = {
  create_instance_profiles_for_existing_roles = true
  create_iam_instance_profile = false
}

items = {
  web-server = {
    name = "web-server"
    iam_role_name = "existing-web-role"
    instance_profile_name = "web-instance-profile"
  }
  database-server = {
    name = "database-server"
    iam_role_name = "existing-database-role"
    instance_profile_name = "database-instance-profile"
  }
}
```

### Using Existing Instance Profiles
```hcl
defaults = {
  create_instance_profiles_for_existing_roles = false
  create_iam_instance_profile = false
  iam_instance_profile = "existing-instance-profile"
}

items = {
  web-server = {
    name = "web-server"
    # Uses default instance profile
  }
  database-server = {
    name = "database-server"
    iam_instance_profile = "different-instance-profile"  # Override
  }
}
```

## Complete Variable Reference

For a complete list of all available variables, see:
- [terraform-aws-ec2-instance variables.tf](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance/blob/master/variables.tf)
- [terraform-aws-ec2-base/iam variables.tf](../terraform-aws-ec2-base/iam/variables.tf)

All variables from these modules can be used in the `defaults` and `items` maps of the wrapper.

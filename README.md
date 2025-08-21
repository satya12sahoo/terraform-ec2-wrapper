# Terraform AWS EC2 Instance Wrapper

A comprehensive wrapper module around [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) that provides simplified multi-instance management with advanced features including IAM instance profile management and CloudWatch monitoring.

## 🚀 Features

- **Multi-Instance Management**: Create multiple EC2 instances with shared defaults and individual overrides
- **IAM Instance Profile Management**: Create instance profiles for existing IAM roles
- **CloudWatch Monitoring**: Comprehensive monitoring with alarms and dashboards
- **Type Safety**: Full type definitions for all variables and outputs
- **Flexible Configuration**: Override any default value on a per-instance basis
- **Complete Output Exposure**: All outputs from underlying modules are available
- **Backward Compatible**: Maintains compatibility with existing configurations

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
- [Usage Examples](#usage-examples)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Modules](#modules)
- [License](#license)

## 🏃‍♂️ Quick Start

### Basic Multi-Instance Setup

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server-1 = {
      name = "web-server-1"
      tags = { Role = "web-server" }
    }
    web-server-2 = {
      name = "web-server-2"
      tags = { Role = "web-server" }
    }
    database-server = {
      name         = "database-server"
      instance_type = "t3.small"
      tags = { Role = "database" }
    }
  }
}
```

### With IAM Instance Profile Management

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Enable instance profile creation for existing roles
    create_instance_profiles_for_existing_roles = true
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      # Existing IAM role name
      iam_role_name = "existing-web-role"
      # Instance profile will be created automatically
      instance_profile_name = "web-instance-profile"
      tags = { Role = "web-server" }
    }
    
    app-server = {
      name = "app-server"
      iam_role_name = "existing-app-role"
      instance_profile_name = "app-instance-profile"
      tags = { Role = "app-server" }
    }
  }
}
```

### With Comprehensive Monitoring

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Enable monitoring
    create_monitoring = true
    
    # CPU monitoring
    create_cpu_alarm = true
    cpu_threshold = 75
    cpu_alarm_actions = [aws_sns_topic.alerts.arn]
    
    # Memory monitoring (requires CloudWatch Agent)
    create_memory_alarm = true
    memory_threshold = 80
    memory_alarm_actions = [aws_sns_topic.alerts.arn]
    
    # Disk monitoring (requires CloudWatch Agent)
    create_disk_alarm = true
    disk_threshold = 85
    disk_alarm_actions = [aws_sns_topic.alerts.arn]
    
    # Network monitoring
    create_network_in_alarm = true
    create_network_out_alarm = true
    network_in_threshold = 500000000  # 500 MB
    network_out_threshold = 500000000
    
    # Status check monitoring
    create_status_check_alarm = true
    status_check_alarm_actions = [aws_sns_topic.alerts.arn]
    
    # Dashboard
    create_dashboard = true
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      # Instance-specific monitoring overrides
      cpu_threshold = 70  # Lower threshold for web server
      memory_threshold = 75
      tags = { Role = "web-server" }
    }
    
    database-server = {
      name = "database-server"
      instance_type = "t3.small"
      # Conservative thresholds for database
      cpu_threshold = 60
      memory_threshold = 70
      disk_threshold = 80
      tags = { Role = "database" }
    }
  }
}
```

## 🧠 Core Concepts

### 1. Defaults and Items Pattern

The module uses a two-tier configuration approach:

- **`defaults`**: Shared configuration applied to all instances
- **`items`**: Individual instance configurations that override defaults

### 2. IAM Instance Profile Management

The module can create instance profiles for existing IAM roles:

- **Toggle**: `create_instance_profiles_for_existing_roles = true`
- **Automatic Creation**: Instance profiles created based on `items` configuration
- **Integration**: Automatically attached to EC2 instances

### 3. CloudWatch Monitoring

Comprehensive monitoring capabilities:

- **CPU Monitoring**: Built-in EC2 metrics
- **Memory Monitoring**: Requires CloudWatch Agent
- **Disk Monitoring**: Requires CloudWatch Agent
- **Network Monitoring**: Built-in EC2 metrics
- **Status Check Monitoring**: Instance health monitoring
- **Dashboards**: Visual monitoring interface

## 📖 Usage Examples

### Advanced Security Group Configuration

```hcl
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
    web-server = {
      name = "web-server"
      
      # Web server specific ingress rules
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
      
      tags = { Role = "web-server" }
    }
    
    database-server = {
      name         = "database-server"
      instance_type = "t3.small"
      
      # Database specific ingress rules
      security_group_ingress_rules = {
        postgres = {
          from_port   = 5432
          to_port     = 5432
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
          description = "PostgreSQL access from VPC"
        }
      }
      
      tags = { Role = "database" }
    }
  }
}
```

### Spot Instance Configuration

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Spot instance defaults
    create_spot_instance = true
    spot_type           = "persistent"
    
    tags = {
      Environment = "development"
      Project     = "my-project"
    }
  }

  items = {
    spot-instance-1 = {
      name = "spot-instance-1"
      spot_price = "0.01"
    }
    
    spot-instance-2 = {
      name = "spot-instance-2"
      spot_price = "0.015"
    }
  }
}
```

### EBS Volume Configuration

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # EBS volume configuration
    ebs_volumes = {
      data = {
        device_name = "/dev/sdf"
        volume_size = 100
        volume_type = "gp3"
        encrypted    = true
        tags = {
          Name = "data-volume"
        }
      }
    }
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    app-server = {
      name = "app-server"
      
      # Instance-specific EBS volumes
      ebs_volumes = {
        data = {
          device_name = "/dev/sdf"
          volume_size = 200
          volume_type = "gp3"
          encrypted    = true
          tags = {
            Name = "app-data-volume"
          }
        }
        logs = {
          device_name = "/dev/sdg"
          volume_size = 50
          volume_type = "gp3"
          encrypted    = true
          tags = {
            Name = "app-logs-volume"
          }
        }
      }
      
      tags = { Role = "app-server" }
    }
  }
}
```

## 📥 Inputs

### Core Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `defaults` | Map of default values for all instances | `any` | `{}` | no |
| `items` | Map of individual instance configurations | `any` | `{}` | no |
| `create_instance_profiles_for_existing_roles` | Enable instance profile creation for existing IAM roles | `bool` | `false` | no |

### Supported Variables in `defaults` and `items`

All variables from the underlying `terraform-aws-ec2-instance` module are supported, plus additional wrapper-specific variables:

#### EC2 Instance Variables
- `ami`, `ami_ssm_parameter`, `instance_type`, `subnet_id`
- `key_name`, `vpc_security_group_ids`, `associate_public_ip_address`
- `availability_zone`, `private_ip`, `secondary_private_ips`
- `root_block_device`, `ebs_volumes`, `ephemeral_block_device`
- `user_data`, `user_data_base64`, `metadata_options`
- `monitoring`, `disable_api_termination`, `disable_api_stop`
- `hibernation`, `ebs_optimized`, `placement_group`
- `tenancy`, `cpu_credits`, `cpu_options`
- `capacity_reservation_specification`, `launch_template`
- `instance_market_options`, `maintenance_options`
- `private_dns_name_options`, `enable_primary_ipv6`
- `ipv6_address_count`, `ipv6_addresses`, `source_dest_check`
- `get_password_data`, `timeouts`, `tags`, `volume_tags`
- `enable_volume_tags`, `ignore_ami_changes`, `putin_khuylo`

#### Security Group Variables
- `create_security_group`, `security_group_name`, `security_group_description`
- `security_group_vpc_id`, `security_group_use_name_prefix`
- `security_group_ingress_rules`, `security_group_egress_rules`
- `security_group_tags`

#### IAM Variables
- `create_iam_instance_profile`, `iam_instance_profile`
- `iam_role_name`, `iam_role_description`, `iam_role_path`
- `iam_role_permissions_boundary`, `iam_role_policies`
- `iam_role_tags`, `iam_role_use_name_prefix`

#### Spot Instance Variables
- `create_spot_instance`, `spot_price`, `spot_type`
- `spot_launch_group`, `spot_valid_from`, `spot_valid_until`
- `spot_wait_for_fulfillment`, `spot_instance_interruption_behavior`

#### EIP Variables
- `create_eip`, `eip_domain`, `eip_tags`

#### Network Interface Variables
- `network_interface`, `placement_partition_number`
- `host_id`, `host_resource_group_arn`

#### Instance Profile Management Variables (Wrapper-Specific)
- `create_instance_profile`, `instance_profile_name`
- `instance_profile_path`, `instance_profile_description`
- `instance_profile_tags`, `enable_instance_profile_rotation`
- `instance_profile_permissions_boundary`

#### Monitoring Variables (Wrapper-Specific)
- `create_monitoring`, `create_cpu_alarm`, `cpu_threshold`
- `cpu_evaluation_periods`, `cpu_period`, `cpu_alarm_actions`
- `cpu_ok_actions`, `create_memory_alarm`, `memory_threshold`
- `memory_evaluation_periods`, `memory_period`, `memory_alarm_actions`
- `create_disk_alarm`, `disk_threshold`, `disk_evaluation_periods`
- `disk_period`, `disk_filesystem`, `disk_mount_path`
- `disk_alarm_actions`, `create_network_in_alarm`, `network_in_threshold`
- `network_in_evaluation_periods`, `network_in_period`, `network_in_alarm_actions`
- `create_network_out_alarm`, `network_out_threshold`
- `network_out_evaluation_periods`, `network_out_period`, `network_out_alarm_actions`
- `create_status_check_alarm`, `status_check_evaluation_periods`
- `status_check_period`, `status_check_alarm_actions`
- `create_dashboard`, `dashboard_name`

## 📤 Outputs

### EC2 Instance Outputs

- `instance_ids` - Map of instance IDs
- `instance_arns` - Map of instance ARNs
- `instance_public_ips` - Map of public IP addresses
- `instance_private_ips` - Map of private IP addresses
- `instance_public_dns` - Map of public DNS names
- `instance_private_dns` - Map of private DNS names
- `instance_key_names` - Map of key pair names
- `instance_subnet_ids` - Map of subnet IDs
- `instance_vpc_security_group_ids` - Map of security group IDs
- `instance_root_block_device` - Map of root block device configurations
- `instance_ebs_block_device` - Map of EBS block device configurations
- `instance_metadata_options` - Map of metadata options
- `instance_network_interface_ids` - Map of network interface IDs
- `instance_primary_network_interface_id` - Map of primary network interface IDs
- `instance_outpost_arn` - Map of outpost ARNs
- `instance_password_data` - Map of password data (sensitive)
- `instance_placement_group` - Map of placement groups
- `instance_placement_partition_number` - Map of placement partition numbers
- `instance_ram_disk_id` - Map of RAM disk IDs
- `instance_security_groups` - Map of security groups
- `instance_source_dest_check` - Map of source/destination check settings
- `instance_spot_bid_status` - Map of spot bid statuses
- `instance_spot_instance_id` - Map of spot instance IDs
- `instance_spot_request_state` - Map of spot request states
- `instance_state` - Map of instance states
- `instance_tenancy` - Map of tenancy settings
- `instance_tags_all` - Map of all tags
- `instance_volume_tags_all` - Map of all volume tags

### Spot Instance Outputs

- `spot_bid_statuses` - Map of spot bid statuses
- `spot_request_states` - Map of spot request states
- `spot_instance_ids` - Map of spot instance IDs

### EBS Volume Outputs

- `ebs_volumes` - Map of EBS volumes and their attributes

### IAM Role / Instance Profile Outputs

- `iam_role_names` - Map of IAM role names
- `iam_role_arns` - Map of IAM role ARNs
- `iam_role_unique_ids` - Map of IAM role unique IDs
- `iam_instance_profile_arns` - Map of IAM instance profile ARNs
- `iam_instance_profile_ids` - Map of IAM instance profile IDs
- `iam_instance_profile_uniques` - Map of IAM instance profile unique IDs

### Instance Profile Outputs (for existing IAM roles)

- `instance_profiles` - Map of all instance profile resources
- `instance_profile_names` - Map of instance profile names
- `instance_profile_arns` - Map of instance profile ARNs
- `instance_profile_ids` - Map of instance profile IDs
- `instance_profile_unique_ids` - Map of instance profile unique IDs

### Monitoring Outputs

- `monitoring_alarms` - Map of monitoring alarms for each instance
- `monitoring_alarm_arns` - Map of monitoring alarm ARNs
- `monitoring_alarm_names` - Map of monitoring alarm names
- `monitoring_dashboards` - Map of monitoring dashboards
- `monitoring_dashboard_names` - Map of monitoring dashboard names
- `monitoring_dashboard_arns` - Map of monitoring dashboard ARNs
- `monitoring_summaries` - Map of monitoring summaries

### Block Device Outputs

- `root_block_devices` - Map of root block device information
- `ebs_block_devices` - Map of EBS block device information
- `ephemeral_block_devices` - Map of ephemeral block device information

### Security Group Outputs

- `security_group_ids` - Map of security group IDs
- `security_group_arns` - Map of security group ARNs
- `security_group_names` - Map of security group names

### EIP Outputs

- `eip_ids` - Map of EIP IDs
- `eip_arns` - Map of EIP ARNs
- `eip_public_ips` - Map of EIP public IPs
- `eip_public_dns` - Map of EIP public DNS names

### Deployment Summary

- `deployment_summary` - Summary of all deployed resources

## 📋 Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.0 |

## 🔧 Modules

| Name | Source | Version |
|------|--------|---------|
| wrapper | github.com/satya12sahoo/terraform-aws-ec2-instance | n/a |
| iam_instance_profiles | ../terraform-aws-ec2-base/iam | n/a |
| instance_monitoring | ../terraform-aws-ec2-base/monitoring | n/a |

## 📄 License

This module is licensed under the same license as the underlying `terraform-aws-ec2-instance` module.

## 🤝 Contributing

This module is a wrapper around the official AWS EC2 instance module. For issues related to the core EC2 functionality, please refer to the [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) repository.

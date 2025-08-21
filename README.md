# Terraform AWS EC2 Instance Wrapper

A comprehensive wrapper module around [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) that provides simplified multi-instance management with advanced features including IAM instance profile management, CloudWatch monitoring, and comprehensive logging.


## 🚀 Features

- **Multi-Instance Management**: Create multiple EC2 instances with shared defaults and individual overrides
- **IAM Instance Profile Management**: Create instance profiles for existing IAM roles
- **CloudWatch Monitoring**: Comprehensive monitoring with alarms and dashboards
- **CloudWatch Logging**: Complete logging solution with log groups, streams, and alarms
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

### IAM Instance Profile Management Example

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Enable instance profile creation for existing IAM roles
    create_instance_profiles_for_existing_roles = true
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      
      # IAM role details for instance profile creation
      iam_role_name = "existing-web-role"
      instance_profile_name = "web-instance-profile"
      
      tags = {
        Role = "web-server"
      }
    }
    
    database-server = {
      name = "database-server"
      instance_type = "t3.small"
      
      # Different IAM role for database
      iam_role_name = "existing-db-role"
      instance_profile_name = "db-instance-profile"
      
      tags = {
        Role = "database"
      }
    }
  }
}
```

### Monitoring Example

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Enable monitoring
    create_monitoring = true
    
    # Monitoring configuration
    create_cpu_alarm = true
    cpu_threshold = 80
    cpu_alarm_actions = [aws_sns_topic.alerts.arn]
    
    create_status_check_alarm = true
    status_check_alarm_actions = [aws_sns_topic.alerts.arn]
    
    create_dashboard = true
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      cpu_threshold = 75  # Override for web server
      tags = {
        Role = "web-server"
      }
    }
    
    database-server = {
      name = "database-server"
      instance_type = "t3.small"
      cpu_threshold = 85  # Different threshold for database
      tags = {
        Role = "database"
      }
    }
  }
}
```

### Logging Example

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Enable logging
    create_logging = true
    
    # Log group configuration
    create_application_log_group = true
    create_system_log_group = true
    create_error_log_group = true
    
    # Metric filters
    create_error_metric_filter = true
    create_access_metric_filter = true
    
    # Log alarms
    create_error_log_alarm = true
    error_log_alarm_threshold = 5
    error_log_alarm_actions = [aws_sns_topic.alerts.arn]
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      error_log_alarm_threshold = 3  # Lower threshold for web server
      tags = {
        Role = "web-server"
      }
    }
    
    database-server = {
      name = "database-server"
      instance_type = "t3.small"
      error_log_alarm_threshold = 2  # Very low threshold for database
      error_log_retention_days = 120  # Longer retention for database
      tags = {
        Role = "database"
      }
    }
  }
}
```

### Advanced Example with Security Groups

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


## 📋 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `defaults` | Map of default values which will be used for each item. Contains shared configuration for all instances. All variables from terraform-aws-ec2-instance and terraform-aws-ec2-base modules can be used here. | `any` | `{}` | no |
| `items` | Maps of items to create instances from. Values are passed through to the underlying terraform-aws-ec2-instance module. All variables from terraform-aws-ec2-instance and terraform-aws-ec2-base modules can be used here. | `any` | `{}` | no |
| `create_instance_profiles_for_existing_roles` | Toggle flag to enable/disable instance profile creation for existing IAM roles. When true, the wrapper will create instance profiles for existing IAM roles specified in items. | `bool` | `false` | no |

### 🔧 Supported Variables in `defaults` and `items`

The following variables can be used in both `defaults` and `items` objects. Values in `items` will override corresponding values in `defaults`:

#### Core EC2 Instance Variables

| Variable | Description | Type | Default Value |
|----------|-------------|------|---------------|
| `ami` | ID of AMI to use for the instance | `string` | `null` |
| `ami_ssm_parameter` | SSM parameter name for the AMI ID | `string` | `"/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"` |
| `associate_public_ip_address` | Whether to associate a public IP address with an instance in a VPC | `bool` | `null` |
| `availability_zone` | AZ to start the instance in | `string` | `null` |
| `capacity_reservation_specification` | Describes an instance's Capacity Reservation targeting option | `object` | `null` |
| `cpu_credits` | The credit option for CPU usage (unlimited or standard) | `string` | `null` |
| `cpu_options` | Defines CPU options to apply to the instance at launch time | `object` | `null` |
| `create` | Whether to create an instance | `bool` | `true` |
| `create_eip` | Determines whether a public EIP will be created and associated with the instance | `bool` | `false` |
| `create_iam_instance_profile` | Determines whether an IAM instance profile is created | `bool` | `false` |
| `create_security_group` | Determines whether a security group will be created | `bool` | `true` |
| `create_spot_instance` | Depicts if the instance is a spot instance | `bool` | `false` |
| `disable_api_stop` | If true, enables EC2 Instance Stop Protection | `bool` | `null` |
| `disable_api_termination` | If true, enables EC2 Instance Termination Protection | `bool` | `null` |
| `ebs_optimized` | If true, the launched EC2 instance will be EBS-optimized | `bool` | `null` |
| `ebs_volumes` | Additional EBS volumes to attach to the instance | `map(object)` | `null` |
| `eip_domain` | Indicates if this EIP is for use in VPC | `string` | `"vpc"` |
| `eip_tags` | A map of additional tags to add to the eip | `map(string)` | `{}` |
| `enable_primary_ipv6` | Whether to assign a primary IPv6 Global Unicast Address (GUA) to the instance | `bool` | `null` |
| `enable_volume_tags` | Whether to enable volume tags | `bool` | `true` |
| `enclave_options_enabled` | Whether Nitro Enclaves will be enabled on the instance | `bool` | `null` |
| `ephemeral_block_device` | Customize Ephemeral (also known as Instance Store) volumes on the instance | `map(object)` | `null` |
| `get_password_data` | If true, wait for password data to become available and retrieve it | `bool` | `null` |
| `hibernation` | If true, the launched EC2 instance will support hibernation | `bool` | `null` |
| `host_id` | ID of a dedicated host that the instance will be assigned to | `string` | `null` |
| `host_resource_group_arn` | ARN of the host resource group in which to launch the instances | `string` | `null` |
| `iam_instance_profile` | IAM Instance Profile to launch the instance with | `string` | `null` |
| `iam_role_description` | Description of the role | `string` | `null` |
| `iam_role_name` | Name to use on IAM role created | `string` | `null` |
| `iam_role_path` | IAM role path | `string` | `null` |
| `iam_role_permissions_boundary` | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` |
| `iam_role_policies` | Policies attached to the IAM role | `map(string)` | `{}` |
| `iam_role_tags` | A map of additional tags to add to the IAM role/profile created | `map(string)` | `{}` |
| `iam_role_use_name_prefix` | Determines whether the IAM role name is used as a prefix | `bool` | `true` |
| `ignore_ami_changes` | Whether changes to the AMI ID changes should be ignored by Terraform | `bool` | `false` |
| `instance_initiated_shutdown_behavior` | Shutdown behavior for the instance | `string` | `null` |
| `instance_market_options` | The market (purchasing) option for the instance | `object` | `null` |
| `instance_tags` | Additional tags for the instance | `map(string)` | `{}` |
| `instance_type` | The type of instance to start | `string` | `"t3.micro"` |
| `ipv6_address_count` | A number of IPv6 addresses to associate with the primary network interface | `number` | `null` |
| `ipv6_addresses` | Specify one or more IPv6 addresses from the range of the subnet | `list(string)` | `null` |
| `key_name` | Key name of the Key Pair to use for the instance | `string` | `null` |
| `launch_template` | Specifies a Launch Template to configure the instance | `object` | `null` |
| `maintenance_options` | The maintenance options for the instance | `object` | `null` |
| `metadata_options` | Customize the metadata options of the instance | `object` | `{http_endpoint = "enabled", http_put_response_hop_limit = 1, http_tokens = "required"}` |
| `monitoring` | If true, the launched EC2 instance will have detailed monitoring enabled | `bool` | `null` |
| `name` | Name to be used on EC2 instance created | `string` | `""` |
| `network_interface` | Customize network interfaces to be attached at instance boot time | `map(object)` | `null` |
| `placement_group` | The Placement Group to start the instance in | `string` | `null` |
| `placement_partition_number` | Number of the partition the instance is in | `number` | `null` |
| `private_dns_name_options` | Customize the private DNS name options of the instance | `object` | `null` |
| `private_ip` | Private IP address to associate with the instance in a VPC | `string` | `null` |
| `putin_khuylo` | Do you agree that Putin doesn't respect Ukrainian sovereignty and territorial integrity? | `bool` | `true` |
| `region` | Region where the resource(s) will be managed | `string` | `null` |
| `root_block_device` | Customize details about the root block device of the instance | `object` | `null` |
| `secondary_private_ips` | A list of secondary private IPv4 addresses to assign to the instance's primary network interface | `list(string)` | `null` |
| `security_group_description` | Description of the security group | `string` | `null` |
| `security_group_egress_rules` | Egress rules to add to the security group | `map(object)` | `{ipv4_default = {...}, ipv6_default = {...}}` |
| `security_group_ingress_rules` | Ingress rules to add to the security group | `map(object)` | `null` |
| `security_group_name` | Name to use on security group created | `string` | `null` |
| `security_group_tags` | A map of additional tags to add to the security group created | `map(string)` | `{}` |
| `security_group_use_name_prefix` | Determines whether the security group name is used as a prefix | `bool` | `true` |
| `security_group_vpc_id` | VPC ID to create the security group in | `string` | `null` |
| `source_dest_check` | Controls if traffic is routed to the instance when the destination address does not match the instance | `bool` | `null` |
| `spot_instance_interruption_behavior` | Indicates Spot instance behavior when it is interrupted | `string` | `null` |
| `spot_launch_group` | A launch group is a group of spot instances that launch together and terminate together | `string` | `null` |
| `spot_price` | The maximum price to request on the spot market | `string` | `null` |
| `spot_type` | If set to one-time, after the instance is terminated, the spot request will be closed | `string` | `null` |
| `spot_valid_from` | The start date and time of the request, in UTC RFC3339 format | `string` | `null` |
| `spot_valid_until` | The end date and time of the request, in UTC RFC3339 format | `string` | `null` |
| `spot_wait_for_fulfillment` | If set, Terraform will wait for the Spot Request to be fulfilled | `bool` | `null` |
| `subnet_id` | The VPC Subnet ID to launch in | `string` | `null` |
| `tags` | A mapping of tags to assign to the resource | `map(string)` | `{}` |
| `tenancy` | The tenancy of the instance (if the instance is running in a VPC) | `string` | `null` |
| `timeouts` | Define maximum timeout for creating, updating, and deleting EC2 instance resources | `map(string)` | `{}` |
| `user_data` | The user data to provide when launching the instance | `string` | `null` |
| `user_data_base64` | Can be used instead of user_data to pass base64-encoded binary data directly | `string` | `null` |
| `user_data_replace_on_change` | When used in combination with user_data or user_data_base64 will trigger a destroy and recreate | `bool` | `null` |
| `volume_tags` | A mapping of tags to assign to the devices created by the instance at launch time | `map(string)` | `{}` |
| `vpc_security_group_ids` | A list of security group IDs to associate with | `list(string)` | `[]` |

#### IAM Instance Profile Management Variables

| Variable | Description | Type | Default Value |
|----------|-------------|------|---------------|
| `create_instance_profiles_for_existing_roles` | Enable instance profile creation for existing IAM roles | `bool` | `false` |
| `iam_role_name` | Name of existing IAM role to create instance profile for | `string` | `null` |
| `instance_profile_name` | Name for the created instance profile | `string` | `null` |
| `instance_profile_path` | Path for the instance profile | `string` | `"/"` |
| `instance_profile_description` | Description for the instance profile | `string` | `null` |
| `instance_profile_tags` | Tags for the instance profile | `map(string)` | `{}` |
| `enable_instance_profile_rotation` | Enable instance profile rotation | `bool` | `false` |
| `instance_profile_permissions_boundary` | Permissions boundary for instance profile | `string` | `null` |

#### CloudWatch Monitoring Variables

| Variable | Description | Type | Default Value |
|----------|-------------|------|---------------|
| `create_monitoring` | Enable CloudWatch monitoring | `bool` | `false` |
| `create_cpu_alarm` | Create CPU utilization alarm | `bool` | `true` |
| `cpu_threshold` | CPU utilization threshold percentage | `number` | `80` |
| `cpu_evaluation_periods` | Number of evaluation periods for CPU alarm | `number` | `2` |
| `cpu_period` | Period in seconds for CPU alarm | `number` | `300` |
| `cpu_alarm_actions` | Actions to take when CPU alarm triggers | `list(string)` | `[]` |
| `create_memory_alarm` | Create memory utilization alarm | `bool` | `false` |
| `memory_threshold` | Memory utilization threshold percentage | `number` | `85` |
| `create_disk_alarm` | Create disk utilization alarm | `bool` | `false` |
| `disk_threshold` | Disk utilization threshold percentage | `number` | `85` |
| `create_network_in_alarm` | Create network in alarm | `bool` | `false` |
| `create_network_out_alarm` | Create network out alarm | `bool` | `false` |
| `create_status_check_alarm` | Create status check alarm | `bool` | `true` |
| `create_dashboard` | Create CloudWatch dashboard | `bool` | `true` |
| `dashboard_name` | Name for the CloudWatch dashboard | `string` | `null` |

#### CloudWatch Logging Variables

| Variable | Description | Type | Default Value |
|----------|-------------|------|---------------|
| `create_logging` | Enable CloudWatch logging | `bool` | `false` |
| `create_application_log_group` | Create application log group | `bool` | `false` |
| `application_log_retention_days` | Retention days for application logs | `number` | `30` |
| `create_system_log_group` | Create system log group | `bool` | `false` |
| `system_log_retention_days` | Retention days for system logs | `number` | `30` |
| `create_access_log_group` | Create access log group | `bool` | `false` |
| `access_log_retention_days` | Retention days for access logs | `number` | `30` |
| `create_error_log_group` | Create error log group | `bool` | `false` |
| `error_log_retention_days` | Retention days for error logs | `number` | `90` |
| `create_application_log_stream` | Create application log stream | `bool` | `false` |
| `create_system_log_stream` | Create system log stream | `bool` | `false` |
| `create_access_log_stream` | Create access log stream | `bool` | `false` |
| `create_error_log_stream` | Create error log stream | `bool` | `false` |
| `create_error_metric_filter` | Create error metric filter | `bool` | `false` |
| `error_metric_filter_pattern` | Pattern for error metric filter | `string` | `"[timestamp, level=ERROR, message]"` |
| `create_access_metric_filter` | Create access metric filter | `bool` | `false` |
| `access_metric_filter_pattern` | Pattern for access metric filter | `string` | `"[timestamp, ip, method, path, status]"` |
| `create_error_log_alarm` | Create error log alarm | `bool` | `false` |
| `error_log_alarm_threshold` | Threshold for error log alarm | `number` | `10` |
| `error_log_alarm_actions` | Actions for error log alarm | `list(string)` | `[]` |
| `create_access_log_alarm` | Create access log alarm | `bool` | `false` |
| `access_log_alarm_threshold` | Threshold for access log alarm | `number` | `1000` |
| `access_log_alarm_actions` | Actions for access log alarm | `list(string)` | `[]` |
| `custom_log_groups` | Map of custom log groups | `map(object)` | `{}` |
| `custom_log_streams` | Map of custom log streams | `map(object)` | `{}` |
| `custom_metric_filters` | Map of custom metric filters | `map(object)` | `{}` |
| `custom_log_alarms` | Map of custom log alarms | `map(object)` | `{}` |

## 📤 Outputs

### Core Wrapper Output

| Name | Description |
|------|-------------|
| `wrapper` | Map of all outputs from the underlying module for each instance |

### Instance Outputs

| Name | Description |
|------|-------------|
| `instance_ids` | Map of instance IDs |
| `instance_arns` | Map of instance ARNs |
| `instance_states` | Map of instance states |
| `instance_availability_zones` | Map of instance availability zones |
| `instance_amis` | Map of AMI IDs used to create instances |
| `instance_public_ips` | Map of public IP addresses assigned to instances |
| `instance_private_ips` | Map of private IP addresses assigned to instances |
| `instance_public_dns` | Map of public DNS names assigned to instances |
| `instance_private_dns` | Map of private DNS names assigned to instances |
| `instance_ipv6_addresses` | Map of IPv6 addresses assigned to instances |
| `instance_primary_network_interface_ids` | Map of primary network interface IDs |
| `instance_capacity_reservation_specifications` | Map of capacity reservation specifications |
| `instance_outpost_arns` | Map of outpost ARNs |
| `instance_password_data` | Map of password data for instances (sensitive) |
| `instance_tags_all` | Map of all tags assigned to instances |

### Security Group Outputs

| Name | Description |
|------|-------------|
| `security_group_ids` | Map of security group IDs |
| `security_group_arns` | Map of security group ARNs |
| `security_group_names` | Map of security group names |

### EIP Outputs

| Name | Description |
|------|-------------|
| `eip_ids` | Map of EIP IDs |
| `eip_public_ips` | Map of EIP public IPs |
| `eip_public_ipv4_pools` | Map of EIP public IPv4 pools |

### Spot Instance Outputs

| Name | Description |
|------|-------------|
| `spot_bid_statuses` | Map of spot bid statuses |
| `spot_request_states` | Map of spot request states |
| `spot_instance_ids` | Map of spot instance IDs |

### EBS Volume Outputs


| Name | Description |
|------|-------------|
| `ebs_volumes` | Map of EBS volumes created and their attributes |

### IAM Role / Instance Profile Outputs

| Name | Description |
|------|-------------|
| `iam_role_names` | Map of IAM role names |
| `iam_role_arns` | Map of IAM role ARNs |
| `iam_role_unique_ids` | Map of IAM role unique IDs |
| `iam_instance_profile_arns` | Map of IAM instance profile ARNs |
| `iam_instance_profile_ids` | Map of IAM instance profile IDs |
| `iam_instance_profile_uniques` | Map of IAM instance profile unique IDs |

### IAM Instance Profile Management Outputs

| Name | Description |
|------|-------------|
| `instance_profiles` | Map of instance profiles created for existing IAM roles |
| `instance_profile_names` | Map of instance profile names |
| `instance_profile_arns` | Map of instance profile ARNs |
| `instance_profile_ids` | Map of instance profile IDs |
| `instance_profile_unique_ids` | Map of instance profile unique IDs |

### CloudWatch Monitoring Outputs

| Name | Description |
|------|-------------|
| `monitoring_alarms` | Map of monitoring alarms for each instance |
| `monitoring_alarm_arns` | Map of monitoring alarm ARNs for each instance |
| `monitoring_alarm_names` | Map of monitoring alarm names for each instance |
| `monitoring_dashboards` | Map of monitoring dashboards for each instance |
| `monitoring_dashboard_names` | Map of monitoring dashboard names for each instance |
| `monitoring_dashboard_arns` | Map of monitoring dashboard ARNs for each instance |
| `monitoring_summaries` | Map of monitoring summaries for each instance |

### CloudWatch Logging Outputs

| Name | Description |
|------|-------------|
| `logging_log_groups` | Map of logging log groups for each instance |
| `logging_log_group_names` | Map of logging log group names for each instance |
| `logging_log_group_arns` | Map of logging log group ARNs for each instance |
| `logging_log_streams` | Map of logging log stream resources for each instance |
| `logging_log_stream_names` | Map of logging log stream names for each instance |
| `logging_metric_filters` | Map of logging metric filter resources for each instance |
| `logging_metric_filter_names` | Map of logging metric filter names for each instance |
| `logging_alarms` | Map of logging alarms for each instance |
| `logging_alarm_names` | Map of logging alarm names for each instance |
| `logging_alarm_arns` | Map of logging alarm ARNs for each instance |
| `logging_summaries` | Map of logging summaries for each instance |

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

| Name | Description |
|------|-------------|
| `root_block_devices` | Map of root block device information |
| `ebs_block_devices` | Map of EBS block device information |
| `ephemeral_block_devices` | Map of ephemeral block device information |

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
# Updated at Thu Aug 21 23:17:32 IST 2025

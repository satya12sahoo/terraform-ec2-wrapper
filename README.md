# Terraform AWS EC2 Instance Wrapper

This module is a wrapper around the [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) module that provides a simplified interface for creating multiple EC2 instances with shared defaults.

## Features

- **Simplified Configuration**: Create multiple EC2 instances with shared default values
- **Type Safety**: Full type definitions for all variables and outputs
- **Flexible Overrides**: Override any default value on a per-instance basis
- **Complete Output Exposure**: All outputs from the underlying module are available
- **Backward Compatible**: Maintains compatibility with existing configurations

## Usage

### Basic Example

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
      tags = {
        Role = "web-server"
      }
    }
    web-server-2 = {
      name = "web-server-2"
      tags = {
        Role = "web-server"
      }
    }
    database-server = {
      name         = "database-server"
      instance_type = "t3.small"
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
    
    # IAM configuration
    create_iam_instance_profile = true
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    
    tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }

  items = {
    web-server = {
      name = "web-server"
      
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
```

### Spot Instance Example

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `defaults` | Map of default values which will be used for each item | `any` | `{}` | no |
| `items` | Maps of items to create instances from. Values are passed through to the module | `any` | `{}` | no |

### Supported Variables in `defaults` and `items`

The following variables can be used in both `defaults` and `items` objects. Values in `items` will override corresponding values in `defaults`:

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

## Outputs

### `wrapper`

Map of all outputs from the underlying module for each instance.

### Instance Outputs

- `instance_ids` - Map of instance IDs
- `instance_arns` - Map of instance ARNs
- `instance_states` - Map of instance states
- `instance_availability_zones` - Map of instance availability zones
- `instance_amis` - Map of AMI IDs used to create instances
- `instance_public_ips` - Map of public IP addresses assigned to instances
- `instance_private_ips` - Map of private IP addresses assigned to instances
- `instance_public_dns` - Map of public DNS names assigned to instances
- `instance_private_dns` - Map of private DNS names assigned to instances
- `instance_ipv6_addresses` - Map of IPv6 addresses assigned to instances
- `instance_primary_network_interface_ids` - Map of primary network interface IDs
- `instance_capacity_reservation_specifications` - Map of capacity reservation specifications
- `instance_outpost_arns` - Map of outpost ARNs
- `instance_password_data` - Map of password data for instances (sensitive)
- `instance_tags_all` - Map of all tags assigned to instances

### Spot Instance Outputs

- `spot_bid_statuses` - Map of spot bid statuses
- `spot_request_states` - Map of spot request states
- `spot_instance_ids` - Map of spot instance IDs

### EBS Volume Outputs

- `ebs_volumes` - Map of EBS volumes created and their attributes

### IAM Role / Instance Profile Outputs

- `iam_role_names` - Map of IAM role names
- `iam_role_arns` - Map of IAM role ARNs
- `iam_role_unique_ids` - Map of IAM role unique IDs
- `iam_instance_profile_arns` - Map of IAM instance profile ARNs
- `iam_instance_profile_ids` - Map of IAM instance profile IDs
- `iam_instance_profile_uniques` - Map of IAM instance profile unique IDs

### Block Device Outputs

- `root_block_devices` - Map of root block device information
- `ebs_block_devices` - Map of EBS block device information
- `ephemeral_block_devices` - Map of ephemeral block device information

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| wrapper | github.com/satya12sahoo/terraform-aws-ec2-instance | n/a |

## License

This module is licensed under the same license as the underlying `terraform-aws-ec2-instance` module.

## Contributing

This module is a wrapper around the official AWS EC2 instance module. For issues related to the core EC2 functionality, please refer to the [terraform-aws-ec2-instance](https://github.com/terraform-aws-modules/terraform-aws-ec2-instance) repository.
# Updated at Thu Aug 21 23:17:32 IST 2025

# Using terraform-ec2-wrapper with Existing IAM Roles

This example demonstrates how to use the `terraform-ec2-wrapper` module to create instance profiles for existing IAM roles and then use them with EC2 instances.

## Overview

When you have existing IAM roles that don't have instance profiles, you need to create instance profiles to attach them to EC2 instances. This example shows how to:

1. **Create Instance Profiles**: Use the wrapper module to create instance profiles for existing IAM roles
2. **Use with EC2 Instances**: Pass the created instance profiles to EC2 instances
3. **Handle Multiple Instances**: Use the same instance profile across multiple EC2 instances
4. **Configuration via tfvars**: Define instance profile configuration in terraform.tfvars

## Prerequisites

- An existing IAM role (without an instance profile)
- VPC and subnet configured
- AWS credentials configured

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    terraform-ec2-wrapper                       │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────────────────────┐    │
│  │ Existing IAM    │    │ aws_iam_instance_profile       │    │
│  │ Role            │───▶│ (created by wrapper module)     │    │
│  │                 │    │                                 │    │
│  └─────────────────┘    └─────────────────────────────────┘    │
│                                    │                           │
│                                    ▼                           │
│  ┌─────────────────┐    ┌─────────────────────────────────┐    │
│  │ Instance        │    │ Multiple EC2 Instances          │    │
│  │ Profile         │───▶│ (web-server-1, web-server-2,    │    │
│  │ (from wrapper)  │    │  database-server)               │    │
│  └─────────────────┘    └─────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Key Features

### ✅ **Wrapper Module Features**
- Creates instance profiles for existing IAM roles using terraform-aws-ec2-base/iam
- Configurable instance profile names and paths
- Comprehensive tagging support
- Conditional creation (only when needed)
- Configuration via tfvars for better separation of concerns

### ✅ **Integration Benefits**
- Uses existing instance profiles instead of creating new ones
- Maintains all wrapper functionality (multi-instance support, security groups, etc.)
- Clean separation of concerns
- Easy configuration management through tfvars

## Usage

### Step 1: Configure Instance Profiles in tfvars

Create a `terraform.tfvars` file with your instance profile configuration:

```hcl
# Instance profiles configuration
instance_profiles = {
  web_server_profile = {
    create_instance_profile = true
    iam_role_name = "existing-web-server-role"
    instance_profile_name = "web-server-instance-profile"
    instance_profile_description = "Instance profile for web server IAM role"
    
    common_tags = {
      Purpose = "Web Server"
      Tier    = "Application"
    }
    
    instance_profile_tags = {
      Role = "web-server"
    }
  }
  
  database_server_profile = {
    create_instance_profile = true
    iam_role_name = "existing-database-role"
    instance_profile_name = "database-instance-profile"
    instance_profile_description = "Instance profile for database IAM role"
    
    common_tags = {
      Purpose = "Database"
      Tier    = "Data"
    }
    
    instance_profile_tags = {
      Role = "database"
    }
  }
}

# Common tags for all resources
common_tags = {
  Environment = "production"
  Project     = "my-project"
  ManagedBy   = "terraform"
}
```

### Step 2: Use the Wrapper Module

```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"

  # Instance profiles configuration (from tfvars)
  instance_profiles = var.instance_profiles
  
  # Common tags for all resources
  common_tags = var.common_tags

  defaults = {
    # Use the instance profile created by the wrapper
    create_iam_instance_profile = false
    
    # Other configuration...
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
  }

  items = {
    web-server-1 = {
      name = "web-server-1"
      # Instance-specific configuration...
    }
    web-server-2 = {
      name = "web-server-2"
      # Instance-specific configuration...
    }
  }
}
```

## Configuration Options

### Instance Profile Variables (in tfvars)

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|:--------:|
| `create_instance_profile` | Whether to create an instance profile | `bool` | `true` | no |
| `iam_role_name` | Name of the existing IAM role | `string` | - | yes |
| `instance_profile_name` | Name for the instance profile | `string` | - | yes |
| `instance_profile_path` | Path for the instance profile | `string` | `"/"` | no |
| `instance_profile_description` | Description for the instance profile | `string` | `"Instance profile for existing IAM role"` | no |
| `common_tags` | Common tags to apply | `map(string)` | `{}` | no |
| `instance_profile_tags` | Additional tags for instance profile | `map(string)` | `{}` | no |
| `enable_instance_profile_rotation` | Enable instance profile rotation | `bool` | `false` | no |
| `instance_profile_permissions_boundary` | Permissions boundary ARN | `string` | `null` | no |

### Wrapper Configuration

| Variable | Description | Value |
|----------|-------------|-------|
| `instance_profiles` | Map of instance profile configurations | From tfvars |
| `common_tags` | Common tags for all resources | From tfvars |
| `create_iam_instance_profile` | Don't create new IAM role/profile | `false` |

## Outputs

### Instance Profile Outputs
- `instance_profiles` - Map of all instance profile resources
- `instance_profile_names` - Map of instance profile names
- `instance_profile_arns` - Map of instance profile ARNs

### EC2 Instance Outputs
- `instance_ids` - IDs of created instances
- `instance_public_ips` - Public IP addresses
- `instance_private_ips` - Private IP addresses
- `iam_instance_profile_arns` - IAM instance profile ARNs used

## Example Scenarios

### Scenario 1: Single Instance Profile for Multiple Instances

**terraform.tfvars:**
```hcl
instance_profiles = {
  web_server_profile = {
    create_instance_profile = true
    iam_role_name = "web-server-role"
    instance_profile_name = "web-server-profile"
  }
}

common_tags = {
  Environment = "production"
  Project     = "my-project"
}
```

**main.tf:**
```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"
  
  instance_profiles = var.instance_profiles
  common_tags = var.common_tags
  
  defaults = {
    create_iam_instance_profile = false
  }
  
  items = {
    web-1 = { name = "web-1" }
    web-2 = { name = "web-2" }
    web-3 = { name = "web-3" }
  }
}
```

### Scenario 2: Different Instance Profiles for Different Instance Types

**terraform.tfvars:**
```hcl
instance_profiles = {
  web_server_profile = {
    create_instance_profile = true
    iam_role_name = "web-server-role"
    instance_profile_name = "web-server-profile"
  }
  
  database_server_profile = {
    create_instance_profile = true
    iam_role_name = "database-role"
    instance_profile_name = "database-profile"
  }
}

common_tags = {
  Environment = "production"
  Project     = "my-project"
}
```

**main.tf:**
```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"
  
  instance_profiles = var.instance_profiles
  common_tags = var.common_tags
  
  defaults = {
    create_iam_instance_profile = false
  }
  
  items = {
    web-server = {
      name = "web-server"
      iam_instance_profile = "web-server-profile"
    }
    database-server = {
      name = "database-server"
      iam_instance_profile = "database-profile"
    }
  }
}
```

## Best Practices

1. **Use Descriptive Names**: Use clear, descriptive names for instance profiles
2. **Tag Resources**: Apply consistent tagging across all resources
3. **Separate Concerns**: Use the IAM module for instance profiles, wrapper for instances
4. **Reuse Profiles**: Use the same instance profile for similar instance types
5. **Document Roles**: Document what each IAM role is used for

## Troubleshooting

### Common Issues

1. **IAM Role Not Found**: Ensure the IAM role name is correct and exists
2. **Permission Issues**: Ensure your AWS credentials have IAM permissions
3. **Instance Profile Already Exists**: Use a unique name or check if it already exists

### Validation Commands

```bash
# Check if IAM role exists
aws iam get-role --role-name your-role-name

# Check if instance profile exists
aws iam get-instance-profile --instance-profile-name your-profile-name

# List instance profiles
aws iam list-instance-profiles
```

## Next Steps

1. **Customize**: Modify the example to match your specific requirements
2. **Test**: Deploy in a test environment first
3. **Scale**: Add more instances or different instance types as needed
4. **Monitor**: Monitor the instances and their IAM permissions

# IAM Role and Security Group Handling Examples

This example demonstrates how the `terraform-aws-ec2-instance` module (and by extension, the `terraform-ec2-wrapper`) handles IAM roles and security groups in different scenarios.

## Overview

The `terraform-aws-ec2-instance` module provides flexible options for handling IAM roles and security groups:

### **IAM Role/Instance Profile Options:**

1. **Create from scratch** (`create_iam_instance_profile = true`)
   - Creates a new IAM role with specified policies
   - Creates a new IAM instance profile
   - Attaches the role to the instance profile

2. **Use existing** (`create_iam_instance_profile = false`)
   - Uses an existing IAM instance profile
   - Specified via `iam_instance_profile` variable

### **Security Group Options:**

1. **Create from scratch** (`create_security_group = true`)
   - Creates a new security group
   - Configures ingress/egress rules
   - Attaches to the instance

2. **Use existing** (`create_security_group = false`)
   - Uses existing security groups
   - Specified via `vpc_security_group_ids` variable

## Key Variables

### **IAM Role/Instance Profile Variables:**

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `create_iam_instance_profile` | `bool` | `false` | Whether to create IAM role and instance profile |
| `iam_instance_profile` | `string` | `null` | Name of existing IAM instance profile to use |
| `iam_role_name` | `string` | `null` | Name for the IAM role (when creating) |
| `iam_role_policies` | `map(string)` | `{}` | Policies to attach to the IAM role |
| `iam_role_description` | `string` | `null` | Description for the IAM role |

### **Security Group Variables:**

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `create_security_group` | `bool` | `true` | Whether to create a security group |
| `vpc_security_group_ids` | `list(string)` | `[]` | List of existing security group IDs |
| `security_group_name` | `string` | `null` | Name for the security group (when creating) |
| `security_group_ingress_rules` | `map(object)` | `{}` | Ingress rules for the security group |
| `security_group_egress_rules` | `map(object)` | `{}` | Egress rules for the security group |

## Examples

### **Example 1: Create Everything from Scratch**

```hcl
module "ec2_with_created_resources" {
  source = "../../"

  defaults = {
    # Create IAM role and instance profile
    create_iam_instance_profile = true
    iam_role_name = "ec2-instance-role"
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    
    # Create security group
    create_security_group = true
    security_group_name = "ec2-instance-sg"
    security_group_ingress_rules = {
      http = {
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }
}
```

**What happens:**
- ✅ Creates new IAM role with S3 read-only policy
- ✅ Creates new IAM instance profile
- ✅ Creates new security group with HTTP ingress rule
- ✅ Attaches both to the EC2 instance

### **Example 2: Use Existing Resources**

```hcl
# First, create existing resources
resource "aws_iam_instance_profile" "existing_profile" {
  name = "existing-ec2-profile"
  role = aws_iam_role.existing_role.name
}

resource "aws_security_group" "existing_sg" {
  name = "existing-ec2-sg"
  # ... security group configuration
}

module "ec2_with_existing_resources" {
  source = "../../"

  defaults = {
    # Use existing IAM instance profile
    create_iam_instance_profile = false
    iam_instance_profile = aws_iam_instance_profile.existing_profile.name
    
    # Use existing security group
    create_security_group = false
    vpc_security_group_ids = [aws_security_group.existing_sg.id]
  }
}
```

**What happens:**
- ✅ Uses existing IAM instance profile
- ✅ Uses existing security group
- ✅ No new IAM or security group resources created

### **Example 3: Mixed Scenarios**

#### **Create IAM, Use Existing Security Group:**

```hcl
module "ec2_mixed_scenario" {
  source = "../../"

  defaults = {
    # Create IAM role and instance profile
    create_iam_instance_profile = true
    iam_role_name = "new-role"
    iam_role_policies = {
      s3_full_access = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    }
    
    # Use existing security group
    create_security_group = false
    vpc_security_group_ids = [aws_security_group.existing_sg.id]
  }
}
```

#### **Use Existing IAM, Create Security Group:**

```hcl
module "ec2_mixed_scenario_2" {
  source = "../../"

  defaults = {
    # Use existing IAM instance profile
    create_iam_instance_profile = false
    iam_instance_profile = aws_iam_instance_profile.existing_profile.name
    
    # Create security group
    create_security_group = true
    security_group_name = "new-sg"
    security_group_ingress_rules = {
      custom_port = {
        from_port   = 8080
        to_port     = 8080
        ip_protocol = "tcp"
        cidr_ipv4   = "10.0.0.0/16"
      }
    }
  }
}
```

### **Example 4: Per-Instance Overrides**

```hcl
module "ec2_multiple_configurations" {
  source = "../../"

  defaults = {
    # Default: Create IAM and security group
    create_iam_instance_profile = true
    create_security_group = true
  }

  items = {
    # Instance 1: Use defaults (create both)
    web-server-1 = {
      name = "web-server-1"
      # Uses defaults - creates IAM and security group
    }
    
    # Instance 2: Override to use existing IAM
    web-server-2 = {
      name = "web-server-2"
      create_iam_instance_profile = false
      iam_instance_profile = "existing-profile-name"
      # Still creates security group (uses default)
    }
    
    # Instance 3: Override to use existing security group
    app-server = {
      name = "app-server"
      create_security_group = false
      vpc_security_group_ids = ["sg-existing123"]
      # Still creates IAM (uses default)
    }
    
    # Instance 4: Override both
    monitoring-server = {
      name = "monitoring-server"
      create_iam_instance_profile = false
      iam_instance_profile = "existing-profile-name"
      create_security_group = false
      vpc_security_group_ids = ["sg-existing123"]
    }
  }
}
```

## Resource Creation Logic

### **IAM Role/Instance Profile Logic:**

```hcl
# In the module's main.tf
iam_instance_profile = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile
```

**When `create_iam_instance_profile = true`:**
- Creates `aws_iam_role`
- Creates `aws_iam_role_policy_attachment` (for each policy)
- Creates `aws_iam_instance_profile`
- Uses the created instance profile name

**When `create_iam_instance_profile = false`:**
- Uses the value of `iam_instance_profile` variable
- No IAM resources created

### **Security Group Logic:**

```hcl
# In the module's main.tf
vpc_security_group_ids = local.create_security_group ? concat(var.vpc_security_group_ids, [aws_security_group.this[0].id]) : var.vpc_security_group_ids
```

**When `create_security_group = true`:**
- Creates `aws_security_group`
- Creates `aws_vpc_security_group_ingress_rule` (for each ingress rule)
- Creates `aws_vpc_security_group_egress_rule` (for each egress rule)
- Adds the created security group ID to the list

**When `create_security_group = false`:**
- Uses only the security group IDs in `vpc_security_group_ids`
- No security group resources created

## Best Practices

### **1. When to Create vs Use Existing:**

**Create IAM Roles When:**
- ✅ You need specific permissions for this instance
- ✅ You want to follow least privilege principle
- ✅ You're creating a new application or service
- ✅ You want full control over the IAM configuration

**Use Existing IAM Roles When:**
- ✅ You have a standard role that multiple instances should use
- ✅ You're following organizational IAM policies
- ✅ You want to reduce the number of IAM resources
- ✅ You're migrating existing infrastructure

**Create Security Groups When:**
- ✅ You need instance-specific security rules
- ✅ You want to isolate different types of instances
- ✅ You're creating a new application with unique requirements
- ✅ You want fine-grained control over network access

**Use Existing Security Groups When:**
- ✅ You have standard security group templates
- ✅ You want to apply consistent security policies
- ✅ You're following organizational security standards
- ✅ You want to reduce the number of security groups

### **2. Naming Conventions:**

```hcl
# Good naming for created resources
iam_role_name = "${var.name}-role"
security_group_name = "${var.name}-sg"

# Good naming for existing resources
iam_instance_profile = "standard-ec2-profile"
vpc_security_group_ids = ["sg-standard-web", "sg-standard-app"]
```

### **3. Policy Management:**

```hcl
# Use managed policies when possible
iam_role_policies = {
  s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  cloudwatch_agent = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Use custom policies only when necessary
iam_role_policies = {
  custom_policy = aws_iam_policy.custom_policy.arn
}
```

### **4. Security Group Rules:**

```hcl
# Use descriptive rule names
security_group_ingress_rules = {
  http_public = {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
    description = "HTTP access from internet"
  }
  ssh_vpc = {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr_ipv4   = "10.0.0.0/16"
    description = "SSH access from VPC"
  }
}
```

## Troubleshooting

### **Common Issues:**

1. **IAM Role Creation Fails:**
   - Check if the role name already exists
   - Verify IAM permissions to create roles
   - Ensure the assume role policy is correct

2. **Security Group Creation Fails:**
   - Check if the security group name already exists
   - Verify VPC ID is correct
   - Ensure security group rules are valid

3. **Existing Resource Not Found:**
   - Verify the IAM instance profile name exists
   - Check if security group IDs are correct
   - Ensure resources are in the same region

### **Debugging Commands:**

```bash
# Check IAM roles
aws iam list-roles --query 'Roles[?contains(RoleName, `ec2`)].RoleName'

# Check security groups
aws ec2 describe-security-groups --query 'SecurityGroups[?contains(GroupName, `ec2`)].GroupId'

# Check instance profiles
aws iam list-instance-profiles --query 'InstanceProfiles[?contains(InstanceProfileName, `ec2`)].InstanceProfileName'
```

## Migration Scenarios

### **From Existing Infrastructure:**

```hcl
# Step 1: Reference existing resources
module "ec2_migration" {
  source = "../../"

  defaults = {
    create_iam_instance_profile = false
    iam_instance_profile = "existing-ec2-profile"
    
    create_security_group = false
    vpc_security_group_ids = ["sg-existing123"]
  }
}

# Step 2: Gradually migrate to created resources
module "ec2_migration_step2" {
  source = "../../"

  defaults = {
    create_iam_instance_profile = true
    iam_role_policies = {
      s3_read_only = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    }
    
    create_security_group = false
    vpc_security_group_ids = ["sg-existing123"]
  }
}
```

This approach provides maximum flexibility while maintaining security and compliance requirements.

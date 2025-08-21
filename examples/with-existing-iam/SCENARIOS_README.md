# Using terraform-ec2-wrapper with Existing IAM Roles - Scenarios

This directory contains examples demonstrating how to use the `terraform-ec2-wrapper` module with existing IAM roles in different scenarios.

## 📋 **Overview**

The wrapper module supports two main scenarios when working with existing IAM roles:

1. **Scenario 1**: IAM Role WITHOUT Instance Profile → Create Instance Profile
2. **Scenario 2**: IAM Role WITH Existing Instance Profile → Use Existing Instance Profile

## 🏗️ **Architecture**

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

## 📁 **Files Structure**

```
examples/with-existing-iam/
├── main.tf                           # Original example (combined approach)
├── README.md                         # Original documentation
├── scenario1-iam-without-profile.tf  # Scenario 1: Create instance profile
├── scenario2-iam-with-profile.tf     # Scenario 2: Use existing instance profile
└── SCENARIOS_README.md               # This file
```

## 🔧 **Scenario 1: IAM Role WITHOUT Instance Profile**

### **When to Use:**
- You have an existing IAM role that doesn't have an instance profile
- You want the wrapper to create an instance profile for the existing IAM role
- You want to attach the created instance profile to EC2 instances

### **Configuration:**

**main.tf:**
```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"
  
  # Default configuration for all instances
  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Toggle flag to enable instance profile creation for existing IAM roles
    create_instance_profiles_for_existing_roles = true
    
    # Use the instance profile created by the wrapper
    create_iam_instance_profile = false  # Don't create new IAM role
    
    # Security group configuration
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
    }
    
    # Common tags for all resources
    common_tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }
  
  # Individual instance configurations
  items = {
    web-server-1 = { 
      name = "web-server-1"
      # Instance profile configuration for existing IAM role
      iam_role_name = "existing-web-server-role"
      instance_profile_name = "web-server-instance-profile"
    }
    web-server-2 = { 
      name = "web-server-2"
      # Instance profile configuration for existing IAM role
      iam_role_name = "existing-web-server-role"
      instance_profile_name = "web-server-instance-profile"
    }
  }
}
```

### **What Happens:**
1. Wrapper creates instance profile for existing IAM role
2. Wrapper automatically uses the created instance profile for EC2 instances
3. All instances use the same instance profile (unless overridden)

### **Usage:**
```bash
# Use scenario 1 configuration
cp scenario1-iam-without-profile.tf main.tf

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## 🔧 **Scenario 2: IAM Role WITH Existing Instance Profile**

### **When to Use:**
- You have an existing IAM role that already has an instance profile
- You want to use the existing instance profile directly
- No instance profile creation is needed

### **Configuration:**

**main.tf:**
```hcl
module "ec2_instances" {
  source = "github.com/satya12sahoo/terraform-ec2-wrapper"
  
  # Default configuration for all instances
  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    
    # Toggle flag to disable instance profile creation (use existing ones)
    create_instance_profiles_for_existing_roles = false
    
    # Use existing instance profile
    create_iam_instance_profile = false  # Don't create new IAM role/profile
    iam_instance_profile = "existing-instance-profile-name"  # Use existing
    
    # Security group configuration
    create_security_group = true
    security_group_egress_rules = {
      ipv4_default = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all IPv4 traffic"
        ip_protocol = "-1"
      }
    }
    
    # Common tags for all resources
    common_tags = {
      Environment = "production"
      Project     = "my-project"
    }
  }
  
  # Individual instance configurations
  items = {
    web-server-1 = { 
      name = "web-server-1"
      # Uses default instance profile from defaults
    }
    database-server = { 
      name = "database-server"
      iam_instance_profile = "different-instance-profile-name"  # Override per instance
    }
  }
}
```

### **What Happens:**
1. No instance profiles are created by the wrapper
2. Wrapper uses the specified existing instance profile(s)
3. You can specify different instance profiles per instance if needed

### **Usage:**
```bash
# Use scenario 2 configuration
cp scenario2-iam-with-profile.tf main.tf

# Initialize and apply
terraform init
terraform plan
terraform apply
```

## 🔄 **Key Differences**

| Aspect | Scenario 1 | Scenario 2 |
|--------|------------|------------|
| **Instance Profile Creation** | ✅ Created by wrapper | ❌ Not created |
| **Configuration** | `instance_profiles = {...}` | `instance_profiles = {}` |
| **IAM Role Requirement** | Must exist without instance profile | Must exist with instance profile |
| **Instance Profile Usage** | Automatic (first created profile) | Manual specification |
| **Flexibility** | Same profile for all instances | Different profiles per instance |

## 🎯 **Decision Matrix**

| Your Situation | Recommended Scenario | Reason |
|----------------|---------------------|---------|
| IAM role exists, no instance profile | Scenario 1 | Let wrapper create instance profile |
| IAM role exists with instance profile | Scenario 2 | Use existing instance profile |
| Multiple IAM roles with different profiles | Scenario 2 | Specify different profiles per instance |
| Single IAM role for all instances | Scenario 1 | Create one profile, use everywhere |

## 🔍 **Validation Commands**

### **Check if IAM Role Exists:**
```bash
aws iam get-role --role-name your-role-name
```

### **Check if Instance Profile Exists:**
```bash
aws iam get-instance-profile --instance-profile-name your-profile-name
```

### **List All Instance Profiles:**
```bash
aws iam list-instance-profiles
```

### **Check IAM Role's Instance Profile:**
```bash
aws iam get-role --role-name your-role-name --query 'Role.AssumeRolePolicyDocument'
```

## 🚀 **Quick Start**

1. **Determine your scenario:**
   - Does your IAM role have an instance profile? → Scenario 2
   - Does your IAM role NOT have an instance profile? → Scenario 1

2. **Copy the appropriate files:**
   ```bash
   # For Scenario 1
   cp scenario1-iam-without-profile.tf main.tf
   
   # OR for Scenario 2
   cp scenario2-iam-with-profile.tf main.tf
   ```

3. **Update the configuration:**
   - Replace placeholder values with your actual IAM role names
   - Update subnet IDs and other infrastructure details

4. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 🛠️ **Troubleshooting**

### **Common Issues:**

1. **IAM Role Not Found:**
   - Ensure the IAM role name is correct
   - Check if the role exists in the correct AWS account/region

2. **Instance Profile Already Exists:**
   - Use Scenario 2 instead of Scenario 1
   - Or use a different instance profile name

3. **Permission Issues:**
   - Ensure your AWS credentials have IAM permissions
   - Check if you can create/modify instance profiles

4. **Wrong Scenario Selected:**
   - If you get errors about instance profiles not existing, use Scenario 1
   - If you get errors about instance profiles already existing, use Scenario 2

## 📚 **Next Steps**

1. **Customize**: Modify the examples to match your specific requirements
2. **Test**: Deploy in a test environment first
3. **Scale**: Add more instances or different instance types as needed
4. **Monitor**: Monitor the instances and their IAM permissions

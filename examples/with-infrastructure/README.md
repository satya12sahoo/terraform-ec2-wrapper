# Terraform EC2 Wrapper with Infrastructure Integration

This example demonstrates how to use the `terraform-ec2-wrapper` module in combination with infrastructure modules from `terraform-aws-ec2-base`.

## Overview

This example shows a complete infrastructure setup including:

- **EC2 Instances**: Managed by the wrapper with shared defaults and per-instance overrides
- **Load Balancer**: Application Load Balancer with target groups
- **Autoscaling**: Auto Scaling Group for dynamic scaling
- **CloudWatch**: Monitoring and alarms
- **VPC Endpoints**: Private connectivity to AWS services

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │  Auto Scaling   │    │   CloudWatch    │
│                 │    │     Group       │    │   Monitoring    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  EC2 Instances  │
                    │   (Wrapper)     │
                    │                 │
                    │ • web-server-1  │
                    │ • web-server-2  │
                    │ • database      │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │  VPC Endpoints  │
                    │                 │
                    │ • S3 Endpoint   │
                    │ • DynamoDB      │
                    └─────────────────┘
```

## Key Features Demonstrated

### 1. **Multi-Instance Management**
- Create multiple instances with shared defaults
- Per-instance security group rules
- Different instance types and configurations

### 2. **Infrastructure Integration**
- Load balancer automatically targets instances
- Autoscaling group uses instance outputs
- CloudWatch monitors all instances
- VPC endpoints for private connectivity

### 3. **Security Best Practices**
- Instance-specific security groups
- IAM roles and policies
- VPC endpoints for private access

## Usage

### Prerequisites

1. **AWS Credentials**: Configured AWS credentials with appropriate permissions
2. **VPC and Subnet**: A VPC with at least one subnet
3. **Key Pair**: An EC2 key pair for SSH access (if needed)

### Configuration

1. **Update Subnet ID**: Replace `subnet-12345678` with your actual subnet ID
2. **Update VPC ID**: Replace `vpc-12345678` with your actual VPC ID
3. **Customize Instance Types**: Adjust instance types based on your workload
4. **Modify Security Groups**: Update security group rules for your requirements

### Deployment

```bash
# Navigate to the example directory
cd examples/with-infrastructure

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Module Integration

### EC2 Wrapper Module

The wrapper handles all instance creation with shared defaults:

```hcl
module "ec2_instances" {
  source = "../../"
  
  defaults = {
    instance_type = "t3.micro"
    subnet_id     = "subnet-12345678"
    # ... shared defaults
  }
  
  items = {
    web-server-1 = { /* instance config */ }
    web-server-2 = { /* instance config */ }
    database-server = { /* instance config */ }
  }
}
```

### Infrastructure Modules

Infrastructure modules use outputs from the wrapper:

```hcl
# Load balancer uses instance IDs
module "load_balancer" {
  instance_ids = values(module.ec2_instances.instance_ids)
  # ... load balancer config
}

# Autoscaling uses instance IDs
module "autoscaling" {
  instance_ids = values(module.ec2_instances.instance_ids)
  # ... autoscaling config
}
```

## Outputs

The example provides comprehensive outputs:

- **Instance Information**: IDs, IPs, DNS names
- **Load Balancer**: DNS name, ARN
- **Autoscaling**: Group name, ARN
- **CloudWatch**: Dashboard name, alarm names
- **VPC Endpoints**: Endpoint IDs

## Customization

### Adding More Instances

```hcl
items = {
  web-server-1 = { /* config */ }
  web-server-2 = { /* config */ }
  web-server-3 = { /* config */ }  # Add more instances
  database-server = { /* config */ }
}
```

### Modifying Infrastructure

```hcl
# Adjust autoscaling parameters
module "autoscaling" {
  desired_capacity = 3
  max_size = 10
  min_size = 2
}

# Add more CloudWatch alarms
module "cloudwatch" {
  # ... additional alarm configurations
}
```

### Security Customization

```hcl
# Custom security group rules per instance
security_group_ingress_rules = {
  custom_port = {
    from_port   = 8080
    to_port     = 8080
    ip_protocol = "tcp"
    cidr_ipv4   = "10.0.0.0/16"
    description = "Custom application port"
  }
}
```

## Best Practices

### 1. **Resource Naming**
- Use consistent naming conventions
- Include environment and project tags
- Use descriptive names for different instance types

### 2. **Security**
- Limit security group rules to necessary ports
- Use VPC endpoints for private AWS service access
- Implement least privilege IAM policies

### 3. **Monitoring**
- Set up CloudWatch alarms for critical metrics
- Use CloudWatch dashboards for visualization
- Monitor both instance and application metrics

### 4. **Scaling**
- Configure autoscaling based on actual usage patterns
- Use appropriate instance types for your workload
- Consider spot instances for cost optimization

## Troubleshooting

### Common Issues

1. **Subnet Not Found**: Ensure the subnet ID is correct and exists
2. **Security Group Rules**: Verify security group rules allow necessary traffic
3. **IAM Permissions**: Ensure AWS credentials have required permissions
4. **Instance Launch**: Check instance type availability in your region

### Debugging

```bash
# Check Terraform state
terraform show

# Validate configuration
terraform validate

# Check specific resource
terraform state show module.ec2_instances
```

## Next Steps

1. **Customize Configuration**: Adapt the example to your specific requirements
2. **Add Monitoring**: Implement additional CloudWatch alarms and dashboards
3. **Security Hardening**: Review and enhance security configurations
4. **Cost Optimization**: Consider spot instances and reserved instances
5. **Backup Strategy**: Implement backup and disaster recovery procedures

## Support

For issues related to:
- **EC2 Wrapper**: Check the main wrapper documentation
- **Infrastructure Modules**: Refer to individual module documentation
- **AWS Services**: Consult AWS documentation and support

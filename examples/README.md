# Terraform EC2 Wrapper Examples

This directory contains examples demonstrating how to use the `terraform-ec2-wrapper` module.

## Examples

### Basic Example (`basic/`)

A simple example showing how to create multiple EC2 instances with shared defaults and custom security groups.

**Features demonstrated:**
- Basic instance creation with shared defaults
- Custom security group rules per instance
- Different instance types
- Tag management

**Files:**
- `main.tf` - Main configuration file

### Spot Instances Example (`spot-instances/`)

An example showing how to create multiple spot instances with different configurations.

**Features demonstrated:**
- Spot instance creation
- Different spot prices per instance
- Spot instance interruption behavior
- Custom security groups for spot instances

**Files:**
- `main.tf` - Main configuration file

## Usage

To use any of these examples:

1. Navigate to the example directory:
   ```bash
   cd examples/basic
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Prerequisites

Before running these examples, make sure you have:

1. **AWS Credentials**: Configured AWS credentials with appropriate permissions
2. **VPC and Subnet**: A VPC with at least one subnet (update the `subnet_id` in the examples)
3. **Key Pair**: An EC2 key pair for SSH access (if needed)

## Customization

These examples are meant to be starting points. You should customize them for your specific needs:

- Update the `subnet_id` to use your actual subnet
- Modify security group rules to match your security requirements
- Adjust instance types and sizes based on your workload
- Update tags to match your organization's tagging strategy

## Notes

- These examples use placeholder values for some resources (like subnet IDs)
- The examples assume you have the necessary AWS permissions
- Always review the Terraform plan before applying changes
- Consider using workspaces or separate state files for different environments

# =============================================================================
# TERRAFORM-EC2-WRAPPER VARIABLES
# =============================================================================
# This file contains the core variables for the terraform-ec2-wrapper module.
# All other variables from terraform-aws-ec2-instance and terraform-aws-ec2-base/iam
# are used through the 'defaults' and 'items' maps.

# =============================================================================
# WRAPPER CORE VARIABLES
# =============================================================================

variable "defaults" {
  description = "Map of default values which will be used for each item. Contains shared configuration for all instances. All variables from terraform-aws-ec2-instance and terraform-aws-ec2-base/iam modules can be used here."
  type        = any
  default     = {}
}

variable "items" {
  description = "Maps of items to create instances from. Values are passed through to the underlying terraform-aws-ec2-instance module. All variables from terraform-aws-ec2-instance and terraform-aws-ec2-base/iam modules can be used here."
  type        = any
  default     = {}
}

# =============================================================================
# WRAPPER-SPECIFIC VARIABLES
# =============================================================================

variable "create_instance_profiles_for_existing_roles" {
  description = "Toggle flag to enable/disable instance profile creation for existing IAM roles. When true, the wrapper will create instance profiles for existing IAM roles specified in items."
  type = bool
  default = false
}



# =============================================================================
# Instance Profile Management for Existing IAM Roles
# =============================================================================
# This file handles the creation of instance profiles for existing IAM roles
# using the terraform-aws-ec2-base/iam module

# Create instance profiles for existing IAM roles
module "iam_instance_profiles" {
  source = "../terraform-aws-ec2-base/iam"
  for_each = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? var.items : {}

  # Instance profile configuration
  create_instance_profile = try(each.value.create_instance_profile, true)
  iam_role_name = try(each.value.iam_role_name, null)
  instance_profile_name = try(each.value.instance_profile_name, "${each.key}-instance-profile")
  instance_profile_path = try(each.value.instance_profile_path, "/")
  instance_profile_description = try(each.value.instance_profile_description, "Instance profile for existing IAM role")
  
  # Tags
  common_tags = merge(
    try(var.defaults.common_tags, {}),
    try(each.value.common_tags, {})
  )
  
  instance_profile_tags = merge(
    {
      Module = "terraform-ec2-wrapper"
      Purpose = "Instance profile for existing IAM role"
    },
    try(each.value.instance_profile_tags, {})
  )
  
  # Additional options
  enable_instance_profile_rotation = try(each.value.enable_instance_profile_rotation, false)
  instance_profile_permissions_boundary = try(each.value.instance_profile_permissions_boundary, null)
}

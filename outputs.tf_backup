# =============================================================================
# TERRAFORM-EC2-WRAPPER OUTPUTS
# =============================================================================

# =============================================================================
# EC2 INSTANCE OUTPUTS
# =============================================================================

output "instance_ids" {
  description = "Map of instance IDs"
  value       = { for k, v in module.wrapper : k => v.id }
}

output "instance_arns" {
  description = "Map of instance ARNs"
  value       = { for k, v in module.wrapper : k => v.arn }
}

output "instance_public_ips" {
  description = "Map of instance public IPs"
  value       = { for k, v in module.wrapper : k => v.public_ip }
}

output "instance_private_ips" {
  description = "Map of instance private IPs"
  value       = { for k, v in module.wrapper : k => v.private_ip }
}

output "instance_public_dns" {
  description = "Map of instance public DNS"
  value       = { for k, v in module.wrapper : k => v.public_dns }
}

output "instance_private_dns" {
  description = "Map of instance private DNS"
  value       = { for k, v in module.wrapper : k => v.private_dns }
}

output "instance_key_names" {
  description = "Map of instance key names"
  value       = { for k, v in module.wrapper : k => v.key_name }
}

output "instance_subnet_ids" {
  description = "Map of instance subnet IDs"
  value       = { for k, v in module.wrapper : k => v.subnet_id }
}

output "instance_vpc_security_group_ids" {
  description = "Map of instance VPC security group IDs"
  value       = { for k, v in module.wrapper : k => v.vpc_security_group_ids }
}

output "instance_root_block_device" {
  description = "Map of instance root block device configurations"
  value       = { for k, v in module.wrapper : k => v.root_block_device }
}

output "instance_ebs_block_device" {
  description = "Map of instance EBS block device configurations"
  value       = { for k, v in module.wrapper : k => v.ebs_block_device }
}

output "instance_metadata_options" {
  description = "Map of instance metadata options"
  value       = { for k, v in module.wrapper : k => v.metadata_options }
}

output "instance_network_interface_ids" {
  description = "Map of instance network interface IDs"
  value       = { for k, v in module.wrapper : k => v.network_interface_ids }
}

output "instance_primary_network_interface_id" {
  description = "Map of instance primary network interface IDs"
  value       = { for k, v in module.wrapper : k => v.primary_network_interface_id }
}

output "instance_outpost_arn" {
  description = "Map of instance outpost ARNs"
  value       = { for k, v in module.wrapper : k => v.outpost_arn }
}

output "instance_password_data" {
  description = "Map of instance password data"
  value       = { for k, v in module.wrapper : k => v.password_data }
}

output "instance_placement_group" {
  description = "Map of instance placement groups"
  value       = { for k, v in module.wrapper : k => v.placement_group }
}

output "instance_placement_partition_number" {
  description = "Map of instance placement partition numbers"
  value       = { for k, v in module.wrapper : k => v.placement_partition_number }
}

output "instance_ram_disk_id" {
  description = "Map of instance RAM disk IDs"
  value       = { for k, v in module.wrapper : k => v.ram_disk_id }
}

output "instance_security_groups" {
  description = "Map of instance security groups"
  value       = { for k, v in module.wrapper : k => v.security_groups }
}

output "instance_source_dest_check" {
  description = "Map of instance source destination check status"
  value       = { for k, v in module.wrapper : k => v.source_dest_check }
}

output "instance_spot_bid_status" {
  description = "Map of instance spot bid status"
  value       = { for k, v in module.wrapper : k => v.spot_bid_status }
}

output "instance_spot_instance_id" {
  description = "Map of instance spot instance IDs"
  value       = { for k, v in module.wrapper : k => v.spot_instance_id }
}

output "instance_spot_request_id" {
  description = "Map of instance spot request IDs"
  value       = { for k, v in module.wrapper : k => v.spot_request_id }
}

output "instance_state" {
  description = "Map of instance states"
  value       = { for k, v in module.wrapper : k => v.instance_state }
}

output "instance_state_transition_reason" {
  description = "Map of instance state transition reasons"
  value       = { for k, v in module.wrapper : k => v.state_transition_reason }
}

output "instance_subnet_id" {
  description = "Map of instance subnet IDs"
  value       = { for k, v in module.wrapper : k => v.subnet_id }
}

output "instance_tenancy" {
  description = "Map of instance tenancy"
  value       = { for k, v in module.wrapper : k => v.tenancy }
}

output "instance_user_data" {
  description = "Map of instance user data"
  value       = { for k, v in module.wrapper : k => v.user_data }
}

output "instance_user_data_base64" {
  description = "Map of instance user data base64"
  value       = { for k, v in module.wrapper : k => v.user_data_base64 }
}

output "instance_vpc_security_group_ids" {
  description = "Map of instance VPC security group IDs"
  value       = { for k, v in module.wrapper : k => v.vpc_security_group_ids }
}

output "instance_volume_tags" {
  description = "Map of instance volume tags"
  value       = { for k, v in module.wrapper : k => v.volume_tags }
}

output "instance_tags_all" {
  description = "Map of instance tags (including defaults)"
  value       = { for k, v in module.wrapper : k => v.tags_all }
}

# =============================================================================
# SECURITY GROUP OUTPUTS
# =============================================================================

output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in module.wrapper : k => v.security_group_ids }
}

output "security_group_arns" {
  description = "Map of security group ARNs"
  value       = { for k, v in module.wrapper : k => v.security_group_arns }
}

output "security_group_names" {
  description = "Map of security group names"
  value       = { for k, v in module.wrapper : k => v.security_group_names }
}

output "security_group_vpc_ids" {
  description = "Map of security group VPC IDs"
  value       = { for k, v in module.wrapper : k => v.security_group_vpc_ids }
}

output "security_group_owner_ids" {
  description = "Map of security group owner IDs"
  value       = { for k, v in module.wrapper : k => v.security_group_owner_ids }
}

output "security_group_rules" {
  description = "Map of security group rules"
  value       = { for k, v in module.wrapper : k => v.security_group_rules }
}

# =============================================================================
# IAM ROLE OUTPUTS
# =============================================================================

output "iam_role_names" {
  description = "Map of IAM role names"
  value       = { for k, v in module.wrapper : k => v.iam_role_names }
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value       = { for k, v in module.wrapper : k => v.iam_role_arns }
}

output "iam_role_unique_ids" {
  description = "Map of IAM role unique IDs"
  value       = { for k, v in module.wrapper : k => v.iam_role_unique_ids }
}

output "iam_role_paths" {
  description = "Map of IAM role paths"
  value       = { for k, v in module.wrapper : k => v.iam_role_paths }
}

output "iam_role_create_date" {
  description = "Map of IAM role creation dates"
  value       = { for k, v in module.wrapper : k => v.iam_role_create_date }
}

output "iam_role_tags_all" {
  description = "Map of IAM role tags (including defaults)"
  value       = { for k, v in module.wrapper : k => v.iam_role_tags_all }
}

# =============================================================================
# IAM INSTANCE PROFILE OUTPUTS
# =============================================================================

output "iam_instance_profile_names" {
  description = "Map of IAM instance profile names"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_names }
}

output "iam_instance_profile_arns" {
  description = "Map of IAM instance profile ARNs"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_arns }
}

output "iam_instance_profile_paths" {
  description = "Map of IAM instance profile paths"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_paths }
}

output "iam_instance_profile_roles" {
  description = "Map of IAM instance profile roles"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_roles }
}

output "iam_instance_profile_unique_ids" {
  description = "Map of IAM instance profile unique IDs"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_unique_ids }
}

output "iam_instance_profile_create_date" {
  description = "Map of IAM instance profile creation dates"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_create_date }
}

output "iam_instance_profile_tags_all" {
  description = "Map of IAM instance profile tags (including defaults)"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_tags_all }
}

# =============================================================================
# ELASTIC IP OUTPUTS
# =============================================================================

output "eip_ids" {
  description = "Map of Elastic IP IDs"
  value       = { for k, v in module.wrapper : k => v.eip_ids }
}

output "eip_public_ips" {
  description = "Map of Elastic IP public IPs"
  value       = { for k, v in module.wrapper : k => v.eip_public_ips }
}

output "eip_public_ipv4_pools" {
  description = "Map of Elastic IP public IPv4 pools"
  value       = { for k, v in module.wrapper : k => v.eip_public_ipv4_pools }
}

output "eip_carrier_ips" {
  description = "Map of Elastic IP carrier IPs"
  value       = { for k, v in module.wrapper : k => v.eip_carrier_ips }
}

output "eip_customer_owned_ips" {
  description = "Map of Elastic IP customer owned IPs"
  value       = { for k, v in module.wrapper : k => v.eip_customer_owned_ips }
}

output "eip_domains" {
  description = "Map of Elastic IP domains"
  value       = { for k, v in module.wrapper : k => v.eip_domains }
}

output "eip_private_ips" {
  description = "Map of Elastic IP private IPs"
  value       = { for k, v in module.wrapper : k => v.eip_private_ips }
}

output "eip_association_ids" {
  description = "Map of Elastic IP association IDs"
  value       = { for k, v in module.wrapper : k => v.eip_association_ids }
}

output "eip_network_interface_ids" {
  description = "Map of Elastic IP network interface IDs"
  value       = { for k, v in module.wrapper : k => v.eip_network_interface_ids }
}

output "eip_network_interface_owner_ids" {
  description = "Map of Elastic IP network interface owner IDs"
  value       = { for k, v in module.wrapper : k => v.eip_network_interface_owner_ids }
}

output "eip_tags_all" {
  description = "Map of Elastic IP tags (including defaults)"
  value       = { for k, v in module.wrapper : k => v.eip_tags_all }
}

# =============================================================================
# INSTANCE PROFILE OUTPUTS (for existing IAM roles)
# =============================================================================

output "instance_profiles" {
  description = "Map of instance profiles created for existing IAM roles"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? module.iam_instance_profiles : {}
}

output "instance_profile_names" {
  description = "Map of instance profile names"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_name } : {}
}

output "instance_profile_arns" {
  description = "Map of instance profile ARNs"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_arn } : {}
}

output "instance_profile_paths" {
  description = "Map of instance profile paths"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_path } : {}
}

output "instance_profile_roles" {
  description = "Map of instance profile roles"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_roles } : {}
}

output "instance_profile_unique_ids" {
  description = "Map of instance profile unique IDs"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_unique_id } : {}
}

output "instance_profile_create_dates" {
  description = "Map of instance profile creation dates"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_create_date } : {}
}

output "instance_profile_tags_all" {
  description = "Map of instance profile tags (including defaults)"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_tags_all } : {}
}

# =============================================================================
# COMBINED OUTPUTS
# =============================================================================

output "all_instances" {
  description = "Map of all EC2 instances"
  value       = module.wrapper
}

output "all_monitoring" {
  description = "Map of all monitoring resources"
  value       = try(var.defaults.create_monitoring, false) ? module.instance_monitoring : {}
}

output "all_instance_profiles" {
  description = "Map of all instance profiles"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? module.iam_instance_profiles : {}
}

output "deployment_summary" {
  description = "Summary of all deployed resources"
  value = {
    total_instances = length(module.wrapper)
    total_monitoring_resources = try(var.defaults.create_monitoring, false) ? length(module.instance_monitoring) : 0
    total_instance_profiles = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? length(module.iam_instance_profiles) : 0
    instance_names = [for k, v in module.wrapper : k]
    monitoring_enabled = try(var.defaults.create_monitoring, false)
    instance_profiles_enabled = try(var.defaults.create_instance_profiles_for_existing_roles, false)
  }
}

################################################################################
# Security Group Outputs
################################################################################

output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in module.wrapper : k => v.security_group_id }
}

output "security_group_arns" {
  description = "Map of security group ARNs"
  value       = { for k, v in module.wrapper : k => v.security_group_arn }
}

output "security_group_names" {
  description = "Map of security group names"
  value       = { for k, v in module.wrapper : k => v.security_group_name }
}

################################################################################
# EIP Outputs
################################################################################

output "eip_ids" {
  description = "Map of EIP IDs"
  value       = { for k, v in module.wrapper : k => v.eip_id }
}

output "eip_public_ips" {
  description = "Map of EIP public IPs"
  value       = { for k, v in module.wrapper : k => v.eip_public_ip }
}

output "eip_public_ipv4_pools" {
  description = "Map of EIP public IPv4 pools"
  value       = { for k, v in module.wrapper : k => v.eip_public_ipv4_pool }
}

################################################################################
# IAM Instance Profile Management Outputs
################################################################################

output "instance_profiles" {
  description = "Map of instance profiles created for existing IAM roles"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? module.iam_instance_profiles : {}
}

output "instance_profile_names" {
  description = "Map of instance profile names"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_name } : {}
}

output "instance_profile_arns" {
  description = "Map of instance profile ARNs"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_arn } : {}
}

output "instance_profile_ids" {
  description = "Map of instance profile IDs"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_id } : {}
}

output "instance_profile_unique_ids" {
  description = "Map of instance profile unique IDs"
  value       = try(var.defaults.create_instance_profiles_for_existing_roles, false) ? { for k, v in module.iam_instance_profiles : k => v.instance_profile_unique_id } : {}
}

################################################################################
# Monitoring Outputs
################################################################################

output "monitoring_alarms" {
  description = "Map of monitoring alarms for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.all_alarms } : {}
}

output "monitoring_alarm_arns" {
  description = "Map of monitoring alarm ARNs for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.all_alarm_arns } : {}
}

output "monitoring_alarm_names" {
  description = "Map of monitoring alarm names for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.all_alarm_names } : {}
}

output "monitoring_dashboards" {
  description = "Map of monitoring dashboards for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.dashboard } : {}
}

output "monitoring_dashboard_names" {
  description = "Map of monitoring dashboard names for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.dashboard_name } : {}
}

output "monitoring_dashboard_arns" {
  description = "Map of monitoring dashboard ARNs for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.dashboard_arn } : {}
}

output "monitoring_summaries" {
  description = "Map of monitoring summaries for each instance"
  value       = try(var.defaults.create_monitoring, false) ? { for k, v in module.instance_monitoring : k => v.monitoring_summary } : {}
}

################################################################################
# Logging Outputs
################################################################################

output "logging_log_groups" {
  description = "Map of logging log groups for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_groups } : {}
}

output "logging_log_group_names" {
  description = "Map of logging log group names for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_groups } : {}
}

output "logging_log_group_arns" {
  description = "Map of logging log group ARNs for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_groups } : {}
}

output "logging_log_streams" {
  description = "Map of logging log streams for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_streams } : {}
}

output "logging_log_stream_names" {
  description = "Map of logging log stream names for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_streams } : {}
}

output "logging_metric_filters" {
  description = "Map of logging metric filters for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_metric_filters } : {}
}

output "logging_metric_filter_names" {
  description = "Map of logging metric filter names for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_metric_filters } : {}
}

output "logging_alarms" {
  description = "Map of logging alarms for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_alarms } : {}
}

output "logging_alarm_names" {
  description = "Map of logging alarm names for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_alarms } : {}
}

output "logging_alarm_arns" {
  description = "Map of logging alarm ARNs for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.all_log_alarms } : {}
}

output "logging_summaries" {
  description = "Map of logging summaries for each instance"
  value       = try(var.defaults.create_logging, false) ? { for k, v in module.instance_logging : k => v.logging_summary } : {}
}

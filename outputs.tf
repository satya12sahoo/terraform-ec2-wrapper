output "wrapper" {
  description = "Map of outputs of a wrapper."
  value       = module.wrapper
  # sensitive = false # No sensitive module output found
}

################################################################################
# Instance Outputs
################################################################################

output "instance_ids" {
  description = "Map of instance IDs"
  value       = { for k, v in module.wrapper : k => v.id }
}

output "instance_arns" {
  description = "Map of instance ARNs"
  value       = { for k, v in module.wrapper : k => v.arn }
}

output "instance_states" {
  description = "Map of instance states"
  value       = { for k, v in module.wrapper : k => v.instance_state }
}

output "instance_availability_zones" {
  description = "Map of instance availability zones"
  value       = { for k, v in module.wrapper : k => v.availability_zone }
}

output "instance_amis" {
  description = "Map of AMI IDs used to create instances"
  value       = { for k, v in module.wrapper : k => v.ami }
}

output "instance_public_ips" {
  description = "Map of public IP addresses assigned to instances"
  value       = { for k, v in module.wrapper : k => v.public_ip }
}

output "instance_private_ips" {
  description = "Map of private IP addresses assigned to instances"
  value       = { for k, v in module.wrapper : k => v.private_ip }
}

output "instance_public_dns" {
  description = "Map of public DNS names assigned to instances"
  value       = { for k, v in module.wrapper : k => v.public_dns }
}

output "instance_private_dns" {
  description = "Map of private DNS names assigned to instances"
  value       = { for k, v in module.wrapper : k => v.private_dns }
}

output "instance_ipv6_addresses" {
  description = "Map of IPv6 addresses assigned to instances"
  value       = { for k, v in module.wrapper : k => v.ipv6_addresses }
}

output "instance_primary_network_interface_ids" {
  description = "Map of primary network interface IDs"
  value       = { for k, v in module.wrapper : k => v.primary_network_interface_id }
}

output "instance_capacity_reservation_specifications" {
  description = "Map of capacity reservation specifications"
  value       = { for k, v in module.wrapper : k => v.capacity_reservation_specification }
}

output "instance_outpost_arns" {
  description = "Map of outpost ARNs"
  value       = { for k, v in module.wrapper : k => v.outpost_arn }
}

output "instance_password_data" {
  description = "Map of password data for instances"
  value       = { for k, v in module.wrapper : k => v.password_data }
  sensitive   = true
}

output "instance_tags_all" {
  description = "Map of all tags assigned to instances"
  value       = { for k, v in module.wrapper : k => v.tags_all }
}

################################################################################
# Spot Instance Outputs
################################################################################

output "spot_bid_statuses" {
  description = "Map of spot bid statuses"
  value       = { for k, v in module.wrapper : k => v.spot_bid_status }
}

output "spot_request_states" {
  description = "Map of spot request states"
  value       = { for k, v in module.wrapper : k => v.spot_request_state }
}

output "spot_instance_ids" {
  description = "Map of spot instance IDs"
  value       = { for k, v in module.wrapper : k => v.spot_instance_id }
}

################################################################################
# EBS Volume Outputs
################################################################################

output "ebs_volumes" {
  description = "Map of EBS volumes created and their attributes"
  value       = { for k, v in module.wrapper : k => v.ebs_volumes }
}

################################################################################
# IAM Role / Instance Profile Outputs
################################################################################

output "iam_role_names" {
  description = "Map of IAM role names"
  value       = { for k, v in module.wrapper : k => v.iam_role_name }
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value       = { for k, v in module.wrapper : k => v.iam_role_arn }
}

output "iam_role_unique_ids" {
  description = "Map of IAM role unique IDs"
  value       = { for k, v in module.wrapper : k => v.iam_role_unique_id }
}

output "iam_instance_profile_arns" {
  description = "Map of IAM instance profile ARNs"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_arn }
}

output "iam_instance_profile_ids" {
  description = "Map of IAM instance profile IDs"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_id }
}

output "iam_instance_profile_uniques" {
  description = "Map of IAM instance profile unique IDs"
  value       = { for k, v in module.wrapper : k => v.iam_instance_profile_unique }
}

################################################################################
# Block Device Outputs
################################################################################

output "root_block_devices" {
  description = "Map of root block device information"
  value       = { for k, v in module.wrapper : k => v.root_block_device }
}

output "ebs_block_devices" {
  description = "Map of EBS block device information"
  value       = { for k, v in module.wrapper : k => v.ebs_block_device }
}

output "ephemeral_block_devices" {
  description = "Map of ephemeral block device information"
  value       = { for k, v in module.wrapper : k => v.ephemeral_block_device }
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

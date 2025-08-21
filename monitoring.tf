# =============================================================================
# Monitoring Integration for EC2 Instances
# =============================================================================
# This file handles the creation of CloudWatch monitoring resources for EC2 instances
# using the terraform-aws-ec2-base/monitoring module

# Create monitoring resources for each EC2 instance
module "instance_monitoring" {
  source = "github.com/satya12sahoo/terraform-aws-ec2-base/tree/master/monitoring"
  for_each = try(var.defaults.create_monitoring, false) ? var.items : {}

  # Instance information
  instance_id   = module.wrapper[each.key].id
  instance_name = try(each.value.name, each.key)

  # Tags
  tags = merge(
    try(var.defaults.tags, {}),
    try(each.value.tags, {}),
    {
      Module = "terraform-ec2-wrapper"
      Purpose = "EC2 Instance Monitoring"
    }
  )

  # CPU Alarm Configuration
  create_cpu_alarm = try(each.value.create_cpu_alarm, try(var.defaults.create_cpu_alarm, true))
  cpu_alarm_name = try(each.value.cpu_alarm_name, "${each.key}-cpu-alarm")
  cpu_threshold = try(each.value.cpu_threshold, try(var.defaults.cpu_threshold, 80))
  cpu_evaluation_periods = try(each.value.cpu_evaluation_periods, try(var.defaults.cpu_evaluation_periods, 2))
  cpu_period = try(each.value.cpu_period, try(var.defaults.cpu_period, 300))
  cpu_alarm_actions = try(each.value.cpu_alarm_actions, try(var.defaults.cpu_alarm_actions, []))
  cpu_ok_actions = try(each.value.cpu_ok_actions, try(var.defaults.cpu_ok_actions, []))

  # Memory Alarm Configuration (requires CloudWatch Agent)
  create_memory_alarm = try(each.value.create_memory_alarm, try(var.defaults.create_memory_alarm, false))
  memory_alarm_name = try(each.value.memory_alarm_name, "${each.key}-memory-alarm")
  memory_threshold = try(each.value.memory_threshold, try(var.defaults.memory_threshold, 85))
  memory_evaluation_periods = try(each.value.memory_evaluation_periods, try(var.defaults.memory_evaluation_periods, 2))
  memory_period = try(each.value.memory_period, try(var.defaults.memory_period, 300))
  memory_alarm_actions = try(each.value.memory_alarm_actions, try(var.defaults.memory_alarm_actions, []))

  # Disk Alarm Configuration (requires CloudWatch Agent)
  create_disk_alarm = try(each.value.create_disk_alarm, try(var.defaults.create_disk_alarm, false))
  disk_alarm_name = try(each.value.disk_alarm_name, "${each.key}-disk-alarm")
  disk_threshold = try(each.value.disk_threshold, try(var.defaults.disk_threshold, 85))
  disk_evaluation_periods = try(each.value.disk_evaluation_periods, try(var.defaults.disk_evaluation_periods, 2))
  disk_period = try(each.value.disk_period, try(var.defaults.disk_period, 300))
  disk_filesystem = try(each.value.disk_filesystem, try(var.defaults.disk_filesystem, "/dev/xvda1"))
  disk_mount_path = try(each.value.disk_mount_path, try(var.defaults.disk_mount_path, "/"))
  disk_alarm_actions = try(each.value.disk_alarm_actions, try(var.defaults.disk_alarm_actions, []))

  # Network In Alarm Configuration
  create_network_in_alarm = try(each.value.create_network_in_alarm, try(var.defaults.create_network_in_alarm, false))
  network_in_alarm_name = try(each.value.network_in_alarm_name, "${each.key}-network-in-alarm")
  network_in_threshold = try(each.value.network_in_threshold, try(var.defaults.network_in_threshold, 1000000000))
  network_in_evaluation_periods = try(each.value.network_in_evaluation_periods, try(var.defaults.network_in_evaluation_periods, 2))
  network_in_period = try(each.value.network_in_period, try(var.defaults.network_in_period, 300))
  network_in_alarm_actions = try(each.value.network_in_alarm_actions, try(var.defaults.network_in_alarm_actions, []))

  # Network Out Alarm Configuration
  create_network_out_alarm = try(each.value.create_network_out_alarm, try(var.defaults.create_network_out_alarm, false))
  network_out_alarm_name = try(each.value.network_out_alarm_name, "${each.key}-network-out-alarm")
  network_out_threshold = try(each.value.network_out_threshold, try(var.defaults.network_out_threshold, 1000000000))
  network_out_evaluation_periods = try(each.value.network_out_evaluation_periods, try(var.defaults.network_out_evaluation_periods, 2))
  network_out_period = try(each.value.network_out_period, try(var.defaults.network_out_period, 300))
  network_out_alarm_actions = try(each.value.network_out_alarm_actions, try(var.defaults.network_out_alarm_actions, []))

  # Status Check Alarm Configuration
  create_status_check_alarm = try(each.value.create_status_check_alarm, try(var.defaults.create_status_check_alarm, true))
  status_check_alarm_name = try(each.value.status_check_alarm_name, "${each.key}-status-check-alarm")
  status_check_evaluation_periods = try(each.value.status_check_evaluation_periods, try(var.defaults.status_check_evaluation_periods, 2))
  status_check_period = try(each.value.status_check_period, try(var.defaults.status_check_period, 60))
  status_check_alarm_actions = try(each.value.status_check_alarm_actions, try(var.defaults.status_check_alarm_actions, []))

  # Dashboard Configuration
  create_dashboard = try(each.value.create_dashboard, try(var.defaults.create_dashboard, true))
  dashboard_name = try(each.value.dashboard_name, "${each.key}-dashboard")
}


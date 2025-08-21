# =============================================================================
# Logging Integration for EC2 Instances
# =============================================================================
# This file handles the creation of CloudWatch logging resources for EC2 instances
# using the terraform-aws-ec2-base/logging module

# Create logging resources for each EC2 instance
module "instance_logging" {
  source = "git::https://github.com/satya12sahoo/terraform-aws-ec2-base.git//logging?ref=master"
  for_each = try(var.defaults.create_logging, false) ? var.items : {}

  # Instance information
  instance_name = try(each.value.name, each.key)

  # Tags
  tags = merge(
    try(var.defaults.tags, {}),
    try(each.value.tags, {}),
    {
      Module = "terraform-ec2-wrapper"
      Purpose = "EC2 Instance Logging"
    }
  )

  # =============================================================================
  # APPLICATION LOG GROUP CONFIGURATION
  # =============================================================================

  create_application_log_group = try(each.value.create_application_log_group, try(var.defaults.create_application_log_group, false))
  application_log_group_name = try(each.value.application_log_group_name, "${each.key}-application-logs")
  application_log_retention_days = try(each.value.application_log_retention_days, try(var.defaults.application_log_retention_days, 30))
  application_log_group_kms_key_id = try(each.value.application_log_group_kms_key_id, try(var.defaults.application_log_group_kms_key_id, null))
  application_log_group_skip_destroy = try(each.value.application_log_group_skip_destroy, try(var.defaults.application_log_group_skip_destroy, false))

  create_application_log_stream = try(each.value.create_application_log_stream, try(var.defaults.create_application_log_stream, false))
  application_log_stream_name = try(each.value.application_log_stream_name, "${each.key}-application-stream")

  # =============================================================================
  # SYSTEM LOG GROUP CONFIGURATION
  # =============================================================================

  create_system_log_group = try(each.value.create_system_log_group, try(var.defaults.create_system_log_group, false))
  system_log_group_name = try(each.value.system_log_group_name, "${each.key}-system-logs")
  system_log_retention_days = try(each.value.system_log_retention_days, try(var.defaults.system_log_retention_days, 30))
  system_log_group_kms_key_id = try(each.value.system_log_group_kms_key_id, try(var.defaults.system_log_group_kms_key_id, null))
  system_log_group_skip_destroy = try(each.value.system_log_group_skip_destroy, try(var.defaults.system_log_group_skip_destroy, false))

  create_system_log_stream = try(each.value.create_system_log_stream, try(var.defaults.create_system_log_stream, false))
  system_log_stream_name = try(each.value.system_log_stream_name, "${each.key}-system-stream")

  # =============================================================================
  # ACCESS LOG GROUP CONFIGURATION
  # =============================================================================

  create_access_log_group = try(each.value.create_access_log_group, try(var.defaults.create_access_log_group, false))
  access_log_group_name = try(each.value.access_log_group_name, "${each.key}-access-logs")
  access_log_retention_days = try(each.value.access_log_retention_days, try(var.defaults.access_log_retention_days, 30))
  access_log_group_kms_key_id = try(each.value.access_log_group_kms_key_id, try(var.defaults.access_log_group_kms_key_id, null))
  access_log_group_skip_destroy = try(each.value.access_log_group_skip_destroy, try(var.defaults.access_log_group_skip_destroy, false))

  create_access_log_stream = try(each.value.create_access_log_stream, try(var.defaults.create_access_log_stream, false))
  access_log_stream_name = try(each.value.access_log_stream_name, "${each.key}-access-stream")

  # =============================================================================
  # ERROR LOG GROUP CONFIGURATION
  # =============================================================================

  create_error_log_group = try(each.value.create_error_log_group, try(var.defaults.create_error_log_group, false))
  error_log_group_name = try(each.value.error_log_group_name, "${each.key}-error-logs")
  error_log_retention_days = try(each.value.error_log_retention_days, try(var.defaults.error_log_retention_days, 90))
  error_log_group_kms_key_id = try(each.value.error_log_group_kms_key_id, try(var.defaults.error_log_group_kms_key_id, null))
  error_log_group_skip_destroy = try(each.value.error_log_group_skip_destroy, try(var.defaults.error_log_group_skip_destroy, false))

  create_error_log_stream = try(each.value.create_error_log_stream, try(var.defaults.create_error_log_stream, false))
  error_log_stream_name = try(each.value.error_log_stream_name, "${each.key}-error-stream")

  # =============================================================================
  # CUSTOM LOG GROUP CONFIGURATION
  # =============================================================================

  custom_log_groups = try(each.value.custom_log_groups, try(var.defaults.custom_log_groups, {}))
  default_custom_log_retention_days = try(each.value.default_custom_log_retention_days, try(var.defaults.default_custom_log_retention_days, 30))
  default_custom_log_skip_destroy = try(each.value.default_custom_log_skip_destroy, try(var.defaults.default_custom_log_skip_destroy, false))

  custom_log_streams = try(each.value.custom_log_streams, try(var.defaults.custom_log_streams, {}))

  # =============================================================================
  # METRIC FILTER CONFIGURATION
  # =============================================================================

  # Error Metric Filter
  create_error_metric_filter = try(each.value.create_error_metric_filter, try(var.defaults.create_error_metric_filter, false))
  error_metric_filter_name = try(each.value.error_metric_filter_name, "${each.key}-error-filter")
  error_metric_filter_pattern = try(each.value.error_metric_filter_pattern, try(var.defaults.error_metric_filter_pattern, "[timestamp, level=ERROR, message]"))
  error_metric_name = try(each.value.error_metric_name, "${each.key}-error-count")
  error_metric_namespace = try(each.value.error_metric_namespace, try(var.defaults.error_metric_namespace, "EC2/Logs"))
  error_metric_value = try(each.value.error_metric_value, try(var.defaults.error_metric_value, "1"))
  error_metric_default_value = try(each.value.error_metric_default_value, try(var.defaults.error_metric_default_value, "0"))

  # Access Metric Filter
  create_access_metric_filter = try(each.value.create_access_metric_filter, try(var.defaults.create_access_metric_filter, false))
  access_metric_filter_name = try(each.value.access_metric_filter_name, "${each.key}-access-filter")
  access_metric_filter_pattern = try(each.value.access_metric_filter_pattern, try(var.defaults.access_metric_filter_pattern, "[timestamp, ip, method, path, status]"))
  access_metric_name = try(each.value.access_metric_name, "${each.key}-access-count")
  access_metric_namespace = try(each.value.access_metric_namespace, try(var.defaults.access_metric_namespace, "EC2/Logs"))
  access_metric_value = try(each.value.access_metric_value, try(var.defaults.access_metric_value, "1"))
  access_metric_default_value = try(each.value.access_metric_default_value, try(var.defaults.access_metric_default_value, "0"))

  # Custom Metric Filters
  custom_metric_filters = try(each.value.custom_metric_filters, try(var.defaults.custom_metric_filters, {}))

  # =============================================================================
  # LOG ALARM CONFIGURATION
  # =============================================================================

  # Error Log Alarm
  create_error_log_alarm = try(each.value.create_error_log_alarm, try(var.defaults.create_error_log_alarm, false))
  error_log_alarm_name = try(each.value.error_log_alarm_name, "${each.key}-error-log-alarm")
  error_log_alarm_comparison_operator = try(each.value.error_log_alarm_comparison_operator, try(var.defaults.error_log_alarm_comparison_operator, "GreaterThanThreshold"))
  error_log_alarm_evaluation_periods = try(each.value.error_log_alarm_evaluation_periods, try(var.defaults.error_log_alarm_evaluation_periods, 2))
  error_log_alarm_period = try(each.value.error_log_alarm_period, try(var.defaults.error_log_alarm_period, 300))
  error_log_alarm_statistic = try(each.value.error_log_alarm_statistic, try(var.defaults.error_log_alarm_statistic, "Sum"))
  error_log_alarm_threshold = try(each.value.error_log_alarm_threshold, try(var.defaults.error_log_alarm_threshold, 10))
  error_log_alarm_description = try(each.value.error_log_alarm_description, try(var.defaults.error_log_alarm_description, "Error log rate alarm for ${each.key}"))
  error_log_alarm_actions = try(each.value.error_log_alarm_actions, try(var.defaults.error_log_alarm_actions, []))
  error_log_alarm_ok_actions = try(each.value.error_log_alarm_ok_actions, try(var.defaults.error_log_alarm_ok_actions, []))
  error_log_alarm_treat_missing_data = try(each.value.error_log_alarm_treat_missing_data, try(var.defaults.error_log_alarm_treat_missing_data, "notBreaching"))

  # Access Log Alarm
  create_access_log_alarm = try(each.value.create_access_log_alarm, try(var.defaults.create_access_log_alarm, false))
  access_log_alarm_name = try(each.value.access_log_alarm_name, "${each.key}-access-log-alarm")
  access_log_alarm_comparison_operator = try(each.value.access_log_alarm_comparison_operator, try(var.defaults.access_log_alarm_comparison_operator, "GreaterThanThreshold"))
  access_log_alarm_evaluation_periods = try(each.value.access_log_alarm_evaluation_periods, try(var.defaults.access_log_alarm_evaluation_periods, 2))
  access_log_alarm_period = try(each.value.access_log_alarm_period, try(var.defaults.access_log_alarm_period, 300))
  access_log_alarm_statistic = try(each.value.access_log_alarm_statistic, try(var.defaults.access_log_alarm_statistic, "Sum"))
  access_log_alarm_threshold = try(each.value.access_log_alarm_threshold, try(var.defaults.access_log_alarm_threshold, 1000))
  access_log_alarm_description = try(each.value.access_log_alarm_description, try(var.defaults.access_log_alarm_description, "Access log rate alarm for ${each.key}"))
  access_log_alarm_actions = try(each.value.access_log_alarm_actions, try(var.defaults.access_log_alarm_actions, []))
  access_log_alarm_ok_actions = try(each.value.access_log_alarm_ok_actions, try(var.defaults.access_log_alarm_ok_actions, []))
  access_log_alarm_treat_missing_data = try(each.value.access_log_alarm_treat_missing_data, try(var.defaults.access_log_alarm_treat_missing_data, "notBreaching"))

  # Custom Log Alarms
  custom_log_alarms = try(each.value.custom_log_alarms, try(var.defaults.custom_log_alarms, {}))
}



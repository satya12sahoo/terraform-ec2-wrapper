# =============================================================================
# Variables for EC2 Instances with Logging Example
# =============================================================================

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 instances will be launched"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair to use for SSH access"
  type        = string
}

variable "alert_email" {
  description = "Email address for logging alerts"
  type        = string
}

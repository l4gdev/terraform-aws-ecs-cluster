variable "labels" {
  type = object({
    tags = object({
      Environment = string
      Service     = string
    })
    name = string
  })
  description = "Labels to apply to all resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnets should be private"
}

variable "instance_key_name" {
  type        = string
  nullable    = true
  default     = null
  description = "Do not use, by default you should use session manager. It will be enabled by default"
}

variable "autoscaling_group_health_check_grace_period" {
  type    = string
  default = 20
}

variable "ecs_optimized_image_ssm_parameter" {
  type    = string
  default = ""
}

variable "instances_groups" {
  type = list(object({
    name = string

    instance_type = optional(string)
    instance_requirements = optional(object({
      allowed_instance_types = list(string) # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#allowed_instance_types
      vcpu_count = optional(object({
        min = optional(number, 1)
        max = optional(number)
      }))
      memory_mib = optional(object({
        min = optional(number, 256)
        max = optional(number)
      }))
      on_demand_max_price_percentage_over_lowest_price = optional(number)
      spot_max_price_percentage_over_lowest_price      = optional(number)
    }), null)


    architecture               = string
    autoscaling_group_min_size = string
    autoscaling_group_max_size = string
    spot = optional(object({
      enabled   = optional(bool, false)
      max_price = optional(string, null)
    }), {})
  }))

  validation {
    condition     = length([for instance_group in var.instances_groups : instance_group.instance_type if instance_group.instance_requirements != null]) == 0
    error_message = "instance_type and instance_requirements are mutually exclusive"
  }
  validation {
    # validate if architecture is arm64 or amd64
    condition     = length([for instance_group in var.instances_groups : instance_group.architecture if instance_group.architecture != "arm64" && instance_group.architecture != "amd64"]) == 0
    error_message = "architecture must be arm64 or amd64"
  }

  description = "List of instance groups to create"
}


variable "fsx" {
  type = list(object({
    name                  = string
    storage_capacity      = number
    deployment_type       = optional(string, "SINGLE_AZ_2")
    subnet_id             = string
    throughput_capacity   = number
    data_compression_type = optional(string, "LZ4")
    mount_path            = string
    disk_iops_configuration = optional(object({
      mode = string
      iops = number
  }), null) }))
  default     = []
  description = "List of FSX file systems to create"
}

locals {
  fsx_remap = { for fsx in var.fsx : fsx["name"] => fsx }
}

variable "enable_container_insights" {
  type        = bool
  default     = false
  description = "Enable CloudWatch Container Insights for the cluster"
}


variable "datadog" {
  type = object({
    enable                      = optional(bool, false)
    api_key_secret_manager_name = string
    site                        = optional(string, "datadoghq.eu")
    process_agent_enabled       = optional(bool, true)
    logs_enable                 = optional(bool, true),
    collect_all_logs            = optional(bool, false)
    apm_enable                  = optional(bool, false),
    agent_log_level             = optional(string, "ERROR")
  })
  default = {
    enable                      = false
    api_key_secret_manager_name = ""
    site                        = "datadoghq.eu"
    process_agent_enabled       = true
    logs_enable                 = true
    collect_all_logs            = false
    apm_enable                  = false
    agent_log_level             = "ERROR"
  }
}

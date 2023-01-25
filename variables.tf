variable "labels" {
  type = object({
    tags = object({
      Environment = string
      Service     = string
    })
    name = string
  })
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnets should be private"
}

variable "instance_key_name" {
  type     = string
  nullable = true
  default  = null
}

variable "autoscaling_group_health_check_grace_period" {
  type    = string
  default = 20
}

variable "ecs_optimized_image_ssm_parameter" {
  type    = string
  default = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}


variable "instances_groups" {
  type = list(object({
    name                       = string
    instance_type              = string
    architecture               = string
    autoscaling_group_min_size = string
    autoscaling_group_max_size = string
    spot = optional(object({
      enable = optional(bool, false)
      price  = optional(string, null)
    }), {})
  }))
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

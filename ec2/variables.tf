variable "labels" {
  type = any
}

variable "autoscaling_group_min_size" {
  type        = string
  description = "minium instances at asg"
}

variable "autoscaling_group_max_size" {
  type        = string
  description = "maximum instances at asg"
}

variable "autoscaling_group_health_check_grace_period" {
  type = string
}
####################
variable "architecture" {
  type = string
}

#####################
variable "instance_subnets" {
  type = list(string)
}

variable "instance_security_group" {
  type = string
}

variable "instance_type" {
  type        = string
  description = "Allowed instance type"
}

variable "instance_requirements" {
  type = object({
    allowed_instance_types = list(string) # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#allowed_instance_types
    vcpu_count = object({
      min = optional(number, 1)
      max = optional(number)
    })
    memory_mib = object({
      min = number
      max = optional(number)
    })
    on_demand_max_price_percentage_over_lowest_price = optional(number)
    spot_max_price_percentage_over_lowest_price      = optional(number)
  })
  default = null
}


variable "instance_iam_role" {
  type        = string
  description = "Instance IAM role"
}

variable "instance_key_name" {
  type = string
}

########

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_optimized_image_ssm_parameter" {
  type = string
}

variable "spot" {
  type = object({
    enabled   = optional(bool, false)
    max_price = optional(string, null)
  })
  default = {
    enabled   = false
    max_price = null
  }
}

variable "instance_group_name" {
  type = string
}

variable "night_scaling" {
  type = object({
    enabled = bool
  })
  default = {
    enabled = false
  }
}

variable "fsx" {
  type = any
}

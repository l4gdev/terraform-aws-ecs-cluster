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
  description = "Size of frontend app"
}

variable "instance_iam_role" {
  type        = string
  description = "ECS iam role"
}

variable "instance_key_name" {
  type = string
}

########

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_optimized_image_ssm_parameter" {
  type    = string
  default = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

variable "spot_price" {
  type    = string
  default = ""
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

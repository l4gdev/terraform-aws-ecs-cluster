locals {

  default_ami_ssm = {
    amd64 = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id",
    arm64 = "/aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended/image_id"
  }

}


data "aws_ssm_parameter" "ami" {
  name = var.ecs_optimized_image_ssm_parameter == "" ? lookup(local.default_ami_ssm, var.architecture) : var.ecs_optimized_image_ssm_parameter
}

variable "volume_size" {
  default = 50
  type    = number
}
resource "aws_launch_template" "ecs" {
  image_id      = data.aws_ssm_parameter.ami.value
  name_prefix   = "${var.labels.tags.Service}-${var.labels.tags.Environment}-"
  instance_type = var.instance_type

  dynamic "instance_requirements" {
    for_each = var.instance_requirements != null ? [1] : []
    content {
      allowed_instance_types = instance_requirements.value.allowed_instance_types
      memory_mib {
        min = instance_requirements.value.memory_mib.min
        max = instance_requirements.value.memory_mib.max
      }
      vcpu_count {
        min = instance_requirements.value.vcpus.min
        max = instance_requirements.value.vcpus.max
      }
      on_demand_max_price_percentage_over_lowest_price = instance_requirements.value.on_demand_max_price_percentage_over_lowest_price
      spot_max_price_percentage_over_lowest_price      = instance_requirements.value.spot_max_price_percentage_over_lowest_price
    }
  }

  dynamic "instance_market_options" {
    for_each = var.spot.enabled == true ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price = var.spot.max_price
      }
    }
  }


  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  vpc_security_group_ids = [var.instance_security_group]



  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
      volume_type = "gp3"
      encrypted   = true
    }
  }
  #
  #  block_device_mappings {
  #    device_name = "/dev/xvda1"
  #    ebs {
  #      volume_size = 40
  #      volume_type = "gp3"
  #      encrypted   = true
  #    }
  #  }


  iam_instance_profile {
    name = var.instance_iam_role
  }
  key_name  = var.instance_key_name
  user_data = base64encode(local.templatefile)

  lifecycle {
    create_before_destroy = true
  }
}

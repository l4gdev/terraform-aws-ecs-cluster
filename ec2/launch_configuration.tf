data "aws_ssm_parameter" "ami" {
  name = var.ecs_optimized_image_ssm_parameter
}

resource "aws_launch_configuration" "production_launch_config" {
  image_id    = data.aws_ssm_parameter.ami.value
  name_prefix = "${var.labels.tags.Service}-${var.labels.tags.Environment}-"
  spot_price  = var.spot_price

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  security_groups = [
    var.instance_security_group
  ]

  root_block_device {
    volume_type = "gp3"
    volume_size = 40
    encrypted   = true
  }

  ebs_block_device {
    volume_type = "gp3"
    device_name = "/dev/xvdcz"
    volume_size = 50
    encrypted   = true
  }

  instance_type        = var.instance_type
  iam_instance_profile = var.instance_iam_role
  key_name             = var.instance_key_name
  user_data            = local.templatefile

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_placement_group" "asg_placement" {
  name     = "${var.labels.tags.Service}-${var.labels.tags.Environment}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  strategy = "spread"
  lifecycle {
    ignore_changes        = [spread_level, name]
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${var.labels.tags.Service}-${var.labels.tags.Environment}-${var.instance_group_name}-${replace(var.instance_type, ".", "-")}-${var.architecture}"
  max_size                  = var.autoscaling_group_max_size
  min_size                  = var.autoscaling_group_min_size
  health_check_grace_period = var.autoscaling_group_health_check_grace_period
  health_check_type         = "EC2"
  placement_group           = aws_placement_group.asg_placement.id
  depends_on                = [aws_placement_group.asg_placement]

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = var.instance_subnets

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.labels.tags.Service}-${var.labels.tags.Environment}-ecs-cluster"
  }

  dynamic "tag" {
    for_each = var.labels.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "5m" ### increased timeout so this wont fail in edge cases,default is 60 seconds
  }
}

resource "aws_ecs_cluster_capacity_providers" "asg_capacity_provider" {
  cluster_name = var.ecs_cluster_name

  capacity_providers = [aws_ecs_capacity_provider.asg_capacity_provider.name, "FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.asg_capacity_provider.name
  }
  depends_on = [aws_ecs_capacity_provider.asg_capacity_provider]
}

resource "aws_ecs_capacity_provider" "asg_capacity_provider" {
  name = "${var.labels.tags.Service}-${var.labels.tags.Environment}-${var.instance_group_name}-${replace(var.instance_type, ".", "-")}-${var.architecture}"

  auto_scaling_group_provider {
    managed_scaling {
      status = "ENABLED"
    }
    auto_scaling_group_arn = aws_autoscaling_group.main.arn
  }
  lifecycle {
    create_before_destroy = false
  }
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.asg_capacity_provider.name
}

resource "aws_autoscaling_schedule" "up" {
  count                  = var.night_scaling.enabled ? 1 : 0
  scheduled_action_name  = "${aws_autoscaling_group.main.name}-up"
  min_size               = var.autoscaling_group_min_size
  max_size               = var.autoscaling_group_max_size
  desired_capacity       = var.autoscaling_group_max_size
  autoscaling_group_name = aws_autoscaling_group.main.name
  recurrence             = "0 7 * * *"
}

resource "aws_autoscaling_schedule" "down" {
  count                  = var.night_scaling.enabled ? 1 : 0
  scheduled_action_name  = "${aws_autoscaling_group.main.name}-down"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  autoscaling_group_name = aws_autoscaling_group.main.name
  recurrence             = "0 22 * * *"
}
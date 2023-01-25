resource "aws_ecs_cluster" "cluster" {
  name = module.labels_ecs_cluster.resource_name
  tags = module.labels_ecs_cluster.tags
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled" #tfsec:ignore:aws-ecs-enable-container-insight
  }
}

module "labels_ecs_cluster" {
  source        = "./labels"
  labels        = var.labels
  resource_type = "ecs_cluster"
}


module "ec2" {
  source     = "./ec2"
  depends_on = [module.fsx]
  for_each   = local.instances_groups

  autoscaling_group_health_check_grace_period = var.autoscaling_group_health_check_grace_period
  autoscaling_group_max_size                  = each.value.autoscaling_group_max_size
  autoscaling_group_min_size                  = each.value.autoscaling_group_min_size
  instance_group_name                         = each.key
  instance_subnets                            = var.private_subnets
  instance_security_group                     = module.security_groups.security_group_id
  instance_type                               = each.value.instance_type
  instance_key_name                           = var.instance_key_name
  instance_iam_role                           = module.iam.iam_role
  spot_price                                  = each.value.spot.price
  ecs_optimized_image_ssm_parameter           = var.ecs_optimized_image_ssm_parameter
  ecs_cluster_name                            = aws_ecs_cluster.cluster.name
  fsx                                         = module.fsx
  architecture                                = each.value.architecture
  labels                                      = var.labels
}

locals {
  instances_groups = { for i in var.instances_groups : i.name => i }
}


module "iam" {
  source = "./iam"
  labels = var.labels
}

module "security_groups" {
  source = "./security_groups"
  labels = var.labels
  vpc_id = var.vpc_id
}

module "fsx" {
  source        = "./fsx"
  for_each      = local.fsx_remap
  configuration = each.value
  labels        = var.labels
  vpc_id        = var.vpc_id
}




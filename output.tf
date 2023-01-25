output "security_group" {
  value = module.security_groups.security_group_id
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "autoscalig_group_name" {
  value = [for a in module.ec2 : a.asg_name]
}

locals {

}


output "instances_capacity_providers" {
  value = [for a in module.ec2 : a.capacity_provider_name]
}
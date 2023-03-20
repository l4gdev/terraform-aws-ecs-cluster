locals {
  templatefile = templatefile("${path.module}/user_data/${var.architecture}.tpl", {
    cluster-name = var.ecs_cluster_name
    fsx          = var.fsx
  })
}



# update security group to allow access to the EFS mount point

resource "aws_security_group_rule" "efs" {
  for_each                 = var.fsx
  type                     = "ingress"
  from_port                = each.value.security_group.from_port
  to_port                  = each.value.security_group.to_port
  protocol                 = each.value.security_group.protocol
  security_group_id        = each.value.security_group.id
  source_security_group_id = var.instance_security_group
}

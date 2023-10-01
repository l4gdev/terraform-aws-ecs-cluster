variable "labels" {
  type = object({
    tags = object({
      Environment = string
      Service     = string
    })
    name = string
  })
}
variable "resource_type" {
  type        = string
  description = "ec2, sg, rds"
  default     = ""
}
locals {
  resource_names = {
    cloud_watch = lower("${var.labels.tags.Service}-${var.labels.tags.Environment}-<log-group-type>-<location>")
    dynamo_db   = lower("${var.labels.tags.Service}-${var.labels.name}-${var.labels.tags.Environment}")
    ecr         = lower(var.labels.name)
    ecs_cluster = lower("${var.labels.tags.Service}-${var.labels.tags.Environment}")
    ecs_service = lower("${var.labels.tags.Service}-${var.labels.tags.Environment}")
    ecs_task    = lower("${var.labels.tags.Service}-${var.labels.tags.Environment}")
    sg          = lower("${var.labels.tags.Service}-${var.labels.name}-${var.labels.tags.Environment}")
    generic     = lower("%s-${var.labels.tags.Service}-${var.labels.name}-${var.labels.tags.Environment}")
  }
  Name = replace(contains(keys(local.resource_names), var.resource_type) ? local.resource_names[var.resource_type] : format(local.resource_names["generic"], var.resource_type), "_", "-")
  Tags = merge(var.labels.tags, { "Name" : local.Name })
}
output "resource_names" {
  value = local.resource_names
}
output "resource_name" {
  value = local.Name
}
output "tags" {
  value = var.labels.tags
}
output "tags_with_resource_name" {
  value = local.Tags
}

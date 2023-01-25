
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.51.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | ./ec2 | n/a |
| <a name="module_fsx"></a> [fsx](#module\_fsx) | ./fsx | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./iam | n/a |
| <a name="module_labels_ecs_cluster"></a> [labels\_ecs\_cluster](#module\_labels\_ecs\_cluster) | ./labels | n/a |
| <a name="module_security_groups"></a> [security\_groups](#module\_security\_groups) | ./security_groups | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_group_health_check_grace_period"></a> [autoscaling\_group\_health\_check\_grace\_period](#input\_autoscaling\_group\_health\_check\_grace\_period) | n/a | `string` | `20` | no |
| <a name="input_ecs_optimized_image_ssm_parameter"></a> [ecs\_optimized\_image\_ssm\_parameter](#input\_ecs\_optimized\_image\_ssm\_parameter) | n/a | `string` | `"/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"` | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | Enable CloudWatch Container Insights for the cluster | `bool` | `false` | no |
| <a name="input_fsx"></a> [fsx](#input\_fsx) | List of FSX file systems to create | <pre>list(object({<br>    name                  = string<br>    storage_capacity      = number<br>    deployment_type       = optional(string, "SINGLE_AZ_2")<br>    subnet_id             = string<br>    throughput_capacity   = number<br>    data_compression_type = optional(string, "LZ4")<br>    mount_path            = string<br>    disk_iops_configuration = optional(object({<br>      mode = string<br>      iops = number<br>  }), null) }))</pre> | n/a | yes |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | n/a | `string` | `null` | no |
| <a name="input_instances_groups"></a> [instances\_groups](#input\_instances\_groups) | n/a | <pre>list(object({<br>    name                       = string<br>    instance_type              = string<br>    architecture               = string<br>    autoscaling_group_min_size = string<br>    autoscaling_group_max_size = string<br>    spot = optional(object({<br>      enable = optional(bool, false)<br>      price  = optional(string, null)<br>    }), {})<br>  }))</pre> | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | <pre>object({<br>    tags = object({<br>      Environment = string<br>      Service     = string<br>    })<br>    name = string<br>  })</pre> | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of subnets should be private | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscalig_group_name"></a> [autoscalig\_group\_name](#output\_autoscalig\_group\_name) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_instances_capacity_providers"></a> [instances\_capacity\_providers](#output\_instances\_capacity\_providers) | n/a |
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

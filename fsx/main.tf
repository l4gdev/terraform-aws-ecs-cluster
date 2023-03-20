resource "aws_fsx_openzfs_file_system" "fsx" {
  deployment_type      = var.configuration.deployment_type
  subnet_ids           = [var.configuration.subnet_id]
  throughput_capacity  = var.configuration.throughput_capacity
  tags                 = var.labels.tags
  security_group_ids   = [aws_security_group.fsx.id]
  copy_tags_to_volumes = true
  copy_tags_to_backups = true
  storage_capacity     = var.configuration.storage_capacity

  #  disk_iops_configuration {
  #    mode = try(var.configuration.disk_iops_configuration.mode, null)
  #    iops = try(var.configuration.disk_iops_configuration.iops, null)
  #  }

  root_volume_configuration {
    data_compression_type = var.configuration.data_compression_type
    nfs_exports {
      client_configurations {
        clients = "*"
        options = [
          "rw",
          "crossmnt",
          "no_root_squash"
        ]
      }
    }
  }

}

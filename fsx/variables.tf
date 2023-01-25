variable "configuration" {
  type = object({
    name                  = string
    storage_capacity      = number
    deployment_type       = optional(string, "SINGLE_AZ_2")
    subnet_id             = string
    throughput_capacity   = number
    storage_capacity      = string
    data_compression_type = optional(string, "LZ4")
    mount_path            = string
    disk_iops_configuration = optional(object({
      mode = string
      iops = number
  }), null) })
}

variable "vpc_id" {
  type = string
}

variable "labels" {
  type = object({
    tags = object({
      Environment = string
      Service     = string
    })
    name = string
  })
}
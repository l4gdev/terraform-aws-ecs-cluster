output "dns_name" {
  value = aws_fsx_openzfs_file_system.fsx.dns_name
}
output "configuration" {
  value = var.configuration
}
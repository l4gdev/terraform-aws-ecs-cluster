resource "aws_security_group" "fsx" {
  name        = "${var.labels.tags.Service}-${var.labels.tags.Environment}-fsx-sg"
  vpc_id      = var.vpc_id
  tags        = var.labels.tags
  description = "Security group for FSx"
  ingress {
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
    cidr_blocks = ["255.255.255.255/32"]
    description = "Dummy rule that allows fsx to be created"
  }
  lifecycle {
    ignore_changes = [ingress]
  }
}

output "security_group" {
  value = {
    id          = aws_security_group.fsx.id
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "NFS traffic from ${aws_security_group.fsx.id}"
  }
}

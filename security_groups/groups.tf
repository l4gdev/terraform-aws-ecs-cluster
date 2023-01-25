resource "aws_security_group" "ECS" {
  name        = module.labels_sg.resource_name
  vpc_id      = var.vpc_id
  description = "ECS Security Group for EC2 instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
    description = "Allow all outbound traffic for external access"
  }
}
module "labels_sg" {
  source        = "../labels"
  labels        = var.labels
  resource_type = "sg"
}
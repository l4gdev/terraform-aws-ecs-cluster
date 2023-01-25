resource "aws_iam_role" "role" {
  name = module.labels_iam_role.resource_name
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })

}

resource "aws_iam_instance_profile" "profile" {
  name = lower("${var.labels.tags.Service}-${var.labels.name}-${var.labels.tags.Environment}")
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "T1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.role.name
}

module "labels_iam_role" {
  source        = "../labels"
  labels        = var.labels
  resource_type = "iam_role"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.role.name
}
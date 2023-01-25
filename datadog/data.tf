data "aws_secretsmanager_secret" "dd_api_key" {
  name = var.datadog.api_key_secret_manager_name
}

data "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id = data.aws_secretsmanager_secret.dd_api_key.id
}

data "aws_caller_identity" "current" {}

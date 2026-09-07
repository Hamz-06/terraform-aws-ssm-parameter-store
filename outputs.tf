
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "parameter_path_arn" {
  description = "ARN wildcard for all SSM parameters under the service/environment path"
  value       = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.application_name}/${var.environment}/*"
}

output "parameter_values" {
  description = "Values of the SSM parameters managed by this module"
  value       = { for name, parameter in var.ssm_parameters : name => parameter.value }
  sensitive   = true
}


terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

module "secrets" {
  for_each = nonsensitive(var.ssm_parameters)
  version  = "2.1.2"
  source   = "terraform-aws-modules/ssm-parameter/aws"

  name  = "/${var.application_name}/${var.environment}/${each.key}"
  value = each.value.value != "" ? each.value.value : "CHANGE_ME"
  # ignore_value_changes already locks the value forever after creation, so it's safe to always
  # allow the initial create/import to overwrite a parameter that may already exist in AWS
  overwrite = each.value.overwrite ? each.value.overwrite : true

  value_wo_version = each.value.overwrite ? each.value.version : 1
  # overwrite = false params are set once by hand; never let terraform touch their value again
  ignore_value_changes = !each.value.overwrite

  secure_type = true

  tags = merge(var.tags, {
    Environment = var.environment
    Application = var.application_name
  })
}
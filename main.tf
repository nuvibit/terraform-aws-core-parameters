# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is only being tested with Terraform 1.0.0 and newer.
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
      configuration_aliases = [
        aws.ssm_ps_writer
      ]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  parameters_map = merge((concat([
    for ok, o in var.parameters : (
      can(tostring(o)) ? [tomap({ "${var.parameters_path_prefix}/${ok}" = tostring(o) })] : [for k1, v1 in o :
        can(tostring(v1)) ? tomap({ "${var.parameters_path_prefix}/${ok}/${k1}" = tostring(v1) }) : (
          tomap({ for k2, v2 in v1 : "${var.parameters_path_prefix}/${ok}/${k1}/${k2}" => v2 })
        )
      ]
    )]...
  ))...)
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ STORE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "ssm_parameters" {
  for_each = local.parameters_map

  name      = each.key
  type      = var.kms_key_arn == null ? "String" : "SecureString"
  value     = each.value
  key_id    = var.kms_key_arn
  tags      = var.resource_tags
  provider  = aws.ssm_ps_writer
}

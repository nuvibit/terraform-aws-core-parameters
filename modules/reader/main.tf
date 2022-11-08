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
        aws.ssm_ps_reader
      ]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  parameters_raw = { for o in data.aws_ssm_parameter.parameters : replace(o.name, "/${var.parameters_path_prefix}//", "") => nonsensitive(o.value) }

  parameters_two_levels_temp = {
    for k, v in local.parameters_raw : split("/", k)[0] => {
      split("/", k)[1] = v
    }... if length(split("/", k)) == 2
  }
  parameters_two_levels = { for key, list in local.parameters_two_levels_temp : key => merge(list...) }

  parameters_three_levels_temp1 = {
    for k, v in local.parameters_raw : split("/", k)[0] => {
      split("/", k)[1] = { split("/", k)[2] = v }
    }... if length(split("/", k)) == 3
  }

  parameters_three_levels_temp2 = { for key, list in local.parameters_three_levels_temp1 : key => { for o in list : keys(o)[0] => values(o)[0]... } }
  parameters_three_levels_temp3 = { for key, map in local.parameters_three_levels_temp2 : key => { for key2, list in map : key2 => merge(list...) } }
  parameters_three_levels       = { for key, o in local.parameters_three_levels_temp3 : key => merge(o, try(local.parameters_two_levels[key], {})) }
  parameters                    = merge(local.parameters_two_levels, local.parameters_three_levels)

}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ PARAMETER READER
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ssm_parameters_by_path" "parameters" {
  path      = var.parameters_path_prefix
  recursive = true
  provider  = aws.ssm_ps_reader
}

data "aws_ssm_parameter" "parameters" {
  for_each = toset(data.aws_ssm_parameters_by_path.parameters.names)
  name     = each.key
  provider = aws.ssm_ps_reader
}
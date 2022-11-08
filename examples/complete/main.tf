# ---------------------------------------------------------------------------------------------------------------------
# ¦ PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ BACKEND
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  backend "remote" {
    organization = "nuvibit"
    hostname     = "app.terraform.io"

    workspaces {
      name = "aws-s-testing"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VERSIONS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = []
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  resource_tags = {
    "module" = "terraform-aws-core-parameters"
  }
  parameters_reader_role_name = "core-parameter-reader-role"
  parameters_writer_role_name = "core-parameter-writer-role"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETER - KMS CMK
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_kms_key" "kms_cmk" {
  description             = "This key will be used for encryption of the Parameter Store entires."
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_cmk.json
  tags                    = local.resource_tags
}

resource "aws_kms_alias" "kms_cmk" {
  name          = "alias/core_parameter_entries"
  target_key_id = aws_kms_key.kms_cmk.key_id
}

data "aws_iam_policy_document" "kms_cmk" {
  # enable IAM in logging account
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Deny IAM User Permissions"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Core Parameter Writer"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.parameters_writer_role_name}"]
    }
    actions = [
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Core Parameter Reader"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.parameters_reader_role_name}"]
    }
    actions = [
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETER - ROLES
# ---------------------------------------------------------------------------------------------------------------------
module "core_parameter_roles" {
  source                      = "../../modules/iam-roles"
  parameters_reader_role_name = local.parameters_reader_role_name
  parameters_writer_role_name = local.parameters_writer_role_name
  kms_key_arn                 = aws_kms_key.kms_cmk.arn
  resource_tags               = local.resource_tags
}

provider "aws" {
  region = "eu-central-1"
  alias  = "core_parameter_writer"
  assume_role {
    role_arn = module.core_parameter_roles.parameters_writer_role_arn
  }
}

provider "aws" {
  region = "eu-central-1"
  alias  = "core_parameter_reader"
  assume_role {
    role_arn = module.core_parameter_roles.parameters_reader_role_arn
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETER - ORG MGMT
# ---------------------------------------------------------------------------------------------------------------------
locals {
  foundation_org_mgmt_parameters = {
    version = "1.0"
    org_mgmt = {
      main_region         = "eu-central-1"
      read_tags_role_name = "read-account-tags-role"
      account_access_role = "OrganizationAccountAccessRole"
      account_id          = "888445683825"
      example1 = {
        test1_a = "test1"
        test1_b = "test2"
      }
      example2 = {
        test2_a = "test3"
        test2_b = "test4"
      }
    }
    core_security = {
      delegation = {
        securityhub      = true
        guardduty        = false
        config           = true
        firewall_manager = true
      }
    }
    account_baseline = {
      auto_remediation = {
        role_name = "foundation-auto-remediation-role"
      }
      aws_config = {
        role_name = "FoundationAwsConfigRole"
      }
    }
  }
}

module "core_parameter_writer1" {
  source = "../../"

  parameters    = local.foundation_org_mgmt_parameters
  resource_tags = local.resource_tags
  
  providers = {
    aws.ssm_ps_writer = aws.core_parameter_writer
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETER - SECURITY
# ---------------------------------------------------------------------------------------------------------------------
locals {
  foundation_core_security_parameters = {
    core_security = {
      account_id = data.aws_caller_identity.current.account_id
      auto_remediation = {
        execution_role_arn = "module.core_security.auto_remediation[\"execution_role_arn\"]"
      }
      aws_config = {
        aggregator_name = "module.core_security.aws_config[\"aggregator_name\"]"
      }
    }
  }
}

module "core_parameter_writer2" {
  source = "../../"

  parameters    = local.foundation_core_security_parameters
  resource_tags = local.resource_tags

  providers = {
    aws.ssm_ps_writer = aws.core_parameter_writer
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETER - READER
# ---------------------------------------------------------------------------------------------------------------------
module "core_parameter_reader" {
  source = "../../modules/reader"

  providers = {
    aws.ssm_ps_reader = aws.core_parameter_reader
  }
}

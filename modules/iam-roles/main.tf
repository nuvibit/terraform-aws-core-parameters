# ---------------------------------------------------------------------------------------------------------------------
# ¦ REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is only being tested with Terraform 1.0.0 and newer.
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
data "aws_caller_identity" "this_account" {}
data "aws_organizations_organization" "this_org" {}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ LOCALS
# ---------------------------------------------------------------------------------------------------------------------
locals {
  org_id = var.org_id == null ? data.aws_organizations_organization.this_org.id : var.org_id
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ PARAMETER READER - IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------
# IAM Role that can be assumed by anyone in the organization
# to query ssm parameter store.
resource "aws_iam_role" "parameters_reader" {
  name                 = var.parameters_reader_role_name
  assume_role_policy   = data.aws_iam_policy_document.parameters_reader_trust.json
  path                 = var.iam_role_path
  permissions_boundary = var.iam_role_permissions_boundary_arn
}

data "aws_iam_policy_document" "parameters_reader_trust" {
  statement {
    sid    = "TrustPolicy"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "sts:AssumeRole"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [local.org_id]
    }
  }
}

resource "aws_iam_role_policy" "parameters_reader" {
  name       = replace(var.parameters_reader_role_name, "role", "policy")
  role       = aws_iam_role.parameters_reader.name
  policy     = data.aws_iam_policy_document.parameters_reader.json
  depends_on = [aws_iam_role.parameters_reader]
}

# need a wildcard for "ssm:GetParametersByPath", "ssm:DescribeParameters"
#tfsec:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "parameters_reader" {
  statement {
    sid    = "AllowSSMForListContext1"
    effect = "Allow"
    actions = [
      "ssm:GetParameterHistory",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      format(
        "arn:aws:ssm:*:%s:parameter%s/*",
        data.aws_caller_identity.this_account.account_id,
        var.parameters_path_prefix
      )
    ]
  }
  statement {
    sid    = "AllowSSMForListContext2"
    effect = "Allow"
    actions = [
      "ssm:GetParametersByPath",
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }
  dynamic "statement" {
    for_each = var.kms_key_arn != null ? ["enabled"] : []
    content {
      sid    = "AllowKmsCmkAccess"
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = [var.kms_key_arn]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ PARAMETER WRITER - IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------
# IAM role that can be assumed by anyone in the organization
# to write parameters to the parameter store
resource "aws_iam_role" "parameters_writer" {
  name                 = var.parameters_writer_role_name
  assume_role_policy   = data.aws_iam_policy_document.parameters_writer_trust.json
  path                 = var.iam_role_path
  permissions_boundary = var.iam_role_permissions_boundary_arn
}

data "aws_iam_policy_document" "parameters_writer_trust" {
  statement {
    sid    = "TrustPolicy"
    effect = "Allow"

    principals {
      identifiers = var.account_ids
      type        = "AWS"
    }
    actions = [
      "sts:AssumeRole"
    ]
    dynamic "condition" {
      for_each = var.account_ids == ["*"] ? ["true"] : []
      content {
        test     = "StringEquals"
        variable = "aws:PrincipalOrgID"
        values   = [local.org_id]
      }
    }
  }
}

resource "aws_iam_role_policy" "parameters_writer" {
  name   = replace(var.parameters_writer_role_name, "role", "policy")
  role   = aws_iam_role.parameters_writer.name
  policy = data.aws_iam_policy_document.parameters_writer.json
}

# need a wildcard for "ssm:GetParametersByPath", "ssm:DescribeParameters"
#tfsec:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "parameters_writer" {
  statement {
    sid    = "AllowSSM"
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:DeleteParameter",
      "ssm:DeleteParameters",
      "ssm:PutParameter",
      "ssm:ListTagsForResource",
      "ssm:AddTagsToResource"
    ]
    resources = [
      format(
        "arn:aws:ssm:*:%s:parameter%s/*",
        data.aws_caller_identity.this_account.account_id,
        var.parameters_path_prefix
      )
    ]
  }
  statement {
    sid    = "AllowSSMForListContext2"
    effect = "Allow"
    actions = [
      "ssm:GetParametersByPath",
      "ssm:DescribeParameters"
    ]
    resources = ["*"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ STORE_PARAMETERS - OPTIONAL 
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "writer_role_arn" {
  count = var.store_parameters == true ? 1 : 0

  name      = "${var.parameters_path_prefix}/platform_parameter/writer_role_arn"
  type      = "String"
  value     = aws_iam_role.parameters_writer.arn
  overwrite = true
  tags      = var.resource_tags
}

resource "aws_ssm_parameter" "reader_role_arn" {
  count = var.store_parameters == true ? 1 : 0

  name      = "${var.parameters_path_prefix}/platform_parameter/reader_role_arn"
  type      = "String"
  value     = aws_iam_role.parameters_reader.arn
  overwrite = true
  tags      = var.resource_tags
}

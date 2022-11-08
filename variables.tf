/*
sample-map
  foundation_parameter = {
    org_mgmt = {
      main_region               = data.aws_region.current.name
      root_id                   = module.master_config.organization_root_id
      org_id                    = data.aws_organizations_organization.current.id
      branding_ou_id            = module.master_config.branding_ou_id
      tenant_ou_ids             = jsonencode(module.master_config.tenant_ou_ids)
      account_id                = data.aws_caller_identity.current.account_id
      env                       = "c1"
      read_context_role_name    = "foundation-read-account-context-role"
      write_parameter_role_name = "foundation-write-parameter-role"
      account_access_role       = "OrganizationAccountAccessRole"
    }
    core_security = {
      account_id                   = "626708301729"
      spoke_provisioning_role_name = "foundation-security-provisioning-role"
    }
    account_baseline = {
      workload_provisioning_user_name = "tf_workload_provisioning"
      provisioning_role_name          = "FoundationBaselineProvisioningRole"
      auto_remediation_role_name      = "foundation-auto-remediation-role"
      aws_config_role_name            = "FoundationAwsConfigRole"
    }
  }
*/

variable "parameters" {
  type = any
}

variable "parameters_overwrite" {
  type    = bool
  default = false
}

variable "parameters_path_prefix" {
  type    = string
  default = "/foundation"
}

variable "kms_key_arn" {
  description = "KMS Key to be used to encrypt the parameter entries."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null ? true : can(regex("^arn:aws:kms", var.kms_key_arn))
    error_message = "Value must contain ARN, starting with \"arn:aws:kms\"."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ COMMON
# ---------------------------------------------------------------------------------------------------------------------
variable "resource_tags" {
  description = "A map of tags to assign to the resources in this module."
  type        = map(string)
  default     = {}
}

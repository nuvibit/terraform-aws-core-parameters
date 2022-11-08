variable "org_id" {
  description = "ID of the AWS Organization."
  type        = string
  default     = null
}

variable "account_ids" {
  description = "Account IDs allowed to write parameters. Will override provided org_id."
  type        = list(string)
  default     = ["*"]
}

variable "parameters_path_prefix" {
  type    = string
  default = "/foundation"
}

variable "parameters_reader_role_name" {
  type    = string
  default = "core-parameter-reader-role"
}

variable "parameters_writer_role_name" {
  type    = string
  default = "core-parameter-writer-role"
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

variable "iam_role_path" {
  description = "Path of the IAM role."
  type        = string
  default     = null

  validation {
    condition     = var.iam_role_path == null ? true : can(regex("^\\/", var.iam_role_path))
    error_message = "Value must start with '/'."
  }
}

variable "iam_role_permissions_boundary_arn" {
  description = "ARN of the policy that is used to set the permissions boundary for all IAM roles of the module."
  type        = string
  default     = null

  validation {
    condition     = var.iam_role_permissions_boundary_arn == null ? true : can(regex("^arn:aws:iam", var.iam_role_permissions_boundary_arn))
    error_message = "Value must contain ARN, starting with 'arn:aws:iam'."
  }
}

variable "parameters" {
  description = "A map of parameters which should be stored as a map in SSM Parameter Store."
  type        = any
}

variable "parameters_overwrite" {
  description = "Set to true to allow overwriting existing parameters. IAM role with write access is required."
  type        = bool
  default     = false
}

variable "parameters_path_prefix" {
  description = "Prefix name to allow fully qualified parameter names which allows parameters to be stored as a map."
  type        = string
  default     = "/foundation"
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

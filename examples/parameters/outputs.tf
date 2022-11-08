output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "foundation_org_mgmt_parameters" {
  value = local.foundation_org_mgmt_parameters
}

output "foundation_core_security_parameters" {
  value = local.foundation_core_security_parameters
}

output "core_parameter_reader" {
  value = module.core_parameter_reader.parameters
}

output "core_parameter_reader_available" {
  value = can(module.core_parameter_reader) ? true : false
}

output "core_parameter_reader_validation" {
  value = can(module.core_parameter_reader) ? (
    module.core_parameter_reader.parameters["core_security"]["account_id"] == data.aws_caller_identity.current.account_id ? (
      module.core_parameter_reader.parameters["core_security"]["delegation"]["securityhub"] == "true" ? (
        module.core_parameter_reader.parameters["org_mgmt"]["example1"]["test1_a"] == "test1" ? (
          module.core_parameter_reader.parameters["account_baseline"]["auto_remediation"]["role_name"] == "foundation-auto-remediation-role" ? true : false
        ) : false
      ) : false
    ) : false
  ) : false
}

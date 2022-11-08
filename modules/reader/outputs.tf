output "parameter_paths" {
  value = distinct([for o in data.aws_ssm_parameter.parameters : split("/", o.name)[1]])
}

output "parameters_raw" {
  value = local.parameters_raw
}

output "parameters_two_levels" {
  value = local.parameters_two_levels
}

output "parameters_three_levels" {
  value = local.parameters_three_levels
}

output "parameters" {
  value = local.parameters
}

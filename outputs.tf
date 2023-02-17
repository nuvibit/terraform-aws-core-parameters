output "parameters_map" {
  description = "The map of parameters which are stored as a map in SSM Parameter Store."
  value       = local.parameters_map
}

output "parameters_path_prefix" {
  description = "Pass through parameters_path_prefix."
  value       = var.parameters_path_prefix
}
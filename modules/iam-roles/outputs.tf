output "parameters_writer_role_name" {
  description = "Name of role used to write parameters into SSM Parameter Store."
  value       = aws_iam_role.parameters_writer.name
}

output "parameters_writer_role_arn" {
  description = "ARN of role used to write parameters into SSM Parameter Store."
  value       = aws_iam_role.parameters_writer.arn
}

output "parameters_reader_role_name" {
  description = "Name of role used to read parameters into SSM Parameter Store."
  value       = aws_iam_role.parameters_reader.name
}

output "parameters_reader_role_arn" {
  description = "ARN of role used to read parameters into SSM Parameter Store."
  value       = aws_iam_role.parameters_reader.arn
}
output "parameters_writer_role_name" {
  value = aws_iam_role.parameters_writer.name
}

output "parameters_writer_role_arn" {
  value = aws_iam_role.parameters_writer.arn
}

output "parameters_reader_role_name" {
  value = aws_iam_role.parameters_reader.name
}

output "parameters_reader_role_arn" {
  value = aws_iam_role.parameters_reader.arn
}
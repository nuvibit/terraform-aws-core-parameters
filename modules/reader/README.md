<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.ssm_ps_reader"></a> [aws.ssm\_ps\_reader](#provider\_aws.ssm\_ps\_reader) | >= 3.71 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameters_by_path.parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameters_by_path) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameters_path_prefix"></a> [parameters\_path\_prefix](#input\_parameters\_path\_prefix) | n/a | `string` | `"/foundation"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameter_paths"></a> [parameter\_paths](#output\_parameter\_paths) | n/a |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | n/a |
| <a name="output_parameters_raw"></a> [parameters\_raw](#output\_parameters\_raw) | n/a |
| <a name="output_parameters_three_levels"></a> [parameters\_three\_levels](#output\_parameters\_three\_levels) | n/a |
| <a name="output_parameters_two_levels"></a> [parameters\_two\_levels](#output\_parameters\_two\_levels) | n/a |
<!-- END_TF_DOCS -->
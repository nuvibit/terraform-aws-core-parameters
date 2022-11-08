# AWS SSM Parameter Store IAM Role Terraform sub-module

<!-- LOGO -->
<a href="https://nuvibit.com">
    <img src="https://nuvibit.com/images/logo/logo-nuvibit-badge.png" alt="nuvibit logo" title="nuvibit" align="right" height="100" />
</a>

<!-- DESCRIPTION -->
[Terraform][terraform-url] sub-module to deploy IAM resources required for SSM Parameter Store on [AWS][aws-url]

<!-- USAGE -->
## Usage
```hcl
module "core_parameter_roles" {
  source = "nuvibit/core-parameters/aws//modules/iam-roles"
  version = "~> 1.0"
  
  source                      = "../../modules/iam-roles"
  parameters_reader_role_name = "core-parameter-reader-role"
  parameters_writer_role_name = "core-parameter-writer-role"
}
```

<!-- EXAMPLES -->
## Examples
- [`examples/example-sub-module`][example-complete-url]

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.parameters_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.parameters_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.parameters_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.parameters_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.this_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.parameters_reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.parameters_reader_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.parameters_writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.parameters_writer_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.this_org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_ids"></a> [account\_ids](#input\_account\_ids) | Account IDs allowed to write parameters. Will override provided org\_id. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Path of the IAM role. | `string` | `null` | no |
| <a name="input_iam_role_permissions_boundary_arn"></a> [iam\_role\_permissions\_boundary\_arn](#input\_iam\_role\_permissions\_boundary\_arn) | ARN of the policy that is used to set the permissions boundary for all IAM roles of the module. | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key to be used to encrypt the parameter entries. | `string` | `null` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | ID of the AWS Organization. | `string` | `null` | no |
| <a name="input_parameters_path_prefix"></a> [parameters\_path\_prefix](#input\_parameters\_path\_prefix) | Prefix name to allow fully qualified parameter names which allows parameters to be stored as a map. | `string` | `"/foundation"` | no |
| <a name="input_parameters_reader_role_name"></a> [parameters\_reader\_role\_name](#input\_parameters\_reader\_role\_name) | Name of IAM role which will be created to read parameters from SSM Parameter Store. | `string` | `"core-parameter-reader-role"` | no |
| <a name="input_parameters_writer_role_name"></a> [parameters\_writer\_role\_name](#input\_parameters\_writer\_role\_name) | Name of IAM role which will be created to write parameters into SSM Parameter Store. | `string` | `"core-parameter-writer-role"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of tags to assign to the resources in this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameters_reader_role_arn"></a> [parameters\_reader\_role\_arn](#output\_parameters\_reader\_role\_arn) | ARN of role used to read parameters into SSM Parameter Store. |
| <a name="output_parameters_reader_role_name"></a> [parameters\_reader\_role\_name](#output\_parameters\_reader\_role\_name) | Name of role used to read parameters into SSM Parameter Store. |
| <a name="output_parameters_writer_role_arn"></a> [parameters\_writer\_role\_arn](#output\_parameters\_writer\_role\_arn) | ARN of role used to write parameters into SSM Parameter Store. |
| <a name="output_parameters_writer_role_name"></a> [parameters\_writer\_role\_name](#output\_parameters\_writer\_role\_name) | Name of role used to write parameters into SSM Parameter Store. |
<!-- END_TF_DOCS -->

<!-- COPYRIGHT -->
<br />
<br />
<p align="center">Copyright &copy; 2022 Nuvibit AG</p>

<!-- MARKDOWN LINKS & IMAGES -->
[nuvibit-shield]: https://img.shields.io/badge/maintained%20by-nuvibit.com-%235849a6.svg?style=flat&color=1c83ba
[nuvibit-url]: https://nuvibit.com
[terraform-version-shield]: https://img.shields.io/badge/tf-%3E%3D0.15.0-blue.svg?style=flat&color=blueviolet
[terraform-version-url]: https://www.terraform.io/upgrade-guides/0-15.html
[release-shield]: https://img.shields.io/github/v/release/nuvibit/terraform-aws-core-parameters?style=flat&color=success
[architecture-png]: https://github.com/nuvibit/terraform-aws-core-parameters/blob/main/docs/architecture.png?raw=true
[release-url]: https://github.com/nuvibit/terraform-aws-core-parameters/releases
[contributors-url]: https://github.com/nuvibit/terraform-aws-core-parameters/graphs/contributors
[license-url]: https://github.com/nuvibit/terraform-aws-core-parameters/tree/main/LICENSE
[terraform-url]: https://www.terraform.io
[aws-url]: https://aws.amazon.com
[example-complete-url]: https://github.com/nuvibit/terraform-aws-core-parameters/tree/main/examples/complete

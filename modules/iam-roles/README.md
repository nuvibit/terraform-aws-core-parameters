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

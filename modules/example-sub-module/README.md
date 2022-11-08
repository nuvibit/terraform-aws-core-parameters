<!-- TITLE & LOGO -->
<a href="https://nuvibit.com">
    <img src="https://nuvibit.com/images/logo/logo-nuvibit-square.png" alt="nuvibit logo" title="nuvibit" align="right" width="100" />
</a>

# AWS EXAMPLE Terraform sub-module

<!-- DESCRIPTION -->
[Terraform][terraform-url] sub-module to deploy SERVICE_NAME resources on [AWS][aws-url]

<!-- USAGE -->
## Usage
```hcl
module "example" {
  source = "nuvibit/template/aws//modules/example-sub-module"
  version = "~> 1.0"

  name  = "template"
}
```

<!-- EXAMPLES -->
## Examples
- [`examples/example-sub-module`][example-complete-url]

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
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
[release-shield]: https://img.shields.io/github/v/release/nuvibit/REPLACE_ME?style=flat&color=success
[architecture-png]: https://github.com/nuvibit/REPLACE_ME/blob/main/docs/architecture.png?raw=true
[release-url]: https://github.com/nuvibit/REPLACE_ME/releases
[contributors-url]: https://github.com/nuvibit/REPLACE_ME/graphs/contributors
[license-url]: https://github.com/nuvibit/REPLACE_ME/tree/main/LICENSE
[terraform-url]: https://www.terraform.io
[aws-url]: https://aws.amazon.com
[nuvibit-product-url]: https://nuvibit.com/products/xxx
[example-complete-url]: https://github.com/nuvibit/REPLACE_ME/tree/main/examples/complete

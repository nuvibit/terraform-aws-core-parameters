
# AWS REPLACE_ME Terraform module

<!-- LOGO -->
<a href="https://nuvibit.com">    
  <img src="https://nuvibit.com/images/logo/logo-nuvibit-badge.png" alt="nuvibit logo" title="nuvibit" align="right" height="100" />
</a>

<!-- SHIELDS -->
[![Maintained by nuvibit.com][nuvibit-shield]][nuvibit-url]
[![Terraform Version][terraform-version-shield]][terraform-version-url]
[![Latest Release][release-shield]][release-url]

<!-- DESCRIPTION -->
[Terraform][terraform-url] module to deploy REPLACE_ME resources on [AWS][aws-url]

<!-- ARCHITECTURE -->
## Architecture
![architecture][architecture-png]

<!-- FEATURES -->
## Features
* Creates a REPLACE_ME

<!-- USAGE -->
## Usage

### REPLACE_ME
```hcl
module "REPLACE_ME" {
  source  = "nuvibit/REPLACE_ME/aws"
  version = "~> 1.0"

  input1 = "value1"
}
```

<!-- EXAMPLES -->
## Examples

* [`examples/complete`][example-complete-url]

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

<!-- AUTHORS -->
## Authors

This module is maintained by [Nuvibit][nuvibit-url] with help from [these amazing contributors][contributors-url]

<!-- LICENSE -->
## License

This module is licensed under Apache 2.0
<br />
See [LICENSE][license-url] for full details

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
[example-complete-url]: https://github.com/nuvibit/REPLACE_ME/tree/main/examples/complete

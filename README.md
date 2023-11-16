# Microsoft Entra ID as SAML Identity Provider

Terraform module to configure Microsoft Entra ID as SAML Identity Provider.

## Usage example

```
module "idp" {
  source = "github.com/leonseng/terraform-azuread-saml-idp.git"

  app_base_url = "https://azuread-saml-idp.example.com"
}
```
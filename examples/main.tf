module "idp" {
  source = "github.com/leonseng/terraform-azuread-saml-idp.git"

  app_base_url = "https://azuread-saml-idp.example.com"
}

output "app_name" {
  value = module.idp.app_name
}

output "enterprise_app_oid" {
  value = module.idp.enterprise_app_oid
}

output "saml_idp_login_url" {
  value = module.idp.saml_idp_login_url
}

output "saml_idp_logout_url" {
  value = module.idp.saml_idp_logout_url
}

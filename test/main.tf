module "idp" {
  source = "../"

  saml_sp_login_url = "https://azuread-saml-idp.example.com"
  saml_sp_acs_url   = "https://azuread-saml-idp.example.com/saml/acs"
  saml_sp_sls_url   = "https://azuread-saml-idp.example.com/saml/sls"
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

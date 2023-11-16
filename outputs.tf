output "enterprise_app_name" {
  value = azuread_application.this.display_name
}

output "enterprise_app_oid" {
  value = azuread_service_principal.this.id
}

output "saml_idp_login_url" {
  value = "https://login.microsoftonline.com/${azuread_service_principal.this.application_tenant_id}/saml2"
}

output "saml_idp_logout_url" {
  value = "https://login.microsoftonline.com/${azuread_service_principal.this.application_tenant_id}/saml2"
}

output "saml_idp_token_signing_cert_b64" {
  sensitive = true
  value     = azuread_service_principal_token_signing_certificate.this.value
}

output "saml_sp_entity_id" {
  value = local.saml_sp_entity_id
}

output "saml_idp_entity_id" {
  value = "https://sts.windows.net/${data.azuread_client_config.current.tenant_id}"
}

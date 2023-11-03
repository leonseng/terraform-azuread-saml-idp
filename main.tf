
resource "random_id" "id" {
  byte_length = 4
  prefix      = var.object_name_prefix
}

locals {
  name_prefix = random_id.id.dec
}

resource "random_uuid" "appid" {}

resource "azuread_application" "this" {
  display_name    = local.name_prefix
  identifier_uris = ["api://${local.name_prefix}"]

  web {
    logout_url    = "${var.app_base_url}/saml/sls"
    redirect_uris = ["${var.app_base_url}/saml/acs"]
  }
}

# enterprise application with SAML SSO
resource "azuread_service_principal" "this" {
  client_id                     = azuread_application.this.client_id
  preferred_single_sign_on_mode = "saml"
  login_url                     = var.app_base_url

  feature_tags {
    custom_single_sign_on = true
    enterprise            = true
  }

}

resource "azuread_service_principal_token_signing_certificate" "this" {
  service_principal_id = azuread_service_principal.this.id
}

resource "local_file" "token_signing_cert" {
  count = var.create_token_signing_cert_file ? 1 : 0

  content = templatefile("${path.module}/templates/saml_token_signing_cert.pem.tmpl",
    {
      token_signing_cert_key : azuread_service_principal_token_signing_certificate.this.value
    }
  )
  filename = "${path.module}/${local.name_prefix}.pem"
}

output "app_name" {
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

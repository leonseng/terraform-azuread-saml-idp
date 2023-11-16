
resource "random_id" "id" {
  byte_length = 4
  prefix      = var.object_name_prefix
}

locals {
  name_prefix   = random_id.id.dec
  app_entity_id = "api://${local.name_prefix}"
}

resource "random_uuid" "appid" {}

resource "azuread_application" "this" {
  display_name    = local.name_prefix
  identifier_uris = [local.app_entity_id]

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

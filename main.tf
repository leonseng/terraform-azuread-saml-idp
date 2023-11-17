data "azuread_client_config" "current" {}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.object_name_prefix
}

locals {
  name_prefix       = random_id.id.dec
  saml_sp_entity_id = var.saml_sp_entity_id == "" ? "api://${local.name_prefix}" : var.saml_sp_entity_id
}

resource "random_uuid" "appid" {}

resource "azuread_application" "this" {
  display_name    = local.name_prefix
  identifier_uris = [local.saml_sp_entity_id]

  web {
    logout_url    = var.saml_sp_sls_url
    redirect_uris = [var.saml_sp_acs_url]
  }
}

# enterprise application with SAML SSO
resource "azuread_service_principal" "this" {
  client_id                     = azuread_application.this.client_id
  preferred_single_sign_on_mode = "saml"
  login_url                     = var.saml_sp_login_url

  feature_tags {
    custom_single_sign_on = true
    enterprise            = true
  }
}

resource "azuread_service_principal_token_signing_certificate" "this" {
  service_principal_id = azuread_service_principal.this.id
}

resource "azuread_application_certificate" "this" {
  count = var.saml_sp_signing_cert == "" ? 0 : 1

  application_id = azuread_application.this.id
  type           = "AsymmetricX509Cert"
  encoding       = "pem"
  value          = file(var.saml_sp_signing_cert)
}

// Reference: https://github.com/hashicorp/terraform-provider-azuread/issues/1179
resource "terraform_data" "app-requestSignatureVerification" {
  count = var.saml_sp_signing_cert == "" ? 0 : 1

  input = {
    application_id = basename(azuread_application_certificate.this[0].application_id)
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOF
        az ad app update --id '${self.input.application_id}' \
            --set 'requestSignatureVerification={"isSignedRequestRequired":true}'
    EOF
  }
}

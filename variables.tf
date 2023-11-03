variable "object_name_prefix" {
  type    = string
  default = "azuread-saml-idp-"
}

variable "app_base_url" {
  type = string
}

variable "create_token_signing_cert_file" {
  type    = bool
  default = false
}

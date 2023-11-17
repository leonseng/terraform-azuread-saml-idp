variable "object_name_prefix" {
  type    = string
  default = "azuread-saml-idp-"
}

variable "saml_sp_entity_id" {
  description = "Unique identifier that identifies the SP to the IdP. E.g. api://sp.example.com"
  type        = string
  default     = ""
}

variable "saml_sp_login_url" {
  description = "SAML SP endpoint for accessing protected resource"
  type        = string
}

variable "saml_sp_acs_url" {
  description = "Assertion Consumer Service endpoint on SAML SP"
  type        = string
}

variable "saml_sp_sls_url" {
  description = "Single Logout Service endpoint on SAML SP"
  type        = string
}

variable "saml_sp_signing_cert" {
  description = "Absolute path to public key used to verify SAML messages signed by SP"
  type        = string
  default     = ""
}

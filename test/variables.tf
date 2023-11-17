variable "saml_sp_signing_cert" {
  description = "Absolute path to public key used to verify SAML messages signed by SP"
  type        = string
  default     = ""
}

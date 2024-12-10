terraform {
  required_providers {
    pfsense = {
      source = "marshallford/pfsense"
      version = "0.7.2"
    }
  }
}

provider "pfsense" {
    url = var.pf_url
    username = var.pf_user
    password = var.pf_pass
    tls_skip_verify = true
}
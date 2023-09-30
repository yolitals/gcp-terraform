terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}
provider "google" {
  credentials = file(var.json_credential)
  region      = var.region
}

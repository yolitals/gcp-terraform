terraform {
 backend "gcs" {
   bucket  = "yolandal-terraform-admin"
   prefix    = "terraform/state"
 }
}

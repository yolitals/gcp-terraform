module "vm_dev" {
  source          = "git::https://github.com/yolitals/gcp-terraform.git//gcp/modules/compute_instance?ref=v0.1.0"
  project_name    = var.project_name
  region          = var.region
  instance_name   = var.instance_name
  machine_type    = var.machine_type
  boot_image      = var.boot_image
  ssh_key         = var.ssh_key
  target_tags     = var.target_tags
  ssh_private_key = var.ssh_private_key
  json_credential = var.json_credential
}

variable "ssh_key" {}
variable "ssh_private_key" {}
variable "json_credential" {}
module "vm_test" {
  source          = "../compute_instance"
  project_name    = "wwcode-terraform-admin"
  region          = "us-central1"
  instance_name   = "test-instance"
  machine_type2    = "f1-micro"
  boot_image      = "ubuntu-1604-xenial-v20170328"
  target_tags     = ["web-app"]
  json_credential = var.json_credential
  ssh_private_key = var.ssh_private_key
  ssh_key         = var.ssh_key
  firewall_rule_name = "firewall-demo"
  local_exec = "echo +'Hello world'"
}

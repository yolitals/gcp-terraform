module "vm_dev" { 
  source        = "./modules/compute_instance"
  billing_account = var.billing_account
  project_name  = var.project_name
  region        = var.region
  instance_name = var.instance_name
  machine_type  = var.machine_type
  boot_image    = var.boot_image
  ssh_key       = var.ssh_key
  target_tags   = var.target_tags
}

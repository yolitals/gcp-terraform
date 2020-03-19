variable "project_name" {
}
variable "region" {}
variable "instance_name" {

}
variable "machine_type" {

}
variable "target_tags" {
}
variable "boot_image" {}
variable "ssh_key" {
    default = "~/.ssh/google_compute_engine.pub"
}
variable "ssh_private_key" {
    default = "~/.ssh/google_compute_engine"
}
variable "json_credential" {
  
}

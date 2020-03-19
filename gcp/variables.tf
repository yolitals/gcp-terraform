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
  default = "./credentials/.credentials/ssh_key.pub"
}
variable "ssh_private_key" {
  default = "./credentials/.credentials/ssh_key"
}
variable "json_credential" {
  default = "./credentials/.credentials/gcp_cred.json"
}

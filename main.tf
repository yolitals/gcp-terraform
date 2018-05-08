variable "project_name" {}
variable "billing_account" {}
variable "region" {}

provider "google" {
 region = "${var.region}"
}

data "google_compute_zones" "available" {}

resource "google_compute_instance" "web-app" {
 project = "yolandal-terraform-admin"
 zone = "${data.google_compute_zones.available.names[0]}"
 name = "tf-compute-1"
 machine_type = "f1-micro"
 tags = ["web-app"]

 boot_disk {
  initialize_params {
   image = "ubuntu-1604-xenial-v20170328"
  }
 }

 network_interface {
  network = "default"
  access_config {
  }
 }

 metadata {
  sshKeys = "ubuntu:${file("~/.ssh/google_compute_engine.pub")}"
 }

 provisioner "remote-exec" {
  connection {
   user = "ubuntu"
  }
  inline = [
   "echo 'Hello world'"
  ]
 }

 provisioner "local-exec" {
  command = "ssh-keyscan -H ${google_compute_instance.web-app.network_interface.0.access_config.0.assigned_nat_ip} >> ~/.ssh/known_hosts && echo '[gcp-compute]' > inventory && echo ${google_compute_instance.web-app.network_interface.0.access_config.0.assigned_nat_ip} >> inventory && ansible-playbook  -e 'host_key_checking=False' docker.yml -i inventory -u ubuntu"
 }

 provisioner "remote-exec" {
  connection {
   user = "ubuntu"
  }
  inline = [
   "docker run -p 80:80 -d yolix/nginx-hello-world:v2"
  ]
 }

}

resource "google_compute_firewall" "default" {
 name    = "test-firewall"
 network = "default"

 allow {
  protocol = "tcp"
  ports    = ["80", "8080", "1000-2000"]
 }

 target_tags =["web-app"]
}


output "instance_id" {
 value = "${google_compute_instance.default.self_link}"
}

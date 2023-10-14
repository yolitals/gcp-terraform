data "google_compute_zones" "available" {
  project = var.project_name
}

resource "google_compute_instance" "web-app" {
  project      = var.project_name
  zone         = data.google_compute_zones.available.names[0]
  name         = var.instance_name
  machine_type = var.machine_type
  tags         = var.target_tags

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    sshKeys = "ubuntu:${file(var.ssh_key)}"
  }

  provisioner "remote-exec" {
    connection {
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
      host        = google_compute_instance.web-app.network_interface.0.access_config.0.nat_ip
    }
    inline = [
      "echo 'Hello world'"
    ]
  }
  provisioner "local-exec" {
    command = "mkdir -p ~/.ssh && ssh-keyscan -H ${google_compute_instance.web-app.network_interface.0.access_config.0.nat_ip} >> ~/.ssh/known_hosts && echo '[gcp-compute]' > inventory && echo ${google_compute_instance.web-app.network_interface.0.access_config.0.nat_ip} >> inventory"
  }
  provisioner "local-exec" {
    command = var.local_exec
  }

}

resource "google_compute_firewall" "default" {
  project = var.project_name
  name    = var.firewall_rule_name
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["web-app"]
  source_tags = []
}

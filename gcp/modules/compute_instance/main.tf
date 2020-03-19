
provider "google" {
  credentials = file(var.json_credential)
  region      = var.region
}

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

}

resource "google_compute_firewall" "default" {
  project = var.project_name
  name    = "test-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  target_tags = ["web-app"]
}

output "app_url" {
  value = "http://${google_compute_instance.web-app.network_interface.0.access_config.0.nat_ip}/hello/"
}
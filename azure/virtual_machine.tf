# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
  name                  = "myVM2"
  location              = "centralus"
  resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  tags {
    environment = "Terraform Demo"
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H ${azurerm_public_ip.myterraformpublicip.ip_address} >> ~/.ssh/known_hosts && echo '[gcp-compute]' > inventory && echo ${azurerm_public_ip.myterraformpublicip.ip_address} >> inventory && ansible-playbook  -e 'host_key_checking=False' ../docker.yml -i inventory -u azureuser"
  }
}
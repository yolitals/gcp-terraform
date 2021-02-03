provider "azurerm" {
  features {}
}
variable "enable_geen" {
  type    = bool
  default = false
}

resource "azurerm_resource_group" "test" {
  name     = "demoazure"
  location = "West US 2"
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test" {
  name                 = "azure24hrs"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "test" {
  name                = "publicIPForLB"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "test" {
  name                = "loadBalancer"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.test.id
  }
}

resource "azurerm_lb_backend_address_pool" "test" {
  resource_group_name = azurerm_resource_group.test.name
  loadbalancer_id     = azurerm_lb.test.id
  name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "test" {
  count               = 2
  name                = "acctni${count.index}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "dynamic"
  }
}


resource "azurerm_availability_set" "avset" {
  name                         = "avset"
  location                     = azurerm_resource_group.test.location
  resource_group_name          = azurerm_resource_group.test.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "blue" {
  count                 = 2
  name                  = "blue-vm-${count.index}"
  location              = azurerm_resource_group.test.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdiskblue-vm${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }



  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  tags = {
    environment = "staging"
  }
  #  provisioner "local-exec" {
  #     command = "ssh-keyscan -H ${azurerm_public_ip.myterraformpublicip.ip_address} >> ~/.ssh/known_hosts && echo '[gcp-compute]' > inventory && echo ${azurerm_public_ip.myterraformpublicip.ip_address} >> inventory && ansible-playbook  -e 'host_key_checking=False' ../docker.yml -i inventory -u azureuser"
  #   }
}
resource "azurerm_virtual_machine" "green" {
  count                 = var.enable_geen == true ? 2 : 0
  name                  = "green-vm-${count.index}"
  location              = azurerm_resource_group.test.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdiskgeen-vm${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }



  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/id_rsa.pub")}"
    }
  }

  tags = {
    environment = "staging"
  }
  #  provisioner "local-exec" {
  #     command = "ssh-keyscan -H ${azurerm_public_ip.myterraformpublicip.ip_address} >> ~/.ssh/known_hosts && echo '[gcp-compute]' > inventory && echo ${azurerm_public_ip.myterraformpublicip.ip_address} >> inventory && ansible-playbook  -e 'host_key_checking=False' ../docker.yml -i inventory -u azureuser"
  #   }
}
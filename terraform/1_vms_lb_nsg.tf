# Reference resources created in another tfstate 
data "azurerm_resource_group" "sandbox_rg" {
  name = "sandbox"
}

data "azurerm_virtual_network" "sandbox_vnet" {
  name                = "sandbox-vnet"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
}

data "azurerm_subnet" "subnet_1" {
  name                 = "sandbox-subnet"
  resource_group_name  = data.azurerm_resource_group.sandbox_rg.name
  virtual_network_name = data.azurerm_virtual_network.sandbox_vnet.name
}

# Create private Load Balancer
resource "azurerm_lb" "sandbox_lb" {
  name                = "sandbox-lb"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name

  frontend_ip_configuration {
    name                          = "PrivateIPAddress"
    subnet_id                     = data.azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "sandbox_backendpool" {
  loadbalancer_id     = azurerm_lb.sandbox_lb.id
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "example" {
  resource_group_name            = data.azurerm_resource_group.sandbox_rg.name
  loadbalancer_id                = azurerm_lb.sandbox_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PrivateIPAddress"
}

# Create NSG
resource "azurerm_network_security_group" "nsg_sandbox" {
  name                = "sandbox-nsg"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
}

# Network Interfaces
resource "azurerm_network_interface" "nic_instance_1" {
  name                = "nic-instance-1"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name

  ip_configuration {
    name                          = "ip-instance-1"
    subnet_id                     = data.azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_instance_2" {
  name                = "nic-instance-2"
  location            = data.azurerm_resource_group.sandbox_rg.location
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name

  ip_configuration {
    name                          = "ip-instance-2"
    subnet_id                     = data.azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate NICs to LB Backend pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_1_to_backend_pool" {
  network_interface_id    = azurerm_network_interface.nic_instance_1.id
  ip_configuration_name   = "ip-instance-1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.sandbox_backendpool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_2_to_backend_pool" {
  network_interface_id    = azurerm_network_interface.nic_instance_2.id
  ip_configuration_name   = "ip-instance-2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.sandbox_backendpool.id
}

# Associate NSG to subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = data.azurerm_subnet.subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_sandbox.id
}

# Virtual Machines
resource "azurerm_linux_virtual_machine" "instance_1" {
  name                = "instance-1"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  size                = "Standard_D2S_v3"
  admin_username      = "ravindra"

  network_interface_ids = [
    azurerm_network_interface.nic_instance_1.id,
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "ravindra"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "instance_2" {
  name                = "instance-2"
  resource_group_name = data.azurerm_resource_group.sandbox_rg.name
  location            = data.azurerm_resource_group.sandbox_rg.location
  size                = "Standard_D2S_v3"
  admin_username      = "ravindra"

  network_interface_ids = [
    azurerm_network_interface.nic_instance_2.id,
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "ravindra"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
}
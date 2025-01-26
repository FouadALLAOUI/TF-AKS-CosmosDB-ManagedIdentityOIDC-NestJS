############################################################
#######################-- VM --#############################
############################################################
/*
resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm_subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.backend_vnet_name
  address_prefixes     = ["10.0.0.0/24"]
}

# Define the network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group_association" "vm_nsg_association" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Define the public IP address
resource "azurerm_public_ip" "jump_server_public_ip" {
  name                = "myLinuxVMPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Define the network interface and associate the public IP directly
resource "azurerm_network_interface" "nic" {
  name                = "myLinuxVMNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump_server_public_ip.id # Associate public IP here
  }
}


# Define the Linux VM
resource "azurerm_linux_virtual_machine" "jumpserver_backendnetwork" {
  name                = "JumpServer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms" # VM size A1_v2
  admin_username      = "AzureAdmin"
  admin_password      = "Azure@Fouad@70" # Specify your password here

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "LinuxVM"
  disable_password_authentication = false # Enable password authentication
}


output "ip_public_jumpserver" {
  value = azurerm_linux_virtual_machine.jumpserver_backendnetwork.public_ip_address
}
*/
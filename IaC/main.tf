provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "myterraformgroup" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "developer"
  }
}

resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "developer"
  }
}

resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "developer"
  }
}

resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "mynsgassociation" {
  subnet_id                 = azurerm_subnet.myterraformsubnet.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

resource "random_string" "storageaccount-name" {
  length = 16
  special = false
  upper = false
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = random_string.storageaccount-name.result
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = azurerm_resource_group.myterraformgroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "developer"
  }
}

resource "azurerm_public_ip" "myterraformpublicip" {
  count               = var.vmcount
  name                = "myPublicIP-${count.index}"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "developer"
  }
}

resource "azurerm_network_interface" "myterraformnic" {
  count               = var.vmcount
  name                = "myNIC-${count.index}"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.myterraformpublicip.*.id, count.index)
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_virtual_machine" "myterraformvm" {
  count                 = var.vmcount
  name                  = "myVM-${count.index}"
  location              = azurerm_resource_group.myterraformgroup.location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [element(azurerm_network_interface.myterraformnic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk-${count.index}"
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
    computer_name  = "myvm${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "developer"
  }
}
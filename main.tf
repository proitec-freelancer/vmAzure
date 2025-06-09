# main.tf
# Proveedor de Azure
provider "azurerm" {
  features {} # Configuración por defecto, necesario declararlo aunque esté vacío
}

# Recurso: Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-terra-vm"
  location = "East US"  # Región económica, puedes cambiar a otra barata como "East US 2"
}

# Recurso: Red virtual
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terra"
  address_space       = ["10.0.0.0/16"] # Rango de IPs
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Recurso: Subred
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-terra"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Recurso: IP pública
resource "azurerm_public_ip" "public_ip" {
  name                = "pip-terra"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic" # IP dinámica más barata
}

# Recurso: Interfaz de red
resource "azurerm_network_interface" "nic" {
  name                = "nic-terra"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Recurso: Máquina Virtual
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-terra"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"  # Instancia más barata

  admin_username = "azureuser" # Usuario para login
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Ruta de tu llave pública local
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Disco HDD estándar, más económico
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"  # Imagen liviana, segura y gratuita
    version   = "latest"
  }
}

# Output: IP pública de la VM
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
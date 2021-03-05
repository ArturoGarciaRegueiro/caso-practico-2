# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "myVM" {
    name                = "${var.vms[count.index]}.acme.es"
    count               = length(var.vms)
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vms[count.index] == "master" ? var.master_size : var.vm_size
    admin_username      = "adminUsername" 
    network_interface_ids = [ azurerm_network_interface.myNic[count.index].id ] 
    disable_password_authentication = true

    # Para ejecutar con ansible será necesario para permitirle acceso al nodo
    admin_ssh_key {
        username   = "adminUsername"
        public_key = file("~/.ssh/id_rsa.pub")
    } 

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }

}

resource "azurerm_managed_disk" "example" {
  name                 = "data-disk"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location 
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_linux_virtual_machine.myVM[1].id 
  lun                = "10"
  caching            = "ReadWrite"
}
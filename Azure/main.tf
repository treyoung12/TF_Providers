terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.34.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "tf_azure_providers"{
  name = "tf_azure_providers"
  location = "East US"
}

# module to create linux servers, much easier than typing it all yourself
module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.tf_azure_providers.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_B21s"
  location            = "East US"
  depends_on          = [azurerm_resource_group.tf_azure_providers]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.tf_azure_providers.name

  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]
  #location = "East US"
  depends_on = [azurerm_resource_group.tf_azure_providers]
}

output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}

variable "msql_map" {}

resource "azurerm_mssql_server" "msql" {
    for_each = var.msql_map
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "Ashutosh@123456"
}
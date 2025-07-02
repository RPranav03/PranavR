
variable "database_map"{}

resource "azurerm_mssql_database" "database" {
    for_each = var.database_map
  name         = each.value.name
  server_id    = "/subscriptions/ef7d50ea-8b81-47b2-9eb2-56aa61bf454b/resourceGroups/ashutosh/providers/Microsoft.Sql/servers/ashutosh-sqlserver"
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}
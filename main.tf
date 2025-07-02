module "rg_details" {
  source = "../../Module/Resourcegroup"
  rg_map = var.rg_details

}

module "subnet_details" {
  depends_on = [module.rg_details, module.vnet_details]
  source     = "../../Module/Subnet"
  subnet_map = var.subnet_details

}

module "vnet_details" {
  depends_on = [module.rg_details]
  source     = "../../Module/Vnet"
  vnet_map   = var.vnet_details

}

module "vm_details" {
  depends_on = [module.rg_details, module.subnet_details]
  source     = "../../Module/Virtualmachine"
  vms        = var.vm_details

}

module "msql_details" {
  source   = "../../Module/msql server"
  msql_map = var.msql_details

}

module "database_details" {
  source       = "../../Module/database"
  database_map = var.database_details

}
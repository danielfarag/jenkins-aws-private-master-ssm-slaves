module "network" {
  source = "./modules/network"
  region = var.region
  availability_zone= var.availability_zone
}

module "compute" {
  source = "./modules/compute"
  private_subnet = module.network.private_subnet
  public_subnet = module.network.public_subnet
  vpc = module.network.vpc
  region = var.region
  availability_zone= var.availability_zone
}

module "storage" {
  source = "./modules/storage"
}
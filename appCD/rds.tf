module "rds" {
    source     = "./modules/rds"
    
    project = var.project
    env = var.env
    vpc_id = module.vpc.id
    cidr_blocks = [var.cidr_block]
    private_subnets = module.vpc.private_subnet_ids

    # db details
    db_username = var.db_username
    db_password = var.db_password
}
output "db_instance_address" {
    value = module.db.this_db_instance_address
    description = "The address of the RDS instance"
}

output "db_instance_arn" {
    value = module.db.this_db_instance_arn
    description = "The ARN of the RDS instance"
}

output "db_instance_endpoint" {
    value = module.db.this_db_instance_endpoint
    description = "The connection endpoint"
}

output "db_instance_id" {
    value = module.db.this_db_instance_id
    description = "The RDS instance ID"
}

output "db_instance_name" {
    value = module.db.this_db_instance_name
    description = "The database name"
}

output "db_instance_password" {
    value = module.db.this_db_instance_password
    description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
}

output "db_instance_port" {
    value = module.db.this_db_instance_port
    description = "The database port"
}
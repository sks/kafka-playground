# Security group to allow internal database traffic
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "allow internal database traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "rds-sg"
  }
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "mysql-db"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.small"
  allocated_storage = 10
  storage_encrypted = false

  username = var.db_username
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  maintenance_window = "Sun:00:00-Sun:03:00"
  backup_window      = "03:00-06:00"

  multi_az = true

  backup_retention_period = 7

  tags = {
    Project     = var.project
    Environment = var.env
  }

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  subnet_ids = var.private_subnets

  family = "mysql5.7"

  major_engine_version = "5.7"

  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

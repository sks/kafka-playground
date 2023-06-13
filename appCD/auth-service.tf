resource "aws_security_group" "auth-service_sg" {
	name        = "auth-service-${var.project}-${var.env}-ecs-sg"
	vpc_id      = module.vpc.id

	ingress {
	  protocol        = "tcp"
	  from_port       = 8012
	  to_port         = 8012
	  security_groups = [aws_security_group.orchestration-service_sg.id, module.lb_sg.id]
	}

	egress {
	  protocol    = "-1"
	  from_port   = 0
	  to_port     = 0
	  cidr_blocks = ["0.0.0.0/0"]
	}
  }

resource "aws_cloudwatch_log_group" "auth-service_lg" {
  name = "auth-service_${var.project}_${var.env}"
}

module "auth-service_task_definition" {
	source         = "./modules/ecs/task_definition"
	name           = "auth-service-${var.project}-${var.env}-ecs-task-def"
	launch_type    = [var.launch_type]
	network_mode   = var.network_mode
	cpu            = var.cpu
	memory         = var.memory
	execution_role = module.task_execution_role.arn
	definitions = templatefile("definitions/container_definition.json", {
	  repository_url  = "appcd2023/is-auth-service:latest"
	  definition_name = "auth-service-${var.project}-${var.env}"
	  container_port  = 8012
	  host_port       = 8012
	  log_group       = "auth-service_${var.project}_${var.env}"
	  region          = var.region
	  prefix          = "auth-service"
	  rds_endpoint    = module.rds.db_instance_endpoint
	  db_username     = var.db_username
	  db_password     = var.db_password
	})
	depends_on = [
		module.rds
	  ]
  }

  module "auth-service_ecs_service" {
	
	source          = "./modules/ecs/service"
	name            = "auth-service-${var.project}-${var.env}-ecs-service"
	cluster         = module.ecs_cluster.id
	task_definition = module.auth-service_task_definition.arn
	desired_count   = var.desired_tasks
	launch_type     = var.launch_type
	container_name  = "auth-service-${var.project}-${var.env}"
	container_port  = 8012
	network_config  = [
		{
		  subnets         = module.vpc.private_subnet_ids
		  public_ip       = "false"
		  security_groups = [aws_security_group.auth-service_sg.id]
		}
	  ]
	
	lb_target_group = module.auth-service_target_group.arn
	http_listener   = module.http_listener.arn
	namespace 		= "${var.project}-${var.env}"
	dns_name 		= "auth-service"
  }

  
  module "auth-service_target_group" {
	source      = "./modules/alb/target_group"
	name        = "auth-service-${var.project}-${var.env}-tg"
	port        = 8012
	protocol    = var.tg_protocol
	target_type = var.tg_type
	vpc_id      = module.vpc.id
  }

  module "auth-service_http_listener_rule" {
	source      	= "./modules/alb/lb_listener_rule"
	listener_arn    = module.http_listener.arn
	action_type 	= var.http_listener_action
	tg_arn      	= module.auth-service_target_group.arn
	svc_name    	= "auth-service"
  }
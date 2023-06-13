resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster
  task_definition = var.task_definition
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  dynamic "network_configuration" {
    for_each = var.network_config
    content {
      subnets = lookup(network_configuration.value, "subnets", null)
      security_groups = lookup(network_configuration.value, "security_groups", null)
      assign_public_ip = lookup(network_configuration.value, "public_ip", null)
    }
  }

  service_connect_configuration {
    enabled = true
    namespace = var.namespace
    service {
      discovery_name = var.container_name
      port_name = "local"
      client_alias {
        dns_name = var.dns_name
        port = var.container_port
      }
    }
  }
}


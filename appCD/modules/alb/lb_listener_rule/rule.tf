resource "aws_lb_listener_rule" "forward_rule" {
  listener_arn = var.listener_arn

  action {
    type             = var.action_type
    target_group_arn = var.tg_arn
  }

  condition {
    path_pattern {
      values = [format("/%s/*", var.svc_name)]
    }
  }
}
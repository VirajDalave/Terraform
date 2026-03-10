output "alb_dns" {
  value = aws_lb.main.dns_name
}

output "sg_id" {
  value = aws_security_group.alb-sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}
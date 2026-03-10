resource "aws_security_group" "alb-sg" {
  name = var.security_group_name
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name = var.lb_name
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-sg.id]
  subnets = var.alb_subnets
  
  enable_deletion_protection = true
}

resource "aws_lb_target_group" "main" {
  name     = "${var.lb_name}-tg"
  port     = var.application_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn

  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb" "ruslan" {
  name     = "ruslan"
  internal = false

  load_balancer_type = "application"

  security_groups = [
    data.aws_security_group.since.id,
    aws_security_group.lb.id
  ]

  subnets = data.aws_subnets.since.ids
}

resource "aws_security_group" "lb" {
  name        = "ruslan_lb_security_group"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.since.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ruslan.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ruslan.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  # TODO
  certificate_arn = "arn:aws:acm:eu-north-1:154782911265:certificate/ca998916-eab1-49ff-9a2a-68c19648d226"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ruslan.arn
  }
}

resource "aws_lb_target_group" "ruslan" {
  name = "ruslan"
  port = var.port

  protocol         = "HTTP"
  protocol_version = "HTTP2"

  vpc_id      = data.aws_vpc.since.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    path                = "/health"
    # port todo
  }
}

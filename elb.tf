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
  }

  # need to split "::/0" accorting to https://github.com/hashicorp/terraform/issues/14382#issuecomment-300769009
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
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
  certificate_arn = "arn:aws:acm:eu-north-1:154782911265:certificate/6f6dc63b-9d52-4e6c-ae7e-69a8d76476bb"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ruslan.arn
  }
}

resource "aws_lb_target_group" "ruslan" {
  name = "ruslan"
  port = var.port

  protocol = "HTTP"
  # safari WS fails to connect with status_code=464 on HTTP2
  # see https://forums.aws.amazon.com/thread.jspa?messageID=967355
  protocol_version = "HTTP1"

  deregistration_delay = 10

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

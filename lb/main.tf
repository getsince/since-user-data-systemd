terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

resource "aws_security_group" "lb" {
  name_prefix = "since-backend-lb-"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "since-backend-lb"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # need to split "::/0" according to https://github.com/hashicorp/terraform/issues/14382#issuecomment-300769009
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

resource "aws_lb" "this" {
  name     = "since-backend"
  internal = false

  load_balancer_type = "application"

  security_groups = [
    var.default_security_group,
    aws_security_group.lb.id
  ]

  subnets = var.subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
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
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener_rule" "imgproxy" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.imgproxy.arn
  }

  condition {
    host_header {
      values = [var.imgproxy_host]
    }
  }
}

resource "aws_lb_target_group" "api" {
  name = "since-backend-api"
  port = var.target_port

  protocol = "HTTP"
  # safari WS fails to connect with status_code=464 on HTTP2
  # see https://forums.aws.amazon.com/thread.jspa?messageID=967355
  protocol_version = "HTTP1"

  deregistration_delay = 10

  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    path                = "/health"
    # TODO port
  }
}

resource "aws_lb_target_group" "imgproxy" {
  name = "since-imgproxy"
  port = 8080

  protocol         = "HTTP"
  protocol_version = "HTTP1"

  deregistration_delay = 10

  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    path                = "/health"
  }
}

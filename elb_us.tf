resource "aws_lb" "ruslan_ohio" {
  name     = "ruslan"
  internal = false

  load_balancer_type = "application"

  security_groups = [
    data.aws_security_group.since_ohio.id,
    aws_security_group.lb_ohio.id
  ]

  subnets = data.aws_subnets.since_ohio.ids

  provider = aws.ohio
}

resource "aws_security_group" "lb_ohio" {
  name        = "ruslan_lb_security_group"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.since_ohio.id

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

  provider = aws.ohio
}

resource "aws_lb_listener" "http_ohio" {
  load_balancer_arn = aws_lb.ruslan_ohio.arn
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

  provider = aws.ohio
}

resource "aws_lb_listener" "https_ohio" {
  load_balancer_arn = aws_lb.ruslan_ohio.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  # TODO
  certificate_arn = "arn:aws:acm:us-east-2:154782911265:certificate/c2bbe26e-1ead-4dc5-bb5d-2088592dbd43"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ruslan_ohio.arn
  }

  provider = aws.ohio
}

resource "aws_lb_target_group" "ruslan_ohio" {
  name = "ruslan"
  port = var.port

  protocol = "HTTP"
  # safari WS fails to connect with status_code=464 on HTTP2
  # see https://forums.aws.amazon.com/thread.jspa?messageID=967355
  protocol_version = "HTTP1"

  deregistration_delay = 10

  vpc_id      = data.aws_vpc.since_ohio.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    path                = "/health"
    # port todo
  }

  provider = aws.ohio
}

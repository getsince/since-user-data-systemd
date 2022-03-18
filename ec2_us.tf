data "aws_ami" "ubuntu_ohio" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]

  provider = aws.ohio
}

resource "aws_launch_template" "ruslan_ohio" {
  name_prefix = "ruslan-"
  image_id    = data.aws_ami.ubuntu_ohio.id

  # cpu mode = standard

  instance_market_options {
    market_type = "spot"

    # spot_options {
    #   spot_instance_type = "persistent"
    # }
  }

  instance_type = "t3.micro"
  # key_name      = "since"

  # TODO
  instance_initiated_shutdown_behavior = "terminate"

  # iam_instance_profile {
  #   name = "test"
  # }

  # TODO
  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      # aws_security_group.ruslan_ssh.id,
      "sg-0ffdda2de6b12d17d", # allows traffic from 10.0.0.0/16
      data.aws_security_group.since_ohio.id
    ]
  }

  # monitoring {
  #   enabled = true
  # }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.ec2_name
    }
  }

  # TODO force instance refresh on change
  # TODO this is visible in tfstate
  user_data = base64encode(templatefile("user_data.sh.tftpl", {
    release_url           = var.release_url,
    release_cookie        = var.release_cookie,
    primary_host_prefix   = var.primary_host_prefix,
    secret_key_base       = var.secret_key_base
    host                  = var.host,
    port                  = var.port,
    dashboard_username    = var.dashboard_username,
    dashboard_password    = var.dashboard_password,
    admin_id              = var.admin_id,
    ec2_name              = var.ec2_name,
    ec2_regions           = join(",", var.ec2_regions)
    imgproxy_prefix       = var.imgproxy_prefix,
    imgproxy_key          = var.imgproxy_key,
    imgproxy_salt         = var.imgproxy_salt,
    maxmind_license_key   = var.maxmind_license_key,
    tg_bot_key            = var.tg_bot_key,
    tg_room_id            = var.tg_room_id,
    sentry_dsn            = var.sentry_dsn,
    database_url          = var.ohio_database_url,
    aws_access_key_id     = var.aws_access_key_id,
    aws_secret_access_key = var.aws_secret_access_key,
    aws_s3_bucket         = var.aws_s3_bucket,
    aws_s3_bucket_static  = var.aws_s3_bucket_static,
    static_cdn            = var.static_cdn,
    aws_s3_bucket_events  = var.aws_s3_bucket_events,
    apns_topic            = var.apns_topic,
    apns_team_id          = var.apns_team_id,
    prod_apns_key_id      = var.prod_apns_key_id,
    prod_apns_key         = var.prod_apns_key,
    sandbox_apns_key_id   = var.sandbox_apns_key_id,
    sandbox_apns_key      = var.sandbox_apns_key,
    phone_home_tg_bot_key = var.phone_home_tg_bot_key,
    phone_home_tg_room_id = var.phone_home_tg_room_id
  }))

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.ohio
}

resource "aws_autoscaling_group" "ruslan_ohio" {
  name = "ruslan"

  launch_template {
    id = aws_launch_template.ruslan_ohio.id
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#instance_refresh
    # A refresh will not start when version = "$Latest" is configured in the launch_template block.
    # To trigger the instance refresh when a launch template is changed, configure version to
    # use the latest_version attribute of the aws_launch_template resource.
    version = aws_launch_template.ruslan.latest_version
  }

  capacity_rebalance = true

  min_size         = 1
  desired_capacity = 2
  max_size         = 10

  target_group_arns = [
    aws_lb_target_group.ruslan_ohio.arn
  ]

  health_check_grace_period = 30
  health_check_type         = "ELB"

  vpc_zone_identifier = data.aws_subnets.since_ohio.ids

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.ohio
}

# data "aws_instances" "ruslan" {
#   filter {
#     name   = "tag:Name"
#     values = [var.ec2_name]
#   }
# }

# output "public_ips" {
#   value = data.aws_instances.ruslan.public_ips
# }

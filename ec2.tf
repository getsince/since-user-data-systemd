data "aws_ami" "ubuntu" {
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
}

resource "aws_launch_template" "ruslan" {
  name_prefix = "ruslan-"
  image_id    = data.aws_ami.ubuntu.id

  credit_specification {
    cpu_credits = "standard"
  }

  # instance_market_options {
  #   market_type = "spot"

  #   # spot_options {
  #   #   spot_instance_type = "persistent"
  #   # }
  # }

  instance_type = "t3.micro"
  key_name      = "since"

  # TODO
  instance_initiated_shutdown_behavior = "terminate"

  # iam_instance_profile {
  #   name = "test"
  # }

  # TODO
  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      aws_security_group.ruslan_ssh.id,
      # 10.0.0.0/16 <-> 10.1.0.0/16
      "sg-0b1af722955d3a5da",
      data.aws_security_group.since.id
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

  # TODO this is visible in tfstate
  user_data = base64encode(templatefile("user_data.sh.tftpl", {
    release_url           = var.release_url,
    release_cookie        = var.release_cookie,
    primary_host_prefix   = var.primary_host_prefix,
    secret_key_base       = var.secret_key_base
    host                  = var.host,
    check_origin          = var.check_origin,
    port                  = var.port,
    dashboard_username    = var.dashboard_username,
    dashboard_password    = var.dashboard_password,
    ec2_name              = var.ec2_name,
    ec2_regions           = join(",", var.ec2_regions)
    imgproxy_prefix       = var.imgproxy_prefix,
    imgproxy_key          = var.imgproxy_key,
    imgproxy_salt         = var.imgproxy_salt,
    maxmind_license_key   = var.maxmind_license_key,
    tg_bot_key            = var.tg_bot_key,
    tg_room_id            = var.tg_room_id,
    sentry_dsn            = var.sentry_dsn,
    database_url          = var.stockholm_database_url,
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
}

resource "aws_autoscaling_group" "ruslan" {
  name = "ruslan"

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0

      spot_allocation_strategy = "capacity-optimized-prioritized"
      spot_instance_pools      = 0
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ruslan.id
        # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#instance_refresh
        # A refresh will not start when version = "$Latest" is configured in the launch_template block.
        # To trigger the instance refresh when a launch template is changed, configure version to
        # use the latest_version attribute of the aws_launch_template resource.
        version = aws_launch_template.ruslan.latest_version
      }

      # TODO t4g with erlang-25

      override {
        instance_type = "t3.micro"
      }

      override {
        instance_type = "t2.micro"
      }

      override {
        instance_type = "t3.small"
      }

      override {
        instance_type = "t2.small"
      }

      override {
        instance_type = "c5a.large"
      }

      override {
        instance_type = "c5.large"
      }

      override {
        instance_type = "c4.large"
      }
    }
  }

  capacity_rebalance = true

  min_size         = 1
  desired_capacity = 2
  max_size         = 10

  target_group_arns = [
    aws_lb_target_group.ruslan.arn
  ]

  health_check_grace_period = 30
  health_check_type         = "ELB"

  vpc_zone_identifier = data.aws_subnets.since.ids

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }
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

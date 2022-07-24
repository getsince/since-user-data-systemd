terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
  }

  required_version = "~> 1.1"
}

resource "aws_launch_template" "this" {
  name_prefix = "since-"
  image_id    = data.aws_ami.ubuntu_amd.id

  instance_type = "t3.micro"
  key_name      = "rail"

  user_data = var.user_data_base64

  instance_initiated_shutdown_behavior = "terminate"

  vpc_security_group_ids = var.security_groups

  credit_specification {
    cpu_credits = "standard"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix = "since-"

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.on_demand_base_capacity
      on_demand_percentage_above_base_capacity = 0

      spot_allocation_strategy = "capacity-optimized-prioritized"
      spot_instance_pools      = 0
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#instance_refresh
        # A refresh will not start when version = "$Latest" is configured in the launch_template block.
        # To trigger the instance refresh when a launch template is changed, configure version to
        # use the latest_version attribute of the aws_launch_template resource.
        version = aws_launch_template.this.latest_version
      }

      dynamic "override" {
        for_each = var.instance_types
        content {
          instance_type = override.value
        }
      }
    }
  }

  capacity_rebalance = true

  target_group_arns = var.lb_target_group_arns

  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier = var.vpc_zone_identifier

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }
}

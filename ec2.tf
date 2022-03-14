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

resource "aws_instance" "ruslan" {
  ami   = data.aws_ami.ubuntu.id
  count = 2

  instance_type = "t3.micro"
  key_name      = "since"

  associate_public_ip_address = true

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.ruslan_ssh.id,
    aws_security_group.http.id
  ]

  user_data = templatefile("user_data.sh.tftpl", {
    release_url           = var.release_url,
    secret_key_base       = var.secret_key_base
    host                  = var.host,
    port                  = var.port,
    dashboard_username    = var.dashboard_username,
    dashboard_password    = var.dashboard_password,
    admin_id              = var.admin_id,
    ec2_name              = var.ec2_name,
    imgproxy_prefix       = var.imgproxy_prefix,
    imgproxy_key          = var.imgproxy_key,
    imgproxy_salt         = var.imgproxy_salt,
    maxmind_license_key   = var.maxmind_license_key,
    tg_bot_key            = var.tg_bot_key,
    tg_room_id            = var.tg_room_id,
    sentry_dsn            = var.sentry_dsn,
    database_url          = var.database_url,
    aws_access_key_id     = var.aws_access_key_id,
    aws_secret_access_key = var.aws_secret_access_key,
    aws_s3_bucket         = var.aws_s3_bucket,
    aws_s3_bucket_static  = var.aws_s3_bucket_static,
    static_cdn            = var.static_cdn,
    aws_s3_bucket_events  = var.aws_s3_bucket_events,
    twilio_account_sid    = var.twilio_account_sid,
    twilio_key_sid        = var.twilio_key_sid,
    twilio_auth_token     = var.twilio_auth_token,
    apns_topic            = var.apns_topic,
    apns_team_id          = var.apns_team_id,
    prod_apns_key_id      = var.prod_apns_key_id,
    prod_apns_key         = var.prod_apns_key,
    sandbox_apns_key_id   = var.sandbox_apns_key_id,
    sandbox_apns_key      = var.sandbox_apns_key,
    phone_home_tg_bot_key = var.phone_home_tg_bot_key,
    phone_home_tg_room_id = var.phone_home_tg_room_id
  })

  tags = {
    Name = var.ec2_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# TODO
# resource "aws_spot_instance_request" "ruslan" {
#   ami = data.aws_ami.ubuntu.id

#   # spot_price             = "0.016"
#   # block_duration_minutes = "120"

#   instance_type        = "t4g.micro"
#   spot_type            = "one-time"
#   wait_for_fulfillment = true

#   associate_public_ip_address = true

#   key_name = "since"

#   security_groups = [
#     aws_security_group.ruslan_ssh.id
#   ]

#   user_data = file("user_data.sh")

#   tags = {
#     Name = "ruslan learning cloud-init and spot instances"
#   }
# }

output "public_ips" {
  value = aws_instance.ruslan[*].public_ip
}

# TODO t4g with erlang-25

module "ec2_stockholm" {
  source = "./ec2"

  instance_name = var.ec2_name

  user_data_base64 = base64encode(templatefile("user_data.sh.tftpl", {
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
    aws_s3_bucket_media   = var.aws_s3_bucket_media,
    media_cdn             = var.media_cdn,
    aws_s3_bucket_events  = var.aws_s3_bucket_events,
    spotify_client_id     = var.spotify_client_id,
    spotify_client_secret = var.spotify_client_secret,
    apns_topic            = var.apns_topic,
    apns_team_id          = var.apns_team_id,
    prod_apns_key_id      = var.prod_apns_key_id,
    prod_apns_key         = var.prod_apns_key,
    sandbox_apns_key_id   = var.sandbox_apns_key_id,
    sandbox_apns_key      = var.sandbox_apns_key,
    phone_home_tg_bot_key = var.phone_home_tg_bot_key,
    phone_home_tg_room_id = var.phone_home_tg_room_id,
    algo_gist_url         = var.algo_gist_url,
    feed_key              = var.feed_key,
    app_store_issuer_id   = var.app_store_issuer_id,
    app_store_key_id      = var.app_store_key_id,
    app_store_key         = var.app_store_key
  }))

  lb_target_group_arns = module.lb_stockholm.target_group_arns
  vpc_zone_identifier  = module.vpc_stockholm.subnet_ids

  security_groups = concat(
    [module.vpc_stockholm.default_security_group_id],
    module.vpc_stockholm.peering_security_group_ids
    # TODO [aws_security_group.ruslan_ssh.id]
  )

  on_demand_base_capacity = 1

  instance_types = ["t3.micro", "t3.small", "t2.micro", "t2.small", "c5a.large", "c5.large", "c4.large"]

  providers = {
    aws = aws.stockholm
  }
}

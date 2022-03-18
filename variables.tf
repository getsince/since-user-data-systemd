variable "release_url" {}
variable "release_cookie" {}

variable "ec2_regions" {
  type = list(string)
}

variable "primary_host_prefix" {}
variable "secret_key_base" {}
variable "host" {}
variable "port" {}
variable "dashboard_username" {}
variable "dashboard_password" {}
variable "ec2_name" {}
variable "imgproxy_prefix" {}
variable "imgproxy_key" {}
variable "imgproxy_salt" {}
variable "maxmind_license_key" {}
variable "tg_bot_key" {}
variable "tg_room_id" {}
variable "sentry_dsn" {}
variable "stockholm_database_url" {}
variable "ohio_database_url" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_s3_bucket" {}
variable "aws_s3_bucket_static" {}
variable "static_cdn" {}
variable "aws_s3_bucket_events" {}
variable "apns_topic" {}
variable "apns_team_id" {}
variable "prod_apns_key_id" {}
variable "prod_apns_key" {}
variable "sandbox_apns_key_id" {}
variable "sandbox_apns_key" {}
variable "phone_home_tg_bot_key" {}
variable "phone_home_tg_room_id" {}

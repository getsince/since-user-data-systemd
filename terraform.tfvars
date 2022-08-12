// see https://github.com/getsince/test3/releases 
release_url = "https://github.com/getsince/test3/releases/download/support-story-fix/ubuntu-22-04-amd64.tar.gz"

// name is used to connect the cluster
ec2_name    = "since-backend2"
ec2_regions = ["eu-north-1", "us-east-2", "us-west-1", "ap-southeast-2", "sa-east-1"]

// 10.0.0.1/16 (eu-north-1) is the primary region (todo: cidr)
primary_host_prefix = "10.0."

// used in links and origin checks
host          = "b.getsince.app"
imgproxy_host = "seeing.getsince.app"
check_origin  = "//*.getsince.app"

// port to bind to
port = "5000"

// the rest are set in .envrc using https://direnv.net
// export TF_VAR_secret_key_base=...

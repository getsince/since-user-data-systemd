// see https://github.com/getsince/test3/releases 
release_url = "https://github.com/getsince/test3/releases/download/rpc/ubuntu-20-04-amd64.tar.gz"

// name is used to connect the cluster
ec2_name = "since-backend2"
ec2_regions = ["eu-north-1", "us-east-2"]

// 10.0.0.1/16 (eu-north-1) is the primary region (todo: cidr)
primary_host_prefix = "10.0."

// used for origin checks
host = "b3.getsince.app"

// port to bind to
port = "5000"

// the rest are set in .envrc using https://direnv.net
// export TF_VAR_secret_key_base=...

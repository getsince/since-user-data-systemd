the most basic way I could come up with to deploy getsince backend to ec2 instances in a way that's easy to scale and somewhat reliable

ec2 instances are deployed with `user_data` script that runs on boot and downloads a release tar from github, configures systemd service and starts it

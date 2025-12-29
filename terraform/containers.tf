module "ecs_ec2" {
  source = "flyflow/ec2/aws"
  version = "~> 1.0"

  vpc_id        = "vpc-0d875e56be488e3e5"
  subnet_ids    = ["subnet-07ba043f755b81b33", "subnet-0e4525cbfb4c98ed0"]
  instance_type = "t3.small"

  desired_count = 1
  cluster_name  = "flyflow-ecs-staging"

  # optional
  ami_id = "ami-053e7be1410d7eb72"
  user_data = <<-EOF
#!/bin/bash
# Redirect all output to a custom log file for debugging.
exec > >(tee -a /var/log/user-data-custom.log) 2>&1

echo "User data script started at $(date)"

echo "Step 1: Updating system packages"
yum update -y


echo "Step 5: Setting ECS_CLUSTER environment variable"
echo "ECS_CLUSTER=flyflow-ecs-staging" > /etc/ecs/ecs.config
echo "ECS_CLUSTER configuration applied"



echo "User data script finished at $(date)"

EOF

  storage = {
    root_volume_size      = 30
    delete_on_termination = true
  }
}
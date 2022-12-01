#!/bin/bash -x

mkdir -p .aws
cat > .aws/config <<EOF
[default]
region = us-east-1
EOF

sudo yum -y update
suod yum -y install git

sudo yum -y install docker
sudo usermod -a -G docker ec2-user
newgrp docker
sudo systemctl start docker.service

mkdir -p /home/ec2-user/actions-runner && cd /home/ec2-user/actions-runner

curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz
tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz

sudo yum -y install libguestfs libguestfs-tools
sudo yum -y install virt-v2v

#!/bin/bash
sudo yum -y update
sudo yum -y install docker
sudo usermod -a -G docker ec2-user
newgrp docker
sudo systemctl start docker.service


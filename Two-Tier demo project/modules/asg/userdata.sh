#!/bin/bash

apt-get update -y
apt-get install -y docker.io
systemctl enable --now docker

docker run -d --name my_container -p 80:5000 virajdalave/flask-app:1763eaf6b950abd003f13fb0da0bb7ee8fcd4df4

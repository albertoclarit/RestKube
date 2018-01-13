#!/bin/bash
# curl -sS https://raw.githubusercontent.com/albertoclarit/DevOps/master/setupenv.sh | bash

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

cd ~

echo "source <(kubectl completion bash)" >> ~/.profile
source ~/.profile

#!/bin/bash
# curl -sS https://raw.githubusercontent.com/albertoclarit/DevOps/master/settingk8.sh | bash

apt-get update
apt-get install -y docker.io nfs-common


apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl kubernetes-cni






sudo add-apt-repository ppa:gophers/archive
sudo apt update


sudo apt-get install -y golang-1.9-go
wget https://github.com/kubernetes-incubator/cri-tools/archive/v1.0.0-alpha.0.zip
apt-get install -y unzip
unzip v1.0.0-alpha.0.zip -d xx

echo "export PATH=\"\$PATH:/usr/lib/go-1.9/bin\"" >> .profile
echo "export PATH=\"\$PATH:/\$HOME/xx/cri-tools-1.0.0-alpha.0/_output/bin\"" >> .profile
echo "source <(kubectl completion bash)" >> ~/.profile
source ~/.profile
cd xx/cri-tools-1.0.0-alpha.0
make
cd ~
source ~/.profile




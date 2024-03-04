#!/bin/bash
sudo yum -y update
sudo yum -y install epel-release
sudo yum -y install git libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
sudo yum install socat -y
sudo yum install -y conntrack
curl -fsSL https://get.docker.com -o install-docker.sh
sh install-docker.sh --dry-run
sudo sh install-docker.sh
sudo usermod -aG docker centos
sudo systemctl start docker
sudo yum -y install wget
sudo wget https://storage.googleapis.com/minikube/releases/v1.32.0/minikube-linux-amd64
sudo chmod +x minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/bin/minikube
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.29.0/bin/linux/amd64/kubectl
sudo chmod +x kubectl
sudo mv kubectl  /usr/bin/
sudo su
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
exit
sudo systemctl enable docker.service
exec sudo su -l $USER
minikube start –driver=docker --kubernetes-version=v1.28.3
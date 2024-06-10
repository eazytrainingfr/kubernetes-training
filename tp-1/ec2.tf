terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR OWN"
  secret_key = "YOUR OWN"
}


resource "aws_instance" "myec2" {
  ami             = "ami-0d71ca6a78e324f68" # CentOS 7
  instance_type   = "t3.large"              # you can change this
  key_name        = "your-public-key.pem"  # the name of your public key
  security_groups = ["franklin-sg"]

  root_block_device {
    volume_size = 100 # you can change this value
  }


  connection {
    type        = "ssh"
    user        = "centos"
    private_key = file("./your-public-key.pem")   # the public key must be in the same folder as ec2.tf
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -y install epel-release",
      "sudo yum -y install nano git libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils",
      "sudo yum install socat -y",
      "sudo yum install -y conntrack",
      "sudo curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo usermod -aG docker centos",
      "suudo systemctl start docker",
      "suudo systemctl enable docker",
      "sudo yum -y install wget",
      "sudo wget https://storage.googleapis.com/minikube/releases/v1.11.0/minikube-linux-amd64",
      "sudo chmod +x minikube-linux-amd64",
      "sudo mv minikube-linux-amd64 /usr/bin/minikube",
      "sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.0/bin/linux/amd64/kubectl",
      "sudo chmod +x kubectl",
      "sudo mv kubectl /usr/bin/",
      "sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables",
      "sudo systemctl enable docker.service",
      "sudo systemctl start docker.service",

    ]
  }


}

resource "aws_security_group" "allow_http_https" {
  name        = "franklin-sg"
  description = "Allow http and https inbound traffic"

  ingress {
    description = "https from vpc"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from vpc"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from vpc"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_eip" "lb" {
  instance = aws_instance.myec2.id
  domain   = "vpc"
  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${self.public_ip} > infos_ec2.txt"
  }
}


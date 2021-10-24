# AWS용 프로바이더 구성
provider "aws" {
  profile = "default"
  region = "ap-northeast-2"
}

locals {
  svc_nm = "dyheo"
  pem_file = "dyheo-histech"

  ## EC2 를 만들기 위한 로컬변수 선언
  ami = "ami-0e4a9ad2eb120e054" ## AMAZON LINUX 2
  instance_type = "t2.micro"
  instance_group = "dyheo-ec2"
  instance_creator = "dyheo"
}

## TAG NAME 으로 vpc id 를 가져온다.
data "aws_vpc" "this" {
  filter {
    name = "tag:Name"
    values = ["${local.svc_nm}-vpc"]
  }
}

## TAG NAME 으로 security group 을 가져온다.
data "aws_security_group" "security-group" {
  filter {
    name = "tag:Name"
    values = ["${local.svc_nm}-sg"]
  }
}

## TAG NAME 으로 subnet 을 가져온다.
data "aws_subnet" "public" {
  filter {
    name = "tag:Name"
    values = ["${local.svc_nm}-sb-public"]
  }
}

# AWS EC2-01
resource "aws_instance" "dyheo-ec2-01" {
  ami = "${local.ami}"
  #associate_public_ip_address = true
  instance_type = "${local.instance_type}"
  key_name = "${local.pem_file}"
  vpc_security_group_ids = ["${data.aws_security_group.security-group.id}"]
  subnet_id = "${data.aws_subnet.public.id}"
  tags = {
    Name = "dyheo-ec2-01",
    Group = "${local.instance_group}",
    Creator = "${local.instance_creator}"
  }
}

# AWS EC2-02
resource "aws_instance" "dyheo-ec2-02" {
  ami = "${local.ami}"
  #associate_public_ip_address = true
  instance_type = "${local.instance_type}"
  key_name = "${local.pem_file}"
  vpc_security_group_ids = ["${data.aws_security_group.security-group.id}"]
  subnet_id = "${data.aws_subnet.public.id}"
  tags = {
    Name = "dyheo-ec2-02",
    Group = "${local.instance_group}",
    Creator = "${local.instance_creator}"
  }
}

## EC2 를 만들면 public ip 를 print 해준다.
output "ec2-01_ansible_host" {
  value = "${aws_instance.dyheo-ec2-01.public_ip}"
}

output "ec2-02_ansible_host" {
  value = "${aws_instance.dyheo-ec2-02.public_ip}"
}

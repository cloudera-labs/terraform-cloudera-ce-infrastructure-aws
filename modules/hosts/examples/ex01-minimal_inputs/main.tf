# Copyright 2025 Cloudera, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "aws" {
  region = var.region
  default_tags {
    tags = var.asset_tags
  }
}

# ------- VPC -------

resource "aws_vpc" "ex01" {
  cidr_block           = var.vpc_cidr
  tags                 = { Name = "${var.prefix}-vpc" }
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "ex01" {
  vpc_id = aws_vpc.ex01.id
  tags   = { Name = "${var.prefix}-igw" }
}

resource "aws_vpc_dhcp_options" "ex01" {
  domain_name         = "${var.prefix}.cldr.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = { Name = "${var.prefix}-vpc-dhcp-options" }
}

resource "aws_vpc_dhcp_options_association" "ex01" {
  vpc_id          = aws_vpc.ex01.id
  dhcp_options_id = aws_vpc_dhcp_options.ex01.id
}

# ------- Network Module -------
module "ex01_network" {
  source = "../../../network"

  region = var.region
  prefix = var.prefix
  vpc_id = aws_vpc.ex01.id

}

resource "aws_security_group" "ssh" {
  vpc_id      = aws_vpc.ex01.id
  name        = "${var.prefix}-sg-ssh"
  description = "SSH traffic [${var.prefix}]"
  tags        = { Name = "${var.prefix}-sg-ssh" }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ingress_ssh_cidrs)

  security_group_id = aws_security_group.ssh.id
  description       = "SSH traffic from ${each.value}"
  cidr_ipv4         = each.value
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = { Name = "${var.prefix}-ssh-${index(var.ingress_ssh_cidrs, each.value)}" }
}

# ------- Host Module -------
module "ex01_hosts" {
  source     = "../.."
  depends_on = [aws_key_pair.ex01, data.aws_ami.ex01]

  name          = "${var.prefix}-host"
  quantity      = 2
  image_id      = data.aws_ami.ex01.image_id
  instance_type = "t2.micro"
  subnet_ids    = module.ex01_network.public_subnets[*].id # Will use the first public subnet
  ssh_key_pair  = aws_key_pair.ex01.key_name
  security_groups = [
    module.ex01_network.intra_cluster_security_group.id,
    aws_security_group.ssh.id
  ]
  public_ip = true
}

# ------- AMI -------
locals {
  ami_owners = ["amazon"]
  ami_filters = {
    name         = ["al2023-ami-2023*"]
    architecture = ["x86_64"]
  }
}

data "aws_ami" "ex01" {
  owners      = local.ami_owners
  most_recent = true

  dynamic "filter" {
    for_each = local.ami_filters

    content {
      name   = filter.key
      values = filter.value
    }
  }
}

# ------- SSH -------

data "tls_public_key" "ex01" {
  private_key_openssh = file(var.ssh_private_key_file)
}

resource "aws_key_pair" "ex01" {
  key_name   = "${var.prefix}-key"
  public_key = trimspace(data.tls_public_key.ex01.public_key_openssh)
}


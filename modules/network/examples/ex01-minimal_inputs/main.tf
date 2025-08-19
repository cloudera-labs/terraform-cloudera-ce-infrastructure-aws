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

resource "aws_vpc" "base" {
  cidr_block           = var.vpc_cidr
  tags                 = { Name = "${var.prefix}-vpc" }
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "base" {
  vpc_id = aws_vpc.base.id
  tags   = { Name = "${var.prefix}-igw" }
}

resource "aws_vpc_dhcp_options" "base" {
  domain_name         = "${var.prefix}.cldr.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = { Name = "${var.prefix}-vpc-dhcp-options" }
}

resource "aws_vpc_dhcp_options_association" "base" {
  vpc_id          = aws_vpc.base.id
  dhcp_options_id = aws_vpc_dhcp_options.base.id
}

# ------- Network Module -------
module "ex01_network" {
  source = "../.."

  region = var.region
  prefix = var.prefix
  vpc_id = aws_vpc.base.id

}

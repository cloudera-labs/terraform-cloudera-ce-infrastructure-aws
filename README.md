# Terraform Modules for Cloudera on Premise Community Edition Infrastructure Creation on AWS

This repository contains a number of Terraform modules for creation of infrastructure resources for Cloudera on premise clusters on AWS. These modules support deployment of the Community Edition reference cluster.

## Modules

| Module name | Description |
| ----------- | ----------- |
| [network](modules/network/README.md) | Creates and manages AWS networking infrastructure with public/private subnets, NAT gateways, route tables, and security groups for Cloudera on premise deployments. |
| [hosts](modules/hosts/README.md) | Provisions and manages AWS EC2 instances with flexible configuration for compute resources, storage volumes, and networking designed for Cloudera on premise deployments. |

Each module contains Terraform resource configuration and example variable definition files.

# Terraform Module for AWS Hosts

The `hosts` module contains resource files to provision and manage AWS EC2 instances with flexible configuration options for compute resources, storage volumes, and networking. This module is designed for Cloudera on premise infrastructure deployments on AWS IaaS but can be used for any AWS EC2 instance provisioning needs.

## Key Features

- **Flexible Instance Provisioning**: Create single instances or multiple identical nodes with sequential naming
- **Custom Storage Configuration**: Attach and manage additional EBS volumes with configurable size, type, and mount points
- **Network Integration**: Place instances in specific subnets with optional public IP assignment
- **Security Management**: Apply security groups to control access to instances
- **Resource Tagging**: Add custom tags to all provisioned resources for better organization and cost management
- **IMDSv2 Support**: Automatic detection and configuration of IMDSv2 tokens based on AMI capabilities

## Usage

The [examples](./examples) directory has example of using this module:

* `ex01-minimal_inputs` demonstrates how this module can be used to create a number of EC2 instances. The [terraform-aws-network](../terraform-aws-network/README.md) module is also used as part of this example.

The sample `terraform.tfvars.sample` describes the required inputs for the example.

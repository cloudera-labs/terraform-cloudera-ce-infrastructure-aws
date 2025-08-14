# Terraform Module for AWS Network

The `network` module contains resource files for creating and managing AWS networking infrastructure required for Cloudera on premise deployments on AWS IaaS. This module simplifies the process of setting up secure, scalable network topologies with public and private subnets, NAT gateways, route tables, and security groups.

## Key Features

- **Flexible Subnet Configuration**: Create custom public and private subnets across multiple availability zones
- **Automatic NAT Gateway Setup**: Deploy NAT gateways in public subnets to provide internet access for private resources
- **Route Table Management**: Configure and associate route tables for both public and private subnets
- **Security Group Provisioning**: Create pre-configured security groups for intra-cluster communication and ACME TLS challenges
- **VPC Integration**: Works with existing VPCs to extend your current network architecture
- **Naming Consistency**: Enforces consistent naming conventions with customizable prefixes for all network resources

## Usage

The [examples](./examples) directory has example of using this module:

* `ex01-minimal_inputs` demonstrates how this module can be used to create the a network infrastructure on AWS.

The sample `terraform.tfvars.sample` describes the required inputs for the example.

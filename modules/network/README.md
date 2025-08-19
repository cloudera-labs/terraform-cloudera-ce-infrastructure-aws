<!-- BEGIN_TF_DOCS -->
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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.60.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.60.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.pvc_base_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.pvc_base_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.pvc_base_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.pvc_base_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.acme_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.pvc_base_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.pvc_base_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc_security_group_egress_rule.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.acme_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_availability_zones.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_internet_gateway.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway) | data source |
| [aws_vpc.pvc_base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Deployment prefix for all cloud-provider assets | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_nat_gateway_name"></a> [nat\_gateway\_name](#input\_nat\_gateway\_name) | NAT gateway name | `string` | `""` | no |
| <a name="input_private_route_table_name"></a> [private\_route\_table\_name](#input\_private\_route\_table\_name) | Private Route Table name prefix | `string` | `""` | no |
| <a name="input_private_subnet_name"></a> [private\_subnet\_name](#input\_private\_subnet\_name) | Private Subnet name prefix | `string` | `""` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of Private Subnet details (name, CIDR, AZ, add'l tags) | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>    az   = string<br/>    tags = map(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_public_route_table_name"></a> [public\_route\_table\_name](#input\_public\_route\_table\_name) | Public Route Table name prefix | `string` | `""` | no |
| <a name="input_public_subnet_name"></a> [public\_subnet\_name](#input\_public\_subnet\_name) | Public Subnet name prefix | `string` | `""` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of Public Subnet details (name, CIDR, AZ, add'l tags) | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>    az   = string<br/>    tags = map(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_acme_name"></a> [security\_group\_acme\_name](#input\_security\_group\_acme\_name) | Security Group for ACME Directory communication (e.g. Let's Encrypt) | `string` | `""` | no |
| <a name="input_security_group_intra_name"></a> [security\_group\_intra\_name](#input\_security\_group\_intra\_name) | Security Group for intra-cluster communication | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acme_tls_security_group"></a> [acme\_tls\_security\_group](#output\_acme\_tls\_security\_group) | ACME Directory traffic Security Group |
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | AWS Availability Zones |
| <a name="output_intra_cluster_security_group"></a> [intra\_cluster\_security\_group](#output\_intra\_cluster\_security\_group) | Intra-cluster traffic Security Group |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Cluster private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Cluster public subnets |
<!-- END_TF_DOCS -->
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

output "ssh_key_pair" {
  value = {
    name        = aws_key_pair.ex01.key_name
    public_key  = trimspace(data.tls_public_key.ex01.public_key_openssh)
    type        = aws_key_pair.ex01.key_type
    fingerprint = aws_key_pair.ex01.fingerprint
  }
  description = "SSH public key"
}

output "vpc" {
  value       = aws_vpc.ex01.id
  description = "AWS VPC"
}

output "nodes" {
  value = values(module.ex01_hosts)

  description = "Node information including IDs, names, private and public IPs"
}
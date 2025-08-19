# Copyright 2025 Cloudera, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {

  volumes = flatten([
    for idx in range(0, var.quantity) :
    [
      for node_vol in coalesce(var.volumes, []) :
      {
        node_index   = idx
        name         = aws_instance.pvc_base[idx].tags.Name
        az           = aws_instance.pvc_base[idx].availability_zone
        device       = node_vol.device_name
        mount        = node_vol.mount
        size         = node_vol.volume_size
        type         = node_vol.volume_type
        subnet_index = aws_instance.pvc_base[idx].subnet_id
      }
    ]
  ])
}

resource "aws_ebs_volume" "inventory" {
  for_each = { for idx, volume in local.volumes : idx => volume }

  availability_zone = each.value.az
  size              = each.value.size
  type              = each.value.type
  tags = {
    Name  = "${each.value.name}: ${each.value.device}"
    mount = each.value.mount
  }
  #encrypted ...
}

resource "aws_volume_attachment" "inventory" {
  for_each = { for idx, volume in local.volumes : idx => volume }

  device_name = each.value.device
  volume_id   = aws_ebs_volume.inventory[index(local.volumes, each.value)].id
  instance_id = aws_instance.pvc_base[each.value.node_index].id
}

locals {
  # Details for all attached volumes
  attached_volumes = [
    for idx, volume in local.volumes :
    {
      "vol_name" = aws_ebs_volume.inventory[index(local.volumes, volume)].tags["Name"]
      "vol_id"   = aws_volume_attachment.inventory[index(local.volumes, volume)].volume_id
      "instance" = aws_volume_attachment.inventory[index(local.volumes, volume)].instance_id
      "device"   = aws_volume_attachment.inventory[index(local.volumes, volume)].device_name
      "mount"    = aws_ebs_volume.inventory[index(local.volumes, volume)].tags["mount"]
    }
    if length(aws_ebs_volume.inventory) > 0
  ]

  # Attached volume details grouped by instance
  attached_volumes_by_instance = {
    for vol in local.attached_volumes :
    vol.instance =>
    {
      vol_name = vol.vol_name
      vol_id   = vol.vol_id
      device   = vol.device
      mount    = vol.mount
    }...
  }
}

terraform {
    required_providers {
      alicloud = {
        source = "aliyun/alicloud"
        version = "1.170.0"
      }
    }
  }
variable "name" {
  default = "lilecong"
}
resource "alicloud_security_group" "group" {
  name        = "lilecong"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}
resource "alicloud_vpc" "vpc" {
  vpc_name       = var.name
  cidr_block = "172.16.0.0/16"
}
resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  zone_id           = data.alicloud_zones.default.zones[0].id
  vswitch_name      = var.name
}
resource "alicloud_instance" "instance" {
  # cn-beijing
  availability_zone = "cn-beijing-a"
  security_groups   = alicloud_security_group.group.*.id

  # series III
  instance_type              = "ecs.t5-lc2m1.nano"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "test_foo_system_disk_name"
  system_disk_description    = "test_foo_system_disk_description"
  image_id                   = "centos_7_5_x64_20G_alibase_20211130.vhd"
  instance_name              = "lilecong"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out  = 10
}

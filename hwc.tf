terraform {
  cloud {
    organization = "bitfactory"

    workspaces {
      name = "ws1"
    }
  }
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.36.0"
    }
  }
}

provider "huaweicloud" {
  # Configuration options
}

data "huaweicloud_images_image" "test" {
  name        = "Ubuntu 22.04 server 64bit"
  most_recent = true
}

data "huaweicloud_compute_flavors" "flavors" {
  availability_zone = data.huaweicloud_availability_zones.test.names[0]
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_availability_zones" "test" {
    region = "ap-southeast-2"
}


data "huaweicloud_networking_secgroups" "test" {
  name = "vpc-dev-app"
}

data "huaweicloud_vpc_subnets" "test" {
  name = "subnet-dev-app"
}

resource "huaweicloud_compute_instance" "test" {
  name                = "tf_ecs-test1"
  description         = "terraform test"
  image_id            = "32d05143-726d-4903-9c2a-17f309cea38b"
  flavor_id           = data.huaweicloud_compute_flavors.flavors.ids[0]
  security_group_ids  = ["14db6826-5e90-47db-b9d8-bf94ad473238"]
  availability_zone = data.huaweicloud_availability_zones.test.names[0]

  network {
    uuid              = data.huaweicloud_vpc_subnets.test.subnets[0].id
  }

}
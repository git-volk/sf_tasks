terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.65.0"
    }
  }
}
provider "yandex" {
  token     = "t1.9euelZrOisnKzZnIjpWJk86amJuNi-3rnpWay5edlMqUnsadkMmRz5qaj57l8_cTHzlK-e8ddzZA_N3z91NNNkr57x13NkD8zef1656Vms7JxpuKlo_LnZnPzo6ZysiV7_zF656Vms7JxpuKlo_LnZnPzo6ZysiV.Fu6JNdpFf9yfw304ZycPX47TbMBrvSkv5ha-v04ckHEpKNq4AgMBBvbAVrMtQ4XeRqive9aAAoiop59bl_yCCg"
  cloud_id  = "b1g5ac343hcibse01ivo"
  folder_id = "b1gpfu97n5irqql8p7ft"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 1
}
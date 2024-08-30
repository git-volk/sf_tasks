terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.127.0"  # Укажите версию провайдера, если необходимо
    }
  }
}

provider "yandex" {
  token     = var.token         # из файла terraform.tfvars
  cloud_id  = var.cloud_id      # из файла terraform.tfvars
  folder_id = var.folder_id     # из файла terraform.tfvars
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "default" {
  name = "default-network"
}

resource "yandex_vpc_subnet" "default" {
  name           = "default-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.0.0.0/16"]
}

resource "yandex_compute_instance" "k8s_master" {
  name        = "k8s-master"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd87c0qpl9prjv5up7mc"  # ID образа Ubuntu 24.04
      size     = 40
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"    # ключ для подключения по SSH
  }
}

resource "yandex_compute_instance" "k8s_node" {
  name        = "k8s-node"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = "fd87c0qpl9prjv5up7mc"  # ID образа Ubuntu 24.04
      size     = 40
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"    # ключ для подключения по SSH
  }
}

resource "yandex_compute_instance" "srv" {
  name        = "srv"
  platform_id = "standard-v1"
  resources {
    cores  = 4
    memory = 16
  }
  boot_disk {
    initialize_params {
      image_id = "fd87c0qpl9prjv5up7mc"  # ID образа Ubuntu 24.04
      size     = 60
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"    # ключ для подключения по SSH
  }
}

# создание файла inventory.ini для Ansible
resource "null_resource" "generate_inventory" {
  provisioner "local-exec" {
    command = <<EOT
      echo "[k8s_master]" > inventory.ini
      echo "${yandex_compute_instance.k8s_master.network_interface.0.nat_ip_address} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini
      echo "" >> inventory.ini

      echo "[k8s_node]" >> inventory.ini
      echo "${yandex_compute_instance.k8s_node.network_interface.0.nat_ip_address} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini
      echo "" >> inventory.ini

      echo "[srv]" >> inventory.ini
      echo "${yandex_compute_instance.srv.network_interface.0.nat_ip_address} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa" >> inventory.ini
    EOT
  }

  depends_on = [
    yandex_compute_instance.k8s_master,
    yandex_compute_instance.k8s_node,
    yandex_compute_instance.srv
  ]
}
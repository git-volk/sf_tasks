data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}

resource "yandex_compute_instance" "vm-manager" {
  count    = var.managers
  name     = "ci-sockshop-docker-swarm-manager-${count.index}"
  hostname = "manager-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYmdZ14CssuSrqqIf1vR/+EHTOO61ChqrwS6vo/LhrcN90Hf3tH1yWBoQkmg57xSFiyrQMurd/numkt+EQNUT0D58pn/yFCSGnS5vQa9vHjDDL5ziNfVR6rIJ2NMHdNaww5YSQxbrA+4G2I4ZLPJn2xgoRIQFbb6yPLTeRhegeKHHrNt40McBP5MKNPfs49AQugWT9tJmgjWSMkxbqntfpWCfK6aBPHoKumyE+SSvN52Hn4kZjvj6giwE/meZ/mE3QxxJ/tubozwQf1iWGt1oCnNacpxssJf4eAuSiYV/UlYtHFs8urKwsWXjmmW3AIeE7KdG/O3BggCgApEVqRiKX root@zakhar-VirtualBox"
  }

}
resource "yandex_compute_instance" "vm-worker" {
  count    = var.workers
  name     = "ci-sockshop-docker-swarm-worker-${count.index}"
  hostname = "worker-${count.index}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
      size     = 15
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_credentials.user}:${file(var.ssh_credentials.pub_key)}"
  }

}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}


resource "yandex_compute_instance" "vmbuild" {
  name = "ycibuild"
  
  resources {
    cores  = 2
    memory = 2
  }  
  
  boot_disk {
    initialize_params {
      image_id = "fd81n0sfjm6d5nq6l05g"
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    nat       = true
  }
  
  scheduling_policy {
    preemptible = true
  }  

  metadata = {
    ssh-keys  = var.ubuntu_ssh_key
    user-data = "${file("./init_vmbuild.sh")}"
  }

}


resource "yandex_compute_instance" "vmrun" {
  name = "ycirun"
  
  resources {
    cores  = 2
    memory = 2
  }  
  
  boot_disk {
    initialize_params {
      image_id = "fd81n0sfjm6d5nq6l05g"
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_terraform.id
    nat       = true
  }
  
  scheduling_policy {
    preemptible = true
  }  

  metadata = {
    ssh-keys  = var.ubuntu_ssh_key
    user-data = "${file("./init_vmrun.sh")}"
  }

}


resource "yandex_vpc_network" "network_terraform" {
  name = "net_terraform"
}

resource "yandex_vpc_subnet" "subnet_terraform" {
  name           = "sub_terraform"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
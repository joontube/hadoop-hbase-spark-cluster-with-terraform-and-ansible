terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}


# Docker 이미지 빌드 (Dockerfile에서 생성)
resource "docker_image" "custom_ubuntu" {
  name = "ubuntu:ssh"  # 빌드 후 저장될 이미지 이름
  build {
    context    = "."   # 현재 디렉토리 사용
    dockerfile = "Dockerfile"
  }
}


# 공통 네트워크 생성 (고정 IP 할당을 위해 subnet 지정)
resource "docker_network" "hadoop_network" {
  name   = "hadoop_network"
  driver = "bridge"

  ipam_config {
    subnet = "172.18.0.0/16"
  }
}

# Ubuntu 22.04 컨테이너 생성 (고정 IP 설정)
resource "docker_container" "master1" {
  name  = "master1"
  image = docker_image.custom_ubuntu.image_id
  hostname = "master1"
  ports {
    internal = 2181
    external = 2181
    protocol = "tcp"
  }

  ports {
    internal = 7077
    external = 7077
    protocol = "tcp"
  }

  ports {
    internal = 8081
    external = 8081
    protocol = "tcp"
  }

  ports {
    internal = 8082
    external = 8082
    protocol = "tcp"
  }

  ports {
    internal = 8083
    external = 8083
    protocol = "tcp"
  }

  ports {
    internal = 16000
    external = 16000
    protocol = "tcp"
  }

  ports {
    internal = 16010
    external = 16010
    protocol = "tcp"
  }

  ports {
    internal = 16020
    external = 16020
    protocol = "tcp"
  }

  ports {
    internal = 33465
    external = 33465
    protocol = "tcp"
  }

  ports {
    internal = 4040
    external = 14040 # 호스트에서 매핑되는 외부 포트가 다름.
    protocol = "tcp"
  }

  command = ["/bin/bash", "-c", "/usr/sbin/sshd -D & sleep infinity"]

  networks_advanced {
    name         = docker_network.hadoop_network.name
    ipv4_address = "172.18.0.2"
  }
}

resource "docker_container" "worker1" {
  name  = "worker1"
  image = docker_image.custom_ubuntu.image_id
  command = ["/bin/bash", "-c", "/usr/sbin/sshd -D & sleep infinity"]
  hostname = "worker1"
  networks_advanced {
    name         = docker_network.hadoop_network.name
    ipv4_address = "172.18.0.3"
  }
}

resource "docker_container" "worker2" {
  name  = "worker2"
  image = docker_image.custom_ubuntu.image_id
  command = ["/bin/bash", "-c", "/usr/sbin/sshd -D & sleep infinity"]
  hostname = "worker2"
  networks_advanced {
    name         = docker_network.hadoop_network.name
    ipv4_address = "172.18.0.4"
  }
}


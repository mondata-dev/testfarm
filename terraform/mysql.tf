resource "docker_image" "mysql_5" {
  name = "mysql:5.7.29"
  keep_locally = true
}

locals {
  mysql_hostname = "${var.docker_prefix}-mysql"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql_5.latest
  name  = local.mysql_hostname
  hostname = local.mysql_hostname

  depends_on = [null_resource.volume_preparations]

  env = [
    "GOSU_VERSION=1.7",
    "MYSQL_DATABASE=${var.mysql_db_name}",
    "MYSQL_MAJOR=5.7",
    "MYSQL_PASSWORD=${var.mysql_password}",
    "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
    "MYSQL_USER=${var.mysql_user}",
    "MYSQL_VERSION=5.7.29-1debian9",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  ]

  # Enable this if you need development access to mysql
  # ports {
  #   internal = 3306
  #   external = 3306
  # }

  networks_advanced {
    name = docker_network.private_network.name
  }

  mounts {
    target = "/var/lib/mysql"
    source = "${local.volume_base_dir_full}/${local.mysql_hostname}-store"
    type = "bind"
  }
}

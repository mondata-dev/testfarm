resource "docker_image" "nginx" {
  name = "nginx:1.17.8"
  keep_locally = true
}

locals {
  reverse_proxy_hostname = "${var.docker_prefix}-nginx"
  reverse_proxy_conf_name = "${local.reverse_proxy_hostname}-conf"
  reverse_proxy_ssl_name = "${local.reverse_proxy_hostname}-ssl"
}

resource "docker_container" "reverse_proxy" {
  image = docker_image.nginx.latest
  name = local.reverse_proxy_hostname
  hostname = local.reverse_proxy_hostname

  depends_on = [
    null_resource.volume_preparations,
    docker_container.wordpress,
  ]

  env = [
    "NGINX_VERSION=1.17.8",
    "NJS_VERSION=0.3.8",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "PKG_RELEASE=1~buster",
  ]

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  mounts {
    target = "/etc/nginx"
    source = "${local.volume_base_dir_full}/${local.reverse_proxy_conf_name}"
    type = "bind"
  }

  mounts {
    target = "/etc/ssl/private"
    source = "${local.volume_base_dir_full}/${local.reverse_proxy_ssl_name}"
    type = "bind"
  }
}

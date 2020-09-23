##############
### Images ###
##############
resource "docker_image" "wordpress" {
  name = var.wordpress_instances[count.index].image
  keep_locally = true

  count = length(var.wordpress_instances)
}

#################
### Container ###
#################
resource "docker_container" "wordpress" {
  image = docker_image.wordpress[count.index].latest
  name = "${var.docker_prefix}-${var.wordpress_instances[count.index].name}"
  hostname = "${var.docker_prefix}-${var.wordpress_instances[count.index].name}"
  count = length(var.wordpress_instances)

  depends_on = [docker_container.mysql, null_resource.volume_preparations]

  env = [
    "WORDPRESS_DB_HOST=${local.mysql_hostname}:3306",
    "WORDPRESS_DB_USER=${var.mysql_user}",
    "WORDPRESS_DB_PASSWORD=${var.mysql_password}",
    "WORDPRESS_DB_NAME=${var.mysql_db_name}",
    "WORDPRESS_TABLE_PREFIX=${replace(var.wordpress_instances[count.index].name, "-", "_")}_",
    "WORDPRESS_DEBUG=1",
  ]

  working_dir = "/var/www/html"

  networks_advanced {
    name = docker_network.private_network.name
  }

  mounts {
    target = "/var/www/html"
    source = "${local.volume_base_dir_full}/${var.docker_prefix}-${var.wordpress_instances[count.index].name}-wwwroot"
    type = "bind"
  }
}

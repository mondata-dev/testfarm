variable "docker_prefix" {
  description = "Create wordpress instances with these names"
  type        = string
  default     = "testfarm"
}

variable "volume_base_dir" {
  type = string
  default = "/tmp/testfarm"
}

variable "wordpress_instances" {
  description = "Create wordpress instances with these names"
  type        = list(object({
    name = string,
    image = string,
  }))
  default = [
    {
      name = "wp-vanilla"
      image = "wordpress:5.3.2-php7.3"
    },
    {
      name = "wp-vanilla-wp49-php56"
      image = "wordpress:4.9.8-php5.6"
    },
  ]
}

variable "mysql_root_password" {
  type = string
  default = "secret"
}

variable "mysql_user" {
  type = string
  default = "wp"
}

variable "mysql_password" {
  type = string
  default = "secret"
}

variable "mysql_db_name" {
  type = string
  default = "wp"
}

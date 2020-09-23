################
### Provider ###
################
provider "docker" {
  # as no host is provided, localhost is implicitly assumed
}

###############
### Network ###
###############
resource "docker_network" "private_network" {
  name = "${var.docker_prefix}-network"
}

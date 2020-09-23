resource "random_string" "volume_base_dir_suffix" {
  length = 4
  special = false
}

locals {
  data_dir = "${path.cwd}/../data"
  volume_base_dir_full = "${var.volume_base_dir}-${random_string.volume_base_dir_suffix.result}"
}

resource "null_resource" "volume_preparations" {
  triggers = {
    volume_base_dir = local.volume_base_dir_full
  }

  provisioner "local-exec" {
    command = <<EOF
mkdir -p ${self.triggers.volume_base_dir} && \
  for f in ${local.data_dir}/*.tar.gz; do \
    sudo tar -xzf $f -C ${self.triggers.volume_base_dir} --same-owner; \
  done && \
  cp -r ${local.data_dir}/${local.reverse_proxy_conf_name} ${self.triggers.volume_base_dir}/ && \
  cp -r ${local.data_dir}/${local.reverse_proxy_ssl_name} ${self.triggers.volume_base_dir}/
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sudo rm -rf ${self.triggers.volume_base_dir}"
  }
}

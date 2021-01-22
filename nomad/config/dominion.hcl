data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

datacenter = "homelab"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = ["dominion.qkroode.nl:4647"]

  host_volume "bitwarden" {
    path = "/mnt/spaces/bitwarden"
    read_only = false
  }
}

vault {
  address = "http://dominion.qkroode.nl:8200"
  create_from_role = "nomad-cluster"
  enabled = true
  token = ""
}

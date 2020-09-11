data_dir             = "/var/lib/nomad"
disable_update_check = true
enable_syslog        = true

datacenter = "homelab"

server {
  enabled = false
}

client {
  enabled = true
  servers = ["dominion.qkroode.nl:4647"]
  }
}

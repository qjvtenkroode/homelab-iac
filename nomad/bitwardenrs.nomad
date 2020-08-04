# Author: Quincey
# Description: Bitwardenrs for selfhosted password management

job "bitwardenrs" {
    datacenters = ["homelab"]
    type = "service"

    group "bitwardenrs" {
        count = 1

        volume "bitwarden" {
            type = "host"
            read_only = false
            source = "bitwarden"
        }

        task "bitwardenrs" {
            driver = "docker"

            volume_mount {
                volume = "bitwarden"
                destination = "/data/"
                read_only = false
            }

            config {
                image = "bitwardenrs/server:latest"

                port_map {
                    http = 80
                }
            }

            resources {
                cpu = 200
                memory = 64

                network {
                    port "http" {
                        static = 8000
                    }
                }
            }

            service {
                name = "bitwardenrs"
                port = "http"

                check {
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}

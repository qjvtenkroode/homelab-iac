# Author: Quincey
# Description: Traefik as frontend proxy

job "traefik" {
    datacenters = ["homelab"]
    type = "service"

    group "traefik" {
        count = 1

        task "traefik" {
            driver = "docker"

            config {
                image = "traefik:v2.2"
                network_mode = "host"
                volumes = [
                    "local/traefik.toml:/etc/traefik/traefik.toml",
                ]
            }

            template {
                data = <<EOF
[entryPoints]
    [entryPoints.http]
    address = ":8080"
    [entryPoints.traefik]
    address = ":8081"

[api]
    dashboard = true
    insecure = true
EOF

                destination = "local/traefik.toml"
            }

            resources {
                cpu = 100
                memory = 128

                network {
                    mbits = 10

                    port "http" {
                        static = 8080
                    }

                    port "api" {
                        static = 8081
                    }
                }
            }
        }
    }
}

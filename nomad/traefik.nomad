# Author: Quincey
# Description: Treafik as frontend proxy for all exposed services within Nomad cluster

job "traefik" {
    datacenters = ["homelab"]
    type = "service"

    group "traefik" {
        count = 1

        task "traefik" {
            driver = "docker"

            config {
                image = "traefik:v2.3"

                port_map {
                    ui = 8080
                    http = 80
                    https = 443
                }

                args = [
                    "--api.insecure=true",
                    "--entrypoints.web.address=:80",
                    "--entrypoints.websecure.address=:443",
                    "--providers.consulcatalog",
                    "--providers.consulcatalog.endpoint.address=consul.service.consul:8500",
                    "--providers.consulcatalog.endpoint.datacenter=homelab",
                    "--providers.consulcatalog.exposedByDefault=false"
                ]
            }

            resources {
                cpu = 500
                memory = 512

                network {
                    mbits = 10

                    port "http" {
                        static = 80
                    }

                    port "https" {
                        static = 443
                    }

                    port "ui" {
                        static = 8080
                    }
                }
            }

            service {
                name = "traefik"
                port = "ui"
                tags = [
                    "traefik.enable=true",
                    "traefik.frontend.entryPoints=http,https"
                ]

                check {
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}

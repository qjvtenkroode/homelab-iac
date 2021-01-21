# Author: Quincey
# Description: Personal website

job "qkroode.nl" {
    datacenters = ["homelab"]
    type = "service"

    group "qkroode.nl" {
        count = 1

        task "qkroode.nl" {
            driver = "docker"

            config {
                image = "registry.service.consul:5000/homelab/qkroode.nl:0.79.0-e0e69fe"

                port_map {
                    http = 80
                }

                logging {
                    type = "splunk"
                    config {
                        splunk-token = "72584d49-5377-3544-4374-4c3674797950"
                        splunk-url = "cribl.service.consul:2400"
                    }
                }
            }

            resources {
                cpu = 100
                memory = 64

                network {
                    port "http" { }
                }
            }

            service {
                name = "qkroode-nl"
                port = "http"
                tags = [
                    "traefik.enable=true",
                    "treafik.frontend.entryPoints=http,https",
                    "treafik.http.middlewares.redirect-https.redirectScheme.scheme=http",
                    "treafik.http.middlewares.redirect-https.redirectScheme.permanent=true",
                    "traefik.http.routers.qkroode-nl-https.rule=Host(`qkroode.nl`)",
                    "traefik.http.routers.qkroode-nl-https.entrypoints=websecure",
                    "traefik.http.routers.qkroode-nl-https.tls=true",
                    "traefik.http.routers.qkroode-nl-https.tls.certresolver=letsencrypt",
                    "traefik.http.routers.qkroode-nl-https.service=qkroode-nl",
                    "traefik.http.routers.qkroode-nl-http.rule=Host(`qkroode.nl`)",
                    "traefik.http.routers.qkroode-nl-http.entrypoints=web",
                    "traefik.http.routers.qkroode-nl-http.middlewares=redirect-https",
                    "traefik.http.routers.qkroode-nl-http.service=qkroode-nl",
                    "traefik.http.services.qkroode-nl.loadbalancer.server.port=${NOMAD_HOST_PORT_http}"
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


















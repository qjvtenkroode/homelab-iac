# Author: Quincey
# Description: Splunk

job "jenkins" {
    datacenters = ["homelab"]
    type = "service"

    group "jenkins" {
        count = 1

        task "jenkins" {
            driver = "docker"

            config {
                image = "jenkins/jenkins:2.249.2-lts-alpine"

                port_map {
                    http = 8080
                }
            }

            resources {
                cpu = 512
                memory = 512

                network {
                    mbits = 10

                    port "http" {}
                }
            }

            service {
                name = "jenkins"
                port = "http"
                tags = [
                    "traefik.enable=true",
                    "traefik.frontend.entryPoints=http",
                    "traefik.http.routers.jenkins.rule=Host(`jenkins.qkroode.nl`)",
                    "traefik.http.routers.jenkins.entrypoints=web",
                    "traefik.http.routers.jenkins.service=jenkins",
                    "traefik.http.services.jenkins.loadbalancer.server.port=${NOMAD_HOST_PORT_http}"
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

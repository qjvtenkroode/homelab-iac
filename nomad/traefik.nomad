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
                    http = 80
                    https = 443
                    prometheus = 8082
                    ui = 8080
                }

                logging {
                    type = "splunk"
                    config {
                        splunk-token = "${TOKEN}"
                        splunk-url = "http://cribl.service.consul:2400"
                        splunk-format = "json",
                        splunk-source = "${NOMAD_TASK_NAME}"
                    }
                }
 
                args = [
                    "--accesslog=true",
                    "--api.insecure=true",
                    "--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=digitalocean",
                    "--certificatesresolvers.letsencrypt.acme.dnschallenge.delaybeforecheck=0",
                    "--certificatesresolvers.letsencrypt.acme.email=qjv.tenkroode@gmail.com",
                    "--certificatesresolvers.letsencrypt.acme.storage=acme.json",
                    "--entryPoints.metrics.address=:8082",
                    "--entryPoints.mqtt.address=:1883",
                    "--entryPoints.web.address=:80",
                    "--entryPoints.websecure.address=:443",
                    "--metrics.prometheus.entryPoint=metrics",
                    "--providers.consulcatalog",
                    "--providers.consulcatalog.endpoint.address=consul.service.consul:8500",
                    "--providers.consulcatalog.endpoint.datacenter=homelab",
                    "--providers.consulcatalog.exposedByDefault=false"
                ]
            }

            resources {
                cpu = 500
                memory = 512 network {
                    mbits = 10

                    port "http" {
                        static = 80
                    }

                    port "https" {
                        static = 443
                    }

                    port "mqtt" {
                        static = 1883
                    }

                    port "prometheus" {
                        static = 8082
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

            template {
                change_mode = "restart"
                destination = "local/values.env"
                env = true

                data = <<EOF
{{ with secret "secret/letsencrypt/digitalocean" }}
DO_AUTH_TOKEN = "{{ .Data.token }}"{{ end }}

{{ with secret "secret/cribl/docker_hec" }}
TOKEN = "{{ .Data.token }}"{{ end }}
EOF
            }

            vault {
                policies = ["homelab"]
            }
        }
    }
}

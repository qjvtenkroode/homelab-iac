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
                image = "bitwardenrs/server:1.16.3"

                port_map {
                    http = 80
                    websocket = 3012
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
            }
 
            env {
                DOMAIN = "https://warden.qkroode.nl"
                SIGNUPS_ALLOWED = false
                WEBSOCKET_ENABLED = true
            }

            resources {
                cpu = 200
                memory = 64

                network {
                    port "http" { }

                    port "websocket" { }
                }
            }

            service {
                name = "bitwardenrs"
                port = "http"
                tags = [
                    "traefik.enable=true",
                    "traefik.frontend.entryPoints=http,https",
                    "traefik.http.middlewares.redirect-https.redirectscheme.scheme=https",
                    "traefik.http.middlewares.redirect-https.redirectscheme.permanent=true",
                    "traefik.http.routers.bitwarden-ui-https.rule=Host(`warden.qkroode.nl`)",
                    "traefik.http.routers.bitwarden-ui-https.entrypoints=websecure",
                    "traefik.http.routers.bitwarden-ui-https.tls=true",
                    "traefik.http.routers.bitwarden-ui-https.tls.certresolver=letsencrypt",
                    "traefik.http.routers.bitwarden-ui-https.service=bitwarden-ui",
                    "traefik.http.routers.bitwarden-ui-http.rule=Host(`warden.qkroode.nl`)",
                    "traefik.http.routers.bitwarden-ui-http.entrypoints=web",
                    "traefik.http.routers.bitwarden-ui-http.middlewares=redirect-https",
                    "traefik.http.routers.bitwarden-ui-http.service=bitwarden-ui",
                    "traefik.http.services.bitwarden-ui.loadbalancer.server.port=${NOMAD_HOST_PORT_http}",
                    "traefik.http.routers.bitwarden-websocket-https.rule=Host(`warden.qkroode.nl`) && Path(`/notifications/hub`)",
                    "traefik.http.routers.bitwarden-websocket-https.entrypoints=websecure",
                    "traefik.http.routers.bitwarden-websocket-https.tls=true",
                    "traefik.http.routers.bitwarden-websocket-https.tls.certresolver=letsencrypt",
                    "traefik.http.routers.bitwarden-websocket-https.service=bitwarden-websocket",
                    "traefik.http.routers.bitwarden-websocket-http.rule=Host(`warden.qkroode.nl`) && Path(`/notifications/hub`)",
                    "traefik.http.routers.bitwarden-websocket-http.entrypoints=web",
                    "traefik.http.routers.bitwarden-websocket-http.middlewares=redirect-https",
                    "traefik.http.routers.bitwarden-websocket-http.service=bitwarden-websocket",
                    "traefik.http.services.bitwarden-websocket.loadbalancer.server.port=${NOMAD_HOST_PORT_websocket}"
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

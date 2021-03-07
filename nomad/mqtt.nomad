# Author: Quincey
# Description: Mosquitto mqtt broker for Shelly devices

job "mqtt" {
    datacenters = ["homelab"]
    type = "service"

    group "mosquitto" {
        count = 1

        task "mosquitto" {
            driver = "docker"
            
            config {
                image = "eclipse-mosquitto:1.6"

                port_map {
                    mqtt = 1883
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

            resources {
                cpu = 100
                memory = 128

                network {
                    port "mqtt" {}
                }
            }

            service {
                name = "mqtt"
                port = "mqtt"
                tags = [
                    "traefik.enable=true",
                    "treafik.frontend.entryPoints=mqtt",
                    "traefik.tcp.routers.mqtt.entrypoints=mqtt",
                    "traefik.tcp.routers.mqtt.rule=HostSNI(`*`)",
                    "traefik.tcp.routers.mqtt.service=mqtt",
                    "traefik.tcp.services.mqtt.loadbalancer.server.port=${NOMAD_HOST_PORT_mqtt}"
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

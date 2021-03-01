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
                image = "eclipse-mosquitto:latest"

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
                    mbits = 10

                    port "mqtt" {
                        static = 1883
                    }
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
 
            service {
                name = "mqtt"
                port = "mqtt"

                check {
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}

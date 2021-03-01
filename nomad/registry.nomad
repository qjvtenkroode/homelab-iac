# Author: Quincey
# Description: Private docker registry

job "registry" {
    datacenters = ["homelab"]
    type = "service"

    task "registry" {
        driver = "docker"
        config {
            image = "registry:latest"
            
            port_map {
                registry = 5000
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
            memory = 64

            network {
                port "registry" {
                    static = 5000
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
            name = "registry"
            port = "registry"

            check {
                type = "tcp"
                interval = "10s"
                timeout = "2s"
            }
        }
    }
}

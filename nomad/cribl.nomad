# Author: Quincey
# Description: Cribl observability pipeline

job "cribl" {
    datacenters = ["homelab"]
    type = "service"

    group "cribl" {
        count = 1

        task "cribl" {
            driver = "docker"

            config {
                image = "registry.service.consul:5000/homelab/cribl:2.4.2-295252e"
            }

            resources {
                cpu = 500
                memory = 1024

                network {
                    mbits = 10

                    port "criblui" {
                        static = 9000
                    }

                    port "pfsense" {
                        static = 2300
                    }

                    port "docker_hec" {
                        static = 2400
                    }
                }
            }

            service {
                name = "cribl"
                port = "criblui"

                check {
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}

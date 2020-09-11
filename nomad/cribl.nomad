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
                image = "cribl/cribl"

            }

            resources {
                cpu = 500
                memory = 1024

                network {
                    mbits = 10

                    port "criblui" {
                        static = 9000
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

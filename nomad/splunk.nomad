# Author: Quincey
# Description: Splunk

job "splunk" {
    datacenters = ["homelab"]
    type = "service"

    group "splunk" {
        count = 1

        task "splunk" {
            driver = "docker"

            env {
                SPLUNK_START_ARGS = "--accept-license",
                SPLUNK_PASSWORD = "1234567890"
            }

            config {
                image = "splunk/splunk:8.0.6"
            }

            resources {
                cpu = 1000
                memory = 1024

                network {
                    mbits = 10

                    port "splunk_web" {
                        static = 8000
                    },

                    port "splunk_mngt" {
                        static = 8089
                    },

                    port "forwarding" {
                        static = 9997
                    }
                }
            }

            service {
                name = "splunk"
                port = "splunk_web"

                check {
                    type = "tcp"
                    interval = "10s"
                    timeout = "2s"
                }
            }
        }
    }
}

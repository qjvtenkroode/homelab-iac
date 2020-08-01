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
                image ="eclipse-mosquitto:latest"
                #volumes = [
                #    "local/mosquitto.conf:/mosquitto/config/mosquitto.conf"
                #]
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
        }
    }
}

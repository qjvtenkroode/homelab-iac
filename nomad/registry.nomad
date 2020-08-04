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
    }
}

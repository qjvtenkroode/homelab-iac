# Infrastructure-as-Code for my homelab

## Status
Nomad tasks
| Taskfile                  | Custom Dockerfile? | Ready | Logging? | Notes                                                |
| ------------------------- | :----------------: | :---: | :------: | ---------------------------------------------------: |
| Registry                  | No                 | Yes   | Yes     | No custom image needed.                              |
| Cribl                     | Yes                | Yes   | TODO     | Basic image is done, pulls from another repository.  |
| Splunk                    | No                 | Yes   | TODO     | Custom image needed.                                 |
| Elastic Netflow Collector | No                 | No    | TODO     | Needs to be build.                                   | 
| Traeffik                  | No                 | Yes   | Yes     | Custom image needed, integrates with Consul.         |
| BitWardenRS               | No                 | Yes   | Yes     | Not sure about custom image.                         |
| MQTT                      | No                 | Yes   | Yes     | Custom image needed.                                 |
| qkroode.nl                | Yes                | Yes   | Yes     | Setup logging towards Cribl and then Splunk.         |

## TODO
 - Registry depends on Cribl ... fails with a clean environment.
 - MQTT service check Consul fails somehow.
 - Traefik fails to get certs with Letsencrypt somehow.

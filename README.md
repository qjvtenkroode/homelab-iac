# Infrastructure-as-Code for my homelab

## TODO
Nomad tasks
| Taskfile                  | Custom Dockerfile? | Ready | Logging? | Notes                                                |
| ------------------------- | :----------------: | :---: | :------: | ---------------------------------------------------: |
| Registry                  | No                 | Yes   | TODO     | No custom image needed.                              |
| Cribl                     | Yes                | Yes   | TODO     | Basic image is done, pulls from another repository.  |
| Splunk                    | No                 | Yes   | TODO     | Custom image needed.                                 |
| Elastic Netflow Collector | No                 | No    | TODO     | Needs to be build.                                   | 
| Traeffik                  | No                 | Yes   | TODO     | Custom image needed, integrates with Consul.         |
| BitWardenRS               | No                 | Yes   | TODO     | Not sure about custom image.                         |
| Jenkins                   | No                 | No    | TODO     | Custom image needed, configuration non-existent yet. |
| MQTT                      | No                 | Yes   | TODO     | Custom image needed.                                 |
| qkroode.nl                | Yes                | Yes   | TODO     | Setup logging towards Cribl and then Splunk.         |

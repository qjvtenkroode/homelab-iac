.PHONY: help deploy* plan*

help: ## This message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## Run a nomad plan for all jobs
plan: plan-registry plan-cribl plan-traefik plan-mqtt plan-bitwardenrs plan-traefik
	
plan-bitwardenrs: ## Run a nomad plan for Bitwardenrs
	nomad job plan nomad/bitwardenrs.nomad

plan-cribl: ## Run a nomad plan for Cribl
	nomad job plan nomad/cribl.nomad

plan-mqtt: ## Run a nomad plan for mqtt
	nomad job plan nomad/mqtt.nomad

plan-qkroode_nl: ## Run a nomad plan for qkroode.nl
	nomad job plan nomad/qkroode.nl.nomad

plan-registry: ## Run a nomad plan for registry
	nomad job plan nomad/registry.nomad

plan-traefik: ## Run a nomad plan for traefik
	nomad job plan nomad/traefik.nomad

## Deploys all jobs, except the custom docker registry, to the Nomad cluster
deploy: deploy-cribl deploy-traefik deploy-mqtt deploy-bitwardenrs deploy-qkroode_nl

deploy-bitwardenrs: ## Deploy a bitwardenrs job to the Nomad cluster
	nomad job run nomad/bitwardenrs.nomad

deploy-cribl: ## Deploy a Cribl job to the Nomad cluster
	nomad job run nomad/cribl.nomad

deploy-mqtt: ## Deploy a mqtt job to the Nomad cluster
	nomad job run nomad/mqtt.nomad

deploy-qkroode_nl: ## Deploy a qkroode.nl job to the Nomad cluster
	nomad job run nomad/qkroode.nl.nomad

deploy-registry: ## Deploy a Registry job to the Nomad cluster
	nomad job run nomad/registry.nomad

deploy-traefik: ## Deploy a traefik job to the Nomad cluster
	nomad job run nomad/traefik.nomad

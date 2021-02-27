.PHONY: help deploy

help: ## This message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

plan: ## Run a nomad plan for all jobs
	plan-cribl
	plan-qkroode_nl
	
plan-cribl: ## Run a nomad plan for Cribl
	nomad job plan nomad/cribl.nomad

plan-qkroode_nl: ## Run a nomad plan for qkroode.nl
	nomad job plan nomad/qkroode.nl.nomad

plan-registry: ## Run a nomad plan for registry
	nomad job plan nomad/registry.nomad

deploy: ## Deploys all jobs to the Nomad cluster
	deploy-cribl
	deploy-qkroode_nl

deploy-cribl: ## Deploy a Cribl job to the Nomad cluster
	nomad job run nomad/cribl.nomad

deploy-qkroode_nl: ## Deploy a qkroode.nl job to the Nomad cluster
	nomad job plan nomad/qkroode.nl.nomad

deploy-registry: ## Deploy a Registry job to the Nomad cluster
	nomad job run nomad/registry.nomad

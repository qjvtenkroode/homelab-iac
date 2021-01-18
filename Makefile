.PHONY: help deploy

help: ## This message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

plan: ## Run a nomad plan for all jobs
	nomad job plan nomad/cribl.nomad

deploy: ## Deploys all jobs to the Nomad cluster
	nomad job run nomad/cribl.nomad

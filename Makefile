# ------------------------------------------------------------
#  Makefile — Local Development Helpers
#  (Not included in action image; ignored via .dockerignore)
# ------------------------------------------------------------

IMAGE=hello-world-scratch-go-action

.PHONY: help fmt tidy build run act-test act-install clean

MAKEFILE_LIST ?= Makefile
# Default target
.DEFAULT_GOAL := help
help: ## Show this help message
	@echo ""
	@echo "Local development tools for the Hello World Scratch Go Action"
	@echo "(These commands are for local testing only — not used inside the action image)"
	@echo ""
	@echo "Available commands:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9._-]+:.*##/ {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

fmt: ## Run go fmt over the project
	go fmt ./...

tidy: ## Run go mod tidy
	go mod tidy

build: fmt tidy ## Format, tidy, and build Docker image
	docker build -t $(IMAGE) .

run: build ## Run the Docker container locally
	docker run --rm \
		-e HELLO_WORLD="The world of env" \
		-e HELLO_EXTRA="Extra env" \
		$(IMAGE) \
		under Test

act-test: ## Run integration test locally using act
	act -W .github/workflows/integration.yml

act-install-brew: ## Install act via Homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew install act

act-install-curl: ## Install act via curl, wget, tar, chmod, mv
	curl -s https://api.github.com/repos/nektos/act/releases/latest \
	| grep "browser_download_url.*linux_amd64.tar.gz" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -i -

	tar xzf act-*-linux_amd64.tar.gz
	chmod +x act
	sudo mv act /usr/local/bin/



clean: ## Remove the built Docker image
	docker rmi $(IMAGE) || true

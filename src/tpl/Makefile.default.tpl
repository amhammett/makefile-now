.PHONY: build deploy guard-% help install test build run

# system
guard-%: # ensure required vars are set
	@ if [ "${${*}}" = "" ]; then \
		echo "Variable $* not set. Specify via $*=<value>"; \
		exit 1; \
	fi

# tasks with double #'s will be displayed in help
help: ## this help text
	@echo 'Available targets'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# environment
install: ## install all the things
	@echo installing ...

# testing
test: ## test all the things
	@echo testing ...

# development
build: ## build all the things
	@echo building ...

run: ## run all the things
	@echo running ...

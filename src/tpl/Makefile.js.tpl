.PHONY: build deploy guard-% help install test build

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

# pathing
yarn_path := yarn

# environment
install: ## install all the things
	${yarn_path} install

# testing
test: ## test all the things
	npm run test

# development
build: ## build all the things
	npm run build

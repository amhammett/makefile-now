.PHONY: build deploy guard-% help run test

# system
guard-%: # ensure required vars are set
	@ if [ "${${*}}" = "" ]; then \
		echo "Variable $* not set. Specify via $*=<value>"; \
		exit 1; \
	fi

python_path := python3
project := default

# tasks
generate: ## generate a makefile
	@echo 'generating makefile in cwd'
	${python_path} src/make_file_now.py --project=${project} ${force}

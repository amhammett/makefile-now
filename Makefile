.PHONY: build deploy guard-% help install test build run

# system
guard-%: # ensure required vars are set
	@ if [ "${${*}}" = "" ]; then \
		echo "Variable $* not set. Specify via $*=<value>"; \
		exit 1; \
	fi

python_path := python3
project := default

# tasks | default
generate: ## generate a makefile
	@echo 'generating makefile in cwd'
	${python_path} src/generate.py --project=${project} ${force}

# tasks with double #'s will be displayed in help
help: ## this help text
	@echo 'Available targets'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ifeq ($(OS),Windows_NT)
    # untested
    python_path := $(shell where python3)
    venv_python_path := venv\Scripts\python
    venv_flake8_path := venv\Scripts\flake8
    venv_isort_path := venv\Scripts\isort
    venv_jsonlint_path := venv\Scripts\jsonlint
    venv_pip_path := venv\Scripts\pip
    venv_pytest_path := venv\Scripts\pytest
    venv_watchmedo_path := venv\Scripts\watchmedo
    virtualenv_path := python -m virtualenv
else
    python_path := $(shell which python3)
    venv_python_path := ./venv/bin/python
    venv_flake8_path := ${venv_python_path} -m flake8
    venv_isort_path := ./venv/bin/isort
    venv_jsonlint_path := ./venv/bin/jsonlint
    venv_pip_path := ./venv/bin/pip
    venv_pytest_path := ${venv_python_path} -m pytest
    venv_watchmedo_path := PYTHONPATH=./venv/lib/python3.7/site-packages ./venv/bin/watchmedo
    virtualenv_path := virtualenv
endif

# environment
venv: ## virtual environment
	$(virtualenv_path) venv --python=$(python_path)

install: venv ## install all the things
	$(venv_pip_path) install -r requirements.txt --no-warn-script-location

# testing
test: json-lint isort flake8 pytest ## test all the things

flake8:
	$(venv_flake8_path) src/

isort:
	$(venv_isort_path) --quiet --check-only --recursive src

json-lint:
	@ if [ -d data ]; then \
		python -m json.tool data/*.json >/dev/null ;\
	fi


pytest:
	$(venv_pytest_path) --cov=src/ --cov-branch tests --verbose --capture=no

# development
watch_pattern := *.py;*.txt
watch_command := make test || true && echo "---"

watch: ## watch file-system changes to trigger a command
	$(venv_watchmedo_path) shell-command --patterns="${watch_pattern}" --recursive --command="${watch_command}" .

build: guard-option ## build all the things
	$(venv_python_path) ./src/script.py --options=${guard-option}

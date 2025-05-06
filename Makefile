export COMPOSE := docker compose
export BUILDKIT_PROGRESS := plain

override COMPOSE_FILE := compose.develop.yaml
export COMPOSE_FILE

# This is used in the compose files:
export DL_VERSION := $(shell cat VERSION)

default:
	@echo ""
	@echo "make        # List available make targets"
	@echo "make setup  # Set up servers"
	@echo "make start  # Start servers"
	@echo "make stop   # Stop servers"
	@echo "make reset  # Stop and start servers"
	@echo "make empty  # Delete database backups (requires priviledges)"
	@echo "make logs   # Show backend processor logs (requires grep)"
	@echo "make peak   # Report peak database memory usage (requires grep)"
	@echo "make test   # Run tests (requires check-jsonschema, busybox, wget)"
	@echo "make tidy   # List violations of StrictYAML (requires yamllint)"
	@echo "make todo   # List inline TODOs in repo (requires grep)"
	@echo ""

setup:
	@mkdir -p backup

# These are temporary secrets for dev and test
	@printf "DB_PASS=password\nDL_PASS=password" > secrets.env

	@${COMPOSE} build

start:
	@${COMPOSE} --env-file .env --env-file secrets.env up -d

stop:
	@${COMPOSE} down

reset:
	@$(MAKE) stop --no-print-directory
	@$(MAKE) start --no-print-directory

empty:
	@rm -rf backup/metadatalake/*

logs:
	@${COMPOSE} logs backend --no-log-prefix | sed --unbuffered G | grep -E --color '^([^\s]*)\s|$$'

peak:
	@echo "Peak Memory Consumption Database Container:"
	@grep VmHWM /proc/$(shell ps ax | grep [c]om.arcadedb.server.ArcadeDBServer | cut -d' ' -f3)/status

test:
	@$(MAKE) -C tests

tidy:
	@yamllint .

todo:
	@grep --color --exclude-dir=.git -Rnw . -e "TODO"

export COMPOSE := docker compose

override COMPOSE_FILE := compose.develop.yaml
export COMPOSE_FILE

# This is used in the compose files:
export DL_VERSION := $(shell cat VERSION)

default:
	@echo ""
	@echo "make        # List available make targets"
	@echo "make setup  # Set up servers (builds development images)"
	@echo "make start  # Start servers"
	@echo "make stop   # Stop servers"
	@echo "make reset  # Stop and start servers"
	@echo "make build  # Build release images"
	@echo "make empty  # Delete database backups"
	@echo "make logs   # Show backend processor logs (requires grep)"
	@echo "make peak   # Report peak database memory usage (requires grep)"
	@echo "make test   # Run tests (requires check-jsonschema, busybox, wget)"
	@echo "make tidy   # List violations of StrictYAML (requires yamllint)"
	@echo "make todo   # List inline TODOs in repo (requires grep)"
	@echo ""
	@${COMPOSE} ls -q | grep dataasee -q && echo " DatAasee is running locally" || echo " DatAasee is NOT running locally"
	@echo ""

setup:
	@mkdir -p -m 766 backup

# These are temporary secrets for dev and test
	@printf "DB_PASS=password\nDL_PASS=password" > secrets.env

	@${COMPOSE} --progress=plain build database
	@${COMPOSE} --progress=plain build backend
	@${COMPOSE} --progress=plain build frontend

start:
	@${COMPOSE} --env-file .env --env-file secrets.env up -d

stop:
	@${COMPOSE} down

reset:
	@$(MAKE) stop --no-print-directory
	@$(MAKE) start --no-print-directory

build:
	@${COMPOSE} -f compose.package.yaml --progress=plain build

empty:
	@${COMPOSE} --env-file .env --env-file secrets.env run --rm database rm -rf /backup/metadatalake
	@${COMPOSE} down --volumes

logs:
	@${COMPOSE} logs backend --no-log-prefix | sed --unbuffered G | grep -E --color '^([^\s]*)\s|$$'

peak:
	@echo "Peak Memory Consumption Database Container:"
	@grep VmHWM /proc/$(shell ps ax | grep [c]om.arcadedb.server.ArcadeDBServer | xargs | cut -d' ' -f1)/status

test:
	@$(MAKE) -C tests

tidy:
	@yamllint .

todo:
	@grep --color --exclude-dir=.git -Rnw . -e "TODO"

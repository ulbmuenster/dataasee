export DRIVER := docker
export BUILDKIT_PROGRESS := "plain docker compose build"

# This is used in the compose files:
export DL_VERSION := $(shell cat VERSION)

default:
	@echo ""
	@echo "make        # List available make targets"
	@echo "make setup  # Set up servers"
	@echo "make start  # Start servers"
	@echo "make stop   # Stop servers (after attempting a backup)"
	@echo "make logs   # Show logs"
	@echo "make state  # Report container status (requires bash)"
	@echo "make watch  # Monitor container status (requires bash)"
	@echo "make peak   # Report peak database memory usage (requires pgrep)"
	@echo "make sbom   # Create per container SBOMs (requires syft)"
	@echo "make test   # Run HTTP API tests (requires check-jsonschema)"
	@echo "make tidy   # List violations of StrictYAML (requires yamllint)"
	@echo "make todo   # List inline TODOs in repo"
	@echo ""

setup:
	@mkdir -p backup
	@mkdir -p secrets

# These are temporary secrets for dev and test
	@echo -n 'password' > secrets/db_pass
	@echo -n 'password' > secrets/dl_pass

	${DRIVER}-compose -f compose.develop.yaml build

start:
	@${DRIVER}-compose -f compose.develop.yaml up -d

stop:
	@${DRIVER}-compose -f compose.develop.yaml down

state:
	@bash -c "paste -d '' <(${DRIVER} stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t') <(${DRIVER} ps --format 'table {{.Size}}\t{{.Status}}\t{{.Names}}')"

watch:
	@watch -n1 -x make -s state

peak:
	@grep VmPeak /proc/$(shell pgrep -f com.arcadedb.server.ArcadeDBServer)/status

logs:
	@${DRIVER}-compose logs backend

todo:
	@grep --color --exclude-dir=.git -Rnw . -e "TODO"

tidy:
	@yamllint .

sbom:
	syft localhost.localhost/dataasee/database:${DL_VERSION} --scope all-layers -o spdx-json > dataasee-database.spdx
	syft localhost.localhost/dataasee/backend:${DL_VERSION} --scope all-layers -o spdx-json > dataasee-backend.spdx
	syft localhost.localhost/dataasee/frontend:${DL_VERSION} --scope all-layers -o spdx-json > dataasee-frontend.spdx

plantuml:
	docker run -d --name plantuml -p 8080:8080 --rm plantuml/plantuml-server:jetty

test:
	@make -C tests

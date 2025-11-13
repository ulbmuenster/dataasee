![DatAasee Logo](assets/dataasee-logo.png) DatAasee (0.5)
=========================================================

DatAasee centralizes and interlinks distributed library/research metadata into an API‑first union catalog.

![DatAasee schematic](docs/images/dataasee.gif)

## A Metadata-Lake for Libraries

### Repository: [github.com/ulbmuenster/dataasee](https://github.com/ulbmuenster/dataasee) (nb [sources backup](https://doi.org/10.5281/zenodo.13734194))
### Maintainer: [Christian Himpe](https://github.com/gramian) (at [University and State Library of Münster](https://github.com/ulbmuenster))
### Licenses: [MIT](LICENSE) (add. [CC-BY](https://creativecommons.org/licenses/by/4.0/) for [openapi.yaml](api/openapi.yaml))
### Function: Metadata-Lake, Metadata Catalog, Metadata Aggregator, Union Catalog
### Audience: University Libraries, Research Libraries, Academic Libraries, Scientific Libraries

## Documentation

* [Dependencies Overview](docs/deps.md)
* [Software Documentation](docs/docs.md)
* [Architecture Documentation](docs/arc42.md)
* [Database Schema](docs/schema.md)
* [OpenAPI Schema](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/ulbmuenster/dataasee/refs/heads/main/api/openapi.yaml) (Swagger UI)
* [`DatAasee`: A Metadata-Lake as Metadata Catalog for a Virtual Data-Lake](https://arxiv.org/abs/2409.05512) (Companion Paper, Open Access)

## Getting Started (Deployment)

**Quick Start** (Prepare a dedicated directory, inside run:)

```shell
$ wget https://raw.githubusercontent.com/ulbmuenster/dataasee/0.5/compose.yaml
$ mkdir -p -m 766 backup
$  DL_PASS=password1 DB_PASS=password2 docker compose up
```

**Web:** http://localhost:8000 (**API:** http://localhost:8343/api/v1/ )

* Depends on `docker compose` (and compatible to `docker` and `podman`)
* To deploy, no need to clone, just use the [`compose.yaml`](compose.yaml) file.
* See the [Deploy Documentation](docs/docs.md#deploy) for details.

## Tech Stack Canvas

* **Setting:** Many distributed data and metadata sources
* **Goals:**
    * Centralize metadata
    * Interlinked metadata catalog
    * Super-index for bibliographic and research data
* **Features:**
    * Interact through HTTP-API (JSON)
    * Search by filter, full-text, source, doi
    * Custom query via: `SQL`, `Gremlin`, `Cypher`, `MQL`, `GraphQL`
* **Frontend:** [Lowdefy](https://www.lowdefy.com) (Optional)
* **Backend:** [Connect](https://docs.redpanda.com/redpanda-connect/about/) (fmr. Benthos)
* **Data Storage:** [ArcadeDB](https://arcadedb.com) (Graph Database)
* **Infrastructure:** [Compose](https://compose-spec.io) (via [Docker](https://www.docker.com) or [Podman](https://podman.io))
* **Deployment:** via [Harbor](https://harbor.uni-muenster.de) (at Uni Münster)
* **Monitoring:** Container Logs (local logging driver)
* **Integrations:**
    * **Protocols:** `OAI-PMH` (HTTP), `S3` (HTTP), `GET` (HTTP), `DatAasee` (HTTP)
    * **Encodings:** `XML` (Plain-Text)
    * **Formats:** `DataCite` (XML), `DC` (XML), `LIDO` (XML), `MARC` (XML), `MODS` (XML)
* **Exports:** `DataCite` (JSON), `BibJSON` (JSON)
* **Security:** Privileged endpoints (CQRS)
* **Testing:** [check-jsonschema](https://check-jsonschema.readthedocs.io/en/stable/)
* **Development:** [Github](https://github.com/ulbmuenster/dataasee)

## Default Ports

* `8343` DatAasee API
* `8000` Web Frontend
* `2480` Database API (Development Container Images Only)
* `9999` Database JMX (Development Container Images Only)

## API Cheat Sheet

* `GET`  [`api/v1/api`](docs/docs.md#api-endpoint)           Returns API specification and schemas.
* `GET`  [`api/v1/ready`](docs/docs.md#ready-endpoint)       Returns service readiness.
* `GET`  [`api/v1/metadata`](docs/docs.md#metadata-endpoint) **Returns queried metadata records.**
* `GET`  [`api/v1/sources`](docs/docs.md#sources-endpoint)   Returns ingested metadata sources.
* `GET`  [`api/v1/schema`](docs/docs.md#schema-endpoint)     Returns database schema.
* `GET`  [`api/v1/enums`](docs/docs.md#enums-endpoint)       Returns enumerated attributes.
* `GET`  [`api/v1/stats`](docs/docs.md#stats-endpoint)       Returns metadata record statistics.
* `POST` [`api/v1/backup`](docs/docs.md#backup-endpoint)     Triggers database backup.
* `POST` [`api/v1/ingest`](docs/docs.md#ingest-endpoint)     Triggers async ingest of metadata.
* `POST` [`api/v1/insert`](docs/docs.md#insert-endpoint)     Inserts single metadata record.
* `POST` [`api/v1/health`](docs/docs.md#health-endpoint)     Probes and returns service liveness.

## Repository Contents

* `api/`       API definition and message schemas
* `assets/`    Logos and style definition
* `backend/`   Processor pipeline and component definitions
* `container/` Dockerfiles
* `database/`  Database initialization, schemas and enumerated data
* `docs/`      Documentation of software, data and architecture
* `frontend/`  Prototype frontend definition
* `tests/`     Test definitions and data

## Getting Started (Development)

* Available `make` targets:
    * `make setup` Build server images (builds development images)
    * `make start` Start servers
    * `make stop`  Stop servers
    * `make reset` Stop and start servers
    * `make build` Build release images (pass `REGISTRY=` to set container image registry)
    * `make empty` Delete database backups
    * `make logs`  Show logs (requires `grep`)
    * `make peak`  Report peak database memory usage (requires `grep`)
    * `make test`  Run tests (requires `check-jsonschema`, `busybox`, `wget`)
    * `make tidy`  List violations of StrictYAML (requires `yamllint`)
    * `make todo`  List inline TODOs in repo (requires `grep`)
* Custom `make` variable: [`COMPOSE`](docs/docs.md#compose-setup) (set Compose implementation)

## Contributors

* [See here](CONTRIBUTORS.md)

## tl;dr

**DatAasee is centralized Metasearch for distributed Metadata.**

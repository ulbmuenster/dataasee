![DatAasee Logo](assets/dataasee-logo.png) DatAasee (0.9)
=========================================================

**DatAasee** centralizes and interlinks distributed library / research metadata into an API‑first union catalog.

![DatAasee data flow schematic](docs/images/dataasee.gif)

## A Metadata-Lake for Libraries

### Repository: [github.com/ulbmuenster/dataasee](https://github.com/ulbmuenster/dataasee) (NB [sources backup](https://doi.org/10.5281/zenodo.13734194))
### Maintainer: [Christian Himpe](https://github.com/gramian) (at [University and State Library of Münster](https://github.com/ulbmuenster))
### Licenses: [MIT](LICENSE) (add. [CC-BY](https://creativecommons.org/licenses/by/4.0/) for [openapi.yaml](api/openapi.yaml))
### Function: Metadata-Lake, Metadata Catalog, Metadata Aggregator, Union Catalog
### Audience: University Libraries, Research Libraries, Academic Libraries, Scientific Libraries

**DatAasee** is currently in pilot stage and not production-ready yet.

## Documentation

* [Dependencies Overview](docs/deps.md)
* [Software Documentation](docs/docs.md)
* [Architecture Documentation](docs/arc42.md)
* [Database Schema](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/ulbmuenster/dataasee/refs/heads/main/docs/schema.md) (YASQL)
* [OpenAPI Schema](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/ulbmuenster/dataasee/refs/heads/main/api/openapi.yaml) (Swagger UI)
* [`DatAasee`: A Metadata-Lake as Metadata Catalog for a Virtual Data-Lake](https://arxiv.org/abs/2409.05512) (Companion Paper, Open Access)

## Getting Started (Test Deployment)

**Quick Start** (Prepare a dedicated directory, inside run:)

```shell
$ wget https://raw.githubusercontent.com/ulbmuenster/dataasee/0.9/compose.yaml
```

```shell
$ mkdir -p -m 777 backup
```

```shell
$  DL_PASS=password1 DB_PASS=password2 docker compose up
```

The `DL_PASS` environment variable passes the password for the `admin` user of
DatAasee which is required for the `POST` HTTP-API endpoints. The `DB_PASS`
environment variable passes the database `root` password used by the back-end.

**Web:** http://localhost:8000 (**API:** http://localhost:8343/api/v1/ )

* Depends on `docker compose` (>=2.37), and is compatible with `docker` and `podman`.
* To deploy, no need to clone, just use the [`compose.yaml`](compose.yaml) file.
* See the [Deploy Documentation](docs/docs.md#deploy) for details.

## API Cheat Sheet

* `GET`  [`api/v1/api`](docs/docs.md#api-endpoint)           Returns API specification and schemas.
* `GET`  [`api/v1/ready`](docs/docs.md#ready-endpoint)       Returns service readiness.
* `GET`  [`api/v1/schema`](docs/docs.md#schema-endpoint)     Returns database schema.
* `GET`  [`api/v1/metadata`](docs/docs.md#metadata-endpoint) **Returns metadata records.**
* `GET`  [`api/v1/database`](docs/docs.md#database-endpoint) Returns metadata queries.
* `POST` [`api/v1/health`](docs/docs.md#health-endpoint)     Returns service liveness.
* `POST` [`api/v1/ingest`](docs/docs.md#ingest-endpoint)     Triggers async ingest of metadata.

## Tech Stack Canvas

* **Setting:** Many distributed data and metadata sources
* **Goals:**
    * Centralize metadata
    * Interlinked metadata catalog
    * Super-index for bibliographic and research data
* **Features:**
    * Interact through HTTP API (`JSON`)
    * Search by filter/facet, full-text, ingest-source, DOI
    * Custom queries via: `SQL`, `OpenCypher`, `MQL`, `GraphQL`, `Redis`
* **Frontend:** [Lowdefy](https://www.lowdefy.com) (Optional)
* **Backend:** [Connect](https://docs.redpanda.com/redpanda-connect/about/) (formerly _Benthos_)
* **Data Storage:** [ArcadeDB](https://arcadedb.com) (Graph Database)
* **Infrastructure:** [Compose](https://compose-spec.io) (via [Docker](https://www.docker.com) or [Podman](https://podman.io))
* **Deployment:** (Public) Container Images from [Harbor](https://harbor.uni-muenster.de) (at _Uni Münster_)
* **Monitoring:** Container Logs (local logging driver)
* **Integrations:**
    * **Protocols:** `OAI-PMH` (HTTP), `S3` (HTTP), `GET` (HTTP), `DatAasee` (HTTP)
    * **Encodings:** `XML` (Plain-Text)
    * **Formats:** `DataCite` (XML), `DC` (XML), `LIDO` (XML), `MARC` (XML), `MODS` (XML)
* **Exports:** `DataCite` (JSON), `BibJSON` (JSON)
* **Security:** Privileged endpoints
* **Testing:** [check-jsonschema](https://check-jsonschema.readthedocs.io/en/stable/)
* **Development:** [Github](https://github.com/ulbmuenster/dataasee)

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

**Local Development** (After a `git clone`)

* Available `make` targets:
    * `make setup` Build development server container images
    * `make start` Start servers
    * `make stop`  Stop servers
    * `make reset` Stop and start servers
    * `make build` Build release container images (pass `REGISTRY=` to set registry)
    * `make empty` Delete database backups
    * `make logs`  Show backend processor logs (requires `grep`)
    * `make peak`  Report peak database memory usage (requires `grep`)
    * `make test`  Run tests (requires `check-jsonschema`, `busybox`, `wget`)
    * `make tidy`  List violations of StrictYAML (requires `yamllint`)
    * `make todo`  List inline TODOs in repo (requires `grep`)
* Custom `make` variable: [`COMPOSE`](docs/docs.md#compose-setup) (set Compose implementation)
* Open the [development frontend](index.html) in your browser for manual testing of the backend

## Contributors

* [See here](CONTRIBUTORS.md)

## tl;dr

**DatAasee provides centralized Metasearch for distributed Metadata.**

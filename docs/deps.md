# Dependencies Overview

| Name             | Version | License    | Source                                                | Function             | Comment
|:-----------------|:--------|:-----------|:------------------------------------------------------|:---------------------|:--------
| Docker Compose   | 2.37.1  | Apache-2.0 | https://docs.docker.com/compose/                      | Orchestrator         | Needed on host system
| Docker           | 27.5.1  | Apache-2.0 | https://docker.com                                    | Container Engine     | Alternatively: Podman
||||||
| ArcadeDB         | 26.4.2  | Apache-2.0 | https://arcadedb.com                                  | Database Server      | Built into container image
| Benthos          | 4.72.0  | MIT        | https://github.com/redpanda-data/benthos              | Backend & API Server | Built into container image
| Lowdefy          | 4.7.3   | Apache-2.0 | https://lowdefy.com                                   | Prototype Frontend   | Built into container image
||||||
| Make             | 4.3     | GPL-3.0    | https://www.gnu.org/software/make                     | Build System         | Development only
| grep             | 3.11    | GPL-3.0    | https://www.gnu.org/software/grep/                    | Output Parsing       | Development only
| yamllint         | 1.33.0  | GPL-3.0    | https://github.com/adrienverge/yamllint               | Source Linter        | Development only
| check-jsonschema | 0.33.0  | Apache-2.0 | https://github.com/python-jsonschema/check-jsonschema | API Testing          | Development only

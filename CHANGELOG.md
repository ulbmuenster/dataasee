# Changelog

## Version 0.5 (2025-11-13)

Advanced development release

* **UPDATED** ArcadeDB to 25.10.1
* **UPDATED** Benthos to 4.60.0
* **UPDATED** Lowdefy to 4.5.2
* **ADDED** `doi` filter to `metadata` endpoint
* **ADDED** export-`format` option to `metadata` endpoint
* **ADDED** `datacite` export format
* **ADDED** `bibjson` export format
* **ADDED** `GraphQL` query example
* **ADDED** DOI search to frontend
* **ADDED** edge (relation) type `isDescribedBy`
* **ADDED** test data to `metadata` endpoint (`id=dataasee`)
* **ADDED** frontend busy check
* **ADDED** selective harvesting option for OAI-PMH
* **ADDED** source rights field for ingest
* **CHANGED** rename `attributes` endpoint to `enums`
* **CHANGED** `ingest` endpoint behavior for empty bodies
* **CHANGED** `ingest` endpoint required fields
* **CHANGED** endpoint types
* **CHANGED** `metadata` result order to no sorting by default
* **CHANGED** `source` property to link
* **CHANGED** default ports
* **IMPROVED** API routing
* **IMPROVED** normalizer script
* **IMPROVED** interconnect script and its performance
* **IMPROVED** enumerations in schema
* **IMPROVED** `health` endpoint
* **IMPROVED** progress logging
* **IMPROVED** format parsers
* **IMPROVED** API developer experience
* **IMPROVED** frontend user experience
* **IMPROVED** deployment documentation
* **IMPROVED** sources endpoint
* **REMOVED** Prometheus endpoints (Docker logs suffice)
* **REMOVED** `message` property from schema (included into `description`)
* **FIXED** ingest via S3
* **FIXED** authentication challenge (found via wget2)
* **FIXED** duplicate index entries and index compaction
* **FIXED** many bugs and security concerns

## Version 0.3 (2025-05-06)

Enhanced development release

* **UPDATED** ArcadeDB to 25.4.1
* **UPDATED** Benthos to 4.50.0
* **UPDATED** Lowdefy to 4.4.0
* **ADDED** ingest protocols: `GET`, `dataasee`
* **ADDED** ingest format: `LIDO`
* **ADDED** `sources` endpoint
* **ADDED** `source` filter
* **ADDED** metadata format filter
* **ADDED** conforming paging links in results responses
* **ADDED** record lists in frontend
* **ADDED** record DOI to results
* **CHANGED** schema: use OpenWEMI
* **CHANGED** metadata endpoint paging now via `page` instead of `skip`
* **CHANGED** database schema
* **CHANGED** secrets management
* **CHANGED** ingest busy test
* **IMPROVED** metadata quality test
* **IMPROVED** interconnect script
* **IMPROVED** format parsers
* **IMPROVED** database queries
* **IMPROVED** database preloading
* **IMPROVED** database response processing
* **IMPROVED** compose deployment configuration
* **REMOVED** support for `podman-compose` (use `docker compose` via podman)
* **FIXED** many bugs and security concerns

## Version 0.2 (2024-09-10)

First public development release

* **UPDATED** ArcadeDB to 24.6.1
* **UPDATED** Benthos to 4.36.0
* **UPDATED** Lowdefy to 4.3.0
* **ADDED** ingest protocol: `S3`
* **ADDED** ingest formats: `DataCite`, `MARC`
* **ADDED** compatibility: `kubernetes` (via `kompose`)
* **ADDED** API testing using JSON-Schema
* **IMPROVED** endpoint processing
* **IMPROVED** endpoint error handling
* **IMPROVED** API semantics
* **IMPROVED** interconnect script
* **IMPROVED** frontend robustness
* **IMPROVED** overall documentation
* **CHANGED** native schema
* **CHANGED** API interface
* **FIXED** many bugs and security concerns

## Version 0.1 (2024-01-18)

Initial internal development release

* **ADDED** ingest protocols: `OAI-PMH`
* **ADDED** ingest formats: `MODS`, `DC`
* **ADDED** query languages: `SQL`, `Gremlin`, `Cypher`, `MQL`, `GraphQL`
* **ADDED** compatibility: `docker-compose`, `podman-compose`

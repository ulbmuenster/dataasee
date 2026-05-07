# Changelog

## Version 0.9 (2026-05-07)

Pilot release

* **UPDATED** ArcadeDB to 26.4.2
* **UPDATED** Benthos to 4.72.0
* **UPDATED** Lowdefy to 4.7.3
* **ADDED** `prop` parameter to `schema` endpoint to select single property
* **ADDED** static frontend for local testing (`index.html`)
* **ADDED** CORS header to backend server
* **ADDED** facets to schema
* **ADDED** facets to frontends
* **ADDED** `redis` query language
* **ADDED** allow URL encoded form as `/ingest` request body
* **ADDED** `/database` endpoint for metadata queries
* **ADDED** number of records to health report
* **ADDED** ingest and interconnect status to health report
* **ADDED** sample proxy configuration (`compose.proxy.yaml`)
* **ADDED** environment variable `DL_SAFE` to disable `/database` endpoint
* **CHANGED** record identifier hash from `xxhash64` to `sha256` and added `ni:` prefix
* **CHANGED** test record id from `dataasee` to `ni:dataasee`
* **CHANGED** rename `externalItems` to `relatedItems`
* **CHANGED** rename `metadataFormat` to `rawFormat`
* **CHANGED** make `backup` endpoint async
* **CHANGED** `schema` endpoint (properties provide enumerations and facets)
* **CHANGED** property naming from `name` to `title`
* **CHANGED** edge property names from `relations/.*` to `@.*`
* **CHANGED** `name` and `data` contents for `identifiers` and `synonyms` items
* **CHANGED** `cypher` query language name to `opencypher`
* **CHANGED** maximum incoming API payload to 12KiB
* **CHANGED** `/schema` endpoint response
* **CHANGED** `/metadata` endpoint response for edge properties and remove query mode
* **CHANGED** make paging one-based instead of zero-based
* **CHANGED** `keywords` property to list of string
* **CHANGED** paging for source listings to cursor-based
* **CHANGED** `rawChecksum` hash from `md5` to `sha256` and added `sha256:` prefix
* **IMPROVED** raw format by consistent labels
* **IMPROVED** `health` endpoint (simpler response without `CHECK DATABASE`)
* **IMPROVED** interconnect script
* **IMPROVED** full-text search
* **REMOVED** `insert` endpoint (replaced by `ingest` via `GET`)
* **REMOVED** `enums` endpoint (enumerations and facets via `schema` endpoint)
* **REMOVED** `sources` endpoint (sources via `schema` endpoint)
* **REMOVED** `synonyms`, `relations`, `relatedItems` from enums
* **REMOVED** `gremlin` query language
* **REMOVED** backup on shutdown
* **REMOVED** `/stats` endpoint (is now custom query in frontend)
* **REMOVED** `numberViews` property
* **REMOVED** `/backup` endpoint (is not needed anymore due to static data)
* **FIXED** many bugs and security concerns

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

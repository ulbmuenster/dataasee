HOST=localhost

POST=--post-data
FILE=--post-file

AUTH:=--user=admin --password=$(shell . ../secrets.env; echo $$DL_PASS)
NOAU=--user= --password=
UNAU=--user=admin --password=xfail

RUN := echo && $(MAKE) --no-print-directory

# Test JSON file on JSON schema
define test_schemafile
	@echo $(strip $2)
	@check-jsonschema --schemafile $1 $2
endef

# Test endpoint response for HTTP status and response on three JSON schemas
define test_endpoint
	@echo $(strip $5)
	@TMP=$$(mktemp) ;\
	trap 'rm -f $$TMP' EXIT ;\
	HTTP=$$(wget --content-on-error -qSO $$TMP $6 $7 http://${HOST}:8343/api/v1$(strip $5) 2>&1 | grep HTTP | tail -1 | cut -d' ' -f4) ;\
	check-jsonschema --schemafile $2 $$TMP ; RET1=$$? ;\
	check-jsonschema --schemafile $3 $$TMP ; RET2=$$? ;\
	check-jsonschema --schemafile $4 $$TMP ; RET3=$$? ;\
	rm $$TMP ;\
	test $$HTTP -eq $1 && test $$RET1 -eq 0 && test $$RET2 -eq 0 && test $$RET3 -eq 0
endef

# Wait for ingest to finish
define wait_ingest
	@until wget -qO- http://${HOST}:8343/api/v1/ingest ${POST}='' ${AUTH} | grep -q '"started":false' ; do echo -n "." && sleep 1; done
endef

.PHONY: test

test:
	@echo && echo "SCHEMA TESTS"

	@$(RUN) test_openapi

	@$(RUN) test_params

	@$(RUN) test_request

	@$(RUN) test_response

	@echo && echo "SYSTEM TESTS (service must have been started)"

	@$(RUN) test_unknown

	@$(RUN) test_ready

	@$(RUN) test_api

	@$(RUN) test_schema

	@$(RUN) test_metadata

	@$(RUN) test_database

	@$(RUN) test_ingest

	@$(RUN) test_health

	@echo && echo "INGEST TESTS (via get)"

	@busybox httpd -h datasets -p 0.0.0.0:9876 || httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1

	@$(RUN) test_datacite

	@$(RUN) test_dc

	@$(RUN) test_mods

	@$(RUN) test_marc

	@$(RUN) test_lido

	@$(RUN) test_form

	@$(RUN) test_data

	@echo && echo "ALL TESTS PASSED"

	@echo

test_openapi:
	$(call test_schemafile, schema/openapi.json, ../api/openapi.yaml)

test_params:
	$(call test_schemafile, schema/jsonschema.json, ../api/params/api.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/params/schema.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/params/metadata.json)

test_request:
	$(call test_schemafile, schema/jsonschema.json, ../api/request/ingest.json)

test_response:
	$(call test_schemafile, schema/jsonschema.json, ../api/response/api.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/database.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/error.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/ingest.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/health.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/metadata.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/ready.json)
	$(call test_schemafile, schema/jsonschema.json, ../api/response/schema.json)

test_unknown:
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /xfail)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /XFAIL0)

test_ready:
	$(call test_endpoint, 406, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /ready, --header='Accept: text/xml')

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/ready.json, /ready)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/ready.json, /ready?ignored=ignored)

test_api:
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?response=xfail)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?request=xfail)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?params=xfail)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?response=)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?request=)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/api.json, /api?params=)

	$(call test_endpoint, 200, schema/any.json, schema/openapi.json, ../api/response/api.json, /api)
	$(call test_endpoint, 200, schema/any.json, schema/openapi.json, ../api/response/api.json, /api?ignored=ignored)

	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=api)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=database)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=health)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=ingest)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=metadata)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=ready)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=schema)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?response=error)

	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?request=ingest)

	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?params=api)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?params=database)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?params=schema)
	$(call test_endpoint, 200, schema/any.json, schema/jsonschema.json, ../api/response/api.json, /api?params=metadata)

test_schema:
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/schema.json, /schema?prop=xfail)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/schema.json, /schema?prop=)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/schema.json, /schema?prop=recordid)  # fails because case

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?ignored=ignored)

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@version)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@comment)

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=schemaVersion)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=recordId)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=metadataQuality)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=dataSteward)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=source)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=createdAt)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=sizeBytes)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=dataLocation)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=dataFormat)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=keywords)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=categories)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=title)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=creators)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=publisher)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=publicationYear)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=resourceType)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=identifiers)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=synonyms)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=language)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=subjects)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=version)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=license)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=rights)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=fundings)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=description)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=relatedItems)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=rawMetadata)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=rawChecksum)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=rawFormat)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@isRelatedTo)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@isNewVersionOf)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@isDerivedFrom)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@hasPart)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@isPartOf)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@isDescribedBy)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@commonExpression)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/schema.json, /schema?prop=@commonManifestation)

test_metadata:
	$(call test_endpoint, 414, schema/jsonapi.json, schema/failure.json, ../api/response/metadata.json, /metadata?id=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/metadata.json, /metadata?id=0)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/metadata.json, /metadata?id=ni:)
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/metadata.json, /metadata?id=ni:xfail)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/metadata.json, /metadata?id=ni:dataasee\&format=xfail)

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?id=ni:dataasee)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?id=ni:dataasee\&format=datacite)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?id=ni:dataasee\&format=bibjson)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?source=)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?doi=xfail)

test_database:
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?query=)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?query=xfail)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=xfail\&query=xfail)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=xfail\&query=SELECT+1)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=sql\&query=fail)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=sql\&query=DROP+TYPE+Metadata)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=sql\&query=UPDATE+Metadata+REMOVE+title)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=sql\&query=INSERT+INTO+Metadata)
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/database.json, /database?language=sql\&query=DELETE+FROM+Metadata)

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?query=SELECT%201)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?language=sql\&query=SELECT%201)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?language=opencypher\&query=RETURN%201)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?language=mongo\&query=%7B%27collection%27%3A%27Metadata%27%2C%27query%27%3A%7B%7D%7D)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?language=redis\&query=PING)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?language=graphql\&query={__typename})

INGEST_NO_SOURCE='{"method":"oai-pmh","format":"datacite","steward":"x@example.invalid","rights":"CC0"}'
INGEST_NO_METHOD='{"source":"http://example.invalid","format":"datacite","steward":"x@example.invalid","rights":"CC0"}'
INGEST_NO_FORMAT='{"source":"http://example.invalid","method":"oai-pmh","steward":"x@example.invalid","rights":"CC0"}'
INGEST_NO_STEWARD='{"source":"http://example.invalid","method":"oai-pmh","format":"datacite","rights":"CC0"}'
INGEST_NO_RIGHTS='{"source":"http://example.invalid","method":"oai-pmh","format":"datacite","steward":"x@example.invalid"}'
INGEST_BAD_METHOD='{"source":"http://example.invalid","method":"xfail","format":"datacite","steward":"x@example.invalid","rights":"CC0"}'
INGEST_BAD_FORMAT='{"source":"http://example.invalid","method":"oai-pmh","format":"xfail","steward":"x@example.invalid","rights":"CC0"}'

test_ingest:
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest)
	$(call test_endpoint, 403, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}='{}', ${NOAU})
	$(call test_endpoint, 403, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}='{}', ${UNAU})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}='{', ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_NO_SOURCE}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_NO_METHOD}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_NO_FORMAT}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_NO_STEWARD}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_NO_RIGHTS}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_BAD_METHOD}, ${AUTH})
	$(call test_endpoint, 400, schema/jsonapi.json, schema/failure.json, ../api/response/ingest.json, /ingest, ${POST}=${INGEST_BAD_FORMAT}, ${AUTH})

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${POST}='', ${AUTH})
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${POST}='{}', ${AUTH})

test_health:
	$(call test_endpoint, 404, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /health)
	$(call test_endpoint, 403, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /health, ${POST}='', ${NOAU})
	$(call test_endpoint, 403, schema/jsonapi.json, schema/failure.json, ../api/response/error.json, /health, ${POST}='', ${UNAU})

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/health.json, /health, ${POST}='', ${AUTH})
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/health.json, /health, ${POST}='{}', ${AUTH})
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/health.json, /health, ${POST}='{', ${AUTH})

test_datacite:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${FILE}=requests/ingest-datacite.json, ${AUTH})

	$(call wait_ingest)

test_dc:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${FILE}=requests/ingest-dc.json, ${AUTH})

	$(call wait_ingest)

test_mods:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${FILE}=requests/ingest-mods.json, ${AUTH})

	$(call wait_ingest)

test_marc:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${FILE}=requests/ingest-marc.json, ${AUTH})

	$(call wait_ingest)

test_lido:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${FILE}=requests/ingest-lido.json, ${AUTH})

	$(call wait_ingest)

test_form:
	$(call test_endpoint, 202, schema/jsonapi.json, schema/success.json, ../api/response/ingest.json, /ingest, ${POST}="source=http://host.docker.internal:9876/ingest-datacite.xml&method=get&format=datacite&steward=little&rights=CC0", ${AUTH})

	$(call wait_ingest)

test_data:
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?source=)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?newest=true)
	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?newest=false)

	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/database.json, /database?query=SELECT%20FROM%20Metadata)

#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?search=test)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?language=en)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?resourcetype=article)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?license=public%20domain)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?category=mathematics)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?doi=10.0000%2Fabcdef)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?from=2010)
#	$(call test_endpoint, 200, schema/jsonapi.json, schema/success.json, ../api/response/metadata.json, /metadata?till=2010)

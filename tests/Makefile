HOST=localhost

POST="--post-data="
FILE=--post-file

AUTH:=--user=admin --password=$(shell . ../secrets.env; echo $$DL_PASS)
UNAU=--user=admin --password=xfail

PASS=-eq
FAIL=-ne

# Test file on schema
define test_schema
	@echo $(strip $2)
	@check-jsonschema --schemafile $1 $2
endef

# Test endpoint response on schemas
define test_endpoint
	@echo $(strip $4)
	@TMP=mktemp ;\
	wget --content-on-error -qO $$TMP $5 $6 http://${HOST}:8343/api/v1$(strip $4) ; RET0=$$? ;\
	check-jsonschema --schemafile $2 $$TMP ; RET1=$$? ;\
	check-jsonschema --schemafile $3 $$TMP ; RET2=$$? ;\
	rm $$TMP ;\
	test $$RET0 $1 0 && test $$RET1 -eq 0 && test $$RET2 -eq 0
endef

# Wait for ingest to finish
define wait_ingest
	@until wget -qO- http://${HOST}:8343/api/v1/ingest ${POST} ${AUTH} | grep -q '"started":false' ; do echo -n "." && sleep 1; done
	@echo
endef

test:
	@echo

	@echo "SCHEMA TESTS"

	@echo

	$(call test_schema, schema/openapi.json, ../api/openapi.yaml)

	@echo

	$(call test_schema, schema/jsonschema.json, ../api/params/api.json)
	$(call test_schema, schema/jsonschema.json, ../api/params/enums.json)
	$(call test_schema, schema/jsonschema.json, ../api/params/metadata.json)

	@echo

	$(call test_schema, schema/jsonschema.json, ../api/request/insert.json)
	$(call test_schema, schema/jsonschema.json, ../api/request/ingest.json)

	@echo

	$(call test_schema, schema/jsonschema.json, ../api/response/api.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/enums.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/backup.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/error.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/ingest.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/insert.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/health.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/metadata.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/ready.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/schema.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/sources.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/stats.json)

	@echo

	@echo "SYSTEM TESTS (service needs to be started)"

	@echo

	$(call test_endpoint, ${PASS}, ../api/response/ready.json, schema/jsonapi.json, /ready)

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/api.json, schema/jsonapi.json, /api?response=xfail)
	$(call test_endpoint, ${FAIL}, ../api/response/api.json, schema/jsonapi.json, /api?request=xfail)
	$(call test_endpoint, ${FAIL}, ../api/response/api.json, schema/jsonapi.json, /api?params=xfail)

	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/openapi.json, /api)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=api)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=enums)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=backup)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=health)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=ingest)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=insert)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=metadata)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=ready)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=schema)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=stats)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=sources)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?response=error)

	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?request=ingest)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?request=insert)

	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?params=api)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?params=enums)
	$(call test_endpoint, ${PASS}, ../api/response/api.json, schema/jsonschema.json, /api?params=metadata)

	@echo

	$(call test_endpoint, ${PASS}, ../api/response/schema.json, schema/jsonapi.json, /schema)

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=xfail)

	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=resourcetypes)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=languages)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=licenses)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=synonyms)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=externalitems)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=categories)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=schemas)
	$(call test_endpoint, ${PASS}, ../api/response/enums.json, schema/jsonapi.json, /enums?type=relations)

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${POST}, ${AUTH})
	$(call test_endpoint, ${FAIL}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${FILE}=requests/insert-minimal.json, ${UNAU})
	$(call test_endpoint, ${FAIL}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${FILE}=requests/insert-xfail-title.json, ${AUTH})

	$(call test_endpoint, ${PASS}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${FILE}=requests/insert-minimal.json, ${AUTH})
	$(call test_endpoint, ${PASS}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${FILE}=requests/insert-maximal.json, ${AUTH})
	$(call test_endpoint, ${PASS}, ../api/response/insert.json, schema/jsonapi.json, /insert, ${FILE}=requests/insert-maxlength.json, ${AUTH})

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-dummy.json, ${UNAU})
	$(call test_endpoint, ${FAIL}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-xfail-source.json, ${AUTH})

	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${POST}, ${AUTH})

	@echo

	$(call test_endpoint, ${PASS}, ../api/response/stats.json, schema/jsonapi.json, /stats)

	@echo

	$(call test_endpoint, ${PASS}, ../api/response/sources.json, schema/jsonapi.json, /sources)

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ)
	$(call test_endpoint, ${FAIL}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=0)

	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=dataasee)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=dataasee\&format=datacite)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=dataasee\&format=bibjson)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?language=sql\&query=SELECT%201)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?search=test)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?language=en)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?resourcetype=article)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?license=public%20domain)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?category=mathematics)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?doi=10.0000%2Fabcdef)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?from=2010)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?till=2010)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?newest=true)
	$(call test_endpoint, ${PASS}, ../api/response/metadata.json, schema/jsonapi.json, /metadata?newest=false)

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/backup.json, schema/jsonapi.json, /backup)
	$(call test_endpoint, ${FAIL}, ../api/response/backup.json, schema/jsonapi.json, /backup, ${POST}, ${UNAU})

	$(call test_endpoint, ${PASS}, ../api/response/backup.json, schema/jsonapi.json, /backup, ${POST}, ${AUTH})

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/health.json, schema/jsonapi.json, /health)
	$(call test_endpoint, ${FAIL}, ../api/response/health.json, schema/jsonapi.json, /health, ${POST}, ${UNAU})

	$(call test_endpoint, ${PASS}, ../api/response/health.json, schema/jsonapi.json, /health, ${POST}, ${AUTH})

	@echo

	$(call test_endpoint, ${FAIL}, ../api/response/error.json, schema/jsonapi.json , /xfail)

	@echo

	@echo "INGEST TESTS (via get)"

	@echo

	@busybox httpd -h datasets -p 0.0.0.0:9876 || httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1

	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-datacite.json, ${AUTH})

	$(call wait_ingest)

	@sleep 1

	@echo

test_datacite:
	@busybox httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1
	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-datacite.json, ${AUTH})
	@lsof -nti:9876 | xargs kill -9
	@echo

test_dc:
	@busybox httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1
	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-dc.json, ${AUTH})
	@lsof -nti:9876 | xargs kill -9
	@echo

test_mods:
	@busybox httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1
	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-mods.json, ${AUTH})
	@lsof -nti:9876 | xargs kill -9
	@echo

test_marc:
	@busybox httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1
	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-marc.json, ${AUTH})
	@lsof -nti:9876 | xargs kill -9
	@echo

test_lido:
	@busybox httpd -h datasets -p 0.0.0.0:9876 || true
	@sleep 1
	$(call test_endpoint, ${PASS}, ../api/response/ingest.json, schema/jsonapi.json, /ingest, ${FILE}=requests/ingest-lido.json, ${AUTH})
	@lsof -nti:9876 | xargs kill -9
	@echo

HOST=localhost

define test_schema
	@echo $(strip $(2))
	@check-jsonschema --schemafile $1 $2
endef

define test_endpoint
	@echo $(strip $(3))
	@TMP=mktemp && wget --content-on-error -qO- $4 http://${HOST}:8343/api/v1$(strip $(3)) | tee $$TMP | check-jsonschema --schemafile $1 - && check-jsonschema --schemafile $2 $$TMP && rm $$TMP
endef

define test_endpoint_auth
	 $(call test_endpoint,$1,$2,$3,--user=admin --password=`cat ../secrets/dl_pass` --post-data='')
endef

define test_endpoint_file
	 $(call test_endpoint,$1,$2,$3,--user=admin --password=`cat ../secrets/dl_pass` --post-file=$(strip $(4)))
endef

test:

	@echo

	$(call test_schema, schema/openapi.json, ../api/openapi.yaml)

	@echo

	$(call test_schema, schema/jsonschema.json, ../api/request/insert.json)
	$(call test_schema, schema/jsonschema.json, ../api/request/ingest.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/ready.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/api.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/schema.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/attributes.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/stats.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/metadata.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/insert.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/ingest.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/backup.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/health.json)
	$(call test_schema, schema/jsonschema.json, ../api/response/error.json)

	@echo

	$(call test_endpoint_auth, ../api/response/error.json, schema/jsonapi.json, /ready)

	$(call test_endpoint, ../api/response/ready.json, schema/jsonapi.json, /ready)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /api?response=xfail)
	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /api?request=xfail)	

	$(call test_endpoint, ../api/response/api.json, schema/openapi.json, /api)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=api)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=attributes)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=backup)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=health)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=ingest)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=insert)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=metadata)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=ready)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=schema)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=stats)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?response=error)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?request=ingest)
	$(call test_endpoint, ../api/response/api.json, schema/jsonschema.json, /api?request=insert)

	@echo

	$(call test_endpoint, ../api/response/schema.json, schema/jsonapi.json, /schema)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /attributes?type=xfail)

	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=resourcetypes)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=languages)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=licenses)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=synonyms)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=externalitems)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=categories)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=schemas)
	$(call test_endpoint, ../api/response/attributes.json, schema/jsonapi.json, /attributes?type=relations)

	@echo

	$(call test_endpoint, ../api/response/stats.json, schema/jsonapi.json, /stats)

	@echo

	$(call test_endpoint_file, ../api/response/error.json, schema/jsonapi.json, /insert, datasets/insert-xfail-title.json)
	$(call test_endpoint_auth, ../api/response/error.json, schema/jsonapi.json, /insert)
	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /insert)

	$(call test_endpoint_file, ../api/response/insert.json, schema/jsonapi.json, /insert, datasets/insert-minimal.json)
	$(call test_endpoint_file, ../api/response/insert.json, schema/jsonapi.json, /insert, datasets/insert-maximal.json)

	@echo

	$(call test_endpoint_file, ../api/response/error.json, schema/jsonapi.json, /ingest, datasets/ingest-xfail-source.json)
	$(call test_endpoint_auth, ../api/response/error.json, schema/jsonapi.json, /ingest)
	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /ingest)

	$(call test_endpoint_file, ../api/response/ingest.json, schema/jsonapi.json, /ingest, datasets/ingest.json)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /metadata?id=ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ)
	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /metadata?id=0)

	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?id=NzE2NjEyNTY3MTA1NzM2ODAyOQ)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?language=sql\&query=SELECT%201)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?search=test)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?language=en)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?resourcetype=article)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?license=public%20domain)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?category=mathematics)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?from=2010)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?till=2010)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?newest=true)
	$(call test_endpoint, ../api/response/metadata.json, schema/jsonapi.json, /metadata?newest=false)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /backup)

	$(call test_endpoint_auth, ../api/response/backup.json, schema/jsonapi.json, /backup)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json, /health)

	$(call test_endpoint_auth, ../api/response/health.json, schema/jsonapi.json, /health)

	@echo

	$(call test_endpoint, ../api/response/error.json, schema/jsonapi.json , /xfail)

	@echo

```plantuml
@startyaml

database:
  name: "metadatalake"
  source: "ArcadeDB"
  project: "DatAasee"
  version: 1
  license: "MIT"
  authors:
    - "Christian Himpe"

definitions:
  mandatory: "mandatory true"
  notnull: "notnull true"
  readonly: "readonly true"
  tiny: "max 255"
  small: "max 4095"
  normal: "max 65535"
  integer: "long"
  notempty: "min 0"
  nonnegative: "min 0"
  url: "regexp"

documents:
  attributes:
    name: "string (mandatory, notnull, readonly, tiny)"
    also: "list of string (notnull, readonly)"

  pair:
    name: "string (mandatory, notnull, tiny)"
    data: "string (mandatory, small, url)"

vertexes:
  metadata:

    # Process
    schemaVersion: "integer (mandatory, notnull, readonly, nonnegative, default)"
    recordId: "string (mandatory, notnull, readonly)"
    metadataQuality: "string (mandatory, notnull, tiny, default)"
    dataSteward: "string (mandatory, small, default)"
    source: "string (mandatory, notnull, readonly, small)"
    createdAt: "datetime (mandatory, notnull, readonly, default)"
    updatedAt: "datetime (default)"

    # Technical
    sizeBytes: "integer (nonnegative)"
    fileFormat: "string (tiny)"
    dataLocation: "string (small, url)"

    # Social
    numberDownloads: "integer (mandatory, notnull, nonnegative, default)"
    keywords: "string (tiny, default)"
    categories: "list of string (max 4)"

    # Descriptive (Mandatory)
    name: "string (mandatory, tiny, default)"
    creators: "list of pair (mandatory, tiny)"
    publisher: "string (mandatory, min 1, tiny)"
    publicationYear: "integer (mandatory, min -9999, max 9999)"
    resourceType: "link of attribute (mandatory)"
    identifiers: "list of pair (mandatory, min 1, tiny)"

    # Descriptive (Optional)
    synonyms: "list of pair (max 255)"
    language: "link of attribute"
    subjects: "list of pair (max 255)"
    version: "string (tiny)"
    license: "link of pair"
    rights: "string (normal)"
    project: "embedded of pair"
    fundings: "list of pair (max 255)"
    description: "string (mandatory, normal, default)"
    message: "string (normal)"
    externalItems: "list of pair (max 255)"

    # Raw Metadata
    rawType: "string (tiny)"
    raw: "string"
    rawChecksum: "string (tiny)"

edges:
  isRelatedTo:
    out: "link of metadata"
    in: "link of metadata"

  isNewVersionOf:
    @extends: "isRelatedTo"

  isDerivedFrom:
    @extends: "isRelatedTo"

  isPartOf:
    @extends: "isRelatedTo"

  isSameExpressionAs:
    @extends: "isRelatedTo"

  isSameManifestationAs:
    @extends: "isRelatedTo"

indexes:
  unique:
    - "metadata.recordId"

  notunique:
    - "metadata.numberDownloads"
    - "metadata.categories"
    - "metadata.publicationYear"
    - "metadata.resourceType"
    - "metadata.identifiers"
    - "metadata.language"
    - "metadata.subjects"
    - "metadata.license"
    - "metadata.rawType"

  full_text:
    - "metadata.keywords"
    - "metadata.name"
    - "metadata.description"

@endyaml
```
  
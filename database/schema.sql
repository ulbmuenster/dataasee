-- Language: ArcadeDB SQL, Project: DatAasee, License: MIT, Author: Christian Himpe

BEGIN;

-- Pair Type
CREATE DOCUMENT TYPE Pair;

CREATE PROPERTY Pair.name STRING (mandatory true, notnull true, min 1, max 255);
CREATE PROPERTY Pair.data STRING (max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');

CREATE DOCUMENT TYPE Categories EXTENDS Pair;
CREATE DOCUMENT TYPE Dataformats EXTENDS Pair;
CREATE DOCUMENT TYPE Languages EXTENDS Pair;
CREATE DOCUMENT TYPE Licenses EXTENDS Pair;
CREATE DOCUMENT TYPE Resourcetypes EXTENDS Pair;
CREATE DOCUMENT TYPE Schemas EXTENDS Pair;
CREATE DOCUMENT TYPE Sources EXTENDS Pair;

-- Raw Type
CREATE DOCUMENT TYPE Raw;

CREATE PROPERTY Raw.value STRING (mandatory true, notnull true, default '');

-- Metadata Type
CREATE VERTEX TYPE Metadata BUCKETS 8;
    ALTER TYPE Metadata CUSTOM comment = 'In this database, the "Metadata" type (cf. table) is the core data model (related to DataCite) and the sole vertex type; try "SELECT * FROM Metadata". For schema details see "SELECT * FROM schema:types", and https://docs.arcadedb.com/#sql for help with the ArcadeDB SQL dialect.';
    ALTER TYPE Metadata CUSTOM version = 1;

-- Process Metadata
CREATE PROPERTY Metadata.schemaVersion SHORT (notnull true, min 1, max 1, default 1);
    ALTER PROPERTY Metadata.schemaVersion CUSTOM label = 'Schema Version';

CREATE PROPERTY Metadata.recordId STRING (mandatory true, notnull true, readonly true, max 47);
    ALTER PROPERTY Metadata.recordId CUSTOM label = 'Record Identifier';

CREATE PROPERTY Metadata.metadataQuality STRING (mandatory true, notnull true, max 255);
    ALTER PROPERTY Metadata.metadataQuality CUSTOM label = 'Metadata Quality';

CREATE PROPERTY Metadata.dataSteward STRING (mandatory true, notnull true, max 4095);
    ALTER PROPERTY Metadata.dataSteward CUSTOM label = 'Data Steward';

CREATE PROPERTY Metadata.source LINK OF Pair (mandatory true, notnull true);
    ALTER PROPERTY Metadata.source CUSTOM label = 'Metadata Source';
    ALTER PROPERTY Metadata.source CUSTOM enum = 'Sources';

CREATE PROPERTY Metadata.sourceRights STRING (mandatory true, notnull true, max 4095);
    ALTER PROPERTY Metadata.sourceRights CUSTOM label = 'Source Rights';

CREATE PROPERTY Metadata.createdAt DATETIME (mandatory true, notnull true, default sysdate());
    ALTER PROPERTY Metadata.createdAt CUSTOM label = 'Created At';

-- Technical Metadata
CREATE PROPERTY Metadata.sizeBytes LONG (min 0);
    ALTER PROPERTY Metadata.sizeBytes CUSTOM label = 'Data Size (in Bytes)';

CREATE PROPERTY Metadata.dataFormat STRING (max 255);
    ALTER PROPERTY Metadata.dataFormat CUSTOM label = 'Data (File) Format';
    ALTER PROPERTY Metadata.dataFormat CUSTOM enum = 'Dataformats';

CREATE PROPERTY Metadata.dataLocation STRING (max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');
    ALTER PROPERTY Metadata.dataLocation CUSTOM label = 'Data Location';

-- Social Metadata
CREATE PROPERTY Metadata.keywords LIST OF STRING (max 15);
    ALTER PROPERTY Metadata.keywords CUSTOM label = 'Keyword(s)';
    ALTER PROPERTY Metadata.keywords CUSTOM comment = 'Uncontrolled custom keywords classifying this record (max 15)';

CREATE PROPERTY Metadata.categories LIST OF LINK (max 3);
    ALTER PROPERTY Metadata.categories CUSTOM label = 'Category(s)';
    ALTER PROPERTY Metadata.categories CUSTOM comment = 'Controlled categories classifying this record (max 3, enumerated)';
    ALTER PROPERTY Metadata.categories CUSTOM enum = 'Categories';

-- Descriptive Metadata (Mandatory)
CREATE PROPERTY Metadata.title STRING (mandatory true, max 255, default '');
    ALTER PROPERTY Metadata.title CUSTOM label = 'Title';
    ALTER PROPERTY Metadata.title CUSTOM comment = 'Short phrase describing this record (max 255)';

CREATE PROPERTY Metadata.creators LIST OF Pair (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY Metadata.creators CUSTOM label = 'Creator(s)';
    ALTER PROPERTY Metadata.creators CUSTOM comment = 'Name (max 255) and optional URI identifier (max 4095) of the persons contributing; (max 255)';

CREATE PROPERTY Metadata.publisher STRING (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY Metadata.publisher CUSTOM label = 'Publisher';
    ALTER PROPERTY Metadata.publisher CUSTOM comment = 'Entity responsible for (first) publication (max 255)';

CREATE PROPERTY Metadata.publicationYear SHORT (mandatory true, min -9999, max 9999, default ifnull(null,null));
    ALTER PROPERTY Metadata.publicationYear CUSTOM label = 'Published (Year)';
    ALTER PROPERTY Metadata.publicationYear CUSTOM comment = 'First year (common era) of publication denoted by up to four digits (min -9999, max 9999)';

CREATE PROPERTY Metadata.resourceType LINK OF Pair (mandatory true, default ifnull(null,null));
    ALTER PROPERTY Metadata.resourceType CUSTOM label = 'Resource Type';
    ALTER PROPERTY Metadata.resourceType CUSTOM comment = 'Primary type of resource (enumerated)';
    ALTER PROPERTY Metadata.resourceType CUSTOM enum = 'Resourcetypes';

CREATE PROPERTY Metadata.identifiers LIST OF Pair (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY Metadata.identifiers CUSTOM label = 'Identifier(s)';
    ALTER PROPERTY Metadata.identifiers CUSTOM comment = 'URI (max 255) and type (max 4095) of identifiers; (max 255)';

-- Descriptive Metadata (Optional)
CREATE PROPERTY Metadata.synonyms LIST OF Pair (max 255);
    ALTER PROPERTY Metadata.synonyms CUSTOM label = 'Synonym(s)';
    ALTER PROPERTY Metadata.synonyms CUSTOM comment = 'title (max 255) and type (max 4095) of synonymous titles; (max 255)';

CREATE PROPERTY Metadata.language LINK OF Pair;
    ALTER PROPERTY Metadata.language CUSTOM label = 'Language';
    ALTER PROPERTY Metadata.language CUSTOM comment = 'Primary content language (enumerated)';
    ALTER PROPERTY Metadata.language CUSTOM enum = 'Languages';

CREATE PROPERTY Metadata.subjects LIST OF Pair (max 255);
    ALTER PROPERTY Metadata.subjects CUSTOM label = 'Subject(s)';
    ALTER PROPERTY Metadata.subjects CUSTOM comment = 'Classifier (max 255) and URI identifier (max 4095) of subjects; (max 255)';

CREATE PROPERTY Metadata.version STRING (max 255);
    ALTER PROPERTY Metadata.version CUSTOM label = 'Version';
    ALTER PROPERTY Metadata.version CUSTOM comment = 'Short identifier fixing the state (max 255)';

CREATE PROPERTY Metadata.license LINK OF Pair;
    ALTER PROPERTY Metadata.license CUSTOM label = 'License';
    ALTER PROPERTY Metadata.license CUSTOM comment = 'SPDX short name of license (enumerated)';
    ALTER PROPERTY Metadata.license CUSTOM enum = 'Licenses';

CREATE PROPERTY Metadata.rights STRING (max 65535);
    ALTER PROPERTY Metadata.rights CUSTOM label = 'Rights';
    ALTER PROPERTY Metadata.rights CUSTOM comment = 'Additional rights agreements (max 65535)';

CREATE PROPERTY Metadata.fundings LIST OF Pair (max 255);
    ALTER PROPERTY Metadata.fundings CUSTOM label = 'Funding(s)';
    ALTER PROPERTY Metadata.fundings CUSTOM comment = 'Award identifier (max 255) and optional funder (max 4095) of fundings; (max 255)';

CREATE PROPERTY Metadata.description STRING (mandatory true, max 65535, default '');
    ALTER PROPERTY Metadata.description CUSTOM label = 'Description';
    ALTER PROPERTY Metadata.description CUSTOM comment = 'Summary of contents and purpose (max 65535)';

CREATE PROPERTY Metadata.relatedItems LIST OF Pair (max 255);
    ALTER PROPERTY Metadata.relatedItems CUSTOM label = 'Link(s)';
    ALTER PROPERTY Metadata.relatedItems CUSTOM comment = 'Type (max 255) and URI identifier (max 4095) of external related links; (max 255)';

-- Raw Metadata
CREATE PROPERTY Metadata.rawMetadata LINK of Raw;
    ALTER PROPERTY Metadata.rawMetadata CUSTOM label = 'Raw Metadata';

CREATE PROPERTY Metadata.rawFormat LINK OF Pair;
    ALTER PROPERTY Metadata.rawFormat CUSTOM label = 'Raw Metadata Format';
    ALTER PROPERTY Metadata.rawFormat CUSTOM enum = 'Schemas';

CREATE PROPERTY Metadata.rawChecksum STRING (max 255);
    ALTER PROPERTY Metadata.rawChecksum CUSTOM label = 'Raw Metadata Checksum';

-- Interconnect Hints
CREATE PROPERTY Metadata.related MAP OF LIST (default null);
    ALTER PROPERTY Metadata.related CUSTOM comment = 'Internal use only';

CREATE PROPERTY Metadata.visited BOOLEAN (default false);
    ALTER PROPERTY Metadata.visited CUSTOM comment = 'Internal use only';

-- Edges
CREATE EDGE TYPE isRelatedTo;
    CREATE PROPERTY isRelatedTo.`@out` LINK OF Metadata;
    CREATE PROPERTY isRelatedTo.`@in` LINK OF Metadata;
    ALTER TYPE isRelatedTo CUSTOM label_out = 'Is related to';
    ALTER TYPE isRelatedTo CUSTOM label_in = 'Is related to*';

CREATE EDGE TYPE isNewVersionOf EXTENDS isRelatedTo;
    ALTER TYPE isNewVersionOf CUSTOM label_out = 'Is new version of';
    ALTER TYPE isNewVersionOf CUSTOM label_in = 'Has new version';

CREATE EDGE TYPE isDerivedFrom EXTENDS isRelatedTo;
    ALTER TYPE isDerivedFrom CUSTOM label_out = 'Is derivation of';
    ALTER TYPE isDerivedFrom CUSTOM label_in = 'Has derivation';

CREATE EDGE TYPE hasPart EXTENDS isRelatedTo;
    ALTER TYPE hasPart CUSTOM label_out = 'Has part';
    ALTER TYPE hasPart CUSTOM label_in = 'Is part of';

CREATE EDGE TYPE isPartOf EXTENDS isRelatedTo;
    ALTER TYPE isPartOf CUSTOM label_out = 'Is part of';
    ALTER TYPE isPartOf CUSTOM label_in = 'Has part';

CREATE EDGE TYPE isDescribedBy EXTENDS isRelatedTo;
    ALTER TYPE isDescribedBy CUSTOM label_out = 'Is described by';
    ALTER TYPE isDescribedBy CUSTOM label_in = 'describes';

CREATE EDGE TYPE commonExpression EXTENDS isRelatedTo; -- Is of same content and format (but differs in identifier or location), like: Book and Ebook
    ALTER TYPE commonExpression CUSTOM label_out = 'Is same expression as';
    ALTER TYPE commonExpression CUSTOM label_in = 'Is same expression as*';

CREATE EDGE TYPE commonManifestation EXTENDS isRelatedTo; -- Is of same content (but differs in format or carrier), like: DOI and OADOI
    ALTER TYPE commonManifestation CUSTOM label_out = 'Is same manifestation as';
    ALTER TYPE commonManifestation CUSTOM label_in = 'Is same manifestation as*';

-- Indexes
CREATE INDEX ON Metadata (recordId) UNIQUE_HASH;

CREATE INDEX ON Metadata (publicationYear) NOTUNIQUE;
CREATE INDEX ON Metadata (resourceType) NOTUNIQUE;
CREATE INDEX ON Metadata (language) NOTUNIQUE;
CREATE INDEX ON Metadata (license) NOTUNIQUE;
CREATE INDEX ON Metadata (source) NOTUNIQUE;
CREATE INDEX ON Metadata (rawFormat) NOTUNIQUE;

CREATE INDEX ON Metadata (categories BY ITEM) NOTUNIQUE;
CREATE INDEX ON Metadata (`subjects.data` BY ITEM) NOTUNIQUE;
CREATE INDEX ON Metadata (`identifiers.name` BY ITEM) NOTUNIQUE_HASH;

CREATE INDEX ON Metadata (title) FULL_TEXT;
CREATE INDEX ON Metadata (keywords BY ITEM) FULL_TEXT;
CREATE INDEX ON Metadata (description) FULL_TEXT;

CREATE INDEX ON Metadata (`synonyms.name` BY ITEM) FULL_TEXT;

-- Views

CREATE MATERIALIZED VIEW Facets AS SELECT [] AS categories, (SELECT language.name AS language, count(*) AS count FROM Metadata WHERE language IS NOT NULL GROUP BY language).language AS language, (SELECT license.name AS license, count(*) AS count FROM Metadata WHERE license IS NOT NULL GROUP BY license).license AS license, (SELECT dataFormat.name AS dataFormat, count(*) AS count FROM Metadata WHERE dataFormat IS NOT NULL GROUP BY dataFormat).dataFormat AS dataFormat, (SELECT resourceType.name AS resourceType, count(*) AS count FROM Metadata WHERE resourceType IS NOT NULL GROUP BY resourceType).resourceType AS resourceType, (SELECT rawFormat.name AS rawFormat, count(*) AS count FROM Metadata WHERE rawFormat IS NOT NULL GROUP BY rawFormat).rawFormat AS rawFormat, (SELECT source.name AS source, count(*) AS count FROM Metadata GROUP BY source).source AS source;

COMMIT;

-- Language: ArcadeDB SQL, Project: DatAasee, License: MIT, Author: Christian Himpe

BEGIN;

-- Pair Type
CREATE DOCUMENT TYPE pair;

CREATE PROPERTY pair.name STRING (mandatory true, notnull true, min 1, max 255);
CREATE PROPERTY pair.data STRING (max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');

CREATE DOCUMENT TYPE categories EXTENDS pair;
CREATE DOCUMENT TYPE dataformats EXTENDS pair;
CREATE DOCUMENT TYPE externalitems EXTENDS pair;
CREATE DOCUMENT TYPE languages EXTENDS pair;
CREATE DOCUMENT TYPE licenses EXTENDS pair;
CREATE DOCUMENT TYPE resourcetypes EXTENDS pair;
CREATE DOCUMENT TYPE schemas EXTENDS pair;
CREATE DOCUMENT TYPE synonyms EXTENDS pair;
CREATE DOCUMENT TYPE sources EXTENDS pair;

-- Metadata Type
CREATE VERTEX TYPE metadata BUCKETS 16;
    ALTER TYPE metadata CUSTOM comment = 'In this database, the "metadata" type (cf. table) is the core data model (related to DataCite) and the sole vertex type; try "SELECT * FROM metadata". For schema details see "SELECT * FROM schema:types", and https://docs.arcadedb.com/#sql for help with the ArcadeDB SQL dialect.';
    ALTER TYPE metadata CUSTOM version = 1;

-- Process Metadata
CREATE PROPERTY metadata.schemaVersion SHORT (notnull true, min 1, max 1, default 1);
    ALTER PROPERTY metadata.schemaVersion CUSTOM label = 'Schema Version';

CREATE PROPERTY metadata.recordId STRING (mandatory true, notnull true, readonly true, max 31);
    ALTER PROPERTY metadata.recordId CUSTOM label = 'Record Identifier';

CREATE PROPERTY metadata.metadataFormat STRING (max 255);
    ALTER PROPERTY metadata.metadataFormat CUSTOM label = 'Metadata Format';

CREATE PROPERTY metadata.metadataQuality STRING (mandatory true, notnull true, max 255);
    ALTER PROPERTY metadata.metadataQuality CUSTOM label = 'Metadata Quality';

CREATE PROPERTY metadata.dataSteward STRING (mandatory true, notnull true, max 4095);
    ALTER PROPERTY metadata.dataSteward CUSTOM label = 'Data Steward';

CREATE PROPERTY metadata.source LINK OF pair (mandatory true, default ifnull(null,null));
    ALTER PROPERTY metadata.source CUSTOM label = 'Metadata Source';

CREATE PROPERTY metadata.sourceRights STRING (mandatory true, notnull true, readonly true, max 4095);
    ALTER PROPERTY metadata.sourceRights CUSTOM label = 'Source Rights';

CREATE PROPERTY metadata.createdAt DATETIME (mandatory true, notnull true, default sysdate());
    ALTER PROPERTY metadata.createdAt CUSTOM label = 'Created At';

-- Technical Metadata
CREATE PROPERTY metadata.sizeBytes LONG (min 0);
    ALTER PROPERTY metadata.sizeBytes CUSTOM label = 'Data Size (in Bytes)';

CREATE PROPERTY metadata.dataFormat STRING (max 255);
    ALTER PROPERTY metadata.dataFormat CUSTOM label = 'Data (File) Format';

CREATE PROPERTY metadata.dataLocation STRING (max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');
    ALTER PROPERTY metadata.dataLocation CUSTOM label = 'Data Location';

-- Social Metadata
CREATE PROPERTY metadata.numberViews LONG (mandatory true, notnull true, min 0, default 0);
    ALTER PROPERTY metadata.numberViews CUSTOM label = 'Number of Views';

CREATE PROPERTY metadata.keywords STRING (max 255, default '');
    ALTER PROPERTY metadata.keywords CUSTOM label = 'Keyword(s)';
    ALTER PROPERTY metadata.keywords CUSTOM comment = 'Uncontrolled custom keywords classifying this record (separated by commas)';

CREATE PROPERTY metadata.categories LIST OF STRING (max 4);
    ALTER PROPERTY metadata.categories CUSTOM label = 'Category(s)';
    ALTER PROPERTY metadata.categories CUSTOM comment = 'Controlled categories classifying this record (max 4, enumerated)';

-- Descriptive Metadata (Mandatory)
CREATE PROPERTY metadata.name STRING (mandatory true, max 255, default '');
    ALTER PROPERTY metadata.name CUSTOM label = 'Title';
    ALTER PROPERTY metadata.name CUSTOM comment = 'Short phrase describing this record (max 255)';

CREATE PROPERTY metadata.creators LIST OF pair (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY metadata.creators CUSTOM label = 'Creator(s)';
    ALTER PROPERTY metadata.creators CUSTOM comment = 'Name (max 255) and optional URI identifier (max 4095) of the persons contributing; (max 255)';

CREATE PROPERTY metadata.publisher STRING (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY metadata.publisher CUSTOM label = 'Publisher';
    ALTER PROPERTY metadata.publisher CUSTOM comment = 'Entity responsible for (first) publication (max 255)';

CREATE PROPERTY metadata.publicationYear SHORT (mandatory true, min -9999, max 9999, default ifnull(null,null));
    ALTER PROPERTY metadata.publicationYear CUSTOM label = 'Published (Year)';
    ALTER PROPERTY metadata.publicationYear CUSTOM comment = 'First year (common era) of publication denoted by up to four digits (min -9999, max 9999)';

CREATE PROPERTY metadata.resourceType LINK OF pair (mandatory true, default ifnull(null,null));
    ALTER PROPERTY metadata.resourceType CUSTOM label = 'Resource Type';
    ALTER PROPERTY metadata.resourceType CUSTOM comment = 'Primary type of resource (enumerated)';

CREATE PROPERTY metadata.identifiers LIST OF pair (mandatory true, max 255, default ifnull(null,null));
    ALTER PROPERTY metadata.identifiers CUSTOM label = 'Identifier(s)'
    ALTER PROPERTY metadata.identifiers CUSTOM comment = 'Type (max 255) and URI (max 4095) of identifiers; (max 255)';

-- Descriptive Metadata (Optional)
CREATE PROPERTY metadata.synonyms LIST OF pair (max 255);
    ALTER PROPERTY metadata.synonyms CUSTOM label = 'Synonym(s)';
    ALTER PROPERTY metadata.synonyms CUSTOM comment = 'Type (max 255) and title (max 4095) of synonymous titles; (max 255)';

CREATE PROPERTY metadata.language LINK OF pair;
    ALTER PROPERTY metadata.language CUSTOM label = 'Language';
    ALTER PROPERTY metadata.language CUSTOM comment = 'Primary content language (enumerated)';

CREATE PROPERTY metadata.subjects LIST OF pair (max 255);
    ALTER PROPERTY metadata.subjects CUSTOM label = 'Subject(s)';
    ALTER PROPERTY metadata.subjects CUSTOM comment = 'Classifier (max 255) and URI identifier (max 4095) of subjects; (max 255)';

CREATE PROPERTY metadata.version STRING (max 255);
    ALTER PROPERTY metadata.version CUSTOM label = 'Version';
    ALTER PROPERTY metadata.version CUSTOM comment = 'Short identifier fixing the state (max 255)';

CREATE PROPERTY metadata.license LINK OF pair;
    ALTER PROPERTY metadata.license CUSTOM label = 'License';
    ALTER PROPERTY metadata.license CUSTOM comment = 'SPDX short name of license (enumerated)';

CREATE PROPERTY metadata.rights STRING (max 65535);
    ALTER PROPERTY metadata.rights CUSTOM label = 'Rights';
    ALTER PROPERTY metadata.rights CUSTOM comment = 'Additional rights agreements (max 65535)';

CREATE PROPERTY metadata.fundings LIST OF pair (max 255);
    ALTER PROPERTY metadata.fundings CUSTOM label = 'Funding(s)';
    ALTER PROPERTY metadata.fundings CUSTOM comment = 'Award identifier (max 255) and optional funder (max 4095) of fundings; (max 255)';

CREATE PROPERTY metadata.description STRING (mandatory true, max 65535, default '');
    ALTER PROPERTY metadata.description CUSTOM label = 'Description';
    ALTER PROPERTY metadata.description CUSTOM comment = 'Summary of contents and purpose (max 65535)';

CREATE PROPERTY metadata.externalItems LIST OF pair (max 255);
    ALTER PROPERTY metadata.externalItems CUSTOM label = 'Link(s)';
    ALTER PROPERTY metadata.externalItems CUSTOM comment = 'Type (max 255) and URI identifier (max 4095) of external related links; (max 255)';

-- Raw Metadata
CREATE PROPERTY metadata.rawMetadata STRING (mandatory true, max 262144, default '');
    ALTER PROPERTY metadata.rawMetadata CUSTOM label = 'Raw Metadata';

CREATE PROPERTY metadata.rawChecksum STRING (max 255);
    ALTER PROPERTY metadata.rawChecksum CUSTOM label = 'Raw Metadata Checksum (md5)';

-- Interconnect Hints
CREATE PROPERTY metadata.related MAP OF LIST (default null);
CREATE PROPERTY metadata.selfies LIST OF STRING (default []);
CREATE PROPERTY metadata.visited BOOLEAN (default false);

-- Edges
CREATE EDGE TYPE isRelatedTo;
    CREATE PROPERTY isRelatedTo.`@out` LINK OF metadata;
    CREATE PROPERTY isRelatedTo.`@in` LINK OF metadata;
    ALTER TYPE isRelatedTo CUSTOM label = 'Is related to';

CREATE EDGE TYPE isNewVersionOf EXTENDS isRelatedTo;
    ALTER TYPE isNewVersionOf CUSTOM label = 'Is new version of';
    ALTER TYPE isNewVersionOf CUSTOM altlabel = 'Has new version';

CREATE EDGE TYPE isDerivedFrom EXTENDS isRelatedTo;
    ALTER TYPE isDerivedFrom CUSTOM label = 'Is derivation of';
    ALTER TYPE isDerivedFrom CUSTOM altlabel = 'Has derivation';

CREATE EDGE TYPE isPartOf EXTENDS isRelatedTo;
    ALTER TYPE isPartOf CUSTOM label = 'Is part of';
    ALTER TYPE isPartOf CUSTOM altlabel = 'Has part';

CREATE EDGE TYPE hasPart EXTENDS isRelatedTo;
    ALTER TYPE hasPart CUSTOM label = 'Has part';
    ALTER TYPE hasPart CUSTOM altlabel = 'Is part of';

CREATE EDGE TYPE isDescribedBy EXTENDS isRelatedTo;
    ALTER TYPE isPartOf CUSTOM label = 'Is described by';
    ALTER TYPE isPartOf CUSTOM altlabel = 'describes';

CREATE EDGE TYPE commonExpression EXTENDS isRelatedTo; -- Is of same content and format (but differs in identifier or location), like: Book and Ebook
    ALTER TYPE commonExpression CUSTOM label = 'Is same expression as';

CREATE EDGE TYPE commonManifestation EXTENDS isRelatedTo; -- Is of same content (but differs in format or carrier), like: DOI and OADOI
    ALTER TYPE commonManifestation CUSTOM label = 'Is same manifestation as';

-- Indexes
CREATE INDEX ON metadata (recordId) UNIQUE;

CREATE INDEX ON metadata (numberViews) NOTUNIQUE;
CREATE INDEX ON metadata (categories) NOTUNIQUE;
CREATE INDEX ON metadata (publicationYear) NOTUNIQUE;
CREATE INDEX ON metadata (resourceType) NOTUNIQUE;
CREATE INDEX ON metadata (language) NOTUNIQUE;
CREATE INDEX ON metadata (license) NOTUNIQUE;
CREATE INDEX ON metadata (metadataFormat) NOTUNIQUE;
CREATE INDEX ON metadata (source) NOTUNIQUE;

CREATE INDEX ON metadata (identifiers BY ITEM) NOTUNIQUE;
CREATE INDEX ON metadata (subjects BY ITEM) NOTUNIQUE;
CREATE INDEX ON metadata (selfies BY ITEM) NOTUNIQUE;

CREATE INDEX ON metadata (keywords) FULL_TEXT;
CREATE INDEX ON metadata (name) FULL_TEXT;
CREATE INDEX ON metadata (description) FULL_TEXT;

COMMIT;

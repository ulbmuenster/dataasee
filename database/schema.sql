-- Language: ArcadeDB SQL, Project: DatAasee, License: MIT, Author: Christian Himpe

CREATE DOCUMENT TYPE attribute BUCKET categories, resourcetypes, roles, languages, externalitems, synonyms, schemas;
CREATE PROPERTY attribute.name STRING (mandatory true, notnull true, readonly true, min 3, max 255);
CREATE PROPERTY attribute.also LIST OF STRING (notnull true, readonly true);

CREATE DOCUMENT TYPE pair;
    ALTER TYPE pair BUCKET +licenses;
CREATE PROPERTY pair.name STRING (mandatory true, notnull true, max 255);
CREATE PROPERTY pair.data STRING (mandatory true, max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');

CREATE VERTEX TYPE metadata;
    ALTER TYPE metadata CUSTOM comment = 'In this database, the "metadata" type (cf. table) is the main data model (based on DataCite) and the sole vertex type; see "SELECT FROM schema:types" for details, and https://docs.arcadedb.com/#SQL for help.';

-- Process Metadata
CREATE PROPERTY metadata.schemaVersion LONG (mandatory true, notnull true, readonly true, min 0, default 1);
    ALTER PROPERTY metadata.schemaVersion CUSTOM label = 'Schema Version';

CREATE PROPERTY metadata.recordId STRING (mandatory true, notnull true, readonly true, max 31);
    ALTER PROPERTY metadata.recordId CUSTOM label = 'Record Identifier';
    CREATE INDEX ON metadata (recordId) UNIQUE;

CREATE PROPERTY metadata.metadataQuality STRING (mandatory true, notnull true, max 255, default 'OK');
    ALTER PROPERTY metadata.metadataQuality CUSTOM label = 'Metadata Quality';

CREATE PROPERTY metadata.dataSteward STRING (mandatory true, max 4095, default null);
    ALTER PROPERTY metadata.dataSteward CUSTOM label = 'Data Steward';

CREATE PROPERTY metadata.source STRING (mandatory true, notnull true, readonly true, max 4095);
    ALTER PROPERTY metadata.source CUSTOM label = 'Source';

CREATE PROPERTY metadata.createdAt DATETIME (mandatory true, notnull true, readonly true, default sysdate('YYYY-MM-DD HH:MM:SS'));
    ALTER PROPERTY metadata.createdAt CUSTOM label = 'Created At';

CREATE PROPERTY metadata.updatedAt DATETIME (default null);
    ALTER PROPERTY metadata.updatedAt CUSTOM label = 'Last Changed';

-- Technical Metadata
CREATE PROPERTY metadata.sizeBytes LONG (min 0);
    ALTER PROPERTY metadata.sizeBytes CUSTOM label = 'Size (in Bytes)';

CREATE PROPERTY metadata.fileFormat STRING (max 255);
    ALTER PROPERTY metadata.fileFormat CUSTOM label = 'File Format';

CREATE PROPERTY metadata.dataLocation STRING (max 4095, regexp '^(http)[s]?(:\\/\\/)[^\\s\\/$.?#].[^\\s]*$|^(?!http[s]?:\\/\\/).*$');
    ALTER PROPERTY metadata.dataLocation CUSTOM label = 'Data Location';

-- Social Metadata
CREATE PROPERTY metadata.numberDownloads LONG (mandatory true, notnull true, min 0, default 0);
    ALTER PROPERTY metadata.numberDownloads CUSTOM label = 'Views';
    CREATE INDEX ON metadata (numberDownloads) NOTUNIQUE;

CREATE PROPERTY metadata.keywords STRING (max 255, default '');
    ALTER PROPERTY metadata.keywords CUSTOM label = 'Keyword(s)';
    ALTER PROPERTY metadata.keywords CUSTOM comment = 'Custom keywords classifying this record (separated by commas)';
    CREATE INDEX ON metadata (keywords) FULL_TEXT;

CREATE PROPERTY metadata.categories LIST OF STRING (max 4);
    ALTER PROPERTY metadata.categories CUSTOM label = 'Category(s)';
    ALTER PROPERTY metadata.categories CUSTOM comment = 'Controlled keywords classifying this record (max 4)';
    CREATE INDEX ON metadata (categories) NOTUNIQUE;

-- Descriptive Metadata (Mandatory)
CREATE PROPERTY metadata.name STRING (mandatory true, max 255, default '');
    ALTER PROPERTY metadata.name CUSTOM label = 'Title';
    ALTER PROPERTY metadata.name CUSTOM comment = 'Short phrase describing this record (max 255)';
    CREATE INDEX ON metadata (name) FULL_TEXT;

CREATE PROPERTY metadata.creators LIST OF pair (mandatory true, max 255);
    ALTER PROPERTY metadata.creators CUSTOM label = 'Creator(s)';
    ALTER PROPERTY metadata.creators CUSTOM comment = 'Name (max 255) and optional URI identifier of the persons contributing; (max 255)';

CREATE PROPERTY metadata.publisher STRING (mandatory true, min 1, max 255);
    ALTER PROPERTY metadata.publisher CUSTOM label = 'Publisher';
    ALTER PROPERTY metadata.publisher CUSTOM comment = 'Institution or company responsible for first publishing (max 255)';

CREATE PROPERTY metadata.publicationYear LONG (mandatory true, min -9999, max 9999);
    ALTER PROPERTY metadata.publicationYear CUSTOM label = 'Published';
    ALTER PROPERTY metadata.publicationYear CUSTOM comment = 'First year of publication denoted by up to four digits (min -9999, max 9999)';
    CREATE INDEX ON metadata (publicationYear) NOTUNIQUE;

CREATE PROPERTY metadata.resourceType LINK OF attribute (mandatory true);
    ALTER PROPERTY metadata.resourceType CUSTOM label = 'Resource Type';
    ALTER PROPERTY metadata.resourceType CUSTOM comment = 'Primary type of resource';
    CREATE INDEX ON metadata (resourceType) NOTUNIQUE;

CREATE PROPERTY metadata.identifiers LIST OF pair (mandatory true, max 255);
    ALTER PROPERTY metadata.identifiers CUSTOM label = 'Identifier(s)'
    ALTER PROPERTY metadata.identifiers CUSTOM comment = 'Type (max 255) and URI of identifiers; (max 255)';

-- Descriptive Metadata (Optional)
CREATE PROPERTY metadata.synonyms LIST OF pair (max 255);
    ALTER PROPERTY metadata.synonyms CUSTOM label = 'Synonym(s)';
    ALTER PROPERTY metadata.synonyms CUSTOM comment = 'Type (max 255) and title (max 4095) of synonym titles; (max 255)';

CREATE PROPERTY metadata.language LINK OF attribute;
    ALTER PROPERTY metadata.language CUSTOM label = 'Language';
    ALTER PROPERTY metadata.language CUSTOM comment = 'Primary content language';
    CREATE INDEX ON metadata (language) NOTUNIQUE;

CREATE PROPERTY metadata.subjects LIST OF pair (max 255);
    ALTER PROPERTY metadata.subjects CUSTOM label = 'Subject(s)';
    ALTER PROPERTY metadata.subjects CUSTOM comment = 'Classifier (max 255) and URI identifier of subjects; (max 255)';
    CREATE INDEX ON metadata (subjects) NOTUNIQUE;

CREATE PROPERTY metadata.version STRING (max 255);
    ALTER PROPERTY metadata.version CUSTOM label = 'Version';
    ALTER PROPERTY metadata.version CUSTOM comment = 'Short identifier fixing the state (max 255)';

CREATE PROPERTY metadata.license LINK OF pair;
    ALTER PROPERTY metadata.license CUSTOM label = 'License';
    ALTER PROPERTY metadata.license CUSTOM comment = 'SPDX short name of license';
    CREATE INDEX ON metadata (license) NOTUNIQUE;

CREATE PROPERTY metadata.rights STRING (max 65535);
    ALTER PROPERTY metadata.rights CUSTOM label = 'Rights';
    ALTER PROPERTY metadata.rights CUSTOM comment = 'Additional rights agreements (max 65535)';

CREATE PROPERTY metadata.project EMBEDDED OF pair;
    ALTER PROPERTY metadata.project CUSTOM label = 'Project';
    ALTER PROPERTY metadata.project CUSTOM comment = 'Name (max 255) of and URI identifier of overarching project';

CREATE PROPERTY metadata.fundings LIST OF pair (max 255);
    ALTER PROPERTY metadata.fundings CUSTOM label = 'Funding(s)';
    ALTER PROPERTY metadata.fundings CUSTOM comment = 'Award identifier (max 255) and optional funder (max 4095) of fundings; (max 255)';

CREATE PROPERTY metadata.description STRING (mandatory true, max 65535, default '');
    ALTER PROPERTY metadata.description CUSTOM label = 'Description';
    ALTER PROPERTY metadata.description CUSTOM comment = 'Summary of contents and purpose (max 65535)';
    CREATE INDEX ON metadata (description) FULL_TEXT;

CREATE PROPERTY metadata.message STRING (max 65535);
    ALTER PROPERTY metadata.message CUSTOM label = 'Message';
    ALTER PROPERTY metadata.message CUSTOM comment = 'Note about this record (max 65535)';

CREATE PROPERTY metadata.externalItems LIST OF pair (max 255);
    ALTER PROPERTY metadata.externalItems CUSTOM label = 'Link(s)';
    ALTER PROPERTY metadata.externalItems CUSTOM comment = 'Type (max 255) and URI identifier of external related links; (max 255)';

-- Raw Metadata
CREATE PROPERTY metadata.rawType STRING (max 255);
    ALTER PROPERTY metadata.rawType CUSTOM label = 'Raw Format';
    CREATE INDEX ON metadata (rawType) NOTUNIQUE;

CREATE PROPERTY metadata.raw STRING; -- TODO: (max 1048575) TODO: Add Full-Text index, and default value ""
    ALTER PROPERTY metadata.raw CUSTOM label = 'Raw Metadata';

CREATE PROPERTY metadata.rawChecksum STRING (max 255);
    ALTER PROPERTY metadata.rawChecksum CUSTOM label = 'Raw Checksum (md5)';

CREATE PROPERTY metadata.related LIST OF pair (default null);

-- Edges
CREATE EDGE TYPE isRelatedTo;
    CREATE PROPERTY isRelatedTo.`@out` LINK OF metadata;
    CREATE PROPERTY isRelatedTo.`@in` LINK OF metadata;
    ALTER TYPE isRelatedTo CUSTOM olabel = 'Is related to';
    ALTER TYPE isRelatedTo CUSTOM ilabel = 'Is related to';

CREATE EDGE TYPE isNewVersionOf EXTENDS isRelatedTo;
    ALTER TYPE isNewVersionOf CUSTOM olabel = 'Is new version of';
    ALTER TYPE isNewVersionOf CUSTOM ilabel = 'Has new version';

CREATE EDGE TYPE isDerivedFrom EXTENDS isRelatedTo;
    ALTER TYPE isDerivedFrom CUSTOM olabel = 'Is derivation of';
    ALTER TYPE isDerivedFrom CUSTOM ilabel = 'Has derivation';

CREATE EDGE TYPE isPartOf EXTENDS isRelatedTo;
    ALTER TYPE isPartOf CUSTOM olabel = 'Is part of';
    ALTER TYPE isPartOf CUSTOM ilabel = 'Has part';

CREATE EDGE TYPE isSameExpressionAs EXTENDS isRelatedTo; -- Is of same content and format (but differs in identifier or location), like: Book and Ebook
    ALTER TYPE isSameExpressionAs CUSTOM olabel = 'Is same expression as';
    ALTER TYPE isSameExpressionAs CUSTOM ilabel = 'Is same expression as';

CREATE EDGE TYPE isSameManifestationAs EXTENDS isRelatedTo; -- Is of same content (but differs in format or carrier), like: DOI and OADOI
    ALTER TYPE isSameManifestationAs CUSTOM olabel = 'Is same manifestation as';
    ALTER TYPE isSameManifestationAs CUSTOM ilabel = 'Is same manifestation as';

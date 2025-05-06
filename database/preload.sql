-- Language: ArcadeDB SQL, Project: DatAasee, License: MIT, Author: Christian Himpe

IMPORT DATABASE file://preload/categories.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO categories FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/dataformats.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO dataformats FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/externalitems.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO externalitems FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/languages.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO languages FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/licenses.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO licenses FROM (SELECT name, data FROM landing);
DELETE FROM landing;

IMPORT DATABASE file://preload/resourcetypes.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO resourcetypes FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/schemas.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO schemas FROM SELECT name, data FROM landing;
DELETE FROM landing;

IMPORT DATABASE file://preload/synonyms.csv WITH documentType = landing, documentSkipEntries = 1;
INSERT INTO synonyms FROM SELECT name, data FROM landing;
DELETE FROM landing;

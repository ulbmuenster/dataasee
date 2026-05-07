-- Language: ArcadeDB SQL, Project: DatAasee, License: MIT, Author: Christian Himpe

IMPORT DATABASE file://preload/categories.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Categories FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

IMPORT DATABASE file://preload/dataformats.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Dataformats FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

IMPORT DATABASE file://preload/languages.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Languages FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

IMPORT DATABASE file://preload/licenses.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Licenses FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

IMPORT DATABASE file://preload/resourcetypes.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Resourcetypes FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

IMPORT DATABASE file://preload/schemas.csv WITH documentType = Landing, documentSkipEntries = 1;
INSERT INTO Schemas FROM (SELECT name, data FROM Landing);
DELETE FROM Landing;

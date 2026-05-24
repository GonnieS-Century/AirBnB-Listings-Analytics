CREATE DATABASE [Project2];

SELECT *
FROM [listingsv2];

CREATE TABLE [BetterDescription]
(
    ID              BIGINT,
    Name            VARCHAR(MAX),
    Description     VARCHAR(MAX),
    PictureURL      VARCHAR(MAX)
);
-- For merging description and neighborhood data from the raw table
-- without making destructive edits to the source data

SELECT *
FROM [BetterDescription];

INSERT INTO [BetterDescription]
(
    Name
)
SELECT
    name
FROM [listingsv2];
-- Always start by inserting equivalent values into the new table
-- before performing joins

INSERT INTO [BetterDescription]
(
    Name
)
SELECT
    CONVERT(VARCHAR(MAX), name)
FROM [listingsv2];

-- The data type for the Name column in the raw data was NVARCHAR,
-- so a CONVERT statement was necessary

SELECT
    b.ID,
    t.name,
    t.description,
    t.picture_url,
    t.neighborhood_overview
FROM [BetterDescription] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

-- Preview before making the LEFT JOIN update effective

UPDATE b
SET
    b.Name        = t.name,
    b.Description = t.description,
    b.PictureURL  = t.picture_url,
    b.Neighborhood = t.neighborhood_overview
FROM [BetterDescription] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

ALTER TABLE [BetterDescription]
DROP COLUMN Description,
            Neighborhood;

ALTER TABLE [BetterDescription]
ADD Description_New VARCHAR(MAX);

UPDATE [BetterDescription]
SET
    Description_New = CONCAT(Description, ' ', Neighborhood);

-- Merging the Description and Neighborhood Overview columns into one,
-- since they appear to be logically complementary

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'listingsv2';

-- Review the data type of each column to determine
-- whether a CONVERT statement is necessary
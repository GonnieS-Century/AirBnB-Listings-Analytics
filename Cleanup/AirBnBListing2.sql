SELECT *
FROM [listingsv2];

CREATE TABLE [HostInfo]
(
    ID                    BIGINT,
    HostID                INT,
    HostName              VARCHAR(MAX),
    Host_Since            DATE,
    HostLocation          VARCHAR(MAX),
    Host_About            VARCHAR(MAX),
    Host_ResponseTime     VARCHAR(MAX),
    Host_ResponseRate     VARCHAR(MAX),
    Host_SuperHost        BIT
);

SELECT *
FROM [HostInfo];

SELECT
    host_neighbourhood,
    neighbourhood_cleansed
FROM [listingsv2];

INSERT INTO [HostInfo]
(
    ID
)
SELECT
    id
FROM [listingsv2];

-- Starting by inserting IDs into the new table for joining purposes

SELECT
    b.ID,
    t.host_id,
    t.host_name,
    t.host_since,
    t.host_location,
    t.host_about,
    t.host_response_time,
    t.host_response_rate,
    t.host_is_superhost
FROM [HostInfo] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

-- Preview before effective joining

UPDATE b
SET
    b.HostID            = t.host_id,
    b.HostName          = t.host_name,
    b.Host_Since        = t.host_since,
    b.HostLocation      = t.host_location,
    b.Host_About        = t.host_about,
    b.Host_ResponseTime = t.host_response_time,
    b.Host_ResponseRate = t.host_response_rate,
    b.Host_SuperHost    = t.host_is_superhost
FROM [HostInfo] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

UPDATE [HostInfo]
SET
    HostLocation = ''
WHERE HostLocation IS NULL;

UPDATE [HostInfo]
SET
    Host_About = ''
WHERE Host_About IS NULL;

-- Filling in NULL values with blank text for easier discussion
-- with the data provider on how to populate them properly

ALTER TABLE [HostInfo]
ADD Host_Neighborhood VARCHAR(MAX);

UPDATE b
SET
    b.Host_Neighborhood = t.neighbourhood_cleansed
FROM [HostInfo] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.ID;

ALTER TABLE [HostInfo]
ADD Listing_Neighborhood VARCHAR(MAX);

UPDATE b
SET
    b.Listing_Neighborhood = t.neighbourhood_group_cleansed
FROM [HostInfo] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.ID;

-- Adding two columns to the new table since I originally thought
-- they were unnecessary. This may change based on feedback
-- from the data provider.

UPDATE [HostInfo]
SET
    Host_SuperHost = ''
WHERE Host_SuperHost IS NULL;

-- Filling NULL values

SELECT
    CASE
        WHEN Host_SuperHost = 1 THEN 'Yes'
        WHEN Host_SuperHost = 0 THEN 'No'
        ELSE NULL
    END AS Host
FROM [HostInfo];

-- Viewing the 0 and 1 value changes before applying them

ALTER TABLE [HostInfo]
ALTER COLUMN Host_SuperHost VARCHAR(MAX);

-- Changing Host_SuperHost column from BIT to VARCHAR

UPDATE [HostInfo]
SET
    Host_SuperHost =
        CASE
            WHEN Host_SuperHost = 1 THEN 'Y'
            WHEN Host_SuperHost = 0 THEN 'N'
        END;

-- Converting the Boolean values in the column to Y and N
-- for better readability
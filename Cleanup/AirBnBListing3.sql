SELECT *
FROM [listingsv2];

CREATE TABLE [Property]
(
    ID                       BIGINT,
    Host_Total_Listings      INT,
    Host_Verification        VARCHAR(MAX),
    Host_Profile_Pic         BIT,
    Host_Identity_Verified   BIT,
    Listing_Neighborhood     VARCHAR(MAX),
    Latitude                 FLOAT,
    Longitude                FLOAT,
    Property_Info            VARCHAR(MAX),
    Room_Info                VARCHAR(MAX)
);

INSERT INTO [Property]
(
    ID
)
SELECT
    id
FROM [listingsv2];

-- Inserting IDs into the new table before starting the join process

SELECT *
FROM [Property];

SELECT *
FROM [listingsv2];

SELECT
    b.ID,
    t.host_total_listings_count,
    t.host_verifications,
    t.host_has_profile_pic,
    t.host_identity_verified,
    t.neighbourhood_group_cleansed,
    t.latitude,
    t.longitude,
    t.property_type,
    t.room_type
FROM [Property] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

-- Preview before applying the LEFT JOIN update

UPDATE b
SET
    b.ID                     = t.id,
    b.Host_Total_Listings    = t.host_total_listings_count,
    b.Host_Verification      = t.host_verifications,
    b.Host_Profile_Pic       = t.host_has_profile_pic,
    b.Host_Identity_Verified = t.host_identity_verified,
    b.Listing_Neighborhood   = t.neighbourhood_group_cleansed,
    b.Latitude               = t.latitude,
    b.Longitude              = t.longitude,
    b.Property_Info          = t.property_type,
    b.Room_Info              = t.room_type
FROM [Property] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

ALTER TABLE [Property]
ALTER COLUMN Host_Profile_Pic VARCHAR(MAX);

ALTER TABLE [Property]
ALTER COLUMN Host_Identity_Verified VARCHAR(MAX);

UPDATE [Property]
SET
    Host_Profile_Pic =
        CASE
            WHEN Host_Profile_Pic = 1 THEN 'Y'
            WHEN Host_Profile_Pic = 0 THEN 'N'
        END;

-- Changing Host_Profile_Pic values from 0 and 1 to Y and N

UPDATE [Property]
SET
    Host_Identity_Verified =
        CASE
            WHEN Host_Identity_Verified = 1 THEN 'Y'
            WHEN Host_Identity_Verified = 0 THEN 'N'
        END;

-- Changing Host_Identity_Verified values from 0 and 1 to Y and N

ALTER TABLE [Property]
ADD
    Accommodations INT,
    Bathrooms FLOAT,
    Bathroom_Info VARCHAR(MAX),
    Bedrooms INT,
    Beds INT;

-- Adding new columns that are relevant to the Property table

UPDATE b
SET
    b.Accommodations = t.accommodates,
    b.Bathrooms      = t.bathrooms,
    b.Bathroom_Info  = t.bathrooms_text,
    b.Bedrooms       = t.bedrooms,
    b.Beds           = t.beds
FROM [Property] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

ALTER TABLE [Property]
ADD Bathrooms_Updated VARCHAR(MAX);

ALTER TABLE [Property]
ALTER COLUMN Bathrooms_Updated VARCHAR(MAX);

-- Changing the data type of the new column so that Bathrooms
-- and Bathroom_Info can be merged after handling NULL values

UPDATE [Property]
SET
    Bathroom_Info = '0'
WHERE Bathroom_Info IS NULL;

UPDATE [Property]
SET
    Bathroom_Info = '0.5'
WHERE Bathroom_Info IN
(
    'Half-Bath',
    'Shared half-Bath',
    'Private half-bath'
);

-- Filling half-bath entries with 0.5

UPDATE [Property]
SET
    Bathroom_Info = LEFT(
        Bathroom_Info,
        PATINDEX('%[^0-9.]%', Bathroom_Info + 'x') - 1
    )
WHERE Bathroom_Info LIKE '%[0-9]%';

-- Removing all trailing text so that only numeric values remain

UPDATE [Property]
SET
    Bathrooms_Updated = COALESCE(
        CAST(Bathrooms AS VARCHAR(MAX)),
        Bathroom_Info
    );

-- Merging Bathrooms and Bathroom_Info into a single column

ALTER TABLE [Property]
DROP COLUMN Bathrooms,
            Bathroom_Info;

-- Deleting the original columns after the merge

UPDATE [Property]
SET
    Bedrooms = 0
WHERE Bedrooms IS NULL;

UPDATE [Property]
SET
    Beds = 0
WHERE Beds IS NULL;

-- Filling NULL values (subject to change based on feedback
-- from the data provider)

ALTER TABLE [Property]
ALTER COLUMN Bathrooms_Updated DECIMAL(18, 2);

-- Converting Bathrooms_Updated from VARCHAR to DECIMAL

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Property';

-- Reviewing all column data types to confirm they are correct
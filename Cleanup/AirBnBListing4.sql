SELECT *
FROM [listingsv2];

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'listingsv2';

CREATE TABLE [Nights_Spent]
(
    ID                         BIGINT,
    Amenities                  VARCHAR(MAX),
    Price                      MONEY,
    Minimum_Nights             INT,
    Maximum_Nights             INT,
    Minimum_Minimum_Nights     INT,
    Maximum_Minimum_Nights     INT,
    Minimum_Maximum_Nights     INT,
    Maximum_Maximum_Nights     INT,
    Minimum_Nights_Average     FLOAT,
    Maximum_Nights_Average     FLOAT
);

INSERT INTO [Nights_Spent]
(
    ID
)
SELECT
    id
FROM [listingsv2];

UPDATE b
SET
    b.Amenities               = t.amenities,
    b.Price                   = t.price,
    b.Minimum_Nights          = t.minimum_nights,
    b.Maximum_Nights          = t.maximum_nights,
    b.Minimum_Minimum_Nights  = t.minimum_minimum_nights,
    b.Maximum_Minimum_Nights  = t.maximum_minimum_nights,
    b.Minimum_Maximum_Nights  = t.minimum_maximum_nights,
    b.Maximum_Maximum_Nights  = t.maximum_maximum_nights,
    b.Minimum_Nights_Average  = t.minimum_nights_avg_ntm,
    b.Maximum_Nights_Average  = t.maximum_nights_avg_ntm
FROM [Nights_Spent] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

SELECT *
FROM [Nights_Spent];

UPDATE [Nights_Spent]
SET
    Price = 0.00
WHERE Price IS NULL;

-- Filling in NULL values.
-- This default value may be revised based on feedback from the data provider.
SELECT *
FROM [listingsv2];

CREATE TABLE [Clean_Listings]
(
    ID                             BIGINT,
    Name                           VARCHAR(MAX),
    Description                    VARCHAR(MAX),
    PictureURL                     VARCHAR(MAX),

    HostID                         INT,
    HostName                       VARCHAR(MAX),
    Host_Since                     DATE,
    HostLocation                   VARCHAR(MAX),
    Host_About                     VARCHAR(MAX),
    Host_ResponseTime              VARCHAR(MAX),
    Host_ResponseRate              VARCHAR(MAX),
    Host_SuperHost                 BIT,

    Host_Total_Listings            INT,
    Host_Verification              VARCHAR(MAX),
    Host_Profile_Pic               BIT,
    Host_Identity_Verified         BIT,

    Listing_Neighborhood           VARCHAR(MAX),
    Latitude                       FLOAT,
    Longitude                      FLOAT,
    Property_Info                  VARCHAR(MAX),
    Room_Info                      VARCHAR(MAX),

    Amenities                      VARCHAR(MAX),
    Price                          MONEY,

    Minimum_Nights                 INT,
    Maximum_Nights                 INT,
    Minimum_Minimum_Nights         INT,
    Maximum_Minimum_Nights         INT,
    Minimum_Maximum_Nights         INT,
    Maximum_Maximum_Nights         INT,
    Minimum_Nights_Average         FLOAT,
    Maximum_Nights_Average         FLOAT,

    Number_of_Reviews              INT,
    Number_of_Reviews_30d          INT,
    Availability_EndofYear         INT,
    Number_of_Reviews_LastYear     INT,
    Estimated_Occupancy_last365d   INT,
    Estimated_Revenue_last365d     INT,

    First_Review                   DATE,
    Last_Review                    DATE,

    Review_Scores_Rating           FLOAT,
    Review_Scores_Accuracy         FLOAT,
    Review_Scores_Cleanliness      FLOAT,
    Review_Scores_Checking         FLOAT,
    Review_Scores_Comm             FLOAT,
    Review_Scores_Location         FLOAT,
    Review_Scores_Value            FLOAT,

    License                        VARCHAR(MAX),
    Instant_Bookable               BIT,
    Reviews_Monthly                DECIMAL(18,2)
);

SELECT *
FROM [BetterDescription];

SELECT *
FROM [Clean_Listings]
ORDER BY Name ASC;

INSERT INTO [Clean_Listings]
(
    ID
)
SELECT
    ID
FROM [listingsv2];

-- Start by inserting IDs into the clean table before joining datasets

UPDATE b
SET
    b.ID           = t.ID,
    b.Name         = t.Name,
    b.Description  = t.Description_New,
    b.PictureURL   = t.PictureURL
FROM [Clean_Listings] AS b
LEFT JOIN [BetterDescription] AS t
    ON b.ID = t.ID;

ALTER TABLE [Clean_Listings]
ALTER COLUMN Host_SuperHost VARCHAR(MAX);

UPDATE b
SET
    b.HostID             = t.HostID,
    b.HostName           = t.HostName,
    b.Host_Since         = t.Host_Since,
    b.HostLocation       = t.HostLocation,
    b.Host_About         = t.Host_About,
    b.Host_ResponseTime  = t.Host_ResponseTime,
    b.Host_ResponseRate  = t.Host_ResponseRate,
    b.Host_SuperHost     = t.Host_SuperHost
FROM [Clean_Listings] AS b
LEFT JOIN [HostInfo] AS t
    ON b.ID = t.ID;

ALTER TABLE [Clean_Listings]
ALTER COLUMN Host_Profile_Pic VARCHAR(MAX);

ALTER TABLE [Clean_Listings]
ALTER COLUMN Host_Identity_Verified VARCHAR(MAX);

ALTER TABLE [Clean_Listings]
ADD Accomodation INT,
Bedrooms INT,
Beds INT,
Bathrooms DECIMAL(18, 2)

UPDATE b
SET
    b.Host_Total_Listings     = t.Host_Total_Listings,
    b.Host_Verification       = t.Host_Verification,
    b.Host_Profile_Pic        = t.Host_Profile_Pic,
    b.Host_Identity_Verified  = t.Host_Identity_Verified,
    b.Listing_Neighborhood    = t.Listing_Neighborhood,
    b.Latitude                = t.Latitude,
    b.Longitude               = t.Longitude,
    b.Property_Info           = t.Property_Info,
    b.Room_Info               = t.Room_Info,
	b.Accomodation           = t.Accomodations,
	b.Bedrooms                = t.Bedrooms,
	b.Beds					  = t.Beds,
	b.Bathrooms               = t.Bathrooms_updated
FROM [Clean_Listings] AS b
LEFT JOIN [Property] AS t
    ON b.ID = t.ID;

select *
from Clean_Listings

UPDATE b
SET
    b.Amenities              = t.Amenities,
    b.Price                  = t.Price,
    b.Minimum_Nights         = t.Minimum_Nights,
    b.Maximum_Nights         = t.Maximum_Nights,
    b.Minimum_Minimum_Nights = t.Minimum_Minimum_Nights,
    b.Maximum_Minimum_Nights = t.Maximum_Minimum_Nights,
    b.Minimum_Maximum_Nights = t.Minimum_Maximum_Nights,
    b.Maximum_Maximum_Nights = t.Maximum_Maximum_Nights,
    b.Minimum_Nights_Average = t.Minimum_Nights_Average,
    b.Maximum_Nights_Average = t.Maximum_Nights_Average
FROM [Clean_Listings] AS b
LEFT JOIN [Nights_Spent] AS t
    ON b.ID = t.ID;

ALTER TABLE [Clean_Listings]
ALTER COLUMN Instant_Bookable VARCHAR(MAX);

UPDATE b
SET
    b.Number_of_Reviews            = t.Number_of_Reviews,
    b.Number_of_Reviews_30d        = t.Number_of_Reviews_30d,
    b.Availability_EndofYear       = t.Availability_EndofYear,
    b.Number_of_Reviews_LastYear   = t.Number_of_Reviews_LastYear,
    b.Estimated_Occupancy_last365d = t.Estimated_Occupancy_last365d,
    b.Estimated_Revenue_last365d   = t.Estimated_Revenue_last365d,
    b.First_Review                 = t.First_Review,
    b.Last_Review                  = t.Last_Review,
    b.Review_Scores_Rating         = t.Review_Scores_Rating,
    b.Review_Scores_Accuracy       = t.Review_Scores_Accuracy,
    b.Review_Scores_Cleanliness    = t.Review_Scores_Cleanliness,
    b.Review_Scores_Checking       = t.Review_Scores_Checking,
    b.Review_Scores_Comm           = t.Review_Scores_Comm,
    b.Review_Scores_Location       = t.Review_Scores_Location,
    b.Review_Scores_Value          = t.Review_Scores_Value,
    b.License                      = t.License,
    b.Instant_Bookable             = t.Instant_Bookable,
    b.Reviews_Monthly              = t.Reviews_Monthly
FROM [Clean_Listings] AS b
LEFT JOIN [Reviews] AS t
    ON b.ID = t.ID;

-- Cleaning inconsistent characters in listing names
UPDATE [Clean_Listings]
SET Name = REPLACE(Name, '?', '');

UPDATE [Clean_Listings]
SET Host_ResponseRate = 
REPLACE(Host_ResponseRate, '%', '')

UPDATE [HostInfo]
SET Host_ResponseRate = NULL
WHERE Host_ResponseRate = 'N/A'


ALTER TABLE Clean_Listings
ALTER COlUMN Host_ResponseRate INT

ALTER TABLE HostInfo
ALTER COlUMN Host_ResponseRate INT --Converting the N/A values back to null
								   --then changing the column data type appropriately

UPDATE b
SET
    b.Host_ResponseRate  = t.Host_ResponseRate
FROM [Clean_Listings] AS b
LEFT JOIN [HostInfo] AS t
    ON b.ID = t.ID;
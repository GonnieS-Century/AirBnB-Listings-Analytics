SELECT *
FROM [listingsv2];

CREATE TABLE [Reviews]
(
    ID                           BIGINT,
    Number_of_Reviews            INT,
    Number_of_Reviews_30d        INT,
    Availability_EndofYear       INT,
    Number_of_Reviews_LastYear   INT,
    Estimated_Occupancy_last365d INT,
    Estimated_Revenue_last365d   INT,
    First_Review                 DATE,
    Last_Review                  DATE,
    Review_Scores_Rating         FLOAT,
    Review_Scores_Accuracy       FLOAT,
    Review_Scores_Cleanliness    FLOAT,
    Review_Scores_Checking       FLOAT,
    Review_Scores_Comm           FLOAT,
    Review_Scores_Location       FLOAT,
    Review_Scores_Value          FLOAT,
    License                      VARCHAR(MAX),
    Instant_Bookable             BIT,
    Reviews_Monthly              DECIMAL(18,2)
);

INSERT INTO [Reviews]
(
    ID
)
SELECT
    id
FROM [listingsv2];

-- Insert IDs into the new table before performing the join

UPDATE b
SET
    b.Number_of_Reviews             = t.number_of_reviews,
    b.Number_of_Reviews_30d        = t.number_of_reviews_l30d,
    b.Availability_EndofYear       = t.availability_eoy,
    b.Number_of_Reviews_LastYear   = t.number_of_reviews_ly,
    b.Estimated_Occupancy_last365d = t.estimated_occupancy_l365d,
    b.Estimated_Revenue_last365d   = t.estimated_revenue_l365d,
    b.First_Review                 = t.first_review,
    b.Last_Review                  = t.last_review,
    b.Review_Scores_Rating         = t.review_scores_rating,
    b.Review_Scores_Accuracy       = t.review_scores_accuracy,
    b.Review_Scores_Cleanliness    = t.review_scores_cleanliness,
    b.Review_Scores_Checking       = t.review_scores_checkin,
    b.Review_Scores_Comm           = t.review_scores_communication,
    b.Review_Scores_Location       = t.review_scores_location,
    b.Review_Scores_Value          = t.review_scores_value,
    b.License                      = t.license,
    b.Instant_Bookable             = t.instant_bookable,
    b.Reviews_Monthly              = t.reviews_per_month
FROM [Reviews] AS b
LEFT JOIN [listingsv2] AS t
    ON b.ID = t.id;

SELECT *
FROM [Reviews];

UPDATE [Reviews]
SET
    Estimated_Revenue_last365d = 0
WHERE Estimated_Revenue_last365d IS NULL;

UPDATE [Reviews]
SET
    First_Review = '1000-01-01'
WHERE First_Review = '1999-01-01';

-- Filling in NULL values as appropriately as possible.
-- Previously used 1999 as a placeholder for NULL, now replaced with 1000
-- to better highlight missing or unknown data

UPDATE [Reviews]
SET
    Review_Scores_Rating      = COALESCE(Review_Scores_Rating, 0.00),
    Review_Scores_Accuracy    = COALESCE(Review_Scores_Accuracy, 0.00),
    Review_Scores_Cleanliness = COALESCE(Review_Scores_Cleanliness, 0.00),
    Review_Scores_Checking    = COALESCE(Review_Scores_Checking, 0.00),
    Review_Scores_Comm        = COALESCE(Review_Scores_Comm, 0.00),
    Review_Scores_Location    = COALESCE(Review_Scores_Location, 0.00),
    Review_Scores_Value       = COALESCE(Review_Scores_Value, 0.00),
    License                   = COALESCE(License, 'N/A'),
    Reviews_Monthly           = COALESCE(Reviews_Monthly, 0.00)
WHERE
    Review_Scores_Rating IS NULL
    OR Review_Scores_Accuracy IS NULL
    OR Review_Scores_Cleanliness IS NULL
    OR Review_Scores_Checking IS NULL
    OR Review_Scores_Comm IS NULL
    OR Review_Scores_Location IS NULL
    OR Review_Scores_Value IS NULL
    OR License IS NULL
    OR Reviews_Monthly IS NULL;

-- Filling remaining NULL values with default placeholders
-- to ensure consistency across the dataset

ALTER TABLE [Reviews]
ALTER COLUMN Instant_Bookable VARCHAR(MAX);

UPDATE [Reviews]
SET
    Instant_Bookable =
        CASE
            WHEN Instant_Bookable = 1 THEN 'Y'
            WHEN Instant_Bookable = 0 THEN 'N'
        END;

-- Converting Boolean values into Y and N for readability
SELECT *
FROM BnB_Listings

SELECT *
FROM Clean_Listings

SELECT 
Listing_Neighborhood,
COUNT(Listing_Neighborhood) Listing_Count,
CAST(
	ROUND(COUNT(Listing_Neighborhood) * 100.0 / SUM(COUNT(Listing_Neighborhood)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
GROUP BY Listing_Neighborhood --Checking the amount of listings neighborhoods populating the dataset
							  --As well as their percentages

SELECT 
Property_Info,
COUNT(Property_Info) Property_Count,
CAST(
	ROUND(COUNT(Property_Info) * 100.0 / SUM(COUNT(Property_Info)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
GROUP BY Property_Info 
ORDER BY Property_Count DESC --Checking the amount of property information populating the dataset
					         --As well as their percentages, in descending order

SELECT 
Room_Info,
COUNT(Room_Info) Room_Count,
CAST(
	ROUND(COUNT(Room_Info) * 100.0 / SUM(COUNT(Room_Info)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
GROUP BY Room_Info --Checking the amount of room information populating the dataset
				   --As well as their percentages



DECLARE @colu NVARCHAR(MAX);
DECLARE @Prop NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Listing_Neighborhood), ',')
FROM (SELECT DISTINCT Listing_Neighborhood FROM Clean_Listings) AS c;

--Step 2: pivot query

SET @prop = '
SELECT *
FROM (
	SELECT 
	Property_Info,
	Listing_Neighborhood
	FROM Clean_Listings
) AS HoodGroup
PIVOT(
	COUNT(Listing_Neighborhood)
	FOR Listing_Neighborhood IN (' + @colu + ')
) AS PivotNeigh

'
;

--Step 3: Execute

EXEC sp_executesql @prop --Checking the concentration of neighborhood records in relation to the property information




DECLARE @colu NVARCHAR(MAX);
DECLARE @room NVARCHAR(MAX);

--Step 1: dynamic column

SELECT @colu = STRING_AGG(QUOTENAME(Listing_Neighborhood), ',')
FROM (SELECT DISTINCT Listing_Neighborhood FROM Clean_Listings) AS c;

--Step 2: pivot query

SET @room = '
SELECT *
FROM (
	SELECT 
	Room_Info,
	Listing_Neighborhood
	FROM Clean_Listings
) AS HoodGroup
PIVOT(
	COUNT(Listing_Neighborhood)
	FOR Listing_Neighborhood IN (' + @colu + ')
) AS PivotNeigh

'
;

--Step 3: Execute

EXEC sp_executesql @room --Checking the concentration of neighborhood records in relation to the room information

----//----


SELECT
Listing_Neighborhood,
MAX(Bathrooms) Highest_Bathroom,
MIN(Bathrooms) Lowest_Bathrooms,
MAX(Bathrooms) - MIN(Bathrooms) Difference_Bathrooms,
CAST(
	ROUND(
		AVG(Bathrooms), 2) AS DECIMAL(5,2)) Avg_Bathrooms,
COUNT(Bathrooms) All_Bathrooms,
SUM(Bathrooms) AS Sum_of_Bathrooms,
CAST(
	ROUND(COUNT(Bathrooms) * 100.0 / SUM(COUNT(Bathrooms)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
WHERE Bathrooms != 0.00
GROUP BY Listing_Neighborhood

--Finding the maximum and minimum bathrooms populating each neighborhood
--As well as the percentage of recorded numbers, average, sum, and their difference


WITH BathRanked AS (
    SELECT
		ID,
		Listing_Neighborhood,
		Bathrooms,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Bathrooms DESC) AS Bath_top,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Bathrooms ASC)  AS Bath_bottom
    FROM BnB_Listings
	WHERE Bathrooms != 0.00
)
SELECT *
FROM BathRanked
WHERE Bath_top <= 5 OR Bath_bottom <= 5
ORDER BY Listing_Neighborhood --Checking the top and bottom 5 bathrooms records on the dataset per neighborhood



SELECT
'Highest' AS Category,
Bathrooms,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5 Bathrooms,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Bathrooms != 0.00
	ORDER BY Bathrooms DESC
) AS Highest_Baths --Top 5 bathrooms

UNION ALL --Joining top and bottom 5 into one table


SELECT
'Lowest' AS Category,
Bathrooms,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5  Bathrooms,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Bathrooms != 0.00
	ORDER BY Bathrooms ASC
) AS Lowest_Baths --Bottom 5 bathrooms



----//----

SELECT
Listing_Neighborhood,
MAX(Bedrooms) Highest_Bedroom,
MIN(Bedrooms) Lowest_Bedrooms,
MAX(Bedrooms) - MIN(Bedrooms) Difference_Bedrooms,
CAST(
	ROUND(
		AVG(Bedrooms), 2) AS DECIMAL(5,2)) Avg_Bedrooms,
COUNT(Bedrooms) All_Bedrooms,
SUM(Bedrooms) AS Sum_of_Bedrooms,
CAST(
	ROUND(COUNT(Bedrooms) * 100.0 / SUM(COUNT(Bedrooms)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
GROUP BY Listing_Neighborhood

--Finding the maximum and minimum bedrooms populating each neighborhood
--As well as the percentage of recorded numbers, average, sum, and their difference


WITH BedroomRanked AS (
    SELECT
		ID,
		Listing_Neighborhood,
		Bedrooms,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Bedrooms DESC) AS Bedroom_top,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Bedrooms ASC)  AS Bedroom_bottom
    FROM BnB_Listings
	WHERE Bedrooms IS NOT NULL
)
SELECT *
FROM BedroomRanked
WHERE Bedroom_top <= 5 OR Bedroom_bottom <= 5
ORDER BY Listing_Neighborhood --Checking the top and bottom 5 bedrooms records on the dataset per neighborhood


SELECT
'Highest' AS Category,
Bedrooms,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5 Bedrooms,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Bedrooms IS NOT NULL
	ORDER BY Bedrooms DESC
) AS Highest_Baths --Top 5 bedrooms

UNION ALL --Joining top and bottom 5 into one table


SELECT
'Lowest' AS Category,
Bedrooms,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5  Bedrooms,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Bedrooms IS NOT NULL
	ORDER BY Bedrooms ASC
) AS Lowest_bedrooms --Bottom 5 bedrooms


----//----

SELECT
Listing_Neighborhood,
MAX(Beds) Highest_Beds,
MIN(Beds) Lowest_Beds,
MAX(Beds) - MIN(Beds) Difference_Beds,
CAST(
	ROUND(
		AVG(Beds), 2) AS DECIMAL(5,2)) Avg_Beds,
COUNT(Beds) All_Bedrooms,
SUM(Beds) AS Sum_of_Bedrooms,
CAST(
	ROUND(COUNT(Beds) * 100.0 / SUM(COUNT(Beds)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Listings
GROUP BY Listing_Neighborhood --Finding the maximum and minimum beds populating each neighborhood
							  --As well as the percentage of recorded numbers, average, sum, and their difference


WITH BedRanked AS (
    SELECT
		ID,
		Listing_Neighborhood,
		Beds,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Beds DESC) AS Bed_top,
        ROW_NUMBER() OVER (PARTITION BY Listing_Neighborhood ORDER BY Beds ASC)  AS Bed_bottom
    FROM BnB_Listings
	WHERE Beds IS NOT NULL
)
SELECT *
FROM BedRanked
WHERE Bed_top <= 5 OR Bed_bottom <= 5
ORDER BY Listing_Neighborhood --Checking the top and bottom 5 beds records on the dataset per neighborhood


SELECT
'Highest' AS Category,
Beds,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5 Beds,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Beds IS NOT NULL
	ORDER BY Bedrooms DESC
) AS Highest_Baths --Top 5 Beds

UNION ALL --Joining top and bottom into one table


SELECT
'Lowest' AS Category,
Beds,
ID,
Listing_Neighborhood,
Room_info
FROM (
	SELECT
	TOP 5  Beds,
	ID,
	Listing_Neighborhood,
	Room_info
	FROM BnB_Listings
	WHERE Bedrooms IS NOT NULL
	ORDER BY Bedrooms ASC
) AS Lowest_bedrooms --Bottom 5 beds
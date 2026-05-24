SELECT * 
FROM listingsv2 --Raw data

SELECT *
FROM [Clean_Listings] --Main Table

CREATE VIEW BnB_Listings AS (
	SELECT
		ID,
		Listing_Neighborhood,
		Property_Info,
		Room_Info,
		Bathrooms,
		Bedrooms,
		Beds
	FROM [Clean_Listings]
) --Creating view for listing data

CREATE VIEW BnB_Hosts AS (
	SELECT
		ID,
		HostName,
		Host_Since,
		HostLocation,
		Host_About,
		Host_ResponseTime,
		Host_ResponseRate,
		Host_SuperHost,
		Host_Total_Listings,
		Host_Identity_Verified
	FROM [Clean_Listings]
) --Creating view for host data


CREATE VIEW BnB_Metrics AS (
	SELECT
		ID,
		Price,
		Minimum_Nights,
		Maximum_Nights,
		Number_of_Reviews,
		First_Review,
		Last_Review,
		Review_Scores_Rating,
		Instant_Bookable,
		Reviews_Monthly
	FROM [Clean_Listings]
) --Creating view for Metrics data



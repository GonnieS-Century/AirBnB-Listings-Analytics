SELECT *
FROM Clean_Listings

SELECT *
FROM BnB_Hosts

UPDATE b
SET
    b.Host_ResponseRate  = t.Host_ResponseRate
FROM [Clean_Listings] AS b
LEFT JOIN [BnB_Hosts] AS t
    ON b.ID = t.ID;

SELECT 
Host_Superhost, 
COUNT(Host_Superhost) SuperHost_Count,
CAST(
	ROUND(COUNT(Host_Superhost) * 100.0 / SUM(COUNT(Host_Superhost)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS SuperHost_Percentage
FROM BnB_Hosts
GROUP BY Host_Superhost --Checking the count and percentage of superhost statuses


SELECT 
HostLocation,
COUNT(HostLocation) Location_Count,
CAST(
	ROUND(COUNT(HostLocation) * 100.0 / SUM(COUNT(HostLocation)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Percentage_of_Total
FROM BnB_Hosts
WHERE HostLocation != ''
GROUP BY HostLocation
ORDER BY Location_Count DESC --Checking the count and percentage of each distinct host location
					         --Without null values, in descending order


SELECT 
Host_Identity_Verified, 
COUNT(Host_Identity_Verified) Identified_Count,
CAST(
	ROUND(COUNT(Host_Identity_Verified) * 100.0 / SUM(COUNT(Host_Identity_Verified)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Identified_Percentage
FROM BnB_Hosts
GROUP BY Host_Identity_Verified --Checking the count and percentage of hosts' identity statuses 


SELECT 
Host_ResponseTime, 
COUNT(Host_ResponseTime) RT_Count,
CAST(
	ROUND(COUNT(Host_ResponseTime) * 100.0 / SUM(COUNT(Host_ResponseTime)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS RT_Percentage
FROM BnB_Hosts
WHERE Host_ResponseTime IS NOT NULL
GROUP BY Host_ResponseTime --Checking the count and percentage of each distinct response time
						   --in descending order based on the rates with the largest recorded amounts


SELECT 
Host_ResponseRate, 
COUNT(Host_ResponseRate) RR_Count,
CAST(
	ROUND(COUNT(Host_ResponseRate) * 100.0 / SUM(COUNT(Host_ResponseRate)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS RR_Percentage
FROM BnB_Hosts
GROUP BY Host_ResponseRate
ORDER BY RR_Count DESC --Checking the count and percentage of each distinct rate
						--in descending order based on the rates with the largest recorded amounts


SELECT 
CASE 
	WHEN (Host_ResponseRate / 10) * 10 = 100 THEN '100%' --This CASE restricts final table to simply 100%
	ELSE 
		CONCAT(
		(Host_ResponseRate / 10) * 10,
		'% - ',
		((Host_ResponseRate / 10) * 10) + 9,
		'%'
	) END AS Percentile_Range,
COUNT(Host_ResponseRate) RR_Count,
CAST(
	ROUND(COUNT(Host_ResponseRate) * 100.0 / SUM(COUNT(Host_ResponseRate)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS RR_Percentage
FROM BnB_Hosts
GROUP BY (Host_ResponseRate / 10)
ORDER BY RR_Count --Checking the count and percentage of each response rate in 10 percentile increments



SELECT
MAX(Host_Since) Most_Recent,
MIN(Host_Since) Oldest,
DATEDIFF(DAY, MAX(Host_Since), MIN(Host_Since)) Day_Difference,
DATEDIFF(MONTH, MAX(Host_Since), MIN(Host_Since)) Month_Difference,
DATEDIFF(YEAR, MAX(Host_Since), MIN(Host_Since)) Year_Difference
FROM BnB_Hosts


----//----


DECLARE @cols NVARCHAR(MAX);
DECLARE @host  NVARCHAR(MAX);

-- Step 1: Build column list dynamically
SELECT @cols = STRING_AGG(QUOTENAME(y), ',')
FROM (SELECT DISTINCT FORMAT(Host_Since, 'yyyy') AS y FROM BnB_Hosts) d;

-- Step 2: Build the pivot query
SET @host = '
SELECT *
FROM (
    SELECT 
        Host_About,
        FORMAT(Host_Since, ''yyyy'') AS ListYear,
		HostLocation
    FROM BnB_Hosts
) AS source
PIVOT (
    COUNT(Host_About)
    FOR ListYear IN (' + @cols + ')
) AS pvt
ORDER BY HostLocation 
';

-- Step 3: Execute it
EXEC sp_executesql @host; --Checking the amount of yearly records in relation to the location of the hosts



----//----


SELECT 
Host_Total_Listings, 
COUNT(Host_Total_Listings) Total_Count,
CAST(
	ROUND(COUNT(Host_Total_Listings) * 100.0 / SUM(COUNT(Host_Total_Listings)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Total_Percentage
FROM BnB_Hosts
WHERE Host_Total_Listings IS NOT NULL
GROUP BY Host_Total_Listings
ORDER BY Total_Count DESC --Checking the different amount and percentage of total listings recorded
						  --In descending order based on the amount of records total listings


SELECT 
SUM(Host_Total_Listings) All_Total
FROM BnB_Hosts

DECLARE @cols NVARCHAR(MAX);
DECLARE @tot  NVARCHAR(MAX);

-- Step 1: Build column list dynamically
SELECT @cols = STRING_AGG(QUOTENAME(y), ',')
FROM (SELECT DISTINCT FORMAT(Host_Since, 'yyyy') AS y FROM BnB_Hosts) d;

-- Step 2: Build the pivot query
SET @tot = '
SELECT *
FROM (
    SELECT
        HostName,
        FORMAT(Host_Since, ''yyyy'') AS ListYear,
		Host_Total_Listings
    FROM BnB_Hosts
) AS source
PIVOT (
    SUM(Host_Total_Listings)
    FOR ListYear IN (' + @cols + ')
) AS pvt
ORDER BY HostName
';

-- Step 3: Execute it
EXEC sp_executesql @tot; --Checking the amount of hosts' total listing records over the years
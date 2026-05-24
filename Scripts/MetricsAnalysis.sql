SELECT *
FROM BnB_Metrics

SELECT *
FROM Clean_Listings

SELECT *
FROM listingsv2



SELECT
ID,
Price,
Minimum_Nights,
Maximum_Nights,
Minimum_Nights - Maximum_Nights AS Night_Difference
FROM BnB_Metrics --Checking each record of maximum and minimum nights and their difference



SELECT
MAX(Minimum_Nights) Highest_Minimum,
MAX(Maximum_Nights) Highest_Maximum,
MAX(Minimum_Nights) - MAX(Maximum_Nights) Highest_Difference,
MIN(Minimum_Nights) Lowest_Minimum,
MIN(Maximum_Nights) Lowest_Maximum,
MIN(Minimum_Nights) - MIN(Maximum_Nights) Lowest_Difference,
ROUND(AVG(Minimum_Nights), 2) AS Avg_Minimum,
ROUND(AVG(Maximum_Nights), 2) AS Avg_Maximum,
ROUND(AVG(Minimum_Nights), 2) - ROUND(AVG(Maximum_Nights), 2) AS Avg_Difference,
COUNT(Minimum_Nights) All_Minimum,
COUNT(Maximum_Nights) All_Maximum,
SUM(Minimum_Nights) AS Sum_of_Minimum,
SUM(Maximum_Nights) AS Sum_of_Maximum,
SUM(Minimum_Nights) - SUM(Maximum_Nights) AS Sum_of_Difference
FROM BnB_Metrics --Checking the maximum, minimum, average, average, sum, count, and each of their differences
				 --Of all recorded maximum and minimum nights


----//----


SELECT
MAX(Number_of_Reviews) Highest_Number,
MIN(Number_of_Reviews) Lowest_Number,
MAX(Number_of_Reviews) - MIN(Number_of_Reviews) Number_Difference,
ROUND(AVG(Number_of_Reviews), 2) AS Avg_Number,
COUNT(Number_of_Reviews) All_Minimum,
SUM(Number_of_Reviews) AS Sum_of_Minimum
FROM BnB_Metrics 


SELECT 
'Highest' AS Category,
ID,
Number_of_Reviews
FROM(
	SELECT
	TOP 5 Number_of_Reviews,
	ID
	FROM BnB_Metrics
	ORDER BY Number_of_Reviews DESC
) AS Highest_Numbers --Top 5 number of reviews

UNION ALL --Joining tables into one

SELECT
'Lowest' AS Category,
ID,
Number_of_Reviews
FROM(
	SELECT
	TOP 5 Number_of_Reviews,
	ID
	FROM BnB_Metrics
	ORDER BY Number_of_Reviews ASC
) AS Lowest_Numbers --Bottom 5 number of reviews


----//----


SELECT
MIN(First_Review) Oldest_First_Review,
MAX(First_Review) Recent_First_Review,
MIN(Last_Review) Oldest_Last_Review,
MAX(Last_Review) Recent_Last_Review,
COUNT(*) All_Records,
YEAR(First_Review) Year,
MONTH(First_Review) Month
FROM BnB_Metrics 
WHERE First_Review != '1000'
GROUP BY Year(First_Review) ,
MONTH(First_Review) 
ORDER BY Year ASC,
Month ASC --Checking the records populating the table throughout the years and months


SELECT 
First_Review,
Last_Review,
DATEDIFF(MONTH, First_Review, Last_Review) Month_Span_Review,
DATEDIFF(YEAR, First_Review, Last_Review) Year_Span_Review,
DATEDIFF(DAY, First_Review, Last_Review) AS Day_Span_Review
FROM BnB_Metrics
WHERE First_Review != '1000'
GROUP BY First_Review,
Last_Review --Checking the differences in years, months and days between the first and last reviews


----//----


SELECT
MAX(Review_Scores_Rating) Highest_Rating,
MIN(Review_Scores_Rating) Lowest_Rating,
ROUND(AVG(Review_Scores_Rating), 2) Avg_Rating,
COUNT(Review_Scores_Rating) All_Rating,
SUM(Review_Scores_Rating) AS Sum_of_Rating
FROM BnB_Metrics
WHERE Review_Scores_Rating != 0 --Checking highest and lowest rating, as well as average, count of records, and their sum



SELECT
CASE
	WHEN Review_Scores_Rating = 5 THEN '5'
	ELSE CONCAT(
			FLOOR(Review_scores_rating),
			'-',
			FLOOR(Review_scores_rating) + 1
	) END AS Rating_range,
COUNT(Review_Scores_Rating) AS Rating_Count
FROM BnB_Metrics
WHERE Review_Scores_Rating != 0
GROUP BY 
	CASE
		WHEN Review_Scores_Rating = 5 THEN '5'
		ELSE CONCAT(
				FLOOR(Review_scores_rating),
				'-',
				FLOOR(Review_scores_rating) + 1
) END
ORDER BY Rating_Range; --Checking the rating populating the records in increments from 0 to 5


----//----

SELECT 
Instant_Bookable, 
COUNT(Instant_Bookable) Bookable_Count,
CAST(
	ROUND(COUNT(Instant_Bookable) * 100.0 / SUM(COUNT(Instant_Bookable)) OVER (), 2) 
	AS DECIMAL (5,2)
) AS Bookable_Percentage,
ROUND(AVG(Price), 2) Price_Avg,
AVG(Minimum_Nights) Avg_Minimum,
AVG(Maximum_Nights) Avg_Maximum,
ROUND(AVG(Review_Scores_Rating), 2) Avg_Rating
FROM BnB_Metrics
GROUP BY Instant_Bookable --Checking the count, percentage, average price, average maximum/minimum nights spent, and average rating of each distinct instant bookable status
						   --in descending order based on the statuses with the largest recorded amounts


----//----


SELECT
MAX(Reviews_Monthly) Highest_Monthly,
MIN(Reviews_Monthly) Lowest_Monthly,
MAX(Reviews_Monthly) - MIN(Reviews_Monthly) Difference_Monthly,
CAST(
	ROUND(AVG(Reviews_Monthly), 2)
	AS DECIMAL(5,2)) AS Avg_Monthly,
COUNT(Reviews_Monthly) All_Monthly,
SUM(Reviews_Monthly) AS Sum_of_Monthly
FROM BnB_Metrics 
WHERE Reviews_Monthly != 0.00 --Checking the highest and lowest reviews per month, their difference
							  --As well as their average, all records, and their total sum


SELECT
CASE 
	WHEN Reviews_Monthly >= 30 THEN '30+' --This CASE is because the highest value on the table is 30, with just one record
	ELSE CONCAT(
			FLOOR(Reviews_Monthly / 5) * 5,
			'-',
			FLOOR(Reviews_Monthly / 5) * 5 + 5
		) END AS Review_Range,
COUNT(*) AS Review_Count
FROM BnB_Metrics
WHERE Reviews_Monthly <= 30
GROUP BY 
	CASE 
		WHEN Reviews_Monthly >= 30 THEN '30+'
		ELSE CONCAT(
				FLOOR(Reviews_Monthly / 5) * 5,
				'-',
				FLOOR(Reviews_Monthly / 5) * 5 + 5
			) END
ORDER BY Review_Count --Checking the amount of reviews per month populating the table
					  --from 0 to 30, in increments of 5 by 5

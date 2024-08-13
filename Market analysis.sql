CREATE DATABASE proj;
USE proj;

-- Who prefers energy drink more? (male/female/non-binary)?
SELECT Gender,COUNT(Consume_frequency) count_of_pref
FROM repondents
LEFT JOIN responses
ON repondents.Respondent_ID= responses.Respondent_ID
GROUP BY Gender
ORDER BY count_of_pref DESC;

-- Which age group prefers energy drinks more?
SELECT Age, COUNT(Respondent_ID) AS count_of_pref 
FROM repondents
GROUP BY Age
ORDER BY Age;

-- Which type of marketing reaches the most Youth (15-30)
SELECT Marketing_channels,count(responses.Respondent_ID) 
AS count_of_marketing
FROM responses JOIN repondents
ON repondents.Respondent_ID= responses.Respondent_ID
WHERE Age ='15-18'OR Age='19-30'
GROUP BY Marketing_channels
ORDER BY count_of_marketing DESC
LIMIT 1;

-- What are the preferred ingredients of energy drinks among respondents?
SELECT Ingredients_expected, COUNT(Ingredients_expected) AS count_of_pref,
CONCAT(ROUND(COUNT(Ingredients_expected)/
(SELECT COUNT(Ingredients_expected) FROM responses)*100,2),'%')
AS preference_percent 
FROM responses
GROUP BY Ingredients_expected
ORDER BY preference_percent DESC;

-- What packaging preferences do respondents have for energy drinks?
SELECT Packaging_preference, COUNT(Packaging_preference) AS preference_count
FROM responses
GROUP BY Packaging_preference
ORDER BY preference_count DESC;

-- Who are the current market leaders?
SELECT Current_brands, COUNT(Current_brands)pref
FROM responses
GROUP BY Current_brands
ORDER BY pref desc;

-- What are the primary reasons consumers prefer those brands over ours?
SELECT Reasons_for_choosing_brands, COUNT(Reasons_for_choosing_brands)AS reason_count
FROM responses 
GROUP BY Reasons_for_choosing_brands 
ORDER BY reason_count DESC;

-- What do people think about our brand?
SELECT Heard_before,COUNT( Heard_before) count_of_res FROM responses
GROUP BY Heard_before
ORDER BY count_of_res DESC;

SELECT Round(AVG(Taste_experience),1)as avg_rating 
FROM responses 
WHERE Tried_before="Yes";

-- Where do respondents prefer to purchase energy drinks?
SELECT Purchase_location, COUNT(Respondent_ID)AS preference
FROM responses
GROUP BY Purchase_location
ORDER BY preference DESC;

-- Which area of business should we focus more on our product development? (Branding/taste/availability)
SELECT Reasons_preventing_trying, COUNT(Reasons_preventing_trying)AS pref FROM responses
GROUP BY Reasons_preventing_trying
ORDER BY pref DESC;

-- Which cities have the highest percentage of respondents who have heard of the brand before?
with highest_awarness AS
( SELECT City, COUNT(Response_ID)AS response, SUM(CASE WHEN Heard_before="Yes" THEN 1 ELSE 0 END) AS heard_count
FROM responses JOIN repondents ON responses.Respondent_ID= repondents.Respondent_ID 
JOIN cities ON repondents.City_ID= cities.City_ID
Group by City )
SELECT City, (heard_count/ response)*100 AS Percentage_Heard_before
FROM highest_awarness;

-- What Should be the price range of drink according to city?
WITH cte as (
SELECT Price_range, COUNT(Price_range) AS response, City ,
ROW_NUMBER() OVER (PARTITION BY city ORDER BY COUNT(Price_range) DESC) AS rn
FROM responses
JOIN repondents ON responses.Respondent_ID= repondents.Respondent_ID 
JOIN cities ON repondents.City_ID= cities.City_ID
GROUP BY City,Price_range
ORDER BY City, Price_range DESC)
SELECT Price_range, city, response FROM cte  WHERE rn= 1;

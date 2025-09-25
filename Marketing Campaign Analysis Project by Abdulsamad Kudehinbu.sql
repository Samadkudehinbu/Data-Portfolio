-- MARKETING CAMPAIGN ANALYSIS WITH SQL

-- CREATE DATABASE
CREATE DATABASE marketing
USE marketing
GO

-- Dataset was imported as a flatfile with the name marketing_data

-- VIEW FULL DATA 

SELECT *
FROM marketing_data

-- DATA CLEANING

--FILTER OUT 2025 DATES

SELECT *
INTO marketing_new
FROM marketing_data
WHERE YEAR(End_Date) < 2025;


SELECT *
FROM marketing_new;

-- CHECK FOR DUPLICATES

SELECT 
	campaign_id, campaign_manager, channel, country, product_category, impressions, clicks, conversions, spend, revenue, 
    COUNT(*) AS DuplicateCount
FROM marketing_new
GROUP BY campaign_id, campaign_manager, channel, country, product_category, impressions, clicks, conversions, spend, revenue
HAVING COUNT(*) > 1;

-- no duplicates found


-- PAGE 1 - CAMPAIGN PERFORMANCE


-- KEY PERFORMANCE INDICATORS (KPIs)

SELECT 
	YEAR(End_Date) AS Year,
	COUNT(DISTINCT campaign_id) AS No_of_Campaigns,
	SUM(Spend) AS Total_Spend,
	SUM(Revenue) AS Total_Revenue,
	CAST(AVG(ROI) AS DECIMAL (10,2)) AS Average_ROI,
	SUM(Conversions) AS Total_Conversions,
	CAST(AVG(CTR) AS DECIMAL (10,2)) AS Average_CTR
FROM marketing_new
GROUP BY YEAR(End_Date)
ORDER BY Year;

-- REVENUE AND SPEND BY PRODUCT CATEGORY
SELECT 
	Product_Category,
	ROUND(SUM(Revenue)/1000000,2) AS Total_Revenue_In_Millions,
	ROUND(SUM(Spend)/1000000,2) AS Total_Spend_In_Millions
FROM marketing_new
GROUP BY Product_Category
ORDER BY Total_Revenue_In_Millions,Total_Spend_In_Millions DESC;


-- REVENUE BY CHANNEL
SELECT 
	Channel,
	ROUND(SUM(Revenue)/1000000,2) AS Total_Revenue_In_Millions
FROM marketing_new
GROUP BY Channel
ORDER BY Total_Revenue_In_Millions DESC

-- MONTHLY CONVERSION TREND
SELECT 
    DATENAME(MONTH, End_Date) AS Month_Name,
    SUM(CASE WHEN YEAR(End_Date) = 2020 THEN Conversions ELSE 0 END) AS [2020 Conversions],
    SUM(CASE WHEN YEAR(End_Date) = 2021 THEN Conversions ELSE 0 END) AS [2021 Conversions],
    SUM(CASE WHEN YEAR(End_Date) = 2022 THEN Conversions ELSE 0 END) AS [2022 Conversions],
    SUM(CASE WHEN YEAR(End_Date) = 2023 THEN Conversions ELSE 0 END) AS [2023 Conversions],
    SUM(CASE WHEN YEAR(End_Date) = 2024 THEN Conversions ELSE 0 END) AS [2024 Conversions]
FROM marketing_new
WHERE YEAR(End_Date) BETWEEN 2020 AND 2024
GROUP BY DATENAME(MONTH, End_Date), MONTH(End_Date)
ORDER BY MONTH(End_Date);


--NUMBER OF CAMPAIGNS BY TARGET AUDIENCE
SELECT  
    Target_Audience,  
    COUNT(DISTINCT Campaign_ID) AS No_of_Campaigns,  
    CAST(COUNT(DISTINCT Campaign_ID) * 100.0 / 
         (SELECT COUNT(DISTINCT Campaign_ID) FROM marketing_new) AS DECIMAL(5,2)) AS Percentage_of_Total
FROM marketing_new
GROUP BY Target_Audience
ORDER BY No_of_Campaigns DESC;


-- MANAGER CONVERSION INSIGHTS
SELECT 
	Campaign_Manager AS Manager,
	AVG(Conversions) AS Average_Conversions,
	CAST(AVG(Conversion_Rate) AS DECIMAL (5,2)) AS Average_Conversion_Rate
FROM marketing_new
GROUP BY Campaign_Manager
ORDER BY Average_Conversion_Rate DESC



-- PAGE 2 - CHANNEL EFFECTIVENESS


select *
from marketing_new

-- AVERATGE CLICK-THROUGH-RATE BY CHANNEL
SELECT 
	Channel,
	CAST(AVG(CTR) AS DECIMAL (5,2)) AS Avg_CTR
FROM marketing_new
GROUP BY Channel
ORDER BY Avg_CTR DESC


-- AVERATGE CLICK-THROUGH-RATE BY Target Audience
SELECT 
	Target_Audience,
	CAST(AVG(CTR) AS DECIMAL (5,2)) AS Avg_CTR
FROM marketing_new
GROUP BY Target_Audience
ORDER BY Avg_CTR DESC

-- AVERATGE CLICK-THROUGH-RATE BY PRODUCT CATEGORY AND CHANNEL
SELECT 
	Product_Category,
	Channel,
	CAST(AVG(CTR) AS DECIMAL (5,2)) AS Avg_CTR
FROM marketing_new
GROUP BY Product_Category,Channel
ORDER BY Avg_CTR DESC


-- CHANNEL EFFECTIVENESS INSIGHTS TABLE
SELECT
    Channel,
    CAST(AVG(CAST(CPA AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS Avg_CPA,
    CAST(AVG(CAST(CPC AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS Avg_CPC,
    CAST(AVG(CAST(Clicks AS BIGINT)) AS DECIMAL(18,2)) AS Avg_No_of_Clicks,
    CAST(AVG(CAST(Impressions AS BIGINT)) AS DECIMAL(18,2)) AS Avg_No_of_Impressions
FROM marketing_new
GROUP BY Channel
ORDER BY Avg_No_of_Clicks DESC;



-- PAGE 3 - AUDIENCE AND GEOGRAPHICAL INSIGHTS

-- GEOGRAPHICAL PERFORMANCE INSIGHTS TABLE
SELECT
	Country,
	SUM(Spend) AS Spend ,
	SUM(Revenue) AS Revenue,
	CAST(AVG(CAST(CTR AS DECIMAL (10,2))) AS DECIMAL (10,2)) AS Avg_CTR,
	CAST(AVG(CAST(CPA AS DECIMAL (10,2))) AS DECIMAL (10,2)) AS Avg_CPA,
	CAST(AVG(Conversion_Rate) AS DECIMAL (10,2)) AS Avg_Conversion_Rate,
	ROUND (AVG(Conversions),2) AS Avg_Conversions
FROM marketing_new
GROUP BY Country
ORDER BY Revenue;


-- PAGE 4 - GENERAL SUMMARY TABLE

SELECT
	Campaign_Manager AS Manager,
	Channel,
	Country,
	Product_Category AS Category,
	Target_Audience AS Audience,
	SUM(Spend) AS Spend,
	SUM(Revenue) AS Revenue,
	CAST(AVG(ROI) AS DECIMAL (10,2)) AS Avg_ROI,
	Gender,
	AVG(Conversions) AS Avg_Conversions,
	CAST(AVG(Conversion_Rate) AS DECIMAL (10,2)) AS Avg_Conversion_Rate,
	CAST(AVG (CPC) AS DECIMAL (10,2)) AS Avg_CPC,
	CAST(AVG (CPA) AS DECIMAL (10,2)) AS Avg_CPC,
	CAST(AVG (CTR) AS DECIMAL (10,2)) AS Avg_CTR
FROM marketing_new
GROUP BY Campaign_Manager,Channel, Country, Product_Category, Target_Audience, Gender
ORDER BY Revenue DESC


	



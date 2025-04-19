CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

-- ----------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------- Feature Engineering -----------------------------------------------------------

-- time_of_day

SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);

-- day_name
SELECT 
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT 
	date,
    MONTHNAME(date)
FROM sales;


ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);
-- -----------------------------------------------------------------------------------------------------------------------------

-- --------------------- CARDS ----------------------------------

-- ------------------- Total Revenue ----------------------------
SELECT
	ROUND(SUM(total), 2) AS total_revenue 
FROM sales;

-- ------------------ Average Customer Rating --------------------
SELECT
	ROUND(AVG(rating), 2) AS avg_customer_rating
FROM sales;

-- ------------------ Total Transactions --------------------------
SELECT
  COUNT(DISTINCT invoice_id) AS total_transactions
FROM sales;

-- ---------------- Average Transactional Value --------------------
SELECT
	ROUND(SUM(total)/COUNT(invoice_id), 2) AS avg_trans_value
FROM sales;

-- ---------------- Total Value Added Tax --------------------------
SELECT
	ROUND(SUM(VAT), 2) AS total_VAT
FROM sales;

-- --------------- Average Gross Income --------------------------------
SELECT 
	ROUND(AVG(gross_income), 2) AS avg_gross_income
FROM sales;

-- ---------------- VISUALIZATIONS -------------------------------------

-- -- 1. Revenue by Product Line (Which product line generates the most revenue?) ---------------------------------------
SELECT
	product_line,
    ROUND(SUM(total), 2) AS total_revenue
FROM 
	sales
GROUP BY 
	product_line
ORDER BY
	total_revenue DESC;

-- -- 2. Sales Trend by Month (How does sales flunctuate by month?) ------------------------------------------------
SELECT 
	month_name,
	ROUND(SUM(total), 2) AS monthly_revenue,
    COUNT(invoice_id) AS transaction_count
FROM 
	sales
GROUP BY
	month_name
ORDER BY
	CASE month_name
		WHEN 'Janauary' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        ELSE 4
	END;

-- -- 3. Payment Method Preference (What are the most popular payment methods among customers?) 
SELECT 
    payment_method, 
    COUNT(invoice_id) AS transaction_count,
    ROUND(COUNT(invoice_id) * 100.0 / (SELECT COUNT(*) FROM sales), 2) AS percentage
FROM 
    sales
GROUP BY 
    payment_method
ORDER BY 
    transaction_count DESC;

-- -- 4. Time of Day Analysis (When are Sales Higest throughout the day?)
SELECT 
    day_name,
    time_of_day,
    ROUND(SUM(total), 2) AS total_sales,
    COUNT(invoice_id) AS transaction_count
FROM 
    sales
GROUP BY 
    time_of_day, day_name
ORDER BY 
    CASE day_name
        WHEN 'Sunday' THEN 1
        WHEN 'Monday' THEN 2
        WHEN 'Tuesday' THEN 3
        WHEN 'Wednesday' THEN 4
        WHEN 'Thursday' THEN 5
        WHEN 'Friday' THEN 6
        WHEN 'Saturday' THEN 7
    END,
    CASE time_of_day
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;

-- -- 6. City Performance Comparison (How do sales compare across different cities?)
SELECT 
    city,
    branch,
    ROUND(SUM(total), 2) AS total_revenue,
    COUNT(invoice_id) AS transaction_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM 
   sales
GROUP BY 
    city, branch
ORDER BY 
    total_revenue DESC;


-- -- Top 10 Highest Value Transactions --------
SELECT 
    invoice_id,
    city,
    customer_type,
    product_line,
    quantity,
    total,
    rating
FROM 
    sales
ORDER BY 
    total DESC
LIMIT 10;

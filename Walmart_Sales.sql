-- Create database
CREATE DATABASE IF NOT EXISTS walmartproject;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
);

SELECT * FROM sales;

-- -------------------------------------------------------------------------------
-- ---------------------Feature Engineering---------------------------------------
-- time_of_day     

SELECT time, 
       CASE 
           WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
           WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sales; 

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE 
			WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
			WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
			ELSE 'Evening'
	END	
);


-- day_name

SELECT
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name

SELECT 
	date,
    MONTHNAME(date) as month_name
FROM sales;  

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------------------------------
-- Business Questions To Answer
-- -------------------------------------------------------------------------------------------
-- -----------------------------Generic Questions----------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch located?
SELECT DISTINCT city, branch
FROM sales;

-- --------------------------------------------------------------------------------------------
-- -----------------------------Product Questions----------------------------------------------

-- 1. How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;


-- 2. What is the most common payment method?
SELECT payment_method,
	COUNT(payment_method) AS Count_payment_method
FROM sales
GROUP BY payment_method
ORDER BY Count_payment_method DESC;
    
    
-- 3. What is the most selling product line?
SELECT product_line,
	COUNT(product_line) AS Count_product_line
FROM sales
GROUP BY product_line
ORDER BY Count_product_line DESC;    


-- 4. What is the total revenue by month?
SELECT month_name AS Month,
	SUM(total) AS Total_Revenue
FROM sales
GROUP BY month_name
ORDER BY Total_Revenue DESC;   
 

-- 5. What month had the largest COGS?
SELECT month_name AS Month,
	SUM(cogs) AS Total_COGS
FROM sales
GROUP BY month_name
ORDER BY Total_COGS DESC;


-- 6. What product line had the largest revenue?
SELECT product_line,
	SUM(total) AS Total_Revenue
FROM sales
GROUP BY product_line
ORDER BY Total_Revenue DESC;    


-- 7. What is the city with the largest revenue?
SELECT city,branch,
	SUM(total) AS Total_Revenue
FROM sales
GROUP BY city,branch
ORDER BY Total_Revenue DESC;


-- 8. What product line had the largest average VAT?
SELECT product_line,
	AVG(VAT) AS Largest_VAT
FROM sales
GROUP BY product_line
ORDER BY Largest_VAT DESC;


-- 9. Which branch sold more products than average product sold?
SELECT branch,
	SUM(quantity) as QTY
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);    


-- 10. What is the most common product line by gender?
SELECT gender,
	product_line,
    COUNT(gender) AS Total_Count
FROM sales
GROUP BY gender,product_line
ORDER BY Total_Count DESC;
    


-- 11. What is the average rating of each product line?
SELECT product_line,
	ROUND(AVG(rating),2) AS Avg_rating
FROM sales
GROUP BY product_line
ORDER BY AVG(rating) DESC;



-- --------------------------------------------------------------------------------------------
-- -----------------------------Sales Questions------------------------------------------------


-- 1. Number of sales made in each time of the day per weekday
SELECT time_of_day,
	COUNT(quantity) AS Total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY Total_sales DESC;    


-- 2. Which of the customer types brings the most revenue?
SELECT customer_type,
	SUM(total) AS Total_rev
FROM sales
GROUP BY customer_type
ORDER BY Total_rev DESC;    


-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city,
	AVG(VAT) AS AVG_VAT
FROM sales
GROUP BY city
ORDER BY AVG_VAT DESC;


-- 4. Which customer type pays the most in VAT?
SELECT customer_type,
	AVG(VAT) AS AVG_VAT
FROM sales
GROUP BY customer_type
ORDER BY AVG_VAT DESC;


-- --------------------------------------------------------------------------------------------
-- -----------------------------Customer Questions----------------------------------------------

-- 1. How many unique customer types does the data have?
SELECT DISTINCT customer_type, COUNT(customer_type)
FROM sales
GROUP BY customer_type
ORDER BY customer_type DESC;


-- 2. How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;


-- 3. What is the most common customer type?
SELECT customer_type,
	COUNT(customer_type) AS No_of_customers
FROM sales
GROUP BY customer_type
ORDER BY No_of_customers DESC;    


-- 4. Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- 5. What is the gender of most of the customers?
SELECT gender,
	COUNT(gender) AS Count
FROM sales
GROUP BY gender
ORDER BY Count DESC;

    
-- 6. What is the gender distribution per branch?
SELECT branch,gender,
	COUNT(gender) AS Count
FROM sales
GROUP BY branch,gender
ORDER BY branch;

SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
  

-- 7. Which time of the day do customers give most ratings?
SELECT time_of_day,
	COUNT(rating) AS Rating
FROM sales
GROUP BY time_of_day
ORDER BY Rating DESC;  

SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;  


-- 8. Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- 9. Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;


-- 10. Which day of the week has the best average ratings per branch?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name 
ORDER BY avg_rating DESC;








  
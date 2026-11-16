SELECT *
FROM bightlearninstitution.retail.bright_coffee_shop
LIMIT 10;

--Check all columns are in the correct format
SELECT 
    transaction_id,
    unit_price,
    CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS unit_price
FROM bightlearninstitution.retail.bright_coffee_shop;

---Correcting to the correct date format
---SELECT 
    ----DATE_FORMAT(transaction_time, 'HH:mm:ss')AS trans_time
    ----CAST(transaction_time AS TIMESTAMP) AS Trans_time
----FROM bightlearninstitution.retail.bright_coffee_shop;

--Check number of records
SELECT COUNT(*) AS total_records
FROM bightlearninstitution.retail.bright_coffee_shop;

--Check for duplicates(on a row bases and not columns)

SELECT *,
    COUNT(*)
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL
HAVING COUNT(*) > 1;  -- NO DUPLICATES FOUND

--Check for NULL values
SELECT *
FROM bightlearninstitution.retail.bright_coffee_shop
WHERE transaction_id IS NULL OR transaction_date IS NULL OR transaction_time IS NULL OR transaction_qty IS NULL OR store_id IS NULL OR store_location IS NULL OR product_id IS NULL OR unit_price IS NULL OR product_category IS NULL OR product_type IS NULL OR product_detail IS NULL; ---NO NULL VALUES ON THIS DATA



----Outline the calculations to be performed
---Total Amount = unit_price * transaction_qty
----Grouping by 30-minute time intervals
-----Total units sold by product type or detail
------------------------------------------------------------------------------------------------------------------------------------------
---1. TOTAL REVENUE
---Using unit_price * transaction_qty
SELECT
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Amount
FROM bightlearninstitution.retail.bright_coffee_shop;

SELECT              ---This shows total revenue per transaction
    transaction_id,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Amount
FROM bightlearninstitution.retail.bright_coffee_shop;


---2.Total Revenue per category
SELECT
    product_category,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;

--3.Total Revenue per category and produxt details
SELECT
    product_category,
    product_detail,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;

SELECT                      ----Used a WHERE to filter by one specific type.
    product_category,
    product_detail,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
---WHERE product_category = 'Coffee'
GROUP BY ALL
ORDER BY product_category;

--4.Total Revenue per product type
SELECT                      
    product_type,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;

--5.Total Units sold
SELECT
   SUM(transaction_qty) AS Total_units_sold
FROM bightlearninstitution.retail.bright_coffee_shop;

SELECT                      ----Used a WHERE to filter by one specific type.
    product_category,
    product_detail,
   SUM(transaction_qty ) AS Total_units_sold
FROM bightlearninstitution.retail.bright_coffee_shop
WHERE product_category = 'Coffee'
GROUP BY ALL;

--6.Total Revenue per store location
SELECT                      
    store_location,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;



--7.Total Revenue based on the time of the day
--Earliest and latest time for transaction MIN+MAX
SELECT
    MIN(transaction_time),
    MAX(transaction_time)
FROM bightlearninstitution.retail.bright_coffee_shop;

--6am - 11:59:59 > morning
--12pm - 16:59:59 > Afternoon
--17pm - 19:59:59 > Evening
--After 20:00 > Night

SELECT   
    ---transaction_time,                   --Once you introduce aggregation you need to GROUP BY ALL but cannot group transaction_time
    ---product_category,
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ElSE 'Night'
    END AS Time_bucket,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;

--Example on finding the hour or time of the day with the most transactions
SELECT   
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ElSE 'Night'
    END AS Time_bucket,
   COUNT (transaction_id) AS Total_transaction
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;

--7. Date extraction(Month name,month_id,day_name)
SELECT
    transaction_date,
    MONTHNAME(transaction_date)AS Month_name,
    MONTH(transaction_date) AS month_number,
    DATE_FORMAT(transaction_date, 'yyyy-MM') AS Month_id,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_number
FROM bightlearninstitution.retail.bright_coffee_shop

--------------------------------------------------------------------------------------------------------------------------------------

---COMBINE ALL THE CODES

SELECT  
    transaction_id,
    transaction_date,
    YEAR(transaction_date)AS year,
    MONTHNAME(transaction_date)AS Month_name,
    MONTH(transaction_date) AS month_number,
    DATE_FORMAT(transaction_date, 'yyyy-MM') AS Month_id,
    DAYNAME(transaction_date) AS day_name,
    DAYOFWEEK(transaction_date) AS day_number,
    product_category,
    product_type,
    product_detail,
    store_location,
    CASE
        WHEN transaction_time BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
        WHEN transaction_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon'
        WHEN transaction_time BETWEEN '17:00:00' AND '19:59:59' THEN 'Evening'
        ElSE 'Night'
    END AS Time_bucket,
   COUNT (transaction_id) AS Total_transaction,
   SUM(transaction_qty ) AS Total_units_sold,
   SUM(transaction_qty *CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2))) AS Total_Revenue
FROM bightlearninstitution.retail.bright_coffee_shop
GROUP BY ALL;









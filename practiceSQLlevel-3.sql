/**
SQL window functions are powerful tools for performing calculations across sets of table rows 
that are related to the current row. They are often used in various business scenarios to provide insights and analytics. 
Here are some common business cases where SQL window functions are particularly useful
**/

-- [1]. **Running Totals and Cumulative Sums**
-- **Use Case:** Calculate a running total of sales over time.
-- **Explanation:** This query provides a running total of sales, which is useful for financial analysis and reporting.
-- **This query has limitation. When sale dates are same, the running total is not sequetial. 
-- Rather multiple sale amounts for the same date are taken and summed up as one. Fix this by adding another column to rank the sale date
-- and the calculate the running total

SELECT saledate, totalamount, 
       SUM(totalamount) OVER (ORDER BY saledate) AS running_total
FROM sales;


-- [2]. **Ranking and Row Numbering**
-- **Use Case:** Rank products by their sales performance to each customer.
-- **Explanation:** This query ranks products for each customer based on their sales amount.

SELECT s.ProductID, p.productname, s.customerid, c.customername, s.totalamount,
       RANK() OVER (PARTITION BY s.customerid ORDER BY s.totalamount DESC) AS sales_rank,
	   DENSE_RANK() OVER (PARTITION BY s.customerid ORDER BY s.totalamount DESC) AS sales_rank_dense,
	   ROW_NUMBER() OVER (PARTITION BY s.customerid ORDER BY s.totalamount DESC) AS sales_rank_rownum
FROM Products p
inner JOIN sales s ON p.productid = s.ProductID
inner join customers c on c.customerid = s.customerid;


-- [3]. **Moving Averages**
-- **Use Case:** Calculate a 3-month moving average of sales.
-- **Explanation:** This query computes a moving average, which helps smooth out short-term fluctuations and highlight longer-term trends in sales data.

SELECT saledate, totalamount,
       AVG(totalamount) OVER (ORDER BY saledate 
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales;


-- [4]. **Year-over-Year Comparisons**
-- **Use Case:** Compare sales from the same period in the previous year.
-- **Explanation:** This query compares the current sales to the sales from the same month in the previous year, which is useful for performance analysis.

SELECT saledate, totalamount,
       LAG(totalamount, 12) OVER (ORDER BY saledate) AS prev_year_sales
FROM sales;


-- [5]. **Percentile Ranks**
-- **Use Case:** Determine the percentile rank of employees based on their salaries.
-- **Explanation:** This query calculates the percentile rank of each employee based on their salary, which can be used for compensation analysis.

SELECT employeeid, employeename, salary,
       PERCENT_RANK() OVER (ORDER BY salary) AS salary_percentile
FROM employees;


-- [6]. **Lead and Lag Analysis**
-- **Use Case:** Analyze sales trends by comparing current sales with previous and next periods.
-- **Explanation:** This query helps identify trends by comparing each period's sales with the previous and next periods.

SELECT saledate, totalamount,
       LAG(totalamount) OVER (ORDER BY saledate) AS prev_totalamount,
       LEAD(totalamount) OVER (ORDER BY saledate) AS next_totalamount
FROM sales;

-- [7]. **Partitioned Aggregates**
-- **Use Case:** Calculate total sales and average sales per product.
-- **Explanation:** This query provides aggregate sales metrics within each department, useful for departmental performance reviews.

SELECT s.productid, p.productname, s.customerid, c.customername, s.totalamount,
       SUM(totalamount) OVER (PARTITION BY s.productid) AS total_sales,
       AVG(totalamount) OVER (PARTITION BY s.productid) AS avg_sales
FROM products p
JOIN sales s ON p.productid = s.productid
inner join customers c on c.customerid = s.customerid;


-- [8]. **Cumulative Distribution and NTile**
-- **Use Case:** Divide customers into performance quartiles based on their sales.
-- **Explanation:** This query distributes customers into quartiles based on their sales performance, 
-- which can be useful for campaigns and incentives.

SELECT c.customerid, c.customername, s.totalamount,
       NTILE(4) OVER (ORDER BY totalamount DESC) AS performance_quartile
FROM customers c
JOIN sales s ON c.customerid = s.customerid;

-- [9. **First and Last Value**
-- **Use Case:** Find the first and last sale amounts for each customer.
-- **Explanation:** This query provides the first and last sale amounts for each customer, which can help analyze customer purchase behavior over time.

SELECT customerid, saledate, totalamount,
       FIRST_VALUE(totalamount) OVER (PARTITION BY customerid ORDER BY saledate) AS first_totalamount,
       LAST_VALUE(totalamount) OVER (PARTITION BY customerid ORDER BY saledate 
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_totalamount
FROM sales;

-- [10]. **Windowed Aggregates for Specific Ranges**
-- **Use Case:** Calculate the total sales for the current month and the previous month.
-- **Explanation:** This query provides a rolling sum of sales for the current and previous months, helping in monthly sales comparisons.

SELECT saledate, totalamount,
       SUM(totalamount) OVER (ORDER BY saledate 
                              ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS two_month_total
FROM sales;


-- [11]. **Calculating the Difference from the Previous Value**
-- **Use Case:** Calculate the month-over-month change in sales.
-- **Explanation:** This query calculates the change in sales from the previous month, useful for identifying trends and growth.

SELECT saledate, totalamount,
       totalamount - LAG(totalamount) OVER (ORDER BY saledate) AS month_over_month_change
FROM sales;

-- [12]. **Cumulative Sales per Customer**
-- **Use Case:** Calculate the cumulative sales amount for each customer.
-- **Explanation:** This query provides a running total of sales for each customer over time, useful for tracking customer value.

SELECT customerid, saledate, totalamount,
       SUM(totalamount) OVER (PARTITION BY customerid ORDER BY saledate) AS cumulative_sales
FROM sales;

-- [13]. **Rolling Average Sales per Product**
-- **Use Case:** Calculate a 3-month rolling average of sales for each product.
-- **Explanation:** This query computes a rolling average for sales of each product over the last three months.

SELECT productid, saledate, totalamount,
       AVG(totalamount) OVER (PARTITION BY productid ORDER BY saledate 
                              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM sales;

-- [14. **Finding Top-N Records within a Group**
-- **Use Case:** Find the top 3 highest sales per product.
-- **Explanation:** This query identifies the top 3 highest sales amounts for each product.

SELECT productid, saleid, totalamount,
       RANK() OVER (PARTITION BY productid ORDER BY totalamount DESC) AS sales_rank
FROM sales
WHERE RANK() OVER (PARTITION BY productid ORDER BY totalamount DESC) <= 3;

-- [15]. **Percentage of Total Sales per Product**
-- **Use Case:** Calculate the percentage contribution of each sale to the total sales of the product.
-- **Explanation:** This query calculates the percentage of each sale's contribution to the total sales for the product.

SELECT productid, saleid, totalamount,
       totalamount * 100.0 / SUM(totalamount) OVER (PARTITION BY productid) AS percentage_of_total
FROM sales;

-- [16]. **Identifying the First Purchase Date per Customer**
-- **Use Case:** Find the first purchase date for each customer.
-- **Explanation:** This query identifies the date of the first purchase made by each customer.

SELECT customerid, saledate, totalamount,
       MIN(saledate) OVER (PARTITION BY customerid) AS first_purchase_date
FROM sales;

-- [17]. **Average Sales Amount in the Same Period Last Year**
-- **Use Case:** Calculate the average sales amount for the same period last year.
-- **Explanation:** This query calculates the average sales amount for the same period in the previous year.

SELECT saledate, totalamount,
       AVG(totalamount) OVER (ORDER BY saledate 
                              RANGE BETWEEN INTERVAL '1' YEAR PRECEDING AND INTERVAL '1' YEAR PRECEDING) AS avg_sales_last_year
FROM sales;

-- [18]. **Sales Growth Rate**
-- **Use Case:** Calculate the sales growth rate compared to the previous month.
-- **Explanation:** This query calculates the growth rate of sales compared to the previous month, expressed as a percentage.

SELECT saledate, totalamount,
       (totalamount - LAG(totalamount) OVER (ORDER BY saledate)) * 100.0 / LAG(totalamount) OVER (ORDER BY saledate) AS growth_rate
FROM sales;

-- [19]. **Comparing the current value with the value in the preceeding row**
-- **Use Case:** Finidng the time gap between hiring of each employee.
-- **Explanation:** This query finds the difference between the hiring date of an employee and the hiring date of the employee 
-- who joined just before him/her



-- [20]. **Finding the Most Recent Sale per Customer**
-- **Use Case:** Identify the most recent sale for each customer.
-- **Explanation:** This query finds the most recent sale date for each customer.

SELECT customerid, saleid, saledate, totalamount,
       MAX(saledate) OVER (PARTITION BY customerid) AS most_recent_saledate
FROM sales;
Create database SQL_Project;
use SQL_Project;
select * from retail_sales;
SELECT COUNT(*) FROM retail_sales;
select count(distinct customer_id) from retail_sales;

alter table retail_sales rename column ï»¿transactions_id to Transaction_ID;
alter table retail_sales rename column quantiy to Quantity;

/*----Check Duplicates----*/
select Transaction_ID,sale_date,sale_time,customer_id,gender,price_per_unit,category,count(*) 
from retail_sales 
group by Transaction_ID,sale_date,sale_time,customer_id,gender,price_per_unit,category
having count(*) > 1;

select * from retail_sales
where sale_date is null or sale_time is null or customer_id is null
or category is null or age is null or gender is null or Quantity is null
or price_per_unit is null or cogs is null or total_sale is null;

delete from retail_sales
where sale_date is null or sale_time is null or customer_id is null
or category is null or age is null or gender is null or Quantity is null
or price_per_unit is null or cogs is null or total_sale is null;

#----Data Analysis-----

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022

select transaction_ID,sale_date,Category,Quantity from retail_sales where category = 'Clothing' and quantity >= 4 
and concat(year(sale_date),"-",month(sale_date)) = '2022-11' order by Sale_date;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select Category, sum(Total_sale) from retail_sales Group by Category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select category,round(avg(age),2) as Avg_Age from retail_sales where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select Gender,Category,count(Transaction_id) from retail_sales group by Gender,Category order by 2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from (
select year(sale_date),monthname(sale_date),avg(total_sale),
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as Rank_Mon
from retail_sales 
group by year(sale_date),monthname(sale_date)) as RankMon_Table
where Rank_Mon = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(Total_sale) from retail_sales group by customer_id order by sum(total_sale) desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as UniQueCust from retail_sales group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with Hourly_Shift
as(
select *,
	case when sale_time <= '12:00:00' then 'Morning'
		 when sale_time between '12:00:00' and '17:00:00' then 'Afternoon'
         else 'Evening'
	end as Shifts
from retail_sales)
select shifts,count(total_sale) from Hourly_Shift group by Shifts;
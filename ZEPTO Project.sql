create database Zepto;

select * from zepto_v2;

select ï»¿Category as category from zepto_v2;

-- data exploration

-- count of rows
select count(*) as Number_of_Rows from zepto_v2;

-- sample data
select * from zepto_v2
limit 10;

-- null values
select * from zepto_v2
where name is null
or
mrp is null
or
ï»¿Category  is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

-- different product categories

select distinct ï»¿Category as category
from zepto_v2
order by ï»¿Category;


-- product in stock vs out of stock
select outOfStock, count(*) as Count
from zepto_v2
group by outofstock;

-- product name present multiple times
select name, count(*) as count_of_times
from zepto_v2
group by name
order by count(*) desc;

-- Data cleaning 
-- Changing category name
    ALTER TABLE zepto_v2
    RENAME COLUMN ï»¿Category TO category;
   
-- product with price = 0
select * from zepto_v2
where mrp = 0 or discountedSellingPrice = 0;

set sql_safe_updates=0;

delete from zepto_v2
where mrp = 0; 

-- convert paise to rupees
update zepto_v2
set mrp = mrp/100, discountedsellingprice = discountedSellingPrice/100;


select * from zepto_v2;

-- Business Question and insights
-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name, mrp, discountpercent
from zepto_v2
order by discountPercent desc
limit 10;

-- Q2.What are the Products with High MRP but Out of Stock
select distinct name, mrp 
from zepto_v2
where outOfStock = 'True' and mrp > 300
order by mrp desc;

-- Q3.Calculate Estimated Revenue for each category
select category, sum(discountedsellingprice * availableQuantity)
as Total_revenue
from zepto_v2
group by category
order by Total_revenue desc;

-- Q4. Find all products where MRP is greater than <500 and discount is less than 10%.
select distinct name, mrp, discountpercent 
from zepto_v2
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discountpercent),2) as Avg_Discount
from zepto_v2
group by category 
order by Avg_Discount desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name, weightinGms, discountedSellingPrice, 
round(discountedSellingPrice/weightinGms,2) as Price_per_gram
from zepto_v2
where weightInGms >= 100
order by Price_per_gram
;

-- Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name, weightingms,
case when weightInGms < 1000 then 'Low'
     when weightInGms < 5000 then 'Medium'
     else 'Bluk'
     end as Weight_Category
From zepto_v2;


-- Q8.What is the Total Inventory Weight Per Category
select category, 
sum(weightInGms * availableQuantity) as Total_Weight
from zepto_v2
group by category
order by Total_Weight;

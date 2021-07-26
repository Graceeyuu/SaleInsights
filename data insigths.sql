-- A computer hardware business in India, which is facing challenges in dynamically changing market. --
-- Plan to invest a data analysis project to provide some data insights --
-- Part 1: Data Exporation --  


-- Have a check of each table first  --
select * from sales.customers;
select * from sales.transactions;
select * from sales.products;
select * from sales.markets;
select * from sales.date;


-- Number of product in each product type --
select count(*), product_type from sales.products
group by product_type;

-- Compare the total sales_amount of each year --
-- Use this to create View 1 -- 
select sum(sales_amount), year 
from sales.transactions t join sales.date d 
on t.order_date = d.date
where  sales_amount >= 0 
group by year;

-- Filter out the negative amount and region that is not in India  --
-- Use this to create View 1 -- 
select t.*, m.* from sales.transactions t join sales.markets m on 
t.market_code = m.markets_code
where markets_name not in ('New York', 'Paris') 
and sales_amount >= 0;

-- Sales by region (zone and city) -- 
select sum(sales_amount), zone from sales.transactions t join sales.markets m 
on t.market_code = m.markets_code
and sales_amount >= 0
group by zone;

select sum(sales_amount), markets_name from sales.transactions t right join sales.markets m
on t.market_code = m.markets_code
where sales_amount >= 0 
and markets_code not in ('New York', 'Paris')
group by 2
order by 1 desc;

-- Sales trend analysis --
-- View 2 --
-- This mothed very hard to order -- 
select sum(sales_amount) as Total_sales, month_name, year
from sales.transactions t join sales.date d 
on t.order_date = d.date
where  sales_amount >= 0 
group by 3, 2
order by 3 desc, 2 desc;

-- Or --
select sum(sales_amount) as Total_sales, cy_date
from sales.transactions t join sales.date d 
on t.order_date = d.date
where  sales_amount >= 0 
group by 2
order by 2 desc;

-- Sale to date analysis: 
-- City -- 
select sum(sales_amount) as Total_sales, cy_date, markets_code, markets_name
from sales.transactions t join sales.date d join sales.markets m
on t.order_date = d.date and t.market_code=m.markets_code
where  sales_amount >= 0 
group by 3, 2
order by 2 desc, 1 desc;

-- 

-- Analysis product performance: 
-- measure by sale_quantity  
select sum(sales_qty) as sale_pro_quantity, p.product_code, product_type
from sales.transactions t right join sales.products p
on t.product_code = p.product_code
group by 2
order by 1 desc;

-- measure by sale_amount -- 
select sum(sales_amount) as Total_amount, p.product_code, product_type
from sales.transactions t right join sales.products p
on t.product_code = p.product_code
group by 2
order by 1 desc;

-- Popular product type -- 
select sum(sales_amount) as Total_amount, product_type
from sales.transactions t join sales.products p
on t.product_code = p.product_code
group by 2
order by 1 desc;

-- Average purchase value -- 
select sum(sales_amount)/sum(sales_qty) as average_per_unit, p.product_code
from sales.transactions t join sales.products p
on t.product_code = p.product_code
where sales_amount > 0
group by 2
order by 1 desc;

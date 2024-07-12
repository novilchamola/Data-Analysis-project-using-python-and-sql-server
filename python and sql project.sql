--After cleaning the data in python, we are answering some of the business related questions.


-- find Top 10 highesht revenue generating products
go

select Top 10 product_id,sum(sale_price) as total_revenue from df_orders
group by product_id
order by total_revenue desc;

go


-- find top 5 highest selling products in each region.
with CTE as (
select region,product_id,sum(sale_price) as total_revenue from df_orders
group by region,product_id)

select* from (
select *,
row_number() over(partition by region order by total_revenue desc) as Top_5
from cte) A
where Top_5<=5;


go

-- find month over month growth comparison for 2022 and 2023 sales eg. jan 2022 vs jan 2023.
	with cte as (
	select year(order_date) as order_year,month(order_date) as order_month,sum(sale_price) as sales from df_orders
	group by  year(order_date),month(order_date) )
	--order by year(order_date),month(order_date)

	select order_month,
	sum(case when order_year=2022 then sales else 0 end) as sales_2022,
	sum(case when order_year=2023 then sales else 0 end) as sales_2023
	from cte
	group by order_month
	order by order_month

Go

-- for each category which month had highest sales.
select * from df_orders;

with cte as (
select category,format(order_date,'yyyyMM') as order_year_month,sum(sale_price) as sales from df_orders
group by category,format(order_date,'yyyyMM')
--order by month(order_date),total_sales desc;
)
select * from (
select *, row_number() over(partition by category order by sales desc) as ranks

from cte) A
where ranks=1;

Go

-- Which sub-category has the highest growth by profit in 2023 compare to 2022.
select * from df_orders;

with cte as (
	select sub_category,year(order_date) as order_year,sum(sale_price) as sales from df_orders
	group by sub_category,year(order_date) 
	)
	,cte2 as
	(
	select sub_category,
	sum(case when order_year=2022 then sales else 0 end) as sales_2022,
	sum(case when order_year=2023 then sales else 0 end) as sales_2023
	from cte
	group by sub_category
	)
	select Top 1*, 
	(sales_2023-sales_2022)*100/sales_2022 as growth_percentage
    from cte2 
	order by (sales_2023-sales_2022)*100/sales_2022 desc




select * from df_orders;
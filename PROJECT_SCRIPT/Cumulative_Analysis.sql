select
order_year,
total_Sales,
sum(total_Sales) over (order by order_year) as running_total_sales,
avg(avg_price) over (order by order_year) as moving_avg_price
from
(
select 
datetrunc(year,order_date) order_year,
sum(sales_amount) as total_Sales,
avg(price) as avg_price
from gold.fact_sales
where order_date is not null
group by datetrunc(year,order_date)
) t;

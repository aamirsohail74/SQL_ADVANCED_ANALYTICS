select
year(order_date) as order_year,
month(order_date) as order_month,sum(sales_amount) total_sales,
count(distinct customer_key) as Total_customers,
sum(quantity) total_quantity
from gold.fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order  by year(order_date) ,month(order_date) asc;


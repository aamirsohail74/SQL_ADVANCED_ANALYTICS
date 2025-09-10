with yearly_product_sales as(
select 
year(f.order_date) as order_year,
p.product_name,
sum(f.sales_amount) as current_sales from 
gold.fact_sales f
left join gold.dim_products p
ON f.product_key=p.product_key 
where f.order_date is not null
group by year(f.order_date),p.product_name
)

select 
order_year,
product_name,
current_sales,
avg(current_sales) over (partition by product_name) avg_sales,
current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name)>0 then 'ABOVE AVG'
	when current_sales - avg(current_sales) over (partition by product_name)<0 then 'BELOW AVG'
	else 'avg'
end avg_change,
lag(current_sales) over (partition by product_name order by order_year) as PY_Sales,
current_sales -lag(current_sales) over (partition by product_name order by order_year) as diff_py,
case when current_sales- lag(current_sales) over (partition by product_name order by order_year) > 0 then 'INCREASE'
	 when current_sales-lag(current_sales) over (partition by product_name order by order_year) <0 then 'decrease'
		else 'no change'
	end Py_change



from yearly_product_sales
order by product_name,order_year

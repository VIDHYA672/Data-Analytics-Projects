SELECT TOP (1000) [order_number]
      ,[product_key]
      ,[customer_key]
      ,[order_date]
      ,[shipping_date]
      ,[due_date]
      ,[sales_amount]
      ,[quantity]
      ,[price]
  FROM [star].[dbo].[gold.fact_sales]

  select * from [gold.fact_sales]

  select count(*) from [gold.fact_sales]

  select order_date,sales_amount from [gold.fact_sales]
  where order_date is not null order by order_date
  SELECT DISTINCT 
    country 
FROM [gold.dim_customers]
ORDER BY country;


   select year(order_date)as order_year1,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,
   count(distinct customer_key)as total_customer
   from [gold.fact_sales]
   where order_date is not null
   group by year(order_date)
   order by year(order_date)


select year(order_date)as order_year,
month(order_date)as order_month,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,
   count(distinct customer_key)as total_customer
   from [gold.fact_sales]
   where order_date is not null
   group by month(order_date),year(order_date)
   order by month(order_date),year(order_date)

                 
select datetrunc(year,order_date)as order_date,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,
   count(distinct customer_key)as total_customer
   from [gold.fact_sales]
   where order_date is not null
   group by datetrunc(year,order_date)
   order by datetrunc( year,order_date)

select format(order_date, 'yyyy-MMM')as order_date,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,
   count(distinct customer_key)as total_customer,
   SUM(quantity)as total_quantity                                ------change-over analaysis-------
   from [gold.fact_sales]
   where order_date is not null
   group by format(order_date, 'yyyy-MMM')
   order by total_sales desc

   order by format(order_date, 'yyyy-MMM') 
---------------------------------------------------------------------------------------------------------
select month_qw,
       total_sale_per_month,
       sum(total_sale_per_month) over(order by month_sort) as runningsales
from (
    select 
        format(order_date,'yyyy-MMM') as month_qw,
        year(order_date) * 100 + month(order_date) as month_sort,  -- numeric for ordering
        cast(sum(sales_amount) as decimal(10,2)) as total_sale_per_month
    from [gold.fact_sales]
    group by format(order_date,'yyyy-MMM'),
             year(order_date) * 100 + month(order_date)
) t
order by month_sort;



    
--------------------------------------------------------------------------------

    select order_dates,total_sales,
  sum( total_sales) over(order by order_dates) as running_sales
    from(

    select datetrunc(year,order_date)as order_dates,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,
   count(distinct customer_key)as total_customer
   from [gold.fact_sales]
   where order_date is not null
   group by datetrunc(year,order_date)
   
   )t
-===========================================================================
select order_dates,total_sales,
    sum(total_sales) over( partition by order_dates order by order_dates) as running_sales,
      avg(avg_sales) over( partition by order_dates order by order_dates) as avg_running_sales
    from(

    select datetrunc(year,order_date)as order_dates,
   cast(sum(sales_amount)as decimal(10,2))
   as total_sales,                                        ------cumulative analaysis-------
   count(distinct customer_key)as total_customer,
   avg(sales_amount)as avg_sales
   from [gold.fact_sales]
   where order_date is not null
   group by datetrunc(year,order_date)
   
   )t
-----------------------------------------------------------------------------------------------------
select * from [gold.fact_sales]
select * from [gold.dim_products]



select product_name,
DATETRUNC(year,start_date) as year_wise_product
from [gold.dim_products]
group by DATETRUNC(year,start_date),product_name
order by DATETRUNC(year,start_date)



select
year(g.order_date)as order_year,f.product_name,
sum(sales_amount)as current_sales
from  [gold.dim_products]    f
left join
[gold.fact_sales]    g
on  f.product_key=g.product_key
where order_date is not null
group by year(g.order_date),(f.product_name)
-------------------------------------------------------

WITH   yearly_product_sales AS
(
select
year(g.order_date)as order_year,f.product_name,
sum(sales_amount)as current_sales
from  [gold.dim_products]    f
left join
[gold.fact_sales]    g
on  f.product_key=g.product_key
where order_date is not null
group by year(g.order_date),
(f.product_name) 
) 
select  
order_year,
product_name,
current_sales,avg(current_sales) over(partition by product_name) as avg_sales,
current_sales-avg(current_sales) over(partition by product_name) as difference_avg,
case when current_sales-avg(current_sales) over(partition by product_name)
>0 then 'above average'
when current_sales-avg(current_sales) over(partition by product_name) 
<0 then 'below avgerage'
else 'avg'---------------------------------------------/* analyze the yearly performance of products by comparing their sales to both the averagesales performance of the product and the previous year's sales*/
end avg_change,
lag(current_sales) over(partition by product_name order by order_year)as previous_year_sales,
 current_sales-lag(current_sales) over(partition by product_name order by order_year) as diiffernce_previous_year_sales,
 case when current_sales-lag(current_sales) over(partition by product_name order by order_year) >0 then 'increase'
 when current_sales-lag(current_sales) over(partition by product_name order by order_year)  < 0 then 'decrease'
 else 'no change'
 end previous_year_sales_change
from yearly_product_sales;
------------------------------------------------------------------------------
/* which categories contribute the most to overall sales */----
with kira as(
select f.category,
sum(g.sales_amount) as total_sales
from [gold.dim_products]   f
join 
[gold.fact_sales]    g
on
f.product_key=g.product_key
group by f.category 
)
select category,total_sales,
sum(total_sales)  over() overall_sales,
concat(round((cast( total_sales as float)  /sum(total_sales) over()) *100,2),'%')  as percentage_sales
from kira
order by total_sales desc;

















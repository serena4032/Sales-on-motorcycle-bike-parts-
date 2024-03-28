select * from dbo.sales$
--Select everything

select warehouse,sum(total) as TotalRevenue, (sum(total)*100) /sum(sum(total)) over ()  as PercentageofTotal  from dbo.sales$
where warehouse in ('North','Central','West')
group by warehouse
--This is the total revenue earned by each region in percentage form. In general, Central has the largest percentage of revenue of 49.1% followed by the North(34.65%) and the West(16.23%)


select product_line,sum(quantity) as quantity,sum(total) as Totalrevenue,sum(total)/sum(sum(total)) over () as Percentageoftotal from dbo.sales$
group by product_line
--This is the percentage of revenue earned for each item. Suspension and traction make up 25% of the revenue, closely followed by frame and body(23.8%). Engine is selling out the least quantity at 627 and has the lowest revenue of 13%


select client_type, (select max(total) from dbo.sales$ where warehouse='North' and client_type=s.client_type) as TotalrevenuefromNorth from dbo.sales$ s
group by client_type
--Subquery for finding the total revenue for the North warehouse grouped into their whole sale and retail department. Whole sale is making a greater revenue of 2324.2 vs Retail (553.87)

select product_line,sum(quantity) as TotalQuantity,avg(total) as AverageRevenue from dbo.sales$
group by product_line


select date,product_line,
sum(case when date between '2021-06-01' and '2021-06-30' then total else null end) as MonthOfJune
from dbo.sales$
group by 
  date,product_line
order by MonthOfJune desc 
--Using case to figure out, the day on which there was the biggest source of revenue for June. In 2021-06-18 saw the biggest sales for frame and body at 2900.02 revenue.

alter table dbo.sales$
drop column payment_fee
--Dropping a column which don't need

select * from dbo.sales$

WITH cte AS (
    SELECT 
        product_line,
        SUM(total) AS total_sales
    FROM 
        dbo.sales$ 
			where payment='Cash'
    GROUP BY 
        product_line)
		select * from cte
--Creating a cte where total_sales are from cash. Suspension and traction had the most revenue in cash of 4418. This makes sense given that suspension and traction generates the biggest source of revenue.

select charindex('electrical',product_line) As Electricalsystems,sum(total) as Totalrevenue from dbo.sales$
where charindex('electrical',product_line)=1
group by charindex('electrical',product_line)
--Finding electrical Systems total revenue using charindex

select 
case when charindex(' ',product_line)-1 >0 then 
substring(product_line,1,charindex(' ',product_line)-1) 
else product_line
end as FirstWordofproductline
from dbo.sales$
--Finding first word of product line using substring and charindex

create view Newview as 
select warehouse,client_type,avg(quantity) as average_quantity
from dbo.sales$
group by warehouse,client_type
select * from Newview
--Creating a new view showing the warehouse,client_type,average_quantity. The average quantity is highest for wholesale in north at 24.1.
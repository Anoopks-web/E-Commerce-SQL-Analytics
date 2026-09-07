 21. Find the top 5 products by revenue.

select p.product_id,p.product_name,sum(p.price*od.quantity*(1-discount)) as revune
from products p
join order_details od
on
p.product_id=od.product_id
group by p.product_id,p.product_name
order by revune desc limit 5;
-- 22. Find the top 3 products in each category by revenue.
with product_revune as(
select p.product_id,p.product_name,p.category,sum(p.price*od.quantity*(1-discount)) as total_revune
from products p
join order_details od
on
p.product_id=od.product_id
group by  
 p.product_id,p.product_name,p.category),
 rank_products as (
 select *,dense_rank() over(partition by category order by total_revune desc) as rnk from product_revune)
 select product_id,product_name,category,total_revune from
 rank_products
 where rnk<=3;
-- 23. Find the average order value.
select avg(order_value) as  avg_order_value
 from(select od.order_id,sum(p.price*od.quantity*(1-discount)) as order_value
 from products p
 join order_details od
 on
 p.product_id=od.product_id
 group by od.order_id)
 as order_total_deatils;
-- 24. Find customers with more than 3 orders.
select c.customer_id,c.customer_name,count(o.order_id) as total_orders
from customers c
join orders o
on
c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
having count(o.order_id)>3;
-- 25. Find customers who never placed an order.
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING count(o.order_id)=0 ;
-- 26. Find products that were never ordered.
select p.product_id,p.product_name,o.order_id
from products p
left join order_details o
on
p.product_id=o.product_id
where o.order_id is Null;
-- 27. Find monthly revenue.
select monthname(o.order_date),sum(p.price*od.quantity*(1-discount)) as sumofsales
from products p
join order_details  od
on
p.product_id=od.product_id
join orders o
on 
o.order_id=od.order_id
group by monthname(o.order_date);
-- 28. Find the highest-revenue month.
select monthname(o.order_date),sum(p.price*od.quantity*(1-discount)) as sumofsales
from products p
join order_details  od
on
p.product_id=od.product_id
join orders o
on 
o.order_id=od.order_id
group by monthname(o.order_date)
order by sumofsales desc limit 1;
-- 29. Calculate daily revenue.
select o.order_date,sum(p.price*od.quantity*(1-discount)) as revune
from products p
join order_details  od
on
p.product_id=od.product_id
join orders o
on 
o.order_id=od.order_id
group by o.order_date;
-- 30. Calculate cumulative revenue by date.
with revune_date as(
select o.order_date,sum(p.price*od.quantity*(1-discount)) as revune
from products p
join order_details  od
on
p.product_id=od.product_id
join orders o
on 
o.order_id=od.order_id
group by o.order_date)
select order_date,revune,sum(revune) over(order by order_date asc)
from revune_date;
-- 31. Rank customers by total revenue.
with customer_revune as(
select c.customer_id,c.customer_name,sum(p.price*od.quantity) as revune
from customers c
join orders o
on
c.customer_id=o.customer_id
join order_details od
on
od.order_id=o.order_id
join
products p
on
p.product_id=od.product_id
group by c.customer_id,c.customer_name) ,
ranking as(
select  customer_id,customer_name,revune,row_number() over(order by revune  desc)  as rnk from customer_revune)
select * from ranking;
-- 32. Find the second-highest revenue customer.
with customer_revune as(
select c.customer_id,c.customer_name,sum(p.price*od.quantity) as revune
from customers c
join orders o
on
c.customer_id=o.customer_id
join order_details od
on
od.order_id=o.order_id
join
products p
on
p.product_id=od.product_id
group by c.customer_id,c.customer_name) ,
ranking as(
select  customer_id,customer_name,revune,row_number() over(order by revune  desc)  as rnk from customer_revune)
select * from ranking where rnk=2;
-- 33. Find the top 2 customers in each city.
with total_revune as(select  c.customer_id,c.customer_name,c.city,sum(p.price*od.quantity*(1-discount))  as total_revune
from customers c join orders o
on
c.customer_id=o.customer_id
join order_details od
on
o.order_id=od.order_id
join products p
on
od.product_id=p.product_id
group by  c.customer_id,c.customer_name,c.city
order by  total_revune desc),
ranking_customers as(
select customer_id,customer_name,city,total_revune,row_number()over(partition by city  order by total_revune desc)as rnk from   total_revune)
select * from  ranking_customers where rnk<=2;
-- 34. Find each customer's total orders.
select c.customer_id,c.customer_name,count(o.order_id)
from customers c
join orders o
on
c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;
-- 35. Find each customer's total quantity purchased.
select c.customer_id,c.customer_name,sum(od.quantity) as sold
from customers c
join orders o
on
c.customer_id=o.customer_id
join
order_details od
on
o.order_id=od.order_id
group by c.customer_id,c.customer_name;
-- 36. Find each customer's average order value.
with order_values as(
select o.customer_id,o.order_id,sum(p.price*od.quantity*(1-discount)) as total_revune
from orders  o
join order_details od
on
o.order_id=od.order_id
join
products p
on
p.product_id=od.product_id
group by   o.customer_id,o.order_id)
select c.customer_id,c.customer_name,avg(total_revune) as avg_order_value
from customers  c 
join  order_values  ov
on
c.customer_id=ov.customer_id
group by c.customer_id,c.customer_name;
-- 37. Find revenue contribution percentage by category.
with toatl_revune as(select p.category,sum(p.price*od.quantity*(1-discount)) as revune
from products p
join order_details od
on
p.product_id=od.product_id
group by  p.category)
select  category,round(revune/sum(revune) over()*100,2) as revune_contribution
from toatl_revune;
-- 38. Find products whose revenue is above average product revenue.
with total_revune as(
select p.product_id,p.product_name,sum(p.price*od.quantity*(1-discount)) as revune
from products p
join order_details od
on
p.product_id=od.product_id
group by  p.product_id,p.product_name)
select product_id,product_name,revune from 
total_revune
where 
revune>(select avg(revune) from total_revune)
order by revune desc;
-- 39. Find the most sold product by quantity.
select p.product_id,p.product_name,sum(od.quantity) as total_sold
from products p
join order_details od
on
p.product_id=od.product_id
group by p.product_id,p.product_name
order by sum(od.quantity) desc limit 1;
-- 40. Find the most popular category by quantity.
select p.category,sum(od.quantity) as sold
from products p
join order_details od
on
p.product_id=od.product_id
group by p.category order by sum(od.quantity) desc limit 1;
-- 41. Find April revenue.
with total_revune as(
select monthname(order_date) as month_name,sum(p.price*od.quantity*(1-discount)) as revune
from  products p
join order_details od
on
p.product_id=od.product_id
join orders o
on
o.order_id=od.order_id
group by  monthname(order_date))
select month_name,revune
from total_revune
where month_name='April';
-- 42. Find customers who ordered in both April and May.
select c.customer_id,c.customer_name
from customers c
join orders o
on
c.customer_id=o.customer_id
where month(o.order_id) in (4,5)
group by  c.customer_id,c.customer_name
HAVING COUNT(DISTINCT MONTH(o.order_date)) = 2;
-- 43. Find customers who ordered in April but not May.
SELECT 
    c.customer_id,
    c.customer_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE MONTH(o.order_date) IN (4, 5)
GROUP BY 
    c.customer_id,
    c.customer_name
HAVING 
    COUNT(DISTINCT CASE 
        WHEN MONTH(o.order_date) = 4 THEN 4 
    END) = 1
    AND
    COUNT(DISTINCT CASE 
        WHEN MONTH(o.order_date) = 5 THEN 5 
    END) = 0;
-- 44. Classify customers as High, Medium, or Low value using CASE.
WITH customer_revune AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(p.price * od.quantity * (1 - od.discount)) AS total_revune
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON od.product_id = p.product_id
    GROUP BY 
        c.customer_id,
        c.customer_name
)
select customer_id,customer_name,total_revune,case
when total_revune>100000 then 'high'
when total_revune>50000 then 'medium'
else 'low' 
end
 as revune_category
from  customer_revune ;
-- 45. Calculate month-over-month revenue growth.
with month_revune as( select year(o.order_date) as years,month(o.order_date) as month_no,monthname(o.order_date) as month_name,sum(p.price*od.quantity*(1-od.discount)) as revune
from products p
join order_details od
on 
p.product_id=od.product_id
join orders o
on
od.order_id=o.order_id
group by years,month_no,month_name),
previous_month_sales as( select
years,month_no,month_name,revune,lag(revune) over(order by years,month_no) as pervious_month_sales
from  month_revune)
select years,month_no,month_name,revune,pervious_month_sales,round((revune-pervious_month_sales)/pervious_month_sales*100,2) as growth_rate
from 
previous_month_sales;

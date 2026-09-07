-- EASY LEVEL
-- 1. Count total customers.
select count(*) from customers;
-- 2. Count total products.
select count(product_id) from products;
-- 3. Count total orders.
select count(*) from orders;
-- 4. Find average product price.
select avg(price) from products;
-- 5. Find highest product price.
select max(price) from products;
-- 6. Find lowest product price.
select min(price) from products;
-- 7. Count customers by city.
select city,count(*)  from customers
group by city;
-- 8. Count products by category.
select category,count(product_id)
from products
group by category;
-- 9. Count orders by status.
select order_status,count(*)
from orders
group by order_status;
-- 10. Find total quantity sold.
select sum(quantity)as total_sold
from order_details;
-- 11. Finds total revenue from order details.
select sum(p.price*o.quantity*(1-o.discount))
from products p
join order_details o
on
p.product_id=o.product_id;
-- 12. Find revenue by product.
select p.product_name,sum(o.quantity*p.price*(1-o.discount)) as revune
from products p
join order_details o
on
p.product_id=o.product_id
group by  p.product_name;
-- 13. Find revenue by category.
select p.category,sum(p.price*o.quantity*(1-discount)) as revune
from products p
join order_details o
on
p.product_id=o.product_id
group by p.category;
-- 14. Find orders placed in each month.
select monthname(o.order_date) as month_name,count(od.order_id) as toatl_orders
from order_details od
join orders o
on
o.order_id=od.order_id
group by month_name;
-- 15. Find customers who signed up in 2025.
select * from customers where year(signup_date)='2025';
-- 16. Find products priced above 50,000.
select * from products where price>50000;
-- 17. Find delivered orders.
select * from orders where order_status='Delivered';
-- 18. Find total discount given.
SELECT 
    SUM(p.price * od.quantity * od.discount) AS total_discount
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id;
-- 19. Find average order quantity.
select avg(quantity) from order_details;
-- 20. Display the top 10 highest-priced products.
select product_name,price from
products
order by price desc limit 10;

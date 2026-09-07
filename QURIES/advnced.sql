 ADVANCED LEVEL
-- 46. Find each customer's first order date.
select c.customer_id,c.customer_name,min(o.order_date) as order_date
from customers c
join orders o
on
c.customer_id=o.customer_id
group by  c.customer_id,c.customer_name
order by customer_id asc;
-- 47. Find each customer's latest order date.
select c.customer_id,c.customer_name,max(o.order_date) as latest_orders
from customers c
join
orders o
on
c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
order by c.customer_id asc;
-- 48. Use LAG() to find each customer's previous order date.
select c.customer_id,c.customer_name,o.order_id,o.order_date,lag(o.order_date)
over(partition by c.customer_id order by o.order_date)as pverios_date
from customers c
join orders o
on
c.customer_id=o.customer_id
order by c.customer_id,o.order_date;
-- 49. Calculate days between consecutive customer orders.
with customer_orders as(
select c.customer_id,c.customer_name,o.order_id,o.order_date,lag(o.order_date)
over(partition by c.customer_id order by o.order_date) as previous_date
from customers c
join orders o
on
c.customer_id=o.customer_id)
select  customer_id,customer_name,order_id,order_date, previous_date,datediff(order_date,previous_date) as differnce
from customer_orders
order by customer_id,order_date;
-- 50. Find customers whose latest order value exceeds their previous order value.
WITH total_order_value AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        SUM(p.price * od.quantity * (1 - od.discount)) AS order_value
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY
        o.customer_id,
        o.order_id,
        o.order_date
),
previous_order AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        order_value,
        LAG(order_value) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_sales
    FROM total_order_value
),
order_ranking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rnk
    FROM previous_order
)
SELECT
    c.customer_id,
    c.customer_name,
    os.order_id,
    os.order_date,
    os.order_value AS latest_order_value,
    os.previous_sales AS previous_order_value
FROM customers c
JOIN order_ranking os
    ON c.customer_id = os.customer_id
WHERE os.rnk = 1
  AND os.order_value > os.previous_sales
ORDER BY c.customer_id;
-- 51. Find the first product purchased by each customer.
with customer_details as(
select c.customer_id,c.customer_name,o.order_id,o.order_date,p.product_id,p.product_name,row_number()over(partition by c.customer_id order by o.order_id,o.order_date) as rnk
from customers c
join orders o
on
c.customer_id=o.customer_id
join order_details od
on
od.order_id=o.order_id
join products p
on
p.product_id=od.product_id)
select * from customer_details where rnk=1;
-- 52. Find the top 3 customers in every city using ROW_NUMBER().
 with customer_city as(
 select c.customer_id,c.customer_name,c.city,sum(p.price*od.quantity*(1-discount)) as total_value
 from customers c
 join orders o
 on
 c.customer_id=o.customer_id
 join order_details od
 on
 o.order_id=od.order_id
 join products p
 on
 p.product_id=od.product_id
 group by   c.customer_id,c.customer_name,c.city),
 customer_ranking as(
 select *,row_number()over(partition by city order by total_value desc) as rnk
 from customer_city)
 select customer_id,customer_name,city,total_value,rnk
 from customer_ranking
 where rnk<=3
 order by  city,rnk;
-- 53. Find the highest-revenue product in every category.
with total_revune as(
select p.product_id,p.product_name,p.category,sum(p.price*od.quantity*(1-discount)) as total_revune
from products p
join order_details od
on
p.product_id=od.product_id
group by 
p.product_id,p.product_name,p.category),
ranking as (
select *,row_number()
over(partition by category order by total_revune desc) as rnk
from total_revune)
select product_id,product_name,category from ranking where rnk=1 order  by category;
select * from ranking;
-- 54. Calculate a 7-day moving average of revenue.
WITH daily_revenue AS (
    SELECT
        o.order_date,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY o.order_date
)
select order_date,revenue,round(avg(revenue) over(order by order_date
rows between 6 preceding and  current row),2) as moving_avg
from  daily_revenue
order by order_date;
-- 55. Calculate cumulative revenue separately by category.
WITH category_revenue AS (
    SELECT
        p.category,
        o.order_date,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM products p
    JOIN order_details od
        ON p.product_id = od.product_id
    JOIN orders o
        ON o.order_id = od.order_id
    GROUP BY
        p.category,
        o.order_date
)
select category,order_date,revenue,
sum(revenue)  over(partition by category order by order_date) as cummulative_revune
from  category_revenue
order by  category ,order_date;
-- 56. Find customers with at least 2 purchases.
select c.customer_id,c.customer_name, COUNT(DISTINCT o.order_id) AS total_purchases
from customers c
join orders o
on
c.customer_id=o.customer_id
group by
c.customer_id,c.customer_name
having total_purchases>=2;
-- 57. Calculate repeat customer percentage.
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    GROUP BY customer_id
)
SELECT
    ROUND(
        SUM(CASE WHEN total_orders >= 2 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_percentage
FROM customer_orders;
-- 58. Find customers whose last order is older than 30 days from the latest database order.
SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(
        (SELECT MAX(order_date) FROM orders),
        MAX(o.order_date)
    ) AS days_since_last_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING days_since_last_order > 30
ORDER BY days_since_last_order DESC;
-- 59. Find the longest gap between purchases for each customer.
WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
),
purchase_gaps AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        previous_order_date,
        DATEDIFF(
            order_date,
            previous_order_date
        ) AS gap_days
    FROM customer_orders
)
SELECT
    customer_id,
    MAX(gap_days) AS longest_purchase_gap
FROM purchase_gaps
GROUP BY customer_id
ORDER BY longest_purchase_gap DESC;
-- 60. Find the customer with the longest purchase gap.
WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
),
purchase_gaps AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        previous_order_date,
        DATEDIFF(
            order_date,
            previous_order_date
        ) AS gap_days
    FROM customer_orders
),
longest_gaps AS (
    SELECT
        customer_id,
        MAX(gap_days) AS longest_purchase_gap
    FROM purchase_gaps
    GROUP BY customer_id
),
ranking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY longest_purchase_gap DESC
        ) AS rnk
    FROM longest_gaps
)
SELECT
    c.customer_id,
    c.customer_name,
    r.longest_purchase_gap
FROM ranking r
JOIN customers c
    ON c.customer_id = r.customer_id
WHERE r.rnk = 1;
-- 61. Calculate revenue rank and quantity rank for every product.
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue,
        SUM(od.quantity) AS total_quantity
    FROM products p
    JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY
        p.product_id,
        p.product_name
)
SELECT
    product_id,
    product_name,
    revenue,
    total_quantity,

    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY total_quantity DESC
    ) AS quantity_rank

FROM product_sales
ORDER BY revenue_rank;
-- 62. Find products responsible for the first 80% of cumulative revenue.
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM products p
    JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY
        p.product_id,
        p.product_name
),
cumulative_revenue AS (
    SELECT
        *,
        SUM(revenue) OVER (
            ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,

        SUM(revenue) OVER () AS total_revenue
    FROM product_revenue
)
SELECT
    product_id,
    product_name,
    revenue,
    cumulative_revenue,
    ROUND(
        cumulative_revenue / total_revenue * 100,
        2
    ) AS cumulative_revenue_percentage
FROM cumulative_revenue
WHERE cumulative_revenue / total_revenue <= 0.80
ORDER BY revenue DESC;
-- 63. Find the top category for every month.
WITH monthly_category_revenue AS (
    SELECT
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month_no,
        MONTHNAME(o.order_date) AS month_name,
        p.category,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date),
        MONTHNAME(o.order_date),
        p.category
),
ranked_categories AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY year, month_no
            ORDER BY revenue DESC
        ) AS rnk
    FROM monthly_category_revenue
)
SELECT
    year,
    month_no,
    month_name,
    category,
    revenue
FROM ranked_categories
WHERE rnk = 1
ORDER BY year, month_no;
-- 64. Find the top customer for every month.
WITH monthly_customer_revenue AS (
    SELECT
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month_no,
        MONTHNAME(o.order_date) AS month_name,
        c.customer_id,
        c.customer_name,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY
        YEAR(o.order_date),
        MONTH(o.order_date),
        MONTHNAME(o.order_date),
        c.customer_id,
        c.customer_name
),
ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY year, month_no
            ORDER BY revenue DESC
        ) AS rnk
    FROM monthly_customer_revenue
)
SELECT
    year,
    month_no,
    month_name,
    customer_id,
    customer_name,
    revenue
FROM ranked_customers
WHERE rnk = 1
ORDER BY year, month_no;
-- 65. Compare each customer's revenue with the average revenue of their city.
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
)
SELECT
    customer_id,
    customer_name,
    city,
    revenue,
    ROUND(
        AVG(revenue) OVER (
            PARTITION BY city
        ),
        2
    ) AS city_average_revenue,
    ROUND(
        revenue - AVG(revenue) OVER (
            PARTITION BY city
        ),
        2
    ) AS difference_from_city_average
FROM customer_revenue
ORDER BY city, revenue DESC;
-- 66. Find customers whose spending is above their city's average
.
-- 67. Calculate customer lifetime value.
select c.customer_id,c.customer_name,sum(p.price*od.quantity*(1-discount)) as life_time_value
from customers c
join orders o
on
c.customer_id=o.customer_id
join order_details od
on
od.order_id=o.order_id
join products p
on
p.product_id=od.product_id
group by  c.customer_id,c.customer_name
order by customer_id;
-- 68. Segment customers using order count and revenue.
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.city,
        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_details od
        ON o.order_id = od.order_id
    JOIN products p
        ON p.product_id = od.product_id
    GROUP BY
        c.customer_id,
        c.customer_name,
        c.city
),
city_average AS (
    SELECT
        *,
        AVG(revenue) OVER (
            PARTITION BY city
        ) AS city_avg_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    customer_name,
    city,
    revenue,
    ROUND(city_avg_revenue, 2) AS city_avg_revenue
FROM city_average
WHERE revenue > city_avg_revenue
ORDER BY city, revenue DESC;


-- Calculate each customer's active months and purchase frequency
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) AS active_months,
    COUNT(DISTINCT o.order_id) AS purchase_frequency
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY
    purchase_frequency DESC;
-- 70. Build an RFM-style customer score using Recency, Frequency, and Monetary value.
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,

        DATEDIFF(
            (SELECT MAX(order_date) FROM orders),
            MAX(o.order_date)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(
            p.price * od.quantity * (1 - od.discount)
        ) AS monetary

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
),

rfm_score AS (
    SELECT
        *,
        
        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary
        ) AS monetary_score

    FROM customer_rfm
)

SELECT
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,

    (
        recency_score
        + frequency_score
        + monetary_score
    ) AS rfm_score

FROM rfm_score
ORDER BY rfm_score DESC;

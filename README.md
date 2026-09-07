
# 🛒 E-Commerce Sales & Customer Analytics Using SQL

## 📌 Project Overview

This project is a comprehensive **E-Commerce Sales and Customer Analytics project** built using **MySQL**.

The objective of this project is to analyze customer behavior, product performance, orders, revenue, discounts, and purchasing patterns using SQL.

The project contains **70 SQL business problems**, progressing from **Easy → Medium → Advanced** level.

It demonstrates how SQL can be used to transform raw transactional data into meaningful business insights.

---

## 🎯 Business Objectives

The main objectives of this project are to:

* Analyze overall sales and revenue
* Identify top-performing products
* Analyze product and category performance
* Understand customer purchasing behavior
* Identify high-value and repeat customers
* Analyze monthly and daily revenue trends
* Calculate customer lifetime value
* Analyze customer purchase frequency
* Identify inactive customers
* Perform customer segmentation
* Apply RFM-style customer analysis

---

## 🗂️ Database Schema

The project uses four main tables:

### 1. Customers

| Column        | Description                |
| ------------- | -------------------------- |
| customer_id   | Unique customer ID         |
| customer_name | Customer name              |
| gender        | Customer gender            |
| city          | Customer city              |
| signup_date   | Customer registration date |

### 2. Products

| Column       | Description       |
| ------------ | ----------------- |
| product_id   | Unique product ID |
| product_name | Product name      |
| category     | Product category  |
| price        | Product price     |

### 3. Orders

| Column       | Description                   |
| ------------ | ----------------------------- |
| order_id     | Unique order ID               |
| customer_id  | Customer who placed the order |
| order_date   | Date of order                 |
| order_status | Current order status          |

### 4. Order Details

| Column     | Description        |
| ---------- | ------------------ |
| order_id   | Order ID           |
| product_id | Product purchased  |
| quantity   | Quantity purchased |
| discount   | Discount applied   |

---

## 🔗 Table Relationships

```text
Customers
    │
    │ customer_id
    ▼
Orders
    │
    │ order_id
    ▼
Order_Details
    │
    │ product_id
    ▼
Products
```

---

# 📊 SQL Analysis

## 🟢 Easy Level

The first section focuses on basic SQL queries and aggregate functions.

### Topics Covered

* Count total customers
* Count total products
* Count total orders
* Average product price
* Highest product price
* Lowest product price
* Customers by city
* Products by category
* Orders by status
* Total quantity sold
* Total revenue
* Revenue by product
* Revenue by category
* Monthly order analysis
* Customers who signed up in 2025
* Products above a specific price
* Delivered orders
* Total discount
* Average order quantity
* Top 10 highest-priced products

### SQL Concepts

```text
COUNT()
SUM()
AVG()
MAX()
MIN()
GROUP BY
ORDER BY
WHERE
JOIN
LIMIT
```

---

# 🟡 Medium Level

The medium-level analysis focuses on business-oriented SQL problems.

### Topics Covered

* Top 5 products by revenue
* Top 3 products in each category
* Average order value
* Customers with more than 3 orders
* Customers who never ordered
* Products that were never ordered
* Monthly revenue
* Highest-revenue month
* Daily revenue
* Cumulative revenue
* Customer revenue ranking
* Second-highest revenue customer
* Top 2 customers in each city
* Customer total orders
* Customer total quantity purchased
* Average order value per customer
* Revenue contribution by category
* Products above average revenue
* Most sold product
* Most popular category
* April revenue
* Customers ordering in April and May
* Customers ordering in April but not May
* Customer value classification
* Month-over-month revenue growth

### SQL Concepts

```text
CTE
CASE
HAVING
Subqueries
ROW_NUMBER()
DENSE_RANK()
LAG()
Window Functions
Date Functions
```

---

# 🔴 Advanced Level

The advanced section focuses on analytical SQL and customer behavior.

### Topics Covered

* First order date for each customer
* Latest order date
* Previous order using LAG()
* Days between consecutive orders
* Latest order vs previous order value
* First product purchased
* Top 3 customers in every city
* Highest-revenue product in each category
* 7-day moving average
* Cumulative revenue by category
* Customers with at least 2 purchases
* Repeat customer percentage
* Customers inactive for more than 30 days
* Longest purchase gap
* Customer with longest purchase gap
* Revenue and quantity ranking
* Products responsible for first 80% of revenue
* Top category for every month
* Top customer for every month
* Customer revenue vs city average
* Customers spending above city average
* Customer lifetime value
* Customer segmentation
* Active months and purchase frequency
* RFM-style customer scoring

---

# 🧠 Key SQL Concepts Demonstrated

This project demonstrates practical knowledge of:

### Basic SQL

* SELECT
* WHERE
* DISTINCT
* ORDER BY
* LIMIT
* GROUP BY
* HAVING

### Aggregate Functions

```sql
COUNT()
SUM()
AVG()
MIN()
MAX()
```

### Joins

```sql
INNER JOIN
LEFT JOIN
```

### Advanced SQL

```sql
WITH
CASE
Subqueries
CTEs
```

### Window Functions

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
NTILE()
SUM() OVER()
AVG() OVER()
```

### Date Functions

```sql
YEAR()
MONTH()
MONTHNAME()
DATEDIFF()
DATE_FORMAT()
```

---

# 📈 Business Metrics Calculated

The project calculates several important business KPIs.

| KPI                     | Purpose                             |
| ----------------------- | ----------------------------------- |
| Total Revenue           | Measure overall sales               |
| Average Order Value     | Measure average customer order size |
| Revenue by Product      | Identify high-performing products   |
| Revenue by Category     | Compare category performance        |
| Customer Lifetime Value | Measure customer value              |
| Repeat Customer %       | Measure customer retention          |
| Purchase Frequency      | Understand customer activity        |
| Recency                 | Identify inactive customers         |
| Monthly Revenue         | Analyze sales trends                |
| Moving Average          | Identify revenue trends             |
| Cumulative Revenue      | Track total revenue growth          |
| RFM Score               | Segment customers                   |

---

# 📊 Revenue Calculation

Revenue is calculated using:

```sql
price × quantity × (1 - discount)
```

Example:

```sql
SUM(
    p.price * od.quantity * (1 - od.discount)
) AS revenue
```

This ensures that the applied discount is considered when calculating actual revenue.

---

# 👥 Customer Analysis

Customer analysis includes:

* Total customer orders
* Total quantity purchased
* Average order value
* Customer revenue ranking
* First order date
* Latest order date
* Previous order date
* Purchase gaps
* Customer lifetime value
* Repeat customer identification
* Customer segmentation
* RFM analysis

---

# 📦 Product Analysis

Product performance is analyzed using:

* Total revenue
* Total quantity sold
* Revenue ranking
* Quantity ranking
* Category performance
* Top products
* Products never ordered
* Products contributing to cumulative revenue

---

# 📅 Time-Based Analysis

The project also performs time-series analysis:

```text
Daily Revenue
Monthly Revenue
Month-over-Month Growth
Cumulative Revenue
7-Day Moving Average
First Order Date
Latest Order Date
Purchase Gap Analysis
```

---

# 🎯 RFM Analysis

An RFM-style analysis is implemented using:

### Recency

How recently the customer made a purchase.

### Frequency

How frequently the customer makes purchases.

### Monetary

How much revenue the customer generated.

The project uses:

```sql
NTILE(5)
```

to create customer scores.

A combined RFM score is calculated as:

```text
Recency Score
+
Frequency Score
+
Monetary Score
=
RFM Score
```

---

# 🛠️ Tools & Technologies

* **MySQL**
* **SQL**
* **Excel**
* **GitHub**

---

# 📁 Project Structure

```text
E-Commerce-SQL-Analytics/
│
├── README.md
│
├── database/
│   ├── create_tables.sql
│   └── insert_data.sql
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_details.csv
│
├── queries/
│   ├── 01_easy.sql
│   ├── 02_medium.sql
│   └── 03_advanced.sql
│
└── screenshots/
    ├── revenue_analysis.png
    ├── customer_analysis.png
    └── rfm_analysis.png
```

---

# 🚀 How to Run the Project

### Step 1 — Create the database

```sql
CREATE DATABASE ecommerce_analytics;

USE ecommerce_analytics;
```

### Step 2 — Create the tables

Run:

```text
database/create_tables.sql
```

### Step 3 — Load the data

Run:

```text
database/insert_data.sql
```

or import the CSV files into MySQL.

### Step 4 — Run the SQL analysis

Execute the queries from:

```text
queries/
```

Start with:

```text
01_easy.sql
```

Then:

```text
02_medium.sql
```

Finally:

```text
03_advanced.sql
```

---

# 💡 Key Learning Outcomes

Through this project, I strengthened my ability to:

* Write business-oriented SQL queries
* Work with multiple related tables
* Analyze transactional data
* Calculate important business KPIs
* Use CTEs for complex analysis
* Apply SQL window functions
* Perform customer segmentation
* Analyze sales trends
* Solve real-world data analysis problems

---

# 📌 Future Improvements

Future versions of this project can include:

* Power BI dashboard
* Excel dashboard
* Customer segmentation dashboard
* Product performance dashboard
* Sales forecasting
* Advanced RFM segmentation
* Python-based exploratory data analysis
* Automated reporting

---

# 👨‍💻 Author

**Anoop K S**

Aspiring Data Analyst

### Skills

```text
SQL | MySQL | Excel | Power BI | Tableau | Python | Pandas | NumPy | DAX
```

---

⭐ If you find this project useful, feel free to explore the SQL queries and analysis.

**Thank you for visiting my project!**


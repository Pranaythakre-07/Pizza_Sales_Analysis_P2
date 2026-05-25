# 🍕 Pizza Sales Analysis SQL Project

## Project Overview

**Project Title**: Pizza Sales Analysis  
**Level**: Beginner  
**Database**: `pizzahut`

This project demonstrates SQL skills and techniques used by data analysts to explore and analyze pizza sales data from a pizza restaurant chain. The project covers database setup, exploratory data analysis (EDA), and business-driven SQL queries to uncover revenue trends, customer preferences, and operational insights.

---

## Objectives

1. **Set up a pizza sales database**: Create and populate a relational database with pizza, order, and order-detail data.
2. **Exploratory Data Analysis (EDA)**: Understand the dataset — total orders, revenue, product mix, and time-based patterns.
3. **Business Analysis**: Answer key business questions using SQL to drive decisions on pricing, inventory, and promotions.

---

## Project Structure

### 1. Database Setup

**Database & Table Creation**: Four tables are created to model orders, pizzas, pizza types, and order line items.

```sql
CREATE DATABASE pizzahut;
USE pizzahut;

-- Table 1: Pizzas (size and price per pizza variant)
CREATE TABLE pizzas (
    pizza_id       VARCHAR(15) NOT NULL,
    pizza_type_id  VARCHAR(10) NOT NULL,
    size           VARCHAR(5)  NOT NULL,
    price          FLOAT       NOT NULL
);

-- Table 2: Orders (one row per customer order)
CREATE TABLE orders (
    order_id    INT  NOT NULL,
    order_date  DATE NOT NULL,
    order_time  TIME NOT NULL,
    PRIMARY KEY (order_id)
);

-- Table 3: Pizza Types (name, category, ingredients)
CREATE TABLE pizza_types (
    pizza_type_id  VARCHAR(10),
    name           VARCHAR(25),
    category       VARCHAR(10),
    ingredients    VARCHAR(50)
);

-- Table 4: Order Details (line items linking orders to pizzas)
CREATE TABLE order_details (
    order_details_id  INT         NOT NULL,
    order_id          INT,
    pizza_id          VARCHAR(20),
    quantity          INT
);
```

---

### 2. Data Analysis & Findings

The following SQL queries answer 12 specific business questions:

---

**Q1. Retrieve the total number of orders placed.**

```sql
SELECT COUNT(order_id) AS Total_order
FROM orders;
```

---

**Q2. Calculate the total revenue generated from pizza sales.**

```sql
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p ON p.pizza_id = od.pizza_id;
```

---

**Q3. Identify the highest-priced pizza.**

```sql
SELECT pt.name, p.price
FROM pizza_types AS pt
JOIN pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
```

---

**Q4. Identify the most common pizza size ordered.**

```sql
SELECT p.size, COUNT(od.order_details_id) AS total_order
FROM pizzas AS p
JOIN order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY total_order DESC;
```

---

**Q5. List the top 5 most ordered pizza types along with their quantities.**

```sql
SELECT pizza_types.name,
       SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas        ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;
```

---

**Q6. Find the total quantity of each pizza category ordered.**

```sql
SELECT pizza_types.category,
       SUM(order_details.quantity) AS Quantity
FROM pizza_types
JOIN pizzas        ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY category
ORDER BY Quantity DESC;
```

---

**Q7. Determine the distribution of orders by hour of the day.**

```sql
SELECT HOUR(order_time) AS Hour,
       COUNT(order_id)  AS order_count
FROM orders
GROUP BY HOUR(order_time);
```

---

**Q8. Find the category-wise distribution of pizzas.**

```sql
SELECT category, COUNT(name) AS total_distribution
FROM pizza_types
GROUP BY category;
```

---

**Q9. Group orders by date and calculate the total pizzas sold per day.**

```sql
SELECT o.order_date,
       SUM(od.quantity) AS total_pizza_sale
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY o.order_date;
```

---

**Q10. Determine the top 3 most ordered pizza types based on revenue.**

```sql
SELECT pizza_types.name,
       ROUND(SUM(order_details.quantity * pizzas.price), 2) AS Revenue
FROM pizza_types
JOIN pizzas        ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;
```

---

**Q11. Calculate the percentage contribution of each pizza category to total revenue.**

```sql
SELECT pt.category,
       ROUND(
           SUM(od.quantity * p.price) / (
               SELECT ROUND(SUM(od.quantity * p.price), 2)
               FROM order_details od
               JOIN pizzas p ON p.pizza_id = od.pizza_id
           ) * 100, 2
       ) AS revenue_percentage
FROM pizza_types pt
JOIN pizzas        p  ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;
```

---

**Q12. Analyze the cumulative revenue generated over time.**

```sql
SELECT order_date,
       SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
FROM (
    SELECT orders.order_date,
           SUM(order_details.quantity * pizzas.price) AS revenue
    FROM order_details
    JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
    JOIN orders ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS sales;
```

---

## Findings

- **Revenue**: Total revenue is calculated by joining order quantities with pizza prices across all orders.
- **Most Popular Size**: The size ordered most frequently reflects customer preferences and can guide inventory decisions.
- **Top Pizzas**: The top 5 most ordered pizzas and the top 3 by revenue may differ — quantity leaders aren't always revenue leaders.
- **Peak Hours**: Order distribution by hour identifies rush periods, helping optimize staffing and kitchen operations.
- **Category Insights**: Category-wise revenue percentages reveal which pizza segments (Classic, Veggie, Supreme, Chicken) drive the most business.
- **Cumulative Revenue**: The running total over time helps track business growth and identify high-performing date ranges.

---

## Reports

- **Sales Summary**: Total orders placed, total revenue, and highest-priced pizza.
- **Product Performance**: Top pizzas by order volume and revenue, most popular size.
- **Time-Based Trends**: Hourly order distribution and daily cumulative revenue growth.
- **Category Analysis**: Revenue contribution and quantity breakdown by pizza category.

---

## Conclusion

This project provides a solid SQL foundation for data analysts, covering multi-table joins, aggregation, window functions, and subqueries — all applied to a realistic pizza sales dataset. The insights derived can directly inform business decisions around menu pricing, staffing schedules, and promotional targeting.

---


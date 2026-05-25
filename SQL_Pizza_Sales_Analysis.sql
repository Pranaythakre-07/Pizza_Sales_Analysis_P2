
Create database pizzahut;

use pizzahut;

-- ---------------------------------------------
## Create 1st Table 

create table pizzas(
					pizza_id varchar(15) not null,
					pizza_type_id varchar(10) not null,
					size varchar (5) not null,
					price Float not null
                    );

select * from pizzas;

-- ---------------------------------------------
## Create 2nd Table 

create table orders(
					 order_id int not null,
					 order_date date not null,
					 order_time time not null,
					 primary key(order_id));

select * from orders;

-- ---------------------------------------------
## Create 3rd Table

create table pizza_types
						  (pizza_type_id varchar(10),
                          name varchar(25),
                          category varchar(10),
                          ingredients varchar(50)
                          );
 
select * from pizza_types;

-- ---------------------------------------------
## Create 4th Table

create table order_details
						  (order_details_id int not null,
                           order_id int,
                           pizza_id varchar(20),
                           quantity int
                           );
		
select * from order_details;
-- ---------------------------------------------

-- 1) Retrieve the total number of orders placed.

	select count(order_id) as Total_order from orders;
    
-- ---------------------------------------------


-- 2) Calculate the total revenue generated from pizza sales.

	select Round(sum(od.quantity * p.price),2) as total_revenue
    from order_details as od
    join pizzas as p
    on p.pizza_id = od.pizza_id;

-- Short form
-- od = order_details
-- p = pizzas

-- ---------------------------------------------

-- 3) Identify the highest-priced pizza.

	select pt.name, p.price
    from pizza_types as pt
    join pizzas as p
    on p.pizza_type_id = pt.pizza_type_id
    order by p.price
    desc 
    limit 1;
    
-- Short form
-- pt = pizza_types
-- p = pizzas

-- ---------------------------------------------

-- 4) Identify the most common pizza size ordered. 

    
    select p.size, count(od.order_details_id) as total_order
    from pizzas as p
    join order_details as od
    on p.pizza_id = od.pizza_id
    group by p.size
    order by total_order desc;
    
-- Short form
-- od = order_details
-- p = pizzas

-- ---------------------------------------------

-- 5) List the top 5 most ordered pizza types along with their quantities.


		SELECT pizza_types.name,
			   SUM(order_details.quantity) AS quantity
		FROM pizza_types
		JOIN pizzas
		ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		JOIN order_details
		ON order_details.pizza_id = pizzas.pizza_id
		GROUP BY pizza_types.name
		ORDER BY quantity DESC
		LIMIT 5;
        

-- ---------------------------------------------

-- 6) Join the necessary tables to find the total quantity of each pizza category ordered.

	select pizza_types.category,
    sum(order_details.quantity) as Quantity
    from pizza_types
    join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details
    on order_details.pizza_id = pizzas.pizza_id
    group by category
    order by Quantity desc;
    
-- ---------------------------------------------

-- 7) Determine the distribution of orders by hour of the day.

	SELECT HOUR(time) AS Hour,
		   COUNT(order_id) AS order_count
	FROM orders
	GROUP BY HOUR(time);
    
    
-- ---------------------------------------------

-- 8) Join relevant tables to find the category-wise distribution of pizzas.

	select category, count(name) as total_distribution
	from pizza_types
	group by category;
    
-- ---------------------------------------------

-- 9) Group the orders by date and calculate the average number of pizzas ordered per day.

select o.date, sum(od.quantity) total_pizza_sale
from orders as o
join order_details as od
on o.order_id = od.order_id
group by date;


-- Short form
-- od = order_details
-- o = orders

-- ---------------------------------------------

-- 10) Determine the top 3 most ordered pizza types based on revenue.

    select pizza_types.name, 
    round(sum(order_details.quantity * pizzas.price),2)as Revenue
    from pizza_types 
    join pizzas
    on pizzas.pizza_type_id = pizza_types.pizza_type_id
    join order_details
    on order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.name
    order by Revenue
    limit 3;

-- ---------------------------------------------

-- 11) Calculate the percentage contribution of each pizza type to total revenue.
  
		SELECT pt.category,
		   ROUND(SUM(od.quantity * p.price) / (
			   SELECT ROUND(SUM(od.quantity * p.price), 2)
			   FROM order_details od
			   JOIN pizzas p ON p.pizza_id = od.pizza_id
		   ) * 100, 2) AS revenue
	FROM pizza_types pt
	JOIN pizzas p ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details od ON od.pizza_id = p.pizza_id
	GROUP BY pt.category
	ORDER BY revenue DESC;

-- ---------------------------------------------

-- 12) Analyze the cumulative revenue generated over time.
    
		SELECT order_date,
			   SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue
		FROM (
			SELECT orders.`date` AS order_date,
				   SUM(order_details.quantity * pizzas.price) AS revenue
			FROM order_details
			JOIN pizzas
			  ON order_details.pizza_id = pizzas.pizza_id
			JOIN orders
			  ON orders.order_id = order_details.order_id
			GROUP BY orders.`date`
		) AS sales;
        
        
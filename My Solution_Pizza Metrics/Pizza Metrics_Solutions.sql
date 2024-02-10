SELECT * FROM pizza_runner.customer_orders;

-- How many pizzas were ordered?
SELECT Count(order_id) AS total_orders    -- count function
FROM customer_orders;

-- How many unique customer orders were made?
SELECT count(Distinct order_id) AS total_orders    -- distict count function 
FROM customer_orders;

-- How many successful orders were delivered by each runner?
/*
This query uses NULLIF(cancellation, '') to set the value to NULL if it's an empty string.

UPDATE runner_orders
SET cancellation = NULLIF(cancellation, ''); */

Select runner_id, count(order_id) as total_delivered_order
from runner_orders
where cancellation IS Not NULL
group by runner_id;

-- How many of each type of pizza was delivered?

with 
deliveredPizza AS (
   Select * 
   From runner_orders
   where cancellation IS NULL     -- CTE1
), 
totaldeliveredpizza as (
   Select co.pizza_id, dp.order_id
   from deliveredPizza dp 
   inner join customer_orders co on dp.order_id = co.order_id    -- CTE2
)
select p.pizza_name, count(tdp.pizza_id) as delivered_pizza
from totalDeliveredPizza tdp
inner join pizza_names p on tdp.pizza_id = p.pizza_id
Group by pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?

with pizzacount as (
select customer_id, pizza_id, count(pizza_id) as Pizza_Count
from customer_orders
group by customer_id, pizza_id
order by customer_id
)

select pc.customer_id, p.pizza_name, pc.pizza_count
from  pizzacount pc
inner join pizza_names p on pc.pizza_id = p.pizza_id
Order by customer_id;

-- What was the maximum number of pizzas delivered in a single order?
with maxorder as (
Select order_id, count(order_id) as Total,
rank() over(order by count(order_id) desc) as rn     -- to rank the total count 
from customer_orders
Group by order_id
)

select total 
from maxorder
where rn = '1';

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

WITH CTE1 AS (
  SELECT
    co.customer_id,
    co.order_id,
    sum(CASE WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL THEN 1 ELSE 0 END) as at_least_one_change,
    sum(CASE WHEN co.exclusions IS NULL AND co.extras IS NULL THEN 1 ELSE 0 END) as no_changes
  FROM customer_orders co
  JOIN runner_orders ro ON co.order_id = ro.order_id
  WHERE ro.cancellation IS NULL
  GROUP BY co.customer_id, co.order_id
),
CTE2 AS (
  SELECT
    customer_id,
    SUM(at_least_one_change) as total_at_least_one_change,
    SUM(no_changes) as total_no_changes
  FROM CTE1
  GROUP BY customer_id
)

SELECT * FROM CTE2;

-- how many pizzas were delivered that had both exclusions and extras?

Select  
SUM(CASE WHEN exclusions IS not NULL AND extras IS NOT NULL THEN '1' else 0 END ) as both_items
from customer_orders;


-- What was the total volume of pizzas ordered for each hour of the day? 

Select 
Extract(Hour from order_time) as HOUR_OF_the_day,   -- to know the hour of the day when each pizza was ordered
count(order_id) as total_pizza_ordered
FROM
   customer_orders
Group by  
   HOUR_OF_the_day
Order BY 
   HOUR_OF_the_day;

-- What was the volume of orders for each day of the week?

SELECT
  DAYNAME(order_time) AS day_of_week,     -- Returns the name of the weekday for date
  COUNT(order_id) AS total_pizzas_ordered
FROM
  customer_orders 
GROUP BY
  day_of_week
ORDER BY
  day_of_week;

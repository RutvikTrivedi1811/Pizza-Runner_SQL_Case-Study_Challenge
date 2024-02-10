SELECT * FROM pizza_runner.runner_orders;

/* updating, manipulating, cleaning runner_orders table */

-- Remove "km" from distance values
UPDATE runner_orders
SET distance = REPLACE(distance, 'km', '')
WHERE distance IS NOT NULL;

-- Set distance to 0 for NULL values
UPDATE runner_orders
SET distance = 0
WHERE distance = 'null';

-- Standardize distance format to two decimal places using CAST
UPDATE runner_orders
SET distance = CAST(distance AS DECIMAL(10, 2))
WHERE distance IS NOT NULL;

-- adding 'km' to the distance column
Update runner_orders
SET distance = CONCAT(distance, '', 'km')
WHERE distance is not null;

/* manipulating duration column */

-- removing non-numeric values from the duration column
UPDATE runner_orders
SET duration = REGEXP_REPLACE(duration, '[^0-9]', '')   --  remove all non-numeric characters from the duration column.
WHERE duration IS NOT NULL;

-- removing 'null' string from the cancellation column
UPDATE runner_orders
SET cancellation = REPLACE(cancellation, 'null', '')
WHERE cancellation IS NOT NULL;

-- removing 'null' string from the pickup_time column
UPDATE runner_orders
SET pickup_time = REPLACE(pickup_time, 'null', '')
WHERE pickup_time IS NOT NULL;

-- Correct date format
UPDATE runner_orders
SET pickup_time = STR_TO_DATE(pickup_time, '%Y-%m-%d %H:%i:%s')
WHERE pickup_time IS NOT NULL;
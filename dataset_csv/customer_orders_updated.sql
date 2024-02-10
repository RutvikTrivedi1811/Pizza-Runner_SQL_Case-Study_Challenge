SELECT * FROM pizza_runner.customer_orders;

-- remove null string  
update customer_orders
SET exclusions = replace(exclusions, 'null','')
WHERE exclusions IS NOT NULL;


-- Set the Data Type
ALTER TABLE customer_orders
MODIFY COLUMN exclusions VARCHAR(255);

-- remove null string from extras column
update customer_orders
SET extras = replace(extras, 'null','')
WHERE extras IS NOT NULL;

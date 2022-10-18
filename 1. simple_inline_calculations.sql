SELECT
	market_date,
	customer_id,
    vendor_id,
    quantity,
    cost_to_customer_per_qty,
    ROUND(quantity * cost_to_customer_per_qty) AS total_cost
FROM farmers_market.customer_purchases
LIMIT 5;

-- Concatenating Strings
SELECT
	customer_id,
	CONCAT(customer_first_name, " ", customer_last_name) AS customer_name
FROM farmers_market.customer
LIMIT 5;

-- Applying ORDER BY 
SELECT
	customer_id,
    CONCAT(customer_first_name, " ", customer_last_name) AS customer_name
FROM farmers_market.customer
ORDER BY customer_last_name, customer_first_name
LIMIT 5;

-- Applying Nesting
SELECT
	customer_id,
    UPPER(CONCAT(customer_first_name, " ", customer_last_name)) AS customer_name
FROM farmers_market.customer
ORDER BY customer_last_name, customer_first_name
LIMIT 5;

/*
NOTE: Note that we did not sort on the new derived column alias customer_
name here, but on columns that exist in the customer table. In some cases (depending
on what database system you’re using, which functions are used, and the execution
order of your query) you can’t reuse aliases in other parts of the query. It is possible
to put some functions or calculations in the ORDER BY clause, to sort by the resulting
value. Some other options for referencing derived values will be covered in later
chapters.
*/
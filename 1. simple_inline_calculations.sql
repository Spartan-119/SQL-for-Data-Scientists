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
SELECT *
FROM farmers_market.customer
LIMIT 5;
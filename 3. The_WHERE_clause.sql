/*
The WHERE clause goes after the FROM statement and before any GROUP BY,
ORDER BY, or LIMIT statements in the SELECT query:
SELECT [columns to return]
FROM [table]
WHERE [conditional filter statements]
ORDER BY [columns to sort on]
*/

-- 1. you could use a conditional statement in the WHERE clause to select
-- only rows from the product table in which the product_category_id is 1.
SELECT
	product_id,
    product_name,
    product_category_id
FROM farmers_market.product
WHERE
	product_category_id = 1
LIMIT 5;


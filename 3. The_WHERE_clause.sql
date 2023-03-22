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

-- FILTERING ON MULTIPLE COLUMNS
SELECT 
	market_date,
    customer_id,
    vendor_id,
    product_id,
    quantity,
    quantity * cost_to_customer_per_qty AS price
FROM farmers_market.customer_purchases
WHERE customer_id = 3 AND customer_id = 4
ORDER BY market_date, customer_id, vendor_id, product_id;

/*
One example where you could use AND in a WHERE clause referring to only a
single column is when you want to return rows with a range of values. If someone
requests “Give me all of the rows with a customer ID greater than 3 and less
than or equal to 5,” the conditions would be written as “WHERE customer_id >
3 AND customer_id <= 5,”
*/

SELECT 
	market_date,
    customer_id,
    vendor_id,
    product_id,
    quantity,
    quantity * cost_to_customer_per_qty AS price
FROM farmers_market.customer_purchases
WHERE customer_id > 3 AND customer_id <= 5
ORDER BY market_date, customer_id, vendor_id, product_id;


/*
You can combine multiple AND, OR, and NOT conditions, and control in which
order they get evaluated, by using parentheses the same way you would in an
algebraic expression to specify the order of operations. The conditions inside
the parentheses get evaluated first.
*/

SELECT 
	product_id,
    product_name
FROM farmers_market.product
WHERE
	product_id = 10
    OR
    (product_id > 3 AND product_id < 8);

-- NOW LOOK AT THE QUERY BELOW:

SELECT 
	product_id,
    product_name
FROM farmers_market.product
WHERE
	(product_id = 10 OR product_id > 3) 
    AND product_id < 8;

/*
Explanation: When the product ID is 10, the WHERE clause in the first query is evaluated as:
TRUE OR (TRUE AND FALSE) = TRUE OR (FALSE) = TRUE
and the WHERE clause in the second query is evaluated as:
(TRUE OR TRUE) AND FALSE = (TRUE) AND FALSE = FALSE

Since the OR statement evaluates to TRUE if any of the conditions are TRUE,
but the AND statement only evaluates to TRUE if all of the conditions are true,
the row with a product_id value of 10 is only returned by the first query.
*/

-- X -- X -- X -- X -- X -- X -- X -- X -- X -- X -- X -- X --

-- MULTI-COLUMN CONDITIONAL FILTERING
-- WHERE clauses can also impose conditions using values in multiple columns.

/*
For example, if we wanted to know the details of purchases made by customer 4 at vendor 7, 
we could use the following query:
*/
SELECT 
	market_date,
    customer_id,
    vendor_id,
    quantity * cost_to_customer_per_qty AS price
FROM farmers_market.customer_purchases
WHERE 
	customer_id = 4 AND vendor_id = 7;
    
/*
Let’s try a WHERE clause that uses an OR condition to apply comparisons across
multiple fields. This query will return anyone in the customer table with the
first name of “Carlos” or the last name of “Diaz” 
*/
SELECT 
	customer_id,
    customer_first_name,
    customer_last_name
FROM farmers_market.customer
WHERE
	customer_first_name = 'Carlos' OR customer_last_name = 'Diaz';

/*
 If you wanted to find out what booth(s) vendor 3 was assigned
to on or before (less than or equal to) May 9, 2019, you could use this query:
*/
SELECT *
FROM farmers_market.vendor_booth_assignments
WHERE
 vendor_id = 3 AND market_date <= '2019-05-09'
ORDER BY market_date;

-- A FEW MORE WAYS TO FILTER
-- BETWEEN, IN, LIKE, ISNULL

-- BETWEEN
SELECT *
FROM farmers_market.vendor_booth_assignments
WHERE
 vendor_id = 3
 AND market_date BETWEEN '2019-05-02' and '2019-05-16'
ORDER BY market_date;

-- IN
/*
To return a list of customers with selected last names, we could use a long list
of OR comparisons, as shown in the first query in the following example. An
alternative way to do the same thing, which may come in handy if you had a
long list of names, is to use the IN keyword and provide a comma-separated
list of values to compare against. This will return TRUE for any row with a
customer_last_name that is in the provided list.
Both the queries below will have the exact same result:
*/
SELECT
 customer_id,
 customer_first_name,
 customer_last_name
FROM farmers_market.customer
WHERE
 customer_last_name = 'Diaz'
 OR customer_last_name = 'Edwards'
 OR customer_last_name = 'Wilson'
ORDER BY customer_last_name, customer_first_name;

SELECT
 customer_id,
 customer_first_name,
 customer_last_name
FROM farmers_market.customer
WHERE
 customer_last_name IN ('Diaz' , 'Edwards', 'Wilson')
ORDER BY customer_last_name, customer_first_name;

-- LIKE
/*
Let’s say that there was a farmer’s market customer you knew as “Jerry,” but
you weren’t sure if he was listed in the database as “Jerry” or “Jeremy” or
“Jeremiah.” All you knew for sure was that the first three letters were “Jer.”
In SQL, instead of listing every variation you can think of, you can search for
partially matched strings using a comparison operator called LIKE, and wildcard
characters, which serve as a placeholder for unknown characters in a string.
In MS SQL Server–style SQL, the wildcard character % (percent sign) can serve
as a stand-in for any number of characters (including none). So the comparison
LIKE ‘Jer%’ will search for strings that start with “Jer” and have any (or no)
additional characters after the “r”:
*/
SELECT 
	customer_id,
    customer_first_name,
    customer_last_name
FROM farmers_market.customer
WHERE customer_first_name LIKE "Jer%";


-- ISNULL
SELECT *
FROM farmers_market.product
WHERE product_size IS NULL;

/*
NOTE: Keep in mind that “blank” and NULL are not the same thing in database
terms. 
A null database field means that there is no value for a given record. 
It indicates the absence of a value. A blank database field means that 
there is a value for a given record, and this value is empty (for a string value) 
or 0 (for a numeric value).

1. NULL is an absence of a value. An empty string is a value, but is just empty. 
NULL is special to a database.

2. NULL has no bounds, it can be used for string, integer, date, etc. fields in a database.

3. NULL isn't allocated any memory, the string with NULL value is just a pointer 
which is pointing to nowhere in memory. however, Empty IS allocated to a memory 
location, although the value stored in the memory is "".

If someone asked you to find all products that didn’t have product sizes,
you might also want to check for blank strings, which would equal ‘’ (two
single-quotes with nothing between), or rows where someone entered a space
or any number of spaces into that field. The TRIM() function removes excess
spaces from the beginning or end of a string value, so if you use a combination
of the TRIM() function and blank string comparison, you can find any row that
is blank or contains only spaces. In this case, the “Red Potatoes - Small” row,
shown in Figure 3.14, has a product_size with one space in it, ' ', so could be
found using the following query:
*/
SELECT *
FROM farmers_market.product
WHERE
	product_size IS NULL OR TRIM(product_size) = '';
    
-- This is important for other types of comparisons as well. Look at the follow- 
-- ing two queries and their output 

SELECT
	market_date,
    transaction_time,
    customer_id,
    vendor_id,
    quantity
FROM farmers_market.customer_purchases
WHERE
	customer_id = 1
    AND vendor_id = 7
    AND quantity > 1;
    
SELECT
	market_date,
    transaction_time,
    customer_id,
    vendor_id,
    quantity
FROM farmers_market.customer_purchases
WHERE
	customer_id = 1
    AND vendor_id = 7
    AND quantity <= 1;

/*
You might think that if you ran both of the queries, you would get all records 
in the database, since in one case you’re looking for quantities over 1, and in 
the other you’re looking for quantities less than or equal to 1, the combination 
of which appears to contain all possible values. But since NULL values aren’t 
comparable to numbers in that way, there is a record that is never returned 
when there’s a numeric comparison used, because it has a NULL value in the 
quantity ﬁeld.
*/

SELECT 
	market_date,
    transaction_time,
    customer_id,
    vendor_id,
    quantity
FROM farmers_market.customer_purchases
WHERE
	customer_id = 1
    AND vendor_id = 7;
    
/*
Ideally, the database should be designed so that the quantity value for a pur- 
chase record isn’t allowed to be NULL because you can’t buy a NULL number 
of items, but since NULL values weren’t prevented, one was entered. 
If you wanted to return all records that don’t have NULL values in a ﬁeld, 
you could use the condition “[ﬁeld name] IS NOT NULL” in the WHERE clause.
*/

-- FILTERING USING SUBQUERIES

/*
46 Chapter 3 ■ The WHERE Clause 
SELECT 
market_date, 
transaction_time, 
customer_id, 
vendor_id, 
quantity 
FROM farmers_market.customer_purchases 
WHERE 
customer_id = 1 
AND vendor_id = 7 
Ideally, the database should be designed so that the quantity value for a pur- 
chase record isn’t allowed to be NULL because you can’t buy a NULL number 
of items, but since NULL values weren’t prevented, one was entered. 
If you wanted to return all records that don’t have NULL values in a ﬁeld, 
you could use the condition “[ﬁeld name] IS NOT NULL” in the WHERE clause. 
Filtering Using Subqueries 
*/

SELECT 
	market_date,
    market_rain_flag
FROM farmers_market.market_date_info
WHERE
	market_rain_flag = 1;
    
/*
Now let’s use the list of dates generated by that query to return purchases 
made on those dates. 
NOTE: when using a query in an IN comparison, you 
can only return the ﬁeld you’re comparing to, so we will not include the market_ 
rain_flag ﬁeld in the following subquery. Therefore, the query inside the 
parentheses just returns the dates shown in Figure 3.18, and the “outer” query 
looks for customer_purchases records with a market_date value in that list of 
dates. You can see in the results in Figure 3.19 that all of the purchase records 
returned occurred on the days it rained
*/

SELECT
	market_date,
    customer_id,
    vendor_id,
    quantity * cost_to_customer_per_qty AS price
FROM farmers_market.customer_purchases
WHERE
	market_date IN 
		(
			SELECT market_date
            FROM farmers_market.market_date_info
            WHERE
				market_rain_flag = 1
        )
LIMIT 5;


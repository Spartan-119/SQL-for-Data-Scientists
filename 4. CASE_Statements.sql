/*
What if, instead of using conditional statements to ﬁlter rows, you want 
a column or value in your dataset to be based on a conditional statement? For 
example, instead of ﬁltering your results to purchases over $50, say you just 
want to return all rows and create a new column that ﬂags each purchase as 
being above or below $50? Or, maybe the machine learning algorithm you want 
to use can’t accept a categorical string column as an input feature, so you want 
to encode those categories into numeric values. These are a version of what 
SQL developers call “derived columns” or “calculated ﬁelds,” and creating new 
columns that present the values differently is what data scientists call “feature 
engineering.” This is where CASE statements come in.
*/

-- It's similar to Python's "if" statements, like, you'll
-- find that SQL handles conditional statements somewhat
-- similarly, just with different syntax.

/*
Let’s say that we want to know which vendors primarily sell fresh produce 
and which don’t. Figure 4.1 shows the vendor types currently in our Farmer’s 
Market database. 

The vendors we want to label as “Fresh Produce” have the word “Fresh” 
in the vendor_type column. We can use a CASE statement and the LIKE oper- 
ator that was covered in Chapter 3 to create a new column, which we’ll alias 
vendor_type_condensed, that condenses the vendor types to just “Fresh Pro- 
duce” or “Other”:
*/

SELECT 
	vendor_id,
    vendor_name,
    vendor_type,
    CASE
		WHEN LOWER(vendor_type) LIKE '%fresh%'
			THEN 'Fresh Produce'
		ELSE
			'Other'
	END AS vendor_type_condensed
FROM farmers_market.vendor;

/*
 If we only wanted 
existing vendor types to be labeled using this logic, we could instead use the IN 
keyword and explicitly list the existing vendor types we want to label with the 
“Fresh Produce” category. As a data analyst or data scientist building a dataset 
that may be refreshed as new data is added to the database, you should always 
consider what might happen to your transformed columns if the underlying 
data changes.
*/

-- CREATING BINARY FLAGS USING CASE

/*
A binary ﬂag ﬁeld contains 
only 1s or 0s, usually indicating a “Yes” or “No” or “exists” or “doesn’t exist” 
type of value. For example, the Farmer’s Markets in our database all occur on 
Wednesday evenings or Saturday mornings. Many machine learning algo- 
rithms won’t know what to do with the words “Wednesday” and “Saturday” 
that appear in our database.

But, the algorithm could use a numeric value as an input. So, how might we 
turn this string column into a number? One approach we can take to including 
the market day in our dataset is to generate a binary ﬂag ﬁeld that indicates 
whether it’s a weekday or weekend market. We can do this with a CASE state- 
ment, making a new column that contains a 1 if the market occurs on a Saturday 
or Sunday, and a 0 if it doesn’t, calling the ﬁeld “weekend_flag,”
*/

SELECT 
	market_date,
    CASE
		WHEN market_day = 'Saturday' OR market_day = 'Sunday'
			THEN 1
		ELSE 0
	END AS weekend_flag
FROM farmers_market.market_date_info
LIMIT 5;
    
-- GROUPING OR BINNING CONTINUOUS VALUES USING CASE

/* Earlier  we had a query that ﬁltered to only customer purchases where 
an item or quantity of an item cost over $50, by putting a conditional statement 
in the WHERE clause. But let’s say we wanted to return all rows, and instead of 
using that value as a ﬁlter, only indicate whether the cost was over $50 or not. 
We could write the query like this:
*/

SELECT 
	market_date,
    customer_id,
    vendor_id,
    ROUND(quantity * cost_to_customer_per_qty, 2) AS price,
    CASE
		WHEN quantity * cost_to_customer_per_qty > 50
			THEN 1
		ELSE 0
	END AS price_over_50
FROM farmers_market.customer_purchases
LIMIT 10;

/*
CASE statements can also be used to “bin” a continuous variable, such as price. 
Let’s say we wanted to put the line-item customer purchases into bins of under 
$5.00, $5.00–$9.99, $10.00–$19.99, or $20.00 and over. We could accomplish that 
with a CASE statement in which we surround the values after the THENs in single 
quotes to generate a column that contains a string label
*/

SELECT
	market_date,
    customer_id,
    vendor_id,
    ROUND(quantity * cost_to_customer_per_qty, 2) AS price,
    CASE
		WHEN quantity * cost_to_customer_per_qty < 5.00
			THEN 'Under $5'
		WHEN quantity * cost_to_customer_per_qty < 10.00
			THEN '$5 - $9.99'
		WHEN quantity * cost_to_customer_per_qty < 20.00
			THEN '$10 - $19.99'
		WHEN quantity * cost_to_customer_per_qty >= 20.00
			THEN '$20 and above'
	END AS price_bin
FROM farmers_market.customer_purchases
LIMIT 10;

-- CATEGORICAL ENCODING USING CASE

SELECT
	vendor_id,
    vendor_name,
    vendor_type,
    CASE
		WHEN vendor_type = 'Arts & Jewelry'
			THEN 1
            ELSE 0
	END AS vendor_type_arts_jewelry,
    CASE
		WHEN vendor_type = 'Eggs & Meats'
			THEN 1
            ELSE 0
	END AS vendor_type_eggs_meats,
    CASE
		WHEN vendor_type = 'Freshly Focused'
			THEN 1
            ELSE 0
	END AS vendor_type_fresh_focused,
    CASE
		WHEN vendor_type = 'Fresh Variety: Veggies & More'
			THEN 1
            ELSE 0
	END AS vendor_type_fresh_variety,
    CASE
		WHEN vendor_type = 'Prepared Foods'
			THEN 1
            ELSE 0
	END AS vendor_type_prepared    
FROM farmers_market.vendor;
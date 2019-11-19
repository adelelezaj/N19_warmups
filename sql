-- Get a list of the 3 long-standing customers for each country

with longstanding_cust AS (
    SELECT *,
    o.customer_id AS o_customer_id,
    c.country AS c_country,
    o.order_date AS o_order_date

    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.country, O.ORDER_ID
    ORDER BY o.order_date 
),
cust_info AS (
    SELECT distinct(o_customer_id), c_country, o_order_date
    FROM longstanding_cust
    GROUP BY 1,2,3
),
all_customers as (
SELECT *,
RANK() OVER(PARTITION BY c_country ORDER BY o_order_date asc)
FROM cust_info
)
SELECT * FROM all_customers
WHERE RANK <=3;

-- Modify the previous query to get the 3 newest customers in each each country.

with longstanding_cust AS (
    SELECT *,
    o.customer_id AS o_customer_id,
    c.country AS c_country,
    o.order_date AS o_order_date

    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.country, O.ORDER_ID
    ORDER BY o.order_date 
),
cust_info AS (
    SELECT distinct(o_customer_id), c_country, o_order_date
    FROM longstanding_cust
    GROUP BY 1,2,3
),
all_customers as (
SELECT *,
RANK() OVER(PARTITION BY c_country ORDER BY o_order_date desc)
FROM cust_info
)
SELECT * FROM all_customers
WHERE RANK <=3;


-- Get the 3 most frequently ordered products in each city
-- FOR SIMPLICITY, we're interpreting "most frequent" as 
-- "highest number of total units ordered within a country"
-- hint: do something with the quanity column
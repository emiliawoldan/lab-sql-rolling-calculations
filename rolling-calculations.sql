-- 1. Get number of monthly active customers.
CREATE OR REPLACE VIEW active_customers AS
SELECT count(customer_id) AS Active_user, date_format(convert(substring_index(rental_date,' ', 2), date), '%M') AS Month
FROM sakila.rental
GROUP BY date_format(convert(substring_index(rental_date,' ', 2), date), '%M');

SELECT * FROM active_customers;

-- 2. Active users in the previous month.
CREATE OR REPLACE VIEW active_last_month AS
SELECT Active_user, Month, lag(Active_user) over () as Active_last_month 
FROM active_customers;

SELECT * FROM active_last_month;

-- 3. Percentage change in the number of active customers.
SELECT Active_user, Month, Active_last_month, (Active_user/Active_last_month)-1 AS Percentage
FROM active_last_month;

-- 4. Retained customers every month. Retained - active current month and month earlier.

SELECT count(d1.customer_id) AS Active_customer, count(d2.customer_id) AS Retained_customer,
date_format(convert(substring_index(d1.rental_date,' ', 2), date), '%m') AS Month
#(date_format(convert(substring_index(d2.rental_date,' ', 1), date), '%M')) - 1 AS Previous_month
FROM sakila.rental d1
JOIN sakila.rental d2
ON d1.customer_id = d2.customer_id AND date_format(CONVERT(substring_index(d1.rental_date,' ', 2), DATE), '%m') = date_format(CONVERT(substring_index(d2.rental_date,' ', 2), DATE), '%m') + 1
GROUP BY date_format(convert(substring_index(d1.rental_date,' ', 2), date), '%m');

/*
SELECT customer_id AS Active_customer, customer_id AS Retained_customer,
date_format(convert(substring_index(rental_date,' ', 2), date), '%m') AS Month,
date_format(convert(substring_index(rental_date,' ', 1), date), '%Y') AS Year
FROM sakila.rental;
*/
-- =============================================
-- ECOMMERCE SQL ANALYSIS QUERIES
-- Includes: SELECT, JOINS, Subqueries, Aggregates, Views, Indexes
-- =============================================

-- 1. SELECT, WHERE, ORDER BY, GROUP BY
-- --------------------------------------------

-- Select all completed orders, ordered by most recent
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE status = 'Completed'
ORDER BY order_date DESC;

-- Group total sales amount by status
SELECT status, COUNT(*) AS total_orders, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status;

-- 2. JOINS (INNER, LEFT, RIGHT)
-- --------------------------------------------

-- INNER JOIN: Get all orders with customer names
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN: List all customers with any orders they’ve placed
SELECT c.customer_id, c.customer_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN: Show all orders and customer info (only works in some DBMS like PostgreSQL)
-- If using SQLite, skip this query
SELECT o.order_id, c.customer_name, o.order_date
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- 3. SUBQUERIES
-- --------------------------------------------

-- Get customers who have placed more than 3 orders
SELECT customer_id, customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 3
);

-- List products that appear in orders with quantity > 2
SELECT *
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM order_items
    WHERE quantity > 2
);

-- 4. AGGREGATE FUNCTIONS (SUM, AVG)
-- --------------------------------------------

-- Total spent by each customer
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- Average quantity ordered per product
SELECT product_id, AVG(quantity) AS avg_quantity
FROM order_items
GROUP BY product_id;

-- 5. CREATE VIEWS FOR ANALYSIS
-- --------------------------------------------

-- View to show top spending customers (over 3000)
CREATE VIEW top_customers AS
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING total_spent > 3000;

-- View to see order count per customer
CREATE VIEW customer_order_count AS
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id;

-- 6. OPTIMIZE QUERIES WITH INDEXES
-- --------------------------------------------

-- Create index on customer_id for faster filtering in orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Create index on order_id and product_id in order_items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

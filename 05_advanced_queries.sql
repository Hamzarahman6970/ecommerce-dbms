SELECT o.order_id, u.name AS customer, o.order_date,
       o.total_amount, py.payment_method, py.payment_status
FROM Orders o
INNER JOIN Users    u  ON o.user_id  = u.user_id
INNER JOIN Payments py ON o.order_id = py.order_id
ORDER BY o.order_date DESC;

SELECT oi.order_item_id, o.order_id, u.name AS customer,
       p.name AS product, oi.quantity, oi.price,
       (oi.quantity * oi.price) AS line_total
FROM Order_Items oi
INNER JOIN Orders   o ON oi.order_id   = o.order_id
INNER JOIN Products p ON oi.product_id = p.product_id
INNER JOIN Users    u ON o.user_id     = u.user_id
ORDER BY o.order_id;

SELECT u.user_id, u.name, u.email,
       COUNT(o.order_id) AS total_orders
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name, u.email
ORDER BY total_orders DESC;

SELECT p.product_id, p.name, p.price,
       COALESCE(SUM(oi.quantity), 0) AS total_sold
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, p.price
ORDER BY total_sold DESC;

SELECT u.name AS customer, COUNT(o.order_id) AS order_count,
       SUM(o.total_amount) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY total_spent DESC;

SELECT u.name AS customer,
       SUM(o.total_amount) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.name
HAVING SUM(o.total_amount) > 10000
ORDER BY total_spent DESC;

SELECT SUM(o.total_amount) AS total_revenue
FROM Orders o
JOIN Payments py ON o.order_id = py.order_id
WHERE py.payment_status = 'Completed';

SELECT c.category_name,
       SUM(oi.quantity * oi.price) AS category_revenue,
       COUNT(DISTINCT oi.order_id) AS orders_count
FROM Order_Items oi
JOIN Products   p ON oi.product_id  = p.product_id
JOIN Categories c ON p.category_id  = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;

SELECT p.name AS product,
       SUM(oi.quantity)            AS total_units_sold,
       SUM(oi.quantity * oi.price) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_units_sold DESC
LIMIT 5;

SELECT product_id, name, stock, price
FROM Products
WHERE stock < 20
ORDER BY stock ASC;

SELECT o.order_id, u.name AS customer,
       o.total_amount, py.payment_method, o.order_date
FROM Payments py
JOIN Orders o ON py.order_id = o.order_id
JOIN Users  u ON o.user_id   = u.user_id
WHERE py.payment_status = 'Pending'
ORDER BY o.order_date;

SELECT name, price,
       ROUND((SELECT AVG(price) FROM Products), 2) AS avg_price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;

SELECT name, email
FROM Users
WHERE user_id IN (
    SELECT DISTINCT user_id FROM Orders
    WHERE EXTRACT(YEAR FROM order_date) = 2024
);

SELECT c.category_name, p.name AS product, p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category_id = p.category_id
)
ORDER BY p.price DESC;

SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS month,
       COUNT(o.order_id)               AS orders,
       SUM(o.total_amount)             AS revenue
FROM Orders o
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;

SELECT payment_method,
       COUNT(*) AS usage_count
FROM Payments
GROUP BY payment_method
ORDER BY usage_count DESC;

SELECT u.name AS customer,
       ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY avg_order_value DESC;

SELECT p.product_id, p.name, p.price, p.stock
FROM Products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id FROM Order_Items
);

DROP VIEW IF EXISTS vw_order_summary;
CREATE VIEW vw_order_summary AS
SELECT o.order_id, u.name AS customer, u.email,
       o.order_date, o.total_amount,
       py.payment_method, py.payment_status
FROM Orders o
JOIN Users    u  ON o.user_id  = u.user_id
JOIN Payments py ON o.order_id = py.order_id;

SELECT * FROM vw_order_summary;

DROP VIEW IF EXISTS vw_product_sales;
CREATE VIEW vw_product_sales AS
SELECT p.product_id, p.name AS product, c.category_name,
       p.price, p.stock,
       COALESCE(SUM(oi.quantity), 0)            AS units_sold,
       COALESCE(SUM(oi.quantity * oi.price), 0) AS revenue
FROM Products p
JOIN Categories  c  ON p.category_id  = c.category_id
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name, c.category_name, p.price, p.stock;

SELECT * FROM vw_product_sales ORDER BY revenue DESC;

CREATE INDEX IF NOT EXISTS idx_orders_user_id       ON Orders(user_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON Order_Items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product  ON Order_Items(product_id);
CREATE INDEX IF NOT EXISTS idx_products_category    ON Products(category_id);
CREATE INDEX IF NOT EXISTS idx_payments_status      ON Payments(payment_status);
CREATE INDEX IF NOT EXISTS idx_users_email          ON Users(email);

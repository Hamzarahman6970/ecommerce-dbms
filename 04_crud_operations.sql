INSERT INTO Users (name, email, password, address)
VALUES ('Test User', 'testuser@gmail.com', 'test1234', 'Test Street, Lahore');

INSERT INTO Categories (category_name)
VALUES ('Toys & Games');

INSERT INTO Products (name, price, stock, category_id)
VALUES ('Lego Building Set', 2500.00, 50, 6);

INSERT INTO Orders (user_id, order_date, total_amount)
VALUES (1, NOW(), 2500.00);

INSERT INTO Order_Items (order_id, product_id, quantity, price)
VALUES (
    (SELECT MAX(order_id) FROM Orders),
    (SELECT product_id FROM Products WHERE name = 'Lego Building Set'),
    1, 2500.00
);

INSERT INTO Payments (order_id, payment_method, payment_status)
VALUES (
    (SELECT MAX(order_id) FROM Orders),
    'JazzCash', 'Pending'
);

SELECT p.product_id, p.name, p.price, p.stock, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
ORDER BY p.product_id;

SELECT o.order_id, u.name AS customer, o.order_date, o.total_amount
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
ORDER BY o.order_date DESC;

SELECT o.order_id, o.order_date, o.total_amount, py.payment_status
FROM Orders o
JOIN Payments py ON o.order_id = py.order_id
WHERE o.user_id = 1;

SELECT product_id, name, stock,
    CASE WHEN stock < 20 THEN 'Low Stock'
         WHEN stock < 50 THEN 'Medium'
         ELSE 'In Stock'
    END AS stock_status
FROM Products
ORDER BY stock ASC;

SELECT o.order_id, u.name AS customer, py.payment_method,
       py.payment_status, o.total_amount
FROM Payments py
JOIN Orders o ON py.order_id = o.order_id
JOIN Users  u ON o.user_id   = u.user_id;

UPDATE Users
SET name = 'Fawad Khan Updated', address = 'New House, Lahore'
WHERE email = 'fawad@gmail.com';

UPDATE Products
SET price = 90000.00
WHERE name = 'Lenovo IdeaPad Laptop';

UPDATE Products
SET stock = stock + 10
WHERE name = 'Samsung Galaxy A54';

UPDATE Payments
SET payment_status = 'Completed'
WHERE order_id = 5;

DELETE FROM Products
WHERE name = 'Lego Building Set';

DELETE FROM Orders
WHERE order_id = (SELECT MAX(order_id) FROM Orders);

DELETE FROM Users
WHERE email = 'testuser@gmail.com';

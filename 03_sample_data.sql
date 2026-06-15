INSERT INTO Users (name, email, password, address) VALUES
('Fawad Khan',   'fawad@gmail.com',  'pass1234',  'House 5, Block A, Lahore'),
('Hamza Rehman', 'hamza@gmail.com',  'hamza5678', 'Street 12, G-10, Islamabad'),
('Sara Ahmed',   'sara@gmail.com',   'sara9999',  'Flat 3, Clifton, Karachi'),
('Ali Raza',     'ali@gmail.com',    'ali4321',   'Plot 7, Phase 4, Peshawar'),
('Zara Malik',   'zara@gmail.com',   'zara1111',  'House 22, Gulberg, Lahore'),
('Usman Tariq',  'usman@gmail.com',  'usman222',  'Model Town, Faisalabad'),
('Nadia Iqbal',  'nadia@gmail.com',  'nadia333',  'Bahria Town, Rawalpindi'),
('Bilal Hassan', 'bilal@gmail.com',  'bilal444',  'Johar Town, Lahore'),
('Ayesha Noor',  'ayesha@gmail.com', 'ayesha555', 'DHA Phase 6, Karachi'),
('Kamran Shah',  'kamran@gmail.com', 'kamran666', 'Hayatabad, Peshawar');

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books'),
('Home & Kitchen'),
('Sports & Fitness');

INSERT INTO Products (name, price, stock, category_id) VALUES
('Samsung Galaxy A54',       45000.00, 30, 1),
('iPhone 13',               120000.00, 15, 1),
('Lenovo IdeaPad Laptop',    85000.00, 10, 1),
('Sony Wireless Headphones',  8500.00, 50, 1),
('HP Laserjet Printer',      22000.00, 20, 1),
('Men Casual Shirt',          1200.00,100, 2),
('Women Kameez',              1800.00, 80, 2),
('Jeans Pants',               2500.00, 60, 2),
('Kids Summer Dress',          900.00,120, 2),
('Winter Jacket',             4500.00, 40, 2),
('Database Systems Textbook', 1500.00, 25, 3),
('Python Programming Book',   1200.00, 35, 3),
('Data Structures & Algo',    1000.00, 30, 3),
('Dawlance Microwave',       12000.00, 18, 4),
('Electric Kettle',           2200.00, 45, 4),
('Non-Stick Frying Pan',      1800.00, 55, 4),
('Rice Cooker',               3500.00, 25, 4),
('Cricket Bat (CA)',          3500.00, 40, 5),
('Football (Nike)',           2500.00, 60, 5),
('Yoga Mat',                  1200.00, 75, 5);

INSERT INTO Orders (user_id, order_date, total_amount) VALUES
(1,  '2024-01-10 10:30:00', 53500.00),
(2,  '2024-01-15 12:00:00',  8500.00),
(3,  '2024-02-01 09:15:00', 45000.00),
(4,  '2024-02-14 14:00:00',  3700.00),
(5,  '2024-03-05 11:30:00', 22000.00),
(6,  '2024-03-20 16:45:00',  4300.00),
(7,  '2024-04-02 08:00:00', 13200.00),
(8,  '2024-04-18 13:20:00',  5700.00),
(9,  '2024-05-01 10:00:00', 87000.00),
(10, '2024-05-25 15:30:00',  7000.00);

INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1, 3, 1, 85000.00),
(1, 4, 1,  8500.00),
(2, 4, 1,  8500.00),
(3, 1, 1, 45000.00),
(4, 6, 1,  1200.00),
(4, 9, 2,   900.00),
(5, 5, 1, 22000.00),
(6, 8, 1,  2500.00),
(6, 6, 1,  1200.00),
(7,14, 1, 12000.00),
(7,15, 1,  2200.00),
(8,11, 1,  1500.00),
(8,12, 1,  1200.00),
(8,13, 1,  1000.00),
(9, 2, 1,120000.00),
(9, 3, 1, 85000.00),
(10,18,1,  3500.00),
(10,19,1,  2500.00),
(1, 6, 1,  1200.00),
(6,20, 1,  1200.00);

INSERT INTO Payments (order_id, payment_method, payment_status) VALUES
(1,  'Credit Card',     'Completed'),
(2,  'EasyPaisa',       'Completed'),
(3,  'Cash on Delivery','Completed'),
(4,  'JazzCash',        'Completed'),
(5,  'Debit Card',      'Pending'),
(6,  'Cash on Delivery','Completed'),
(7,  'Credit Card',     'Pending'),
(8,  'EasyPaisa',       'Completed'),
(9,  'Credit Card',     'Failed'),
(10, 'Cash on Delivery','Pending');

cat > ~/ecommerce_project/02_create_tables.sql << 'ENDOFFILE'
DROP TABLE IF EXISTS Payments CASCADE;
DROP TABLE IF EXISTS Order_Items CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Products CASCADE;
DROP TABLE IF EXISTS Categories CASCADE;
DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE Users (
    user_id    SERIAL       PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    password   VARCHAR(255) NOT NULL,
    address    TEXT         NOT NULL
);

CREATE TABLE Categories (
    category_id   SERIAL       PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Products (
    product_id  SERIAL        PRIMARY KEY,
    name        VARCHAR(150)  NOT NULL,
    price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock       INT           NOT NULL CHECK (stock >= 0),
    category_id INT           NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id)
        REFERENCES Categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE Orders (
    order_id     SERIAL        PRIMARY KEY,
    user_id      INT           NOT NULL,
    order_date   TIMESTAMP     NOT NULL DEFAULT NOW(),
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    CONSTRAINT fk_user FOREIGN KEY (user_id)
        REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Order_Items (
    order_item_id SERIAL        PRIMARY KEY,
    order_id      INT           NOT NULL,
    product_id    INT           NOT NULL,
    quantity      INT           NOT NULL CHECK (quantity > 0),
    price         NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_order   FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)   ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (product_id)
        REFERENCES Products(product_id) ON DELETE RESTRICT
);

CREATE TABLE Payments (
    payment_id     SERIAL      PRIMARY KEY,
    order_id       INT         NOT NULL UNIQUE,
    payment_method VARCHAR(50) NOT NULL
        CHECK (payment_method IN ('Cash on Delivery','Credit Card','Debit Card','EasyPaisa','JazzCash')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (payment_status IN ('Pending','Completed','Failed','Refunded')),
    CONSTRAINT fk_payment_order FOREIGN KEY (order_id)
        REFERENCES Orders(order_id) ON DELETE CASCADE
);
ENDOFFILE

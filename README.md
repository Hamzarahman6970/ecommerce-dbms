================================================================
  E-COMMERCE DATABASE MANAGEMENT SYSTEM
  Team:       Fawad Khan & Hamza Rehman
  Instructor: Mr. Ali Hassan
  Database:   PostgreSQL | OS: Ubuntu
================================================================

HOW TO RUN (Copy & Paste these commands in Ubuntu Terminal)
================================================================

STEP 1: Install PostgreSQL (if not already installed)
------------------------------------------------------
  sudo apt update
  sudo apt install postgresql postgresql-contrib -y
  sudo systemctl start postgresql
  sudo systemctl enable postgresql

STEP 2: Open PostgreSQL Shell
------------------------------------------------------
  sudo -u postgres psql

STEP 3: Set postgres password (inside psql shell)
------------------------------------------------------
  ALTER USER postgres PASSWORD 'postgres';
  \q

STEP 4: Navigate to your project folder
------------------------------------------------------
  (Copy all .sql files to a folder, e.g., ~/ecommerce_project)
  cd ~/ecommerce_project

STEP 5: Run all files in order
------------------------------------------------------
  psql -U postgres -f 01_create_database.sql
  psql -U postgres -d ecommerce_db -f 02_create_tables.sql
  psql -U postgres -d ecommerce_db -f 03_sample_data.sql
  psql -U postgres -d ecommerce_db -f 04_crud_operations.sql
  psql -U postgres -d ecommerce_db -f 05_advanced_queries.sql
  psql -U postgres -d ecommerce_db -f 06_procedures_triggers.sql

  (Enter password "postgres" when prompted each time)

OR: Run everything in one command:
------------------------------------------------------
  psql -U postgres -f 00_run_all.sql


DEMO COMMANDS FOR VIVA
================================================================

Connect to the database:
  psql -U postgres -d ecommerce_db

Useful psql commands (type inside psql):
  \dt              → list all tables
  \d Users         → describe Users table structure
  \d Orders        → describe Orders table structure
  \dv              → list all views
  \df              → list all functions/procedures

Quick demo queries (paste inside psql):
  SELECT * FROM Users;
  SELECT * FROM Products;
  SELECT * FROM Orders;
  SELECT * FROM vw_order_summary;
  SELECT * FROM vw_product_sales;
  CALL place_order(1, 4, 2, 'EasyPaisa');
  CALL update_stock(1, 100);

Exit psql:
  \q


FILE DESCRIPTIONS
================================================================
  00_run_all.sql          → Run all files automatically
  01_create_database.sql  → Creates ecommerce_db database
  02_create_tables.sql    → Creates all 6 tables with constraints
  03_sample_data.sql      → Inserts 10 users, 20 products, 10 orders...
  04_crud_operations.sql  → INSERT, SELECT, UPDATE, DELETE examples
  05_advanced_queries.sql → 20 advanced JOINs, subqueries, views, indexes
  06_procedures_triggers.sql → 2 stored procedures + 2 triggers
  07_viva_questions.sql   → 50 viva Q&A (read as text, don't run)
  README.txt              → This file

ER DIAGRAM (Text Format)
================================================================

  Users
  ──────────────────────────
  user_id (PK)
  name
  email (UNIQUE)
  password
  address
      │
      │ 1:N
      ▼
  Orders
  ──────────────────────────
  order_id (PK)
  user_id (FK → Users)
  order_date
  total_amount
      │                    │
      │ 1:N                │ 1:1
      ▼                    ▼
  Order_Items          Payments
  ──────────────────── ──────────────────────────
  order_item_id (PK)   payment_id (PK)
  order_id (FK)        order_id (FK → Orders)
  product_id (FK)      payment_method
  quantity             payment_status
  price
      │
      │ N:1
      ▼
  Products
  ──────────────────────────
  product_id (PK)
  name
  price
  stock
  category_id (FK → Categories)
      │
      │ N:1
      ▼
  Categories
  ──────────────────────────
  category_id (PK)
  category_name

================================================================
  Ready for Submission and Viva!
================================================================

-- Create the production schema if it does not already exist
CREATE SCHEMA IF NOT EXISTS production;

-- Create the production.categories table if it does not already exist
CREATE TABLE IF NOT EXISTS production.categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- Create the production.brands table if it does not already exist
CREATE TABLE IF NOT EXISTS production.brands (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

-- Create the production.products table with foreign keys to categories and brands
CREATE TABLE IF NOT EXISTS production.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (category_id) 
		REFERENCES production.categories (category_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) 
		REFERENCES production.brands (brand_id) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the sales schema if it does not already exist
CREATE SCHEMA IF NOT EXISTS sales;

-- Create the sales.customers table if it does not already exist
CREATE TABLE IF NOT EXISTS sales.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL UNIQUE,
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10)
);

-- Create the sales.stores table if it does not already exist
CREATE TABLE IF NOT EXISTS sales.stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    phone VARCHAR(25),
    email VARCHAR(255) NOT NULL UNIQUE,
    street VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10)
);

-- Create the sales.staffs table with foreign keys to stores and itself for a manager
CREATE TABLE IF NOT EXISTS sales.staffs (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(25),
    active INT NOT NULL,
    store_id INT NOT NULL,
    manager_id INT,
    FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) 
		REFERENCES sales.staffs (staff_id) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the sales.orders table with foreign keys to customers, stores, and staffs
CREATE TABLE IF NOT EXISTS sales.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status INT NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    shipped_date DATE,
    store_id INT NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (customer_id) 
		REFERENCES sales.customers (customer_id) 
		ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) 
		REFERENCES sales.staffs (staff_id) 
		ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Create the production.stocks table with a composite primary key
CREATE TABLE IF NOT EXISTS production.stocks (
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) 
		REFERENCES sales.stores (store_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) 
		REFERENCES production.products (product_id) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create the sales.order_items table with a composite primary key
CREATE TABLE IF NOT EXISTS sales.order_items (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) 
		REFERENCES sales.orders (order_id) 
		ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) 
		REFERENCES production.products (product_id) 
		ON DELETE CASCADE ON UPDATE CASCADE
);

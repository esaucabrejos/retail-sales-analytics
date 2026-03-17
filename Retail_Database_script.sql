CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_HQ VARCHAR(150) NOT NULL,
    opening_date DATE NOT NULL
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(150),
    contact_phone VARCHAR(20)
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    cost_price DECIMAL(10 , 2 ) NOT NULL,
    selling_price DECIMAL(10 , 2 ) NOT NULL,
    active_status BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_category FOREIGN KEY (category_id)
        REFERENCES categories (category_id),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id)
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_type VARCHAR(50) NOT NULL,
    registration_date DATE
);

SHOW TABLES;


CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    customer_id INT,
    sale_date DATETIME NOT NULL,
    total_amount DECIMAL(12 , 2 ) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    CONSTRAINT fk_store FOREIGN KEY (store_id)
        REFERENCES stores (store_id),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);

CREATE TABLE sales_detail (
    sale_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    subtotal DECIMAL(12 , 2 ) NOT NULL,
    CONSTRAINT fk_sale FOREIGN KEY (sale_id)
        REFERENCES sales (sale_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL,
    last_update DATETIME NOT NULL,
    CONSTRAINT fk_inventory_store FOREIGN KEY (store_id)
        REFERENCES stores (store_id),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

CREATE TABLE purchases (
    purchase_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    store_id INT NOT NULL,
    purchase_date DATETIME NOT NULL,
    total_cost DECIMAL(12 , 2 ) NOT NULL,
    CONSTRAINT fk_pruchase_supplier FOREIGN KEY (supplier_id)
        REFERENCES suppliers (supplier_id),
    CONSTRAINT fk_purchase_store FOREIGN KEY (store_id)
        REFERENCES stores (store_id)
);

CREATE TABLE purchase_detail (
    purchase_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10 , 2 ) NOT NULL,
    subtotal DECIMAL(12 , 2 ) NOT NULL,
    CONSTRAINT fk_purchase_detail FOREIGN KEY (purchase_id)
        REFERENCES purchases (purchase_id),
    CONSTRAINT fk_purchase_product FOREIGN KEY (product_id)
        REFERENCES products (product_id)
);

USE retail_data_system;

SELECT 
	s.store_id,
    st.store_name,
    DATE_FORMAT(s.sale_date, '%Y-%m') AS year__month,
    COUNT(DISTINCT s.sale_id) AS total_transactions,
    SUM(s.total_amount) AS total_revenue,
    ROUND(AVG(s.total_amount),2) AS avg_ticket
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, year__month
ORDER BY year__month, s.store_id;

SELECT 
	p.product_id,
    p.product_name,
    SUM(sd.quantity) AS total_units_sold,
    SUM(sd.subtotal) AS total_revenue,
    SUM(sd.quantity * p.cost_price) AS total_cost,
    SUM(sd.subtotal) - SUM(sd.quantity * p.cost_price) AS gross_profit
FROM sales_detail sd
JOIN products p ON sd.product_id = p.product_id
GROUP BY p.product_id
ORDER BY gross_profit DESC
LIMIT 10;

CREATE OR REPLACE VIEW sales_analytics AS
SELECT
	s.sale_id,
    s.sale_date,
    s.store_id,
    st.store_name,
    sd.product_id,
    p.product_name,
    c.category_name,
    sd.quantity,
    sd.unit_price,
    sd.subtotal,
    p.cost_price,
    (sd.subtotal - (sd.quantity * p.cost_price)) AS profit
FROM sales s
JOIN sales_detail sd ON s.sale_id = sd.sale_id
JOIN products p ON sd.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id 
JOIN stores st ON s.store_id = st.store_id;

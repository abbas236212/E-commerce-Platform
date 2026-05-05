CREATE DATABASE IF NOT EXISTS online_shopping;
USE online_shopping;
SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;
CREATE TABLE customer (
    customer_id   INT            AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    phone         VARCHAR(20),
    address       VARCHAR(300),
    created_at    DATETIME       DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE vendor (
    vendor_id     INT            AUTO_INCREMENT PRIMARY KEY,
    vendor_name   VARCHAR(150)   NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    phone         VARCHAR(20),
    store_name    VARCHAR(200)   NOT NULL,
    joined_date   DATETIME       DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE category (
    category_id   INT            AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100)   NOT NULL UNIQUE,
    description   VARCHAR(300)
);
CREATE TABLE product (
    product_id     INT            AUTO_INCREMENT PRIMARY KEY,
    vendor_id      INT            NOT NULL,
    category_id    INT            NOT NULL,
    product_name   VARCHAR(200)   NOT NULL,
    unit_price     DECIMAL(10,2)  NOT NULL,
    stock_qty      INT            DEFAULT 0,
    product_status VARCHAR(20)    DEFAULT 'Active',
    created_at     DATETIME       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prod_vendor    FOREIGN KEY (vendor_id)   REFERENCES vendor(vendor_id),
    CONSTRAINT fk_prod_category  FOREIGN KEY (category_id) REFERENCES category(category_id),
    CONSTRAINT chk_price         CHECK (unit_price > 0),
    CONSTRAINT chk_stock         CHECK (stock_qty >= 0),
    CONSTRAINT chk_prod_status   CHECK (product_status IN ('Active','Inactive','OutOfStock'))
);
CREATE TABLE cart (
    cart_id       INT       AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT       NOT NULL UNIQUE,
    created_at    DATETIME  DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE cart_items (
    cart_item_id  INT   AUTO_INCREMENT PRIMARY KEY,
    cart_id       INT   NOT NULL,
    product_id    INT   NOT NULL,
    quantity      INT   NOT NULL,
    CONSTRAINT fk_cartitem_cart    FOREIGN KEY (cart_id)    REFERENCES cart(cart_id),
    CONSTRAINT fk_cartitem_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT chk_cart_qty        CHECK (quantity > 0)
);
CREATE TABLE orders (
    order_id      INT            AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT            NOT NULL,
    order_date    DATETIME       DEFAULT CURRENT_TIMESTAMP,
    order_status  VARCHAR(30)    DEFAULT 'Pending',
    total_amount  DECIMAL(12,2)  NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT chk_order_status  CHECK (order_status IN ('Pending','Confirmed','Shipped','Delivered','Cancelled'))
);
CREATE TABLE order_items (
    order_item_id INT            AUTO_INCREMENT PRIMARY KEY,
    order_id      INT            NOT NULL,
    product_id    INT            NOT NULL,
    quantity      INT            NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL,
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES product(product_id),
    CONSTRAINT chk_oi_qty    CHECK (quantity > 0),
    CONSTRAINT chk_oi_price  CHECK (unit_price > 0)
);

CREATE TABLE payment (
    payment_id     INT            AUTO_INCREMENT PRIMARY KEY,
    order_id       INT            NOT NULL UNIQUE,
    method         VARCHAR(50)    NOT NULL,
    amount         DECIMAL(12,2)  NOT NULL,
    payment_status VARCHAR(30)    DEFAULT 'Pending',
    payment_date   DATETIME       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pay_order   FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT chk_pay_method CHECK (method IN ('Credit Card','Debit Card','Bank Transfer','Cash on Delivery','Wallet')),
    CONSTRAINT chk_pay_status CHECK (payment_status IN ('Pending','Completed','Failed','Refunded'))
);
CREATE TABLE shipment (
    shipment_id     INT           AUTO_INCREMENT PRIMARY KEY,
    order_id        INT           NOT NULL UNIQUE,
    courier_name    VARCHAR(100)  NOT NULL,
    tracking_no     VARCHAR(100)  NOT NULL UNIQUE,
    delivery_status VARCHAR(30)   DEFAULT 'Processing',
    shipped_date    DATE,
    delivered_date  DATE,
    CONSTRAINT fk_ship_order   FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT chk_ship_status CHECK (delivery_status IN ('Processing','Shipped','Out for Delivery','Delivered','Returned'))
);
CREATE TABLE reviews (
    review_id    INT            AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT            NOT NULL,
    product_id   INT            NOT NULL,
    rating       DECIMAL(2,1)   NOT NULL,
    review_text  VARCHAR(1000),
    review_date  DATETIME       DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rev_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    CONSTRAINT fk_rev_product  FOREIGN KEY (product_id)  REFERENCES product(product_id),
    CONSTRAINT chk_rating      CHECK (rating BETWEEN 1 AND 5)
);

CREATE TABLE discounts (
    discount_id      INT            AUTO_INCREMENT PRIMARY KEY,
    discount_code    VARCHAR(30)    NOT NULL UNIQUE,
    discount_percent DECIMAL(5,2)   NOT NULL,
    valid_from       DATE           NOT NULL,
    valid_until      DATE           NOT NULL,
    is_active        CHAR(1)        DEFAULT 'Y',
    CONSTRAINT chk_disc_pct    CHECK (discount_percent BETWEEN 1 AND 100),
    CONSTRAINT chk_disc_active CHECK (is_active IN ('Y','N'))
);
CREATE TABLE discount_usage (
    usage_id     INT  AUTO_INCREMENT PRIMARY KEY,
    discount_id  INT  NOT NULL,
    order_id     INT  NOT NULL,
    CONSTRAINT fk_du_discount FOREIGN KEY (discount_id) REFERENCES discounts(discount_id),
    CONSTRAINT fk_du_order    FOREIGN KEY (order_id)    REFERENCES orders(order_id),
    CONSTRAINT uq_du          UNIQUE (discount_id, order_id)
);
INSERT INTO customer (full_name, email, phone, address) VALUES
('Ali Hassan',      'ali.hassan@email.com',    '0300-1234567', 'House 12, Rawalpindi'),
('Sara Malik',      'sara.malik@email.com',    '0311-2345678', 'Street 4, Lahore'),
('Usman Khan',      'usman.khan@email.com',    '0321-3456789', 'Block B, Islamabad'),
('Fatima Zahra',    'fatima.z@email.com',      '0333-4567890', 'Karachi Main Road'),
('Bilal Akhtar',    'bilal.akhtar@email.com',  '0345-5678901', 'Gulberg III, Lahore'),
('Nadia Rehman',    'nadia.rehman@email.com',  '0301-6789012', 'F-7, Islamabad'),
('Tariq Mehmood',   'tariq.m@email.com',       '0312-7890123', 'Faisalabad City'),
('Ayesha Siddiqui', 'ayesha.s@email.com',      '0322-8901234', 'DHA Phase 2, Karachi');

INSERT INTO vendor (vendor_name, email, phone, store_name) VALUES
('Tech Bazaar Pvt Ltd', 'info@techbazaar.pk',     '0300-1111111', 'TechBazaar'),
('Fashion Hub',         'contact@fashionhub.pk',  '0311-2222222', 'FashionHub PK'),
('Home Essentials Co.', 'sales@homeessentials.pk','0321-3333333', 'HomeEssentials'),
('Sports World',        'info@sportsworld.pk',    '0333-4444444', 'SportsWorld PK');
INSERT INTO category (category_name, description) VALUES
('Electronics',  'Phones, Laptops, Gadgets'),
('Fashion',      'Clothing and Accessories'),
('Home & Living','Furniture and Appliances'),
('Sports',       'Sports Equipment and Gear'),
('Books',        'Educational and Fiction Books');

INSERT INTO product (vendor_id, category_id, product_name, unit_price, stock_qty) VALUES
(1, 1, 'Samsung Galaxy S24',      189999.00,  50),
(1, 1, 'Dell Laptop Inspiron 15', 149999.00,  30),
(1, 1, 'Sony Headphones WH-1000',  45000.00,   8),
(2, 2, 'Men Casual Shirt',          2500.00, 200),
(2, 2, 'Women Formal Kurta',        3800.00, 150),
(2, 2, 'Leather Handbag',           8500.00,  60),
(3, 3, 'Wooden Dining Table',      55000.00,  15),
(3, 3, 'Non-Stick Cookware Set',   12000.00,  40),
(4, 4, 'Cricket Bat (Hardball)',    7500.00,  80),
(4, 4, 'Football Adidas Size 5',   4200.00,   5),
(1, 1, 'USB-C Fast Charger',        1800.00, 120),
(3, 3, 'Air Purifier LG',          38000.00,   3);
INSERT INTO cart (customer_id) VALUES (1), (2), (3);

INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 4, 2),
(1, 9, 1),
(2, 1, 1),
(3, 7, 1);
INSERT INTO orders (customer_id, order_date, order_status, total_amount) VALUES
(1, '2024-11-01', 'Delivered',  379998.00),
(2, '2024-11-05', 'Delivered',   45000.00),
(3, '2024-11-10', 'Shipped',    149999.00),
(4, '2024-11-15', 'Pending',      6300.00),
(5, '2024-12-01', 'Delivered',   55000.00),
(6, '2024-12-10', 'Cancelled',    7500.00),
(7, '2024-12-15', 'Confirmed',   20400.00),
(8, '2025-01-05', 'Delivered',   16200.00),
(1, '2025-01-12', 'Delivered',   12000.00),
(2, '2025-02-01', 'Shipped',      8500.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 2, 189999.00),
(2,  3, 1,  45000.00),
(3,  2, 1, 149999.00),
(4,  4, 1,   2500.00),
(4,  5, 1,   3800.00),
(5,  7, 1,  55000.00),
(6,  9, 1,   7500.00),
(7,  4, 4,   2500.00),
(7, 11, 2,   1800.00),
(8,  4, 2,   2500.00),
(8,  5, 3,   3800.00),
(9,  8, 1,  12000.00),
(10, 6, 1,   8500.00);

INSERT INTO payment (order_id, method, amount, payment_status) VALUES
(1,  'Credit Card',      379998.00, 'Completed'),
(2,  'Bank Transfer',     45000.00, 'Completed'),
(3,  'Debit Card',       149999.00, 'Completed'),
(4,  'Cash on Delivery',   6300.00, 'Pending'),
(5,  'Credit Card',       55000.00, 'Completed'),
(6,  'Wallet',             7500.00, 'Refunded'),
(7,  'Bank Transfer',     20400.00, 'Completed'),
(8,  'Credit Card',       16200.00, 'Completed'),
(9,  'Debit Card',        12000.00, 'Completed'),
(10, 'Credit Card',        8500.00, 'Completed');

INSERT INTO shipment (order_id, courier_name, tracking_no, delivery_status, shipped_date, delivered_date) VALUES
(1,  'TCS Courier', 'TCS-0001', 'Delivered',        '2024-11-02', '2024-11-05'),
(2,  'Leopards',    'LEO-0002', 'Delivered',        '2024-11-06', '2024-11-09'),
(3,  'BlueEx',      'BEX-0003', 'Shipped',          '2024-11-11', NULL),
(5,  'TCS Courier', 'TCS-0005', 'Delivered',        '2024-12-02', '2024-12-06'),
(7,  'Leopards',    'LEO-0007', 'Out for Delivery', '2024-12-16', NULL),
(8,  'BlueEx',      'BEX-0008', 'Delivered',        '2025-01-06', '2025-01-10'),
(9,  'TCS Courier', 'TCS-0009', 'Delivered',        '2025-01-13', '2025-01-16'),
(10, 'BlueEx',      'BEX-0010', 'Shipped',          '2025-02-02', NULL);

INSERT INTO reviews (customer_id, product_id, rating, review_text) VALUES
(1, 1, 5.0, 'Excellent phone, very fast!'),
(2, 3, 4.0, 'Great sound quality, comfortable fit.'),
(3, 2, 4.5, 'Good laptop, slightly heavy though.'),
(4, 4, 3.0, 'Average quality, okay for the price.'),
(4, 5, 5.0, 'Beautiful kurta, great stitching!'),
(5, 7, 5.0, 'Solid table, easy to assemble.'),
(6, 9, 2.0, 'Bat broke after a few uses.'),
(7, 4, 4.0, 'Nice shirt, fits well.'),
(8, 4, 4.0, 'Good material, fast delivery.'),
(8, 5, 5.0, 'Love the design and color!');

INSERT INTO discounts (discount_code, discount_percent, valid_from, valid_until, is_active) VALUES
('EID2024',   20.00, '2024-04-01', '2024-04-15', 'N'),
('WELCOME10', 10.00, '2024-01-01', '2025-12-31', 'Y'),
('WINTER25',  25.00, '2024-12-01', '2024-12-31', 'N'),
('SALE50',    50.00, '2025-01-01', '2025-01-07', 'N');
INSERT INTO discount_usage (discount_id, order_id) VALUES (2, 4), (3, 7);
 
COMMIT;



SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    c.category_name,
    p.unit_price,
    p.stock_qty,
    p.product_status
FROM product p
JOIN vendor   v ON p.vendor_id   = v.vendor_id
JOIN category c ON p.category_id = c.category_id
ORDER BY p.product_id;

SELECT
    o.order_id,
    c.full_name      AS customer_name,
    o.order_date,
    o.order_status,
    o.total_amount
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

SELECT
    o.order_id,
    c.full_name         AS customer,
    p.product_name,
    v.vendor_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders      o
JOIN customer    c  ON o.customer_id  = c.customer_id
JOIN order_items oi ON o.order_id     = oi.order_id
JOIN product     p  ON oi.product_id  = p.product_id
JOIN vendor      v  ON p.vendor_id    = v.vendor_id
ORDER BY o.order_id;

SELECT
    pay.payment_id,
    c.full_name     AS customer,
    o.order_id,
    pay.method,
    pay.amount,
    pay.payment_status,
    pay.payment_date
FROM payment  pay
JOIN orders   o ON pay.order_id  = o.order_id
JOIN customer c ON o.customer_id = c.customer_id
ORDER BY pay.payment_id;

SELECT
    s.shipment_id,
    c.full_name       AS customer,
    o.order_id,
    s.courier_name,
    s.tracking_no,
    s.delivery_status,
    s.shipped_date,
    s.delivered_date
FROM shipment  s
JOIN orders    o ON s.order_id    = o.order_id
JOIN customer  c ON o.customer_id = c.customer_id
ORDER BY s.shipment_id;
SELECT
    r.review_id,
    c.full_name    AS customer,
    p.product_name,
    r.rating,
    r.review_text,
    r.review_date
FROM reviews  r
JOIN customer c ON r.customer_id = c.customer_id
JOIN product  p ON r.product_id  = p.product_id
ORDER BY r.review_date DESC;
SELECT
    c.full_name    AS customer,
    p.product_name,
    ci.quantity,
    p.unit_price,
    (ci.quantity * p.unit_price) AS subtotal
FROM cart_items ci
JOIN cart     ca ON ci.cart_id     = ca.cart_id
JOIN customer c  ON ca.customer_id = c.customer_id
JOIN product  p  ON ci.product_id  = p.product_id
ORDER BY c.full_name;

SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    SUM(oi.quantity)                   AS total_sold,
    SUM(oi.quantity * oi.unit_price)   AS total_revenue
FROM order_items oi
JOIN product  p ON oi.product_id = p.product_id
JOIN vendor   v ON p.vendor_id   = v.vendor_id
JOIN orders   o ON oi.order_id   = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY p.product_id, p.product_name, v.vendor_name
ORDER BY total_sold DESC
LIMIT 5;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id)                  AS total_orders,
    SUM(total_amount)                AS monthly_revenue
FROM orders
WHERE order_status != 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
SELECT
    v.vendor_id,
    v.vendor_name,
    v.store_name,
    COUNT(DISTINCT o.order_id)            AS total_orders,
    SUM(oi.quantity)                      AS units_sold,
    SUM(oi.quantity * oi.unit_price)      AS total_revenue
FROM vendor      v
JOIN product     p  ON v.vendor_id  = p.vendor_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders      o  ON oi.order_id  = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY v.vendor_id, v.vendor_name, v.store_name
ORDER BY total_revenue DESC;

SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    c.category_name,
    p.stock_qty,
    CASE
        WHEN p.stock_qty = 0  THEN 'OUT OF STOCK'
        WHEN p.stock_qty <= 5 THEN 'CRITICAL'
        ELSE 'LOW'
    END AS stock_alert
FROM product  p
JOIN vendor   v ON p.vendor_id   = v.vendor_id
JOIN category c ON p.category_id = c.category_id
WHERE p.stock_qty <= 10
ORDER BY p.stock_qty ASC;
SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    COUNT(r.review_id)          AS review_count,
    ROUND(AVG(r.rating), 2)     AS avg_rating,
    MAX(r.rating)               AS highest_rating,
    MIN(r.rating)               AS lowest_rating
FROM product  p
JOIN vendor   v ON p.vendor_id  = v.vendor_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, v.vendor_name
ORDER BY avg_rating DESC;
SELECT
    delivery_status,
    COUNT(*)  AS shipment_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM shipment), 2) AS percentage
FROM shipment
GROUP BY delivery_status
ORDER BY shipment_count DESC;
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id)    AS total_orders,
    SUM(o.total_amount)  AS lifetime_spend,
    MAX(o.order_date)    AS last_order_date
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY lifetime_spend DESC;
sELECT
    method,
    COUNT(*)              AS usage_count,
    SUM(amount)           AS total_collected,
    ROUND(AVG(amount), 2) AS avg_payment
FROM payment
WHERE payment_status = 'Completed'
GROUP BY method
ORDER BY total_collected DESC;SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    p.stock_qty
FROM product     p
JOIN vendor      v  ON p.vendor_id  = v.vendor_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL
ORDER BY p.product_id;SELECT
    cat.category_name,
    COUNT(DISTINCT p.product_id)          AS products_listed,
    SUM(oi.quantity)                      AS units_sold,
    SUM(oi.quantity * oi.unit_price)      AS category_revenue
FROM category    cat
JOIN product     p   ON cat.category_id = p.category_id
JOIN order_items oi  ON p.product_id    = oi.product_id
JOIN orders      o   ON oi.order_id     = o.order_id
WHERE o.order_status != 'Cancelled'
GROUP BY cat.category_name
ORDER BY category_revenue DESC;
SELECT
    o.order_id,
    c.full_name       AS customer,
    d.discount_code,
    d.discount_percent,
    o.total_amount    AS original_amount,
    ROUND(o.total_amount * (1 - d.discount_percent / 100), 2) AS discounted_amount
FROM orders        o
JOIN customer      c  ON o.customer_id  = c.customer_id
JOIN discount_usage du ON o.order_id   = du.order_id
JOIN discounts     d  ON du.discount_id = d.discount_id
ORDER BY o.order_id;
SELECT customer_id, full_name, email, phone
FROM customer
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id FROM orders
)
ORDER BY customer_id;
SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    avg_data.avg_rating
FROM product p
JOIN vendor  v ON p.vendor_id = v.vendor_id
JOIN (
    SELECT product_id, ROUND(AVG(rating), 2) AS avg_rating
    FROM reviews
    GROUP BY product_id
    HAVING AVG(rating) >= 4
) avg_data ON p.product_id = avg_data.product_id
ORDER BY avg_data.avg_rating DESC;
SELECT
    courier_name,
    COUNT(*)                                               AS total_deliveries,
    ROUND(AVG(DATEDIFF(delivered_date, shipped_date)), 1)  AS avg_delivery_days
FROM shipment
WHERE delivered_date IS NOT NULL
GROUP BY courier_name
ORDER BY avg_delivery_days ASC;
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    c.full_name          AS customer_name,
    c.email              AS customer_email,
    o.order_date,
    o.order_status,
    o.total_amount,
    pay.method           AS payment_method,
    pay.payment_status,
    s.courier_name,
    s.tracking_no,
    s.delivery_status
FROM orders    o
JOIN customer  c    ON o.customer_id = c.customer_id
LEFT JOIN payment  pay ON o.order_id = pay.order_id
LEFT JOIN shipment s   ON o.order_id = s.order_id;

SELECT * FROM vw_order_summary ORDER BY order_id;
CREATE OR REPLACE VIEW vw_product_catalog AS
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    v.store_name           AS sold_by,
    p.unit_price,
    p.stock_qty,
    p.product_status,
    ROUND(AVG(r.rating), 1) AS avg_rating
FROM product   p
JOIN vendor    v   ON p.vendor_id   = v.vendor_id
JOIN category  cat ON p.category_id = cat.category_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, cat.category_name,
         v.store_name, p.unit_price, p.stock_qty, p.product_status;
         CREATE OR REPLACE VIEW vw_low_stock AS
SELECT
    p.product_id,
    p.product_name,
    v.vendor_name,
    v.email        AS vendor_email,
    p.stock_qty,
    CASE
        WHEN p.stock_qty = 0  THEN 'OUT OF STOCK'
        WHEN p.stock_qty <= 5 THEN 'CRITICAL'
        ELSE 'LOW'
    END AS stock_alert
FROM product p
JOIN vendor  v ON p.vendor_id = v.vendor_id
WHERE p.stock_qty <= 10;
SELECT * FROM vw_low_stock ORDER BY stock_qty;
CREATE OR REPLACE VIEW vw_vendor_revenue AS
SELECT
    v.vendor_id,
    v.vendor_name,
    v.store_name,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    SUM(oi.quantity * oi.unit_price)    AS total_revenue,
    ROUND(AVG(r.rating), 2)             AS avg_product_rating
FROM vendor      v
JOIN product     p  ON v.vendor_id  = p.vendor_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders      o  ON oi.order_id  = o.order_id AND o.order_status != 'Cancelled'
LEFT JOIN reviews     r  ON p.product_id = r.product_id
GROUP BY v.vendor_id, v.vendor_name, v.store_name;
SELECT * FROM vw_vendor_revenue ORDER BY total_revenue DESC;

UPDATE orders SET order_status = 'Delivered' WHERE order_id = 3;
UPDATE product SET stock_qty = stock_qty - 1 WHERE product_id = 3;
UPDATE discounts SET is_active = 'N' WHERE discount_code = 'WELCOME10';
UPDATE shipment
SET delivery_status = 'Delivered', delivered_date = CURDATE()
WHERE tracking_no = 'BEX-0003';
DELETE FROM cart_items WHERE cart_item_id = 1;

SELECT * FROM customer ORDER BY customer_id;
SELECT * FROM vendor ORDER BY vendor_id;
SELECT * FROM category ORDER BY category_id;


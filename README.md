E-commerce Platform Database (DBMS Project)
Overview

This project implements a fully normalized relational database system for a multi-vendor e-commerce platform using SQL (Oracle/MySQL-compatible). It manages all core functionalities including:

Customer registration and management
Vendor onboarding and store management
Product listings and category handling
Shopping cart and order processing
Payment recording and shipment tracking
Customer reviews and discount code management

The database design follows Third Normal Form (3NF) and includes primary keys, foreign keys, unique constraints, check constraints, default values, and not-null rules to ensure data integrity.

Features
Normalized database schema for 13 core tables
Constraint enforcement to prevent data anomalies
Sample data simulating a realistic e-commerce marketplace
Representative SQL queries: joins, subqueries, aggregations, and reporting
Extensible design for future web apps or REST API integration
Database Schema

The database consists of the following main tables:

customer, vendor, category, product
cart, cart_items
orders, order_items
payment, shipment
reviews, discounts, discount_usage

Relationships include one-to-one, one-to-many, and many-to-many via junction tables like order_items and discount_usage.

Sample Queries

The repository includes practical queries such as:

Listing all products with vendor and category info
Customer order history and lifetime value
Top-selling products and vendor-wise sales summaries
Low stock alerts and active cart contents
Products with average rating ≥ 4
Setup Instructions
Clone the repository:
git clone https://github.com/your-username/online-shopping-db.git
Open your SQL client (MySQL/Oracle).
Run the SQL script SQL code.sql to create tables and insert sample data.
Execute queries from the script to explore the database functionality.
Future Enhancements
Implement views, stored procedures, and triggers
Add user roles and access control
Integrate with a front-end web application or REST API
Author

Muhammad Abbas – Student, Department of Computer Science, Riphah International University

License

This project is open-source and free to use for educational purposes.

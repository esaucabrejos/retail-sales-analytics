**Retail Sales Analytics Dashboard**
End-to-end data analytics pipeline that transforms raw transactional data into actionable business insights using Python, MySQL, and Tableau.

**Overview**
This project simulates a retail sales environment across 3 stores, 6 relational tables, and hundreds of transactions. The goal is to demonstrate a complete analytics workflow — from data generation and relational modeling to SQL aggregation and interactive BI visualization.

| Tool    | Purpose                        |
|---------|-------------------------------|
| Python  | Synthetic data generation      |
| MySQL   | Relational database and modeling |
| Tableau | Interactive dashboard & KPIs    |

**Database Schema**
The simulated retail database includes the following main tables:
    stores –> store locations
    categories –> product categories
    suppliers –> supplier information
    products –> product catalog
    sales –> sales transactions
    sales_detail –> individual items sold per transaction

**Dashboard**
The Tableau dashboard covers the following metrics:
**KPIs**
    Total Revenue
    Total Profit
    Profit Margin
**Trends**
    Revenue by Month
**Comparisons**
    Revenue by Store
    Profit by Category
    Units Sold by Category
**Product Analysis**
    Top 10 Best-Selling Products

**Key Insights**
Some insights obtained from the simulated data include:

    Beverage products generate the highest revenue and profit across all stores.
    Sales performance across the three stores is relatively balanced.
    Seasonal patterns appear in the monthly revenue trend.
    A small group of products contributes significantly to total revenue.

**How to Run**
1. Database setup - Run *Retail_Database_script.sql* in MySQL Workbench to create the schema and load the analytical view.
2. Data generation - Execute *seed_data.py* to populate the database with synthetic retail data.
3. Visualization - Open *Dashboard.twbx* in Tableau Desktop to explore the interactive dashboard.

**Author**
Esau Cabrejos

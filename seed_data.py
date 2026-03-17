import mysql.connector
from datetime import datetime, timedelta
import random

def create_connection():
    connection = mysql.connector.connect(
        host = "localhost",
        user = "root",
        password = "Randall_12",
        database = "retail_data_system"
    )
    return connection

def table_has_data(cursor, table_name):
    cursor.execute(f'SELECT COUNT(*) FROM {table_name}')
    count = cursor.fetchone()[0]
    return count > 0

def insert_stores(cursor):
    if table_has_data(cursor, "stores"):
        print("La tabla stores ya tiene datos, saltando inserción.")
        return
    stores = [
        ("Sucursal Centro", "Centro CDMX", "2022-01-01"),
        ("Sucursal Norte", "Norte CDMX", "2022-03-15"),
        ("Sucursal Sur", "Sur CDMX", "2022-06-10"),
    ]

    query = "INSERT INTO stores (store_name, store_HQ, opening_date) VALUES (%s, %s, %s)"
    for store in stores:
        cursor.execute(query, store)

def insert_categories(cursor):
    if table_has_data(cursor, "categories"):
        print("La tabla categories ya tiene datos, saltando inserción.")
        return
    categories = [
        ("Bebidas",),
        ("Snacks",),
        ("Lacteos",),
        ("Panaderia",),
        ("Abarrotes",),
        ("Limpieza",),
        ("Higiene Personal",),
        ("Mascotas",)
    ]

    query = "INSERT INTO categories (category_name) VALUES (%s)"
    for category in categories:
        cursor.execute(query, category)

def insert_suppliers(cursor, num_suppliers = 20):
    if table_has_data(cursor, "suppliers"):
        print("La tabla suppliers ya tiene datos, saltando inserción.")
        return
    query = """ 
    INSERT INTO suppliers (supplier_name, contact_email, contact_phone)
    VALUES (%s, %s, %s)
    """
    for i in range(1, num_suppliers + 1):
        supplier = (
            f'Proveedor_{i}',
            f'proveedor{i}@mail.com',
            f'555000{i:03}'
        )
        cursor.execute(query, supplier)

def insert_products(cursor, num_products = 500):
    if table_has_data(cursor, "products"):
        print("La tabla products, saltando inserción.")
        return
    query = """
    INSERT INTO products
    (product_name, category_id, supplier_id, cost_price, selling_price, active_status)
    VALUES(%s, %s, %s, %s, %s, %s)
    """

    for i in range(1, num_products + 1):
        category_id = random.randint(1, 8)
        supplier_id = random.randint(1, 20)
        cost_price = round(random.uniform(5,200),2)
        margin_multiplier = random.uniform(1.15, 1.40)
        selling_price = round(cost_price*margin_multiplier, 2)

        product = (
            f'Producto_{i}',
            category_id,
            supplier_id,
            cost_price,
            selling_price,
            True
        )
        cursor.execute(query, product)

def insert_inventory(cursor):
    if table_has_data(cursor, "inventory"):
        print('La tabla inventory ya tiene datos, saltando inserción')
        return
    query = """ 
    INSERT INTO inventory (store_id, product_id, stock_quantity, last_update)
    VALUES (%s, %s, %s, %s)
    """
    for store_id in range(1,4):
        for product_id in range(1,501):
            stock = random.randint(50, 200)

            cursor.execute(query, (
                store_id,
                product_id,
                stock,
                datetime.now()
            ))

def generate_sales(cursor, days = 180):
    if table_has_data(cursor, "sales"):
        print("La tabla sales ya tiene datos, saltando inserción")
        return
    
    sale_query = """
    INSERT INTO sales (store_id, customer_id, sale_date, total_amount, payment_method)
    VALUES (%s, %s, %s, %s, %s)
    """
    detail_query = """
    INSERT INTO sales_detail (sale_id, product_id, quantity, unit_price, subtotal)
    VALUES (%s, %s, %s, %s, %s)
    """
    payment_methods = ["Efectivo", "Tarjeta", "Transferencia"]
    start_date = datetime.now() - timedelta(days=days)

    for day in range(days):
        current_date = start_date + timedelta(days=day)

        for store_id in range(1,4):
            num_sales = random.randint(10, 30)

            for _ in range(num_sales):
                customer_id = None
                payment = random.choice(payment_methods)

                cursor.execute(sale_query, (
                    store_id,
                    customer_id,
                    current_date,
                    0,
                    payment
                ))

                sale_id = cursor.lastrowid
                total_amount = 0
                num_items = random.randint(1, 5)

                for _ in range(num_items):
                    product_id = random.randint(1, 500)
                    quantity = random.randint(1,3)
                    cursor.execute(
                        "SELECT selling_price FROM products WHERE product_id = %s",
                        (product_id,)
                    )
                    price = cursor.fetchone()[0]
                    subtotal = price * quantity
                    total_amount += subtotal

                    cursor.execute(detail_query, (
                        sale_id,
                        product_id,
                        quantity, 
                        price,
                        subtotal
                    ))
                cursor.execute(
                        "UPDATE sales SET total_amount = %s WHERE sale_id = %s",
                       (total_amount, sale_id)
                )
                

    

if __name__ == "__main__":
    conn = create_connection()
    cursor = conn.cursor()
    insert_stores(cursor)
    insert_categories(cursor)
    insert_suppliers(cursor)
    insert_products(cursor)
    insert_inventory(cursor)
    generate_sales(cursor)
    conn.commit()
    cursor.close()
    conn.close()
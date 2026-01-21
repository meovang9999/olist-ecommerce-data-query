import pandas as pd
from sqlalchemy import create_engine, text
import os

url_connection = " " #MySQL connection info
engine = create_engine(url_connection)

sql_setup = """
DROP DATABASE IF EXISTS olist;
CREATE DATABASE olist;
USE olist;

CREATE TABLE olist_customers(
    customer_id varchar(100) not null,
    customer_unique_id varchar(100) null,
    customer_zip_code_prefix varchar(20) null,
    customer_city varchar(100) null,    
    customer_state varchar(15) null,
    primary key (customer_id)
);

CREATE TABLE olist_orders(
    order_id varchar(100),
    customer_id varchar(100),
    order_status varchar(50),
    order_purchase_timestamp datetime,
    order_approved_at datetime,
    order_delivered_carrier_date datetime,
    order_delivered_customer_date datetime,
    order_estimated_delivery_date datetime,
    primary key (order_id),
    foreign key (customer_id) references olist_customers(customer_id)
);

CREATE TABLE olist_products(
    product_id varchar(100),
    product_category_name varchar(100),
    product_name_lenght int,
    product_description_lenght int,
    product_photos_qty int,
    product_weight_g decimal(10, 2),
    product_length_cm decimal(10, 2),
    product_height_cm decimal(10, 2),
    product_width_cm decimal(10, 2),
    primary key (product_id)
);

CREATE TABLE olist_sellers(
    seller_id varchar(100),
    seller_zip_code_prefix varchar(10),
    seller_city varchar(100),
    seller_state char(2),
    primary key (seller_id)
);

CREATE TABLE olist_geolocation(
    geolocation_zip_code_prefix varchar(20),
    geolocation_lat decimal(12,8),
    geolocation_lng decimal(12,8),
    geolocation_city varchar(100),
    geolocation_state varchar(10)
);

CREATE TABLE olist_order_items(
    order_id varchar(100),
    order_item_id int,
    product_id varchar(100),
    seller_id varchar(100),
    shipping_limit_date datetime,
    price decimal(10, 2),
    freight_value decimal(10, 2),
    primary key (order_id, order_item_id),
    foreign key (order_id) references olist_orders(order_id),
    foreign key (product_id) references olist_products(product_id),
    foreign key (seller_id) references olist_sellers(seller_id)
);

CREATE TABLE olist_order_payments(
    order_id varchar(100),
    payment_sequential int,
    payment_type varchar(20),
    payment_installments int,
    payment_value decimal(10, 2),
    foreign key (order_id) references olist_orders(order_id)
);

CREATE TABLE olist_order_reviews(
    review_id varchar(100),
    order_id varchar(100),
    review_score int,
    review_comment_title varchar(255),
    review_comment_message text,
    review_creation_date datetime,
    review_answer_timestamp datetime,
    primary key (review_id, order_id),
    foreign key (order_id) references olist_orders(order_id)
);

CREATE TABLE product_category_name_translation(
    product_category_name varchar(100),
    product_category_name_english varchar(100),
    primary key (product_category_name)
);
"""

with engine.connect() as conn:
    for statement in sql_setup.split(';'):
        if statement.strip():
            conn.execute(text(statement))
    conn.execute(text("COMMIT;"))

engine = create_engine(url_connection + "olist")

csv_folder = " " #Dataset folder path
file_table_map = {
    "olist_customers_dataset.csv": "olist_customers",
    "olist_products_dataset.csv": "olist_products",
    "olist_sellers_dataset.csv": "olist_sellers",
    "olist_geolocation_dataset.csv": "olist_geolocation",
    "product_category_name_translation.csv": "product_category_name_translation",
    "olist_orders_dataset.csv": "olist_orders",
    "olist_order_items_dataset.csv": "olist_order_items",
    "olist_order_payments_dataset.csv": "olist_order_payments",
    "olist_order_reviews_dataset.csv": "olist_order_reviews",
}

for file_name, table_name in file_table_map.items():
    file_path = os.path.join(csv_folder, file_name)
    print(f"Importing {file_name} → {table_name}")
    df = pd.read_csv(file_path)
    df = df.where(pd.notnull(df), None)
    df.to_sql(
        name=table_name,
        con=engine,
        if_exists="append",
        index=False,
        chunksize=5000,
        method="multi"
    )
print("done")
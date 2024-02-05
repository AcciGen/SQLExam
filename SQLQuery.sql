-- create table if not exists persons (
-- 	person_id bigserial,
-- 	person_first_name varchar(20),
-- 	person_last_name varchar(20),
-- 	person_birth_date date,
-- 	primary key(person_id)
-- );

-- create table if not exists customers (
-- 	customer_id bigint unique,
-- 	card_number varchar(16),
-- 	discount smallint,
-- 	constraint fk_customer_id
-- 		foreign key(customer_id)
-- 			references persons(person_id)
-- );

-- create table if not exists contact_types (
-- 	contact_type_id bigserial,
-- 	contact_type_name varchar,
-- 	primary key(contact_type_id)
-- );

-- create table if not exists person_contacts (
-- 	person_contact_id bigserial,
-- 	person_id bigint,
-- 	contact_type_id bigint,
-- 	contact_value varchar,
-- 	constraint fk_person_id foreign key(person_id) references persons(person_id),
-- 	constraint fk_contact_type_id foreign key(contact_type_id) references contact_types(contact_type_id)
-- );

-- create table if not exists supermarkets (
-- 	supermarket_id bigserial,
-- 	supermarket_name varchar(40),
-- 	primary key(supermarket_id)
-- );

-- create table if not exists location_city (
-- 	city_id bigserial,
-- 	city varchar,
-- 	country varchar,
-- 	primary key(city_id)
-- );

-- create table if not exists locations (
-- 	location_id bigserial,
-- 	location_address varchar,
-- 	location_city_id bigint,
-- 	primary key(location_id),
-- 	constraint fk_location_city_id
-- 		foreign key(location_city_id) references location_city(city_id)
-- );

-- create table if not exists supermarket_locations (
-- 	supermarket_location_id bigserial,
-- 	supermarket_id bigint,
-- 	location_id bigint,
-- 	primary key(supermarket_location_id),
-- 	constraint fk_supermarket_id foreign key(supermarket_id) references supermarkets(supermarket_id),
-- 	constraint fk_location_id foreign key(location_id) references locations(location_id)
-- );

-- create table if not exists customer_orders (
-- 	customer_order_id bigserial,
-- 	operation_time timestamp,
-- 	supermarket_location_id bigint,
-- 	customer_id bigint,
-- 	primary key(customer_order_id),
-- 	constraint fk_supermarket_location_id foreign key(supermarket_location_id) references supermarket_locations(supermarket_location_id),
-- 	constraint fk_customer foreign key(customer_id) references customers(customer_id)
-- );

-- create table if not exists product_manufacturers (
-- 	manufacturer_id bigserial,
-- 	manufacturer_name varchar,
-- 	primary key(manufacturer_id)
-- );

-- create table if not exists product_suppliers (
-- 	supplier_id bigserial,
-- 	supplier_name varchar,
-- 	primary key(supplier_id)
-- );

-- create table if not exists product_categories (
-- 	category_id bigserial,
-- 	category_name varchar,
-- 	primary key(category_id)
-- );

-- create table if not exists product_titles (
-- 	product_title_id bigserial,
-- 	product_title varchar,
-- 	product_category_id bigint,
-- 	primary key(product_title_id),
-- 	constraint fk_product_category_id foreign key(product_category_id) references product_categories(category_id)
-- );

-- create table if not exists shop_products (
-- 	product_id bigserial,
-- 	product_title_id bigint,
-- 	product_manufacturer_id bigint,
-- 	product_supplier_id bigint,
-- 	unit_price money,
-- 	comment varchar,
-- 	primary key(product_id),
-- 	constraint fk_product_title_id foreign key(product_title_id) references product_titles(product_title_id),
-- 	constraint fk_product_manufacturer_id foreign key(product_manufacturer_id) references product_manufacturers(manufacturer_id),
-- 	constraint fk_product_supplier_id foreign key(product_supplier_id) references product_suppliers(supplier_id)
-- );

-- set lc_monetary to "English_United States.1252";

-- create table if not exists customer_order_details (
-- 	customer_order_detail_id bigserial unique,
-- 	customer_order_id bigint,
-- 	product_id bigint,
-- 	price money,
-- 	price_with_discount money,
-- 	product_amount bigint,
-- 	constraint fk_customer_order_id foreign key(customer_order_id) references customer_orders(customer_order_id),
-- 	constraint fk_product_id foreign key(product_id) references shop_products(product_id)
-- );


-- Task 13
-- update shop_products
-- set unit_price = unit_price * 1.1
-- where product_manufacturer_id = (select manufacturer_id from product_manufacturers where manufacturer_name = 'Orbit')
-- and product_title_id in (select product_title_id from product_titles where product_category_id = (select category_id from product_categories where category_name = 'grocery'));

-- select * from shop_products;

-- Task 14
-- select person_first_name || '  ' || person_last_name as fullname,
-- 	avg((price_with_discount::decimal) * product_amount) as avg_sum from customer_order_details
-- 	inner join customer_orders using(customer_order_id)
-- 	inner join customers c using(customer_id)
-- 	inner join persons p on c.customer_id = p.person_id
-- 	group by person_id
-- 	having avg((price_with_discount::decimal) * product_amount) > 200000
-- 	order by avg((price_with_discount::decimal) * product_amount) desc,
-- 	fullname asc;

-- Task 15
-- select customer_order_detail_id, customer_order_id, product_id, price, price_with_discount, product_amount from customer_order_details
-- inner join customer_orders using(customer_order_id)
-- inner join customers c using(customer_id)
-- inner join persons p on p.person_id = c.customer_id
-- where extract(year from p.person_birth_date) between 2000 and 2005;

-- Task 16
-- delete from customer_order_details
-- where product_id in (select product_id from shop_products where product_title_id in (select product_title_id from product_titles where category_id in (select category_id from product_categories where category_name = 'drinks')));

-- delete from shop_products
-- where product_title_id in (select product_title_id from product_titles where category_id in (select category_id from product_categories where category_name = 'drinks'));

-- delete from product_titles
-- where category_id in (select category_id from product_categories where category_name = 'drinks');

-- delete from product_categories
-- where category_name = 'drinks';

-- Task 17
-- insert into product_categories(category_id, category_name) values(990007, 'protein');
-- insert into product_titles(product_title_id, product_title, product_category_id) values(7777, 'whey', 990007);
-- insert into product_suppliers(supplier_id, supplier_name) values(27, 'Sigma');
-- insert into product_manufacturers(manufacturer_id, manufacturer_name) values(77, 'Sigmas Company');
-- insert into shop_products(product_id, product_title_id, product_manufacturer_id, product_supplier_id, unit_price, comment) 
-- values(99007, 7777, 77, 27, '200000'::float8::numeric::money, 'done');

-- Task 18
-- select
-- 	pt.product_title as product_name,
-- 	unit_price,
-- 	case
--     	when unit_price <= '300'::float8::numeric::money then 'very cheap'
--         when unit_price > '300'::float8::numeric::money and unit_price <= '750'::float8::numeric::money then 'affordable'
--        	else 'expensive'
--     end as type,
-- 	comment
-- FROM shop_products
-- left join product_titles pt using(product_title_id);

-- Task 20
-- create or replace function getProductListByOperationDate(operationDate date)
-- returns table (purchases varchar(255))
-- language plpgsql
-- as $$
-- begin
-- 	return Query
-- 	select product_titles.product_title from customer_order_details cod
-- 		inner join customer_orders using(customer_order_id)
-- 		inner join product_titles pt on pt.product_title_id = cod.product_id
-- 		where DATE(operation_time) = operationDate;
-- end $$;

-- Task 23
-- create view checkout as
-- select person_first_name|| ' ' || person_last_name as fullName, product_title as product_name,
-- 		price_with_discount, product_amount, unit_price from persons p
-- 		inner join customers c on c.customer_id = p.person_id
-- 		inner join customer_orders using(customer_id)
-- 		inner join customer_order_details using(customer_order_id)
-- 		inner join shop_products using(product_id)
-- 		inner join product_titles using(product_title_id);

-- select * from checkout;
		
-- Task 24
-- create view product_details as
-- select product_title as product_name, category_name,
-- 		supplier_name, manufacturer_name from shop_products sp
-- 		inner join product_manufacturers pm on pm.manufacturer_id = sp.product_manufacturer_id
-- 		inner join product_suppliers ps on ps.supplier_id = sp.product_supplier_id
-- 		inner join product_titles pt using(product_title_id)
-- 		inner join product_categories pc on pc.category_id = pt.product_category_id;
		
-- select * from product_details;

-- Task 25
-- create view customer_details as
-- select person_first_name|| ' ' || person_last_name as fullName,
-- person_birth_date, c.card_number
-- from persons inner join customers as c on person_id = customer_id;

-- select * from customer_details;

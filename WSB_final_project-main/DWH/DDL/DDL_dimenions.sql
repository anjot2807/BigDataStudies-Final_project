DROP TABLE IF exists wsb.dim_countries cascade;
create table wsb.dim_countries
	(
		id serial PRIMARY KEY,
		country varchar(100) unique NOT null
	);



DROP TABLE IF exists wsb.dim_regions cascade;
create table wsb.dim_regions
	(
		id serial PRIMARY KEY,
		region varchar(100) NOT null
	);
	


DROP TABLE IF exists wsb.dim_countries_and_regions cascade;
create table wsb.dim_countries_and_regions
	(
		id serial PRIMARY KEY,
		country_id smallint,
		region_id smallint,
		constraint country_key
			foreign key (country_id) references wsb.dim_countries(id),
		constraint region_key
			foreign key (region_id) references wsb.dim_regions(id)
	);
	


DROP TABLE IF exists wsb.dim_products cascade;
create table wsb.dim_products
	(
		id serial PRIMARY KEY,
		product varchar(50) unique NOT null
	);



DROP TABLE IF exists wsb.dim_product_categories cascade;
create table wsb.dim_product_categories
	(
		id serial PRIMARY KEY,
		product_category varchar(25)unique NOT null
	);



DROP TABLE IF exists wsb.dim_products_and_categories cascade;
create table wsb.dim_products_and_categories
	(
		id serial PRIMARY key,
		product_id smallint ,
		product_category_id smallint,
		constraint product_key
			foreign key (product_id) references wsb.dim_products(id),
		constraint product_categiories_key
			foreign key (product_category_id) references wsb.dim_product_categories(id)
	);



DROP TABLE IF exists wsb.dim_units cascade;
create table wsb.dim_units
	(
		id serial PRIMARY KEY,
		unit varchar(100) NOT null
	);
	


DROP TABLE IF exists wsb.dim_flags_production cascade;
create table wsb.dim_flags_production
	(
		id serial PRIMARY KEY,
		flag varchar(2),
		description varchar(100)
	);



DROP TABLE IF exists wsb.dim_flags_exchange cascade;
create table wsb.dim_flags_exchange
	(
		id serial PRIMARY KEY,
		flag varchar(2),
		description varchar(100)
	);
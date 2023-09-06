DROP TABLE IF exists wsb.fct_production cascade;
create table wsb.fct_production
	(
		id serial PRIMARY KEY,
		country_id smallint not null,
		product_id smallint not null ,
		date_year smallint,
		unit_id smallint,
		value numeric not null,
		flag_id smallint,
		constraint country_key
			foreign key (country_id) references wsb.dim_countries(id),
		constraint product_key
			foreign key (product_id) references wsb.dim_products(id),
		constraint unit_key
			foreign key (unit_id) references wsb.dim_units(id),
		constraint flag_key
			foreign key (flag_id) references wsb.dim_flags_production(id)	
	);
	


DROP TABLE IF exists wsb.fct_exchange_products cascade;
create table wsb.fct_exchange_products
	(
		id serial PRIMARY KEY,
		reporter_country_id smallint not null,
		partner_country_id smallint,
		product_id smallint,
		exchange_type char(1),
		date_year smallint,
		unit_id smallint,
		value numeric not null,
		flag_id smallint,
		constraint reporter_country_key
			foreign key (reporter_country_id) references wsb.dim_countries(id),
		constraint paertner_country_key
			foreign key (partner_country_id) references wsb.dim_countries(id),	
		constraint product_key
			foreign key (product_id) references wsb.dim_products(id),
		constraint unit_key
			foreign key (unit_id) references wsb.dim_units(id),
		constraint flag_key
			foreign key (flag_id) references wsb.dim_flags_exchange(id)	
	);	

truncate wsb.fct_exchange_products restart identity cascade;
INSERT INTO wsb.fct_exchange_products
	(
		reporter_country_id ,
		partner_country_id ,
		product_id,
		exchange_type,
		date_year,
		unit_id,
		value,
		flag_id
	)
select
		dco.id,
		dc.id,
		dp.id,
		case
		when sep."element"  = 'Export Quantity' then 'e'
		when sep."element"  = 'Import Quantity' then 'i'
		end 
		"element",
		"year",
		du.id,
		value,
		dfe.id

FROM wsb.stg_exchange_products sep
left join  wsb.dim_countries dco on
			sep."reporter countries" = dco.country 
left join wsb.dim_countries dc on
			sep."partner countries" = dc.country 
left join wsb.dim_products dp on
			sep.item = dp.product
left join wsb.dim_units du on
			sep.unit = du.unit
left join wsb.dim_flags_exchange dfe on
			sep.flag  = dfe.flag 
			
WHERE sep."element" in ('Export Quantity', 'Import Quantity')
	and sep.item in (select item from wsb.stg_production where "element" = 'Production')
	and sep."value" is not null;

---------------------------------------------------------------------
truncate wsb.fct_production  restart identity cascade;
INSERT INTO wsb.fct_production 
	(
		country_id,
		product_id,
		date_year,
		unit_id,
		value,
		flag_id
	)
select
		dc.id,
		dp.id,
		"year",
		du.id,
		value,
		dfp.id

FROM wsb.stg_production sp 
left join wsb.dim_countries dc on
			sp."area" = dc.country 
left join wsb.dim_products dp on
			sp.item = dp.product
left join wsb.dim_units du on
			sp.unit = du.unit
left join wsb.dim_flags_production dfp  on
			sp.flag  = dfp.flag

WHERE sp."element" = 'Production'
	and sp."area" in (select country from wsb.dim_countries) ------ dane wrzucone tylko do pañœtw bez regionów
	and sp."item" in (select product from wsb.dim_products dp)
	and sp.value is not null;


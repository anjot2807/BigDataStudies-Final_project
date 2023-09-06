drop view if exists wsb.v_countries_partner;
create view wsb.v_countries_partner as select * from wsb.dim_countries;

drop view if exists wsbv_v_c_and_r_partner;
create view wsb.v_c_and_r_partner as select * from wsb.dim_countries_and_regions dcar ;

drop view if exists wsb.v_regions_partner;
create view wsb.v_regions_partner as select * from wsb.dim_regions;


drop view if exists wsb.v_date_year;
create view wsb.v_date_year as select distinct  date_year from wsb.fct_production;

drop view if exists wsb.v_consumption;
create view wsb.v_consumption as 
with
countries as
	(
	select 
		dc.id,
		dc.country,
		dr.id as region_id,
		dr.region
	from
		wsb.dim_countries dc 
	join wsb.dim_countries_and_regions dcar on dc.id = dcar.country_id 
	join wsb.dim_regions dr on dcar.region_id = dr.id
	),

products as
	(
	select
		dp.id,
		dp.product,
		dpc.id as category_id,
		dpc.product_category
	from 
		wsb.dim_products dp 
	join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
	join wsb.dim_product_categories dpc on dpac.product_category_id = dpc.id
	),
	
units as 
	(
	select
		id,
		unit
	from 
		wsb.dim_units du 
	),
export as
	(select
		fep.reporter_country_id,
		fep.product_id,
		fep.date_year,
		fep.unit_id,
		sum(fep.value) as value
	from
		wsb.fct_exchange_products fep
	left join countries on fep.partner_country_id = countries.id
	left join countries c1 on fep.reporter_country_id = c1.id
	left join units on fep.unit_id = units.id 
	where countries.region = 'World'
	and c1.region = 'World'
	and fep.exchange_type = 'e'
	and units.unit = 'tonnes'
	group by
		fep.reporter_country_id,
		fep.product_id,
		fep.date_year,
		fep.unit_id),
import_ as
	(select
		fep.reporter_country_id,
		fep.product_id,
		fep.date_year,
		fep.unit_id,
		sum(fep.value) as value
	from
		wsb.fct_exchange_products fep
	left join countries on fep.partner_country_id = countries.id
	left join countries c1 on fep.reporter_country_id = c1.id
	left join units on fep.unit_id = units.id
	where countries.region = 'World'
	and c1.region = 'World'
	and fep.exchange_type = 'i'
	and units.unit = 'tonnes'
	group by
		fep.reporter_country_id,
		fep.product_id,
		fep.date_year,
		fep.unit_id),
production as 
	(select
		fp.country_id,
		fp.product_id,
		fp.date_year,
		fp.unit_id,
		fp.value 
from 
	wsb.fct_production fp 
left join countries on fp.country_id = countries.id
left join units on fp.unit_id = units.id
where countries.region = 'World'
and units.unit = 'tonnes'
)


select
	production.country_id,
	production.product_id,
	coalesce(production.value,0) + coalesce(i1.value,0) - coalesce(e1.value,0) as consumption,
	production.date_year
from 
	production
full join export e1 on ( production.country_id = e1.reporter_country_id
					and production.product_id =  e1.product_id
					and production.date_year = e1.date_year)
full join import_ i1 on (production.country_id = i1.reporter_country_id
					and production.product_id =  i1.product_id
					and production.date_year = i1.date_year)
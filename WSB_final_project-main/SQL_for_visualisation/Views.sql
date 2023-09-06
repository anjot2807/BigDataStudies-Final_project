
--------------------------------------------------------------------------------------------
drop view if exists wsb.v_production_world_total;
create view wsb.v_production_world_total as 
select 
	sum(fp.value), 
	dp.product ,
	dpc.product_category,
	fp.date_year
	from 
	wsb.fct_production fp 
	join wsb.dim_countries dc on fp.country_id = dc.id 
	join wsb.dim_countries_and_regions dcar on dc.id = dcar.country_id 
	join wsb.dim_regions dr on dcar.region_id = dr.id 
	join wsb.dim_products dp on fp.product_id = dp.id 
	join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
	join wsb.dim_product_categories dpc on dpac.product_category_id  = dpc.id 
	join wsb.dim_units du on fp.unit_id = du.id
	where dr.region = 'World'
	and du.unit = 'tonnes'
	group by dp.product, dpc.product_category, fp.date_year ;
--------------------------------------------------------------------------------------------
drop view if exists wsb.v_trade_world_total;
create view wsb.v_trade_world_total as 
	select
		sum(fep.value) as sum_value,
		fep.date_year,
		dp.product ,
		dpc.product_category
		from 
		wsb.fct_exchange_products fep 
		join wsb.dim_countries dc1 on fep.reporter_country_id  = dc1.id
		join wsb.dim_countries dc2 on fep.partner_country_id  = dc2.id 
		join wsb.dim_countries_and_regions dcar2 on dc2.id = dcar2.country_id
		join wsb.dim_countries_and_regions dcar1 on dc1.id = dcar1.country_id
		join wsb.dim_regions dr1 on dcar1.region_id = dr1.id 
		join wsb.dim_regions dr2 on dcar2.region_id = dr2.id 
		join wsb.dim_products dp on fep.product_id = dp.id 
		join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
		join wsb.dim_product_categories dpc on dpac.product_category_id  = dpc.id 
		join wsb.dim_units du on fep.unit_id = du.id 
		where dr1.region ='World'
		and dr2.region = 'World'
		and fep.exchange_type = 'e'
		and du.unit = 'tonnes'
		group by fep.date_year, dp.product, dpc.product_category;


---------------------------------------------------------------------------------------------	
drop view if exists wsb.v_export_europe;
create view wsb.v_export_europe as 
select
	dc1.country as reporter_country,
	dc2.country as partnert_country,
	dr2.region partner_region, 
	fep.value,
	fep.date_year,
	dp.product ,
	dpc.product_category
	from 
	wsb.fct_exchange_products fep 
	join wsb.dim_countries dc1 on fep.reporter_country_id  = dc1.id
	join wsb.dim_countries dc2 on fep.partner_country_id  = dc2.id
	join wsb.dim_countries_and_regions dcar1 on dc1.id = dcar1.country_id 
	join wsb.dim_countries_and_regions dcar2 on dc2.id = dcar2.country_id 
	join wsb.dim_regions dr1 on dcar1.region_id = dr1.id 
	join wsb.dim_regions dr2 on dcar2.region_id = dr2.id 
	join wsb.dim_products dp on fep.product_id = dp.id 
	join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
	join wsb.dim_product_categories dpc on dpac.product_category_id  = dpc.id 
	join wsb.dim_units du on fep.unit_id = du.id 
	where dr1.region = 'Europe'
	and dr2.region in ('World', 'Europe', 'European Union (27)')
	and fep.exchange_type = 'e'
	and du.unit = 'tonnes';

--------------------------------------------------------------------------------------------------

drop view if exists wsb.v_import_europe;
create view wsb.v_import_europe as 
select
	dc1.country as reporter_country,
	dc2.country as partnert_country,
	dr2.region partner_region, 
	fep.value,
	fep.date_year,
	dp.product ,
	dpc.product_category
	from 
	wsb.fct_exchange_products fep 
	join wsb.dim_countries dc1 on fep.reporter_country_id  = dc1.id
	join wsb.dim_countries dc2 on fep.partner_country_id  = dc2.id 
	join wsb.dim_countries_and_regions dcar2 on dc2.id = dcar2.country_id
	join wsb.dim_countries_and_regions dcar1 on dc1.id = dcar1.country_id
	join wsb.dim_regions dr1 on dcar1.region_id = dr1.id 
	join wsb.dim_regions dr2 on dcar2.region_id = dr2.id 
	join wsb.dim_products dp on fep.product_id = dp.id 
	join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
	join wsb.dim_product_categories dpc on dpac.product_category_id  = dpc.id 
	join wsb.dim_units du on fep.unit_id = du.id 
	where dr1.region ='Europe'
	and dr2.region in ('World', 'Europe', 'European Union (27)') 
	and fep.exchange_type = 'i'
	and du.unit = 'tonnes';
----------------------------------------------------------------------------------
drop view if exists wsb.v_production_world;
create view wsb.v_production_world as 
select 
	fp.value, 
	dp.product ,
	dpc.product_category,
	fp.date_year, 
	dc.country,
	dr.region 
	from 
	wsb.fct_production fp 
	join wsb.dim_countries dc on fp.country_id = dc.id 
	join wsb.dim_countries_and_regions dcar on dc.id = dcar.country_id 
	join wsb.dim_regions dr on dcar.region_id = dr.id 
	join wsb.dim_products dp on fp.product_id = dp.id 
	join wsb.dim_products_and_categories dpac on dp.id = dpac.product_id 
	join wsb.dim_product_categories dpc on dpac.product_category_id  = dpc.id 
	join wsb.dim_units du on fp.unit_id = du.id
	where dr.region in ('World','Europe', 'European Union (27)') 
	and du.unit = 'tonnes';
------------------------------------------------------------------------------------
drop view if exists wsb.v_countries;
create view wsb.v_countries as select * from wsb.dim_countries;

------------------------------------------------------------------------------------
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
	countries.region_id,
	production.product_id,
	products.category_id,
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
join countries on production.country_id = countries.id
join products on production.product_id = products.id;


----------------------------------------------------------------------------------------------------

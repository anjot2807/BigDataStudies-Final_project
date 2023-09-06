INSERT INTO wsb.dim_countries 
	(
		country 
	)
select distinct
		"Country"
from wsb.stg_countries_and_regions

union

select distinct									-- w pliku csv (countries_and_regions) brak dwóch pañst o francuskobrzmi¹cych nazwach
		"reporter countries" 					-- st¹d dodatkowa klauzula
from wsb.stg_exchange_products sep;

------------------------------------------------------------------------------

INSERT INTO wsb.dim_flags_production 
	(
		flag ,
		description
	)
select distinct
		"Flag",
		"Flags"
from wsb.stg_production_flags spf ;

-------------------------------------------------------------------------------

INSERT INTO wsb.dim_flags_exchange 
	(
		flag ,
		description
	)
select distinct
		"Flag",
		"Flags"
from wsb.stg_exchange_flags;

------------------------------------------------------------------------------
INSERT INTO wsb.dim_regions 
	(
		region
	)
select distinct 
		"Country Group"
FROM wsb.stg_countries_and_regions; 

----------------------------------------------------
INSERT INTO wsb.dim_countries_and_regions
	(
		country_id,
		region_id
	)
select 
		dc.id,
		dm.id 
FROM wsb.stg_countries_and_regions  stcr
left join wsb.dim_countries dc on
		stcr."Country" = dc.country 
left join wsb.dim_regions dm on
		stcr."Country Group" =  dm.region ;

-------------------------------------------------------
INSERT INTO wsb.dim_units 
	(
		unit
	)
select distinct 
		unit
FROM wsb.stg_exchange_products 
	
UNION 

select distinct unit
FROM wsb.stg_production;

------------------------------------------------

INSERT INTO wsb.dim_products 
	(
		product
	)
select distinct 
		item
FROM wsb.stg_exchange_products sep

WHERE sep."element" in ('Export Quantity', 'Import Quantity')
	and sep.item in (select item from wsb.stg_production where "element" = 'Production')
	and sep.value is not null;
	
----------------------------------------------------------
	
INSERT INTO wsb.dim_product_categories
	(
		product_category 
	)
select distinct 
		"Item Group"
FROM wsb.stg_product_categories
where "Item" in (select product from wsb.dim_products dp2); 

-----------------------------------------------------------

INSERT INTO wsb.dim_products_and_categories
	(
		product_id ,
		product_category_id 
	)
select distinct 
		dp.id,
		dpc.id		
FROM wsb.stg_product_categories spc

left join wsb.dim_products dp on
		spc."Item" = dp.product
left join wsb.dim_product_categories dpc on
		spc."Item Group" = dpc.product_category;
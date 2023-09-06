-- TABELE SATAGING - do za�adowania danych csv z plik�w:
	--Production_Crops_Livestock_E_All_Data_(Normalized).csv   --> 	stg_production
	--Trade_DetailedTradeMatrix_E_All_Data_(Normalized).csv    -->  stg_exchange_products
	--Pozosta�e tabele nale�y pobra� z "Definiftions ands standards" z link�w:
		-- https://www.fao.org/faostat/en/#data/QCL
		-- https://www.fao.org/faostat/en/#data/TM
-- dwa sposoby �adowania sprowadzaj�ce si� do wbudowanej funkcji PostgresSQL COPY
	-- �adowanie za pomoc� skryptu python z bibliotek� psycopyg2 z udzia�em funkcji copy_expert
	-- �adowanie za pomoc� "Import Data" w DBeaver



DROP TABLE IF exists wsb.stg_production;
create table wsb.stg_production
	(
		"area code" smallint,								
		"area" varchar(100), -- nazwa kraju/regionu ( region np EU)
		"item code" smallint, 								
		"item" varchar(100) , -- rodzaj �ywno�ci
		"element code" smallint, 							
		"element" varchar(100),-- do tabeli fakt�w bierzemy tylko warto�� Production wi�c w tabeli fakt�w nie potrzebujemy ju� samego atrybutu
		"year code" smallint, 								
		"year" smallint,
		"unit" varchar(10),
		"value" numeric,
		"flag" varchar(2) 
	);



DROP TABLE IF exists wsb.stg_exchange_products;
create table wsb.stg_exchange_products
	(
		"reporter country code" smallint, 			
		"reporter countries" varchar(100), -- kraj zg�aszaj�cy wymian� - TYLKO KRAJE BEZ REGION�W
		"partner country code" smallint, 			
		"partner countries" varchar(100),   -- kraj parnerski w wymianie  - TYLKO KRAJE BEZ REGION�W
		"item code" smallint, 							
		"item" varchar(100),			 -- rodzaj �ywno�ci
		"element code" smallint, 					
		"element" varchar(100),				 -- rodzaj transakcji - bierzemy pod uwag� tylko IMPORT QUANTITY i EXPORT QUANTITY
		"year code" smallint,							
		"year" smallint,
		"unit" varchar(10),
		"value" numeric,
		"flag" varchar(2)
	);



DROP TABLE IF exists wsb.stg_countries_and_regions;
create table wsb.stg_countries_and_regions
	(
		"Country Group Code" smallint,
		"Country Group" varchar(100),
		"Country Code" smallint,
		"Country" varchar(100),
		"M49 Code" smallint,
		"ISO2 Code" varchar(2),
		"ISO3 Code" varchar(3)
	);



DROP TABLE IF exists wsb.stg_production_flags;
create table wsb.stg_production_flags
	(
	"Flag" varchar(2),
	"Flags" varchar(100)
	);	



DROP TABLE IF exists wsb.stg_exchange_flags;
create table wsb.stg_exchange_flags
	(
	"Flag" varchar(2),
	"Flags" varchar(100)
	);	
	


DROP TABLE IF exists wsb.stg_product_categories;
create table wsb.stg_product_categories
	(
	"Item Group Code" varchar(4),
	"Item Group" varchar(25),
	"Item Code" smallint,
	"Item" varchar(50),
	"Factor" varchar(50),
	"HS Code" char(1),
	"HS07 Code" varchar(70),
	"HS12 Code" varchar(70),
	"CPC Code" varchar(10)
	);	
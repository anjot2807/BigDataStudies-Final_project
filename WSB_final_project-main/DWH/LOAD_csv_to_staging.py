import psycopg2
import os

from dotenv import load_dotenv

load_dotenv()

HOST = os.getenv("HOST")
DB_NAME = os.getenv("DB_NAME")
USER = os.getenv("USER")
PASSWORD = os.getenv("PASSWORD")

prodcution_file = "Production_Crops_Livestock_E_All_Data_(Normalized).csv"
exchange_products_file = "Trade_DetailedTradeMatrix_E_All_Data_(Normalized).csv"
countries_and_regions = "countries_and_regions.csv"
production_flags = "production_flags.csv"
exchange_flags = "exchange_flags.csv"
prodcut_categories = "product_categories.csv"

conn = psycopg2.connect(f"host={HOST} dbname={DB_NAME} user={USER} password={PASSWORD}")
cur = conn.cursor()

all_needed_csv_paths = []
for root, dirs, files in os.walk("data_csv"):
	for file in files:
		if file == prodcution_file:
			print(f'loading {prodcution_file}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY  wsb.stg_production(
				"area code",										
				area, 
				"item code", 							
				item, 
				"element code", 							
				element,
				"year code", 										
				year,
				unit,
				value,
				flag
				) FROM stdin with csv HEADER""", f)
				conn.commit()
		if file == exchange_products_file :
			print(f'loading {exchange_products_file}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY  wsb.stg_exchange_products(
				"reporter country code" , 							
				"reporter countries" ,
				"partner country code" , 							
				"partner countries" ,  
				"item code" , 	
				item ,		
				"element code" , 							
				element ,				
				"year code" ,
				year ,
				unit ,
				value ,
				flag 
				) FROM stdin with csv HEADER""", f)
				conn.commit()
		if file == countries_and_regions :
			print(f'loading {countries_and_regions}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY wsb.stg_countries_and_regions(
				"Country Group Code",
				"Country Group",
				"Country Code",
				"Country",
				"M49 Code",
				"ISO2 Code",
				"ISO3 Code"
				) FROM stdin with csv HEADER""", f)
				conn.commit()
		if file == production_flags :
			print(f'loading {production_flags}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY wsb.stg_production_flags(
				"Flag" ,
				"Flags"
				) FROM stdin with csv HEADER""", f)
				conn.commit()		
		if file == exchange_flags :
			print(f'loading {exchange_flags}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY wsb.stg_exchange_flags(
				"Flag" ,
				"Flags"
				) FROM stdin with csv HEADER""", f)
				conn.commit()										
		if file == prodcut_categories :
			print(f'loading {prodcut_categories}..............')
			file =root + "\\" +  file
			with open(file, 'r', encoding='cp1252') as f:
				cur.copy_expert("""COPY wsb.stg_product_categories(
				"Item Group Code" ,
				"Item Group" ,
				"Item Code" ,
				"Item" ,
				"Factor" ,
				"HS Code" ,
				"HS07 Code",
				"HS12 Code",
				"CPC Code" 
				) FROM stdin with csv HEADER""", f)
				conn.commit()					
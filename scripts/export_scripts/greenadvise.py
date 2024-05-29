import pandas as pd
import time
from db import create_db_connection, truncate_table

engine = create_db_connection()
schema_name = "new_emerge"

start_time = time.time()
print("Start time")

# PRICING TYPES
sample_data = {
    'pricing_type_id': [1, 2, 3],
    'pricing_type_name': ["electricity_price_1", "electricity_price_2", "electricity_price_3"],
    'description': [None, None, None]
}
table_name = "pricing_type"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')


# COUNTRIES
sample_data = {
    'country_name': ["Unknown"],
    'region': ["region"],
    'country_id': [1]
}
table_name = "countries"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')

# LOCATION
sample_data = {
    'location_id': [1],
    'country_id': [1],
    'location_type': ["country"],
    'location_name': ["unknown"]
}
table_name = "locations"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')

# DEMAND

sample_data = {
    'demand_type_id': [27, 15, 9, 1],
    'type_name': ["demand_27", "demand_15", "demand_09", "elec_demand_no_heat"],
    'description': [None, None, None, None]
}
table_name = "demand_types"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')


# PV GENERATION
sample_data = {
    'pv_generation_type_id': [1, 2, 3, 4],
    'pv_generation_type_name': ["north", "east", "west", "south"],
    'description': [None, None, None, None]
}
table_name = "pv_generation_type"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')

xls = pd.ExcelFile('raw_data/greenadvice_input.xlsx')

temp_df = pd.read_excel(xls, sheet_name="Sheet1")


timedimension = temp_df[["Num", "month", "day", "hour"]]
timedimension["year"] = 2024
timedimension.rename(columns={'Num': 'time_id'}, inplace=True, errors='raise')

timedimension.to_sql(name="time_dimension",
                con=engine,
                schema=schema_name,
                index=False,
                if_exists='append')


def ingest_pv_gen(df, col_name, demand_id):
    temp_df = df[["Num", col_name]]
    temp_df["pv_generation_type_id"] = demand_id
    temp_df.rename(columns={'Num': 'time_id', col_name: "generation_kwh"}, inplace=True, errors='raise')
    temp_df.to_sql(name="pv_generation",
                     con=engine,
                     schema=schema_name,
                     index=False,
                     if_exists='append')


ingest_pv_gen(temp_df, "pv_gen_kwh/kw_east", 1)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_south", 2)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_west", 3)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_north", 4)


def ingest_electricity_demand(df, col_name, demand_id):
    temp_df = df[["Num", col_name]]
    temp_df["location_id"] = 1
    temp_df["demand_type_id"] = demand_id
    temp_df.rename(columns={'Num': 'time_id', col_name: "demand_amount"}, inplace=True, errors='raise')
    temp_df.to_sql(name="electricity_demand",
                     con=engine,
                     schema=schema_name,
                     index=False,
                     if_exists='append')


ingest_electricity_demand(temp_df, "demand_09", 9)
ingest_electricity_demand(temp_df, "demand_15", 15)
ingest_electricity_demand(temp_df, "demand_27", 27)


def ingest(df, col_name, price_id, table_name, schema_name):
    temp_df = df[["Num", col_name]]
    temp_df["country_id"] = 1
    temp_df["pricing_type_id"] = price_id
    temp_df.rename(columns={'Num': 'time_id', col_name: "price"}, inplace=True, errors='raise')
    temp_df.to_sql(name=table_name,
                   con=engine,
                   schema=schema_name,
                   index=False,
                   if_exists='append')


def ingest_electricity_price(df, col_name, price_id):
    temp_df = df[["Num", col_name]]
    temp_df["country_id"] = 1
    temp_df["pricing_type_id"] = price_id
    temp_df.rename(columns={'Num': 'time_id', col_name: "price"}, inplace=True, errors='raise')
    temp_df.to_sql(name="electricity_pricing",
                     con=engine,
                     schema=schema_name,
                     index=False,
                     if_exists='append')


ingest_electricity_price(temp_df, "electricity_price_1", 1)
ingest_electricity_price(temp_df, "electricity_price_2", 2)
ingest_electricity_price(temp_df, "electricity_price_3", 3)


end_time = time.time()
elapsed_time = end_time - start_time
print(f"Execution time: {elapsed_time} seconds")

import pandas as pd
import time
from db import create_db_connection, truncate_table

engine = create_db_connection()
schema_name = "test"

start_time = time.time()
print("Start time")

# PRICING TYPES
sample_data = {
    'pricingtypeid': [1, 2, 3],
    'pricingtypename': ["electricity_price_1", "electricity_price_2", "electricity_price_3"],
    'description': [None, None, None]
}
table_name = "pricingtype"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name="pricingtype",
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')


# COUNTRIES
sample_data = {
    'countryname': ["Unknown"],
    'region': ["region"],
    'countryid': [1]
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
    'locationid': [1],
    'countryid': [1],
    'locationtype': ["country"],
    'locationname': ["unknown"]
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
    'demandtypeid': [27, 15, 9, 1],
    'typename': ["demand_27", "demand_15", "demand_09", "elec_demand_no_heat"],
    'description': [None, None, None, None]
}
table_name = "demandtypes"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name="demandtypes",
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')


# PV GENERATION
sample_data = {
    'pv_gen_type_id': [1, 2, 3, 4],
    'pv_gen_type_name': ["north", "east", "west", "south"],
    'pv_gen_type_description': [None, None, None, None]
}
table_name = "pv_gen_type"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name="pv_gen_type",
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')

xls = pd.ExcelFile('raw_data/greenadvice_input.xlsx')

temp_df = pd.read_excel(xls, sheet_name="Sheet1")


timedimension = temp_df[["Num", "month", "day", "hour"]]
timedimension["year"] = 2024
timedimension.rename(columns={'Num': 'timeid'}, inplace=True, errors='raise')

timedimension.to_sql(name="timedimension",
                con=engine,
                schema="test",
                index=False,
                if_exists='append')


def ingest_pv_gen(df, col_name, demand_id):
    temp_df = df[["Num", col_name]]
    temp_df["pvtype"] = demand_id
    temp_df.rename(columns={'Num': 'timeid', col_name: "generationkwh"}, inplace=True, errors='raise')
    temp_df.to_sql(name="pvgeneration",
                     con=engine,
                     schema="test",
                     index=False,
                     if_exists='append')


ingest_pv_gen(temp_df, "pv_gen_kwh/kw_east", 1)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_south", 2)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_west", 3)
ingest_pv_gen(temp_df, "pv_gen_kwh/kw_north", 4)


def ingest_electricity_demand(df, col_name, demand_id):
    temp_df = df[["Num", col_name]]
    temp_df["locationid"] = 1
    temp_df["demandtypeid"] = demand_id
    temp_df.rename(columns={'Num': 'timeid', col_name: "demandamount"}, inplace=True, errors='raise')
    temp_df.to_sql(name="electricitydemand",
                     con=engine,
                     schema="test",
                     index=False,
                     if_exists='append')


ingest_electricity_demand(temp_df, "demand_09", 9)
ingest_electricity_demand(temp_df, "demand_15", 15)
ingest_electricity_demand(temp_df, "demand_27", 27)


def ingest(df, col_name, price_id, table_name, schema_name):
    temp_df = df[["Num", col_name]]
    temp_df["countryid"] = 1
    temp_df["pricingtypeid"] = price_id
    temp_df.rename(columns={'Num': 'timeid', col_name: "price"}, inplace=True, errors='raise')
    temp_df.to_sql(name=table_name,
                   con=engine,
                   schema=schema_name,
                   index=False,
                   if_exists='append')


def ingest_electricity_price(df, col_name, price_id):
    temp_df = df[["Num", col_name]]
    temp_df["countryid"] = 1
    temp_df["pricingtypeid"] = price_id
    temp_df.rename(columns={'Num': 'timeid', col_name: "price"}, inplace=True, errors='raise')
    temp_df.to_sql(name="electricitypricing",
                     con=engine,
                     schema="test",
                     index=False,
                     if_exists='append')


ingest_electricity_price(temp_df, "electricity_price_1", 1)
ingest_electricity_price(temp_df, "electricity_price_2", 2)
ingest_electricity_price(temp_df, "electricity_price_3", 3)


end_time = time.time()
elapsed_time = end_time - start_time
print(f"Execution time: {elapsed_time} seconds")

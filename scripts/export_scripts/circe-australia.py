import pandas as pd
from db import truncate_table, create_db_connection


engine = create_db_connection()
schema_name = "test"

xls = pd.ExcelFile('raw_data/Australia.xlsx')


def ingest_australia_data(df, engine, schema, table, orig_cols, col_aliases, type):
    truncate_table(engine, schema, table)
    temp_df = df[orig_cols]
    temp_df.rename(columns=col_aliases, inplace=True, errors='raise')

    bus_df = pd.read_sql_query(f"SELECT busid, name FROM {schema}.buses", engine)
    bus_name_to_id_map = pd.Series(bus_df["busid"].values, index=bus_df["name"]).to_dict()

    if type == "branch":
        temp_df['busfrom'] = temp_df['busfrom'].map(bus_name_to_id_map)
        temp_df['busto'] = temp_df['busto'].map(bus_name_to_id_map)
    elif type != "bus":
        temp_df['busid'] = temp_df['busid'].map(bus_name_to_id_map)

    temp_df.to_sql(name=table,
                   con=engine,
                   schema=schema,
                   index=False,
                   if_exists='append')


for sheet_name in xls.sheet_names:
    temp_df = pd.read_excel(xls, sheet_name=sheet_name)

    if sheet_name == "bus":
        orig_cols = ["name", "is_slack", "Vnom"]
        col_aliases = {'Vnom': 'vnom', 'is_slack': 'isslack'}
        ingest_australia_data(temp_df, engine, schema_name, "buses", orig_cols, col_aliases, "bus")

    elif sheet_name == "branch":
        orig_cols = ["name", 'bus_from', 'bus_to', 'R', 'X', 'G', 'B', 'rate']
        col_aliases = {'bus_from': 'busfrom', 'bus_to': 'busto', 'rate': 'ratemva', 'R': 'r', 'X': 'x', 'G': 'g', 'B': 'b'}
        ingest_australia_data(temp_df, engine, schema_name, "branches", orig_cols, col_aliases, "branch")

    elif sheet_name == "load":
        orig_cols = ["Unnamed: 1", "name"]
        col_aliases = {"name": "busid", "Unnamed: 1": "name"}
        ingest_australia_data(temp_df, engine, schema_name, "loads", orig_cols, col_aliases, "load")

    elif sheet_name == "shunt":
        orig_cols = ["name", 'bus']
        col_aliases = {'bus': 'busid'}
        ingest_australia_data(temp_df, engine, schema_name, "shunts", orig_cols, col_aliases, "shunt")

    elif sheet_name == "static_generator":
        continue

    elif sheet_name == "battery":
        continue

    elif sheet_name == "controlled_generator":
        orig_cols = ["name", 'bus', 'P', 'Pmin', 'Pmax', 'Qmin', 'Qmax', 'Snom', 'Vset']
        col_aliases = {'bus': 'busid',
                        'P': 'activepowermw',
                        'Pmin': 'pmin',
                        'Pmax': 'pmax',
                        'Qmin': 'qmin',
                        'Qmax': 'qmax',
                        'Snom': 'snommva',
                        'Vset': 'vset'}
        ingest_australia_data(temp_df, engine, schema_name, "generators", orig_cols, col_aliases, "controlled_generator")

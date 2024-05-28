import pandas as pd
from db import truncate_table, create_db_connection


engine = create_db_connection()
schema_name = "new_emerge"

xls = pd.ExcelFile('raw_data/Australia.xlsx')

# BRANCH TYPES
sample_data = {
    'branch_type_name': ["line", "transformer"],
    'description': ["", ""]
}
table_name = "branch_type"
truncate_table(engine, schema_name, table_name)
df = pd.DataFrame(sample_data)
df.to_sql(name=table_name,
            con=engine,
            schema=schema_name,
            index=False,
            if_exists='append')


def ingest_australia_data(df, engine, schema, table, orig_cols, col_aliases, type):
    truncate_table(engine, schema, table)
    temp_df = df[orig_cols]
    temp_df.rename(columns=col_aliases, inplace=True, errors='raise')

    bus_df = pd.read_sql_query(f"SELECT bus_id FROM {schema}.buses", engine)
    bus_name_to_id_map = {bus_id: bus_id for bus_id in bus_df["bus_id"]}

    if type == "branch":
        temp_df['bus_from'] = temp_df['bus_from'].map(bus_name_to_id_map)
        temp_df['bus_to'] = temp_df['bus_to'].map(bus_name_to_id_map)
    elif type != "bus":
        temp_df['bus_id'] = temp_df['bus_id'].map(bus_name_to_id_map)

    temp_df.to_sql(name=table,
                   con=engine,
                   schema=schema,
                   index=False,
                   if_exists='append')


for sheet_name in xls.sheet_names:
    temp_df = pd.read_excel(xls, sheet_name=sheet_name)

    if sheet_name == "bus":
        orig_cols = ["name", "is_slack", "Vnom"]
        col_aliases = {'Vnom': 'v_nom', 'is_slack': 'is_slack', "name": "bus_id"}
        ingest_australia_data(temp_df, engine, schema_name, "buses", orig_cols, col_aliases, "bus")

    elif sheet_name == "branch":
        orig_cols = ["name", 'bus_from', 'bus_to', 'R', 'X', 'G', 'B', 'rate', "branch_type"]
        col_aliases = {'rate': 'rate_mva', 'R': 'r', 'X': 'x', 'G': 'g', 'B': 'b'}
        ingest_australia_data(temp_df, engine, schema_name, "branches", orig_cols, col_aliases, "branch")

    elif sheet_name == "load":
        orig_cols = ["Unnamed: 1", "name"]
        col_aliases = {"name": "bus_id", "Unnamed: 1": "name"}
        ingest_australia_data(temp_df, engine, schema_name, "loads", orig_cols, col_aliases, "load")

    elif sheet_name == "shunt":
        orig_cols = ["name", 'bus']
        col_aliases = {'bus': 'bus_id'}
        ingest_australia_data(temp_df, engine, schema_name, "shunts", orig_cols, col_aliases, "shunt")

    elif sheet_name == "static_generator":
        continue

    elif sheet_name == "battery":
        continue

    elif sheet_name == "controlled_generator":
        orig_cols = ["name", 'bus', 'P', 'Pmin', 'Pmax', 'Qmin', 'Qmax', 'Snom', 'Vset']
        col_aliases = {'bus': 'bus_id',
                        'P': 'active_power_mw',
                        'Pmin': 'p_min',
                        'Pmax': 'p_max',
                        'Qmin': 'q_min',
                        'Qmax': 'q_max',
                        'Snom': 's_nom_mva',
                        'Vset': 'v_set'}
        ingest_australia_data(temp_df, engine, schema_name, "generators", orig_cols, col_aliases, "controlled_generator")

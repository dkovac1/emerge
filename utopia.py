import pandas as pd
import os


utopia_data_path = os.path.relpath("UTOPIA_2015_08_27.dat")
utopia_table_definitions_path = os.path.relpath("utopia_test_tables.dat")


def read_table_definition_file(filepath):
    data = {}

    with open(filepath, 'r') as file:
        lines = file.readlines()

        current_param = None
        current_columns = None

        for line in lines:
            line = line.strip()

            if line.startswith("-"):
                parts = line.split()
                current_columns.append(parts[1])

            elif line == "":
                data[current_param] = current_columns
                # data.append({current_param : current_columns})
                current_columns = []
                current_param = None

            else:
                current_param = line
                current_columns = []

    return data


def read_dat_file(filepath):
    data = []

    with open(filepath, 'r') as file:
        lines = file.readlines()

        current_param = None
        current_param_type = None
        current_data = None
        current_data_frame_columns = None

        i = 0
        for line in lines:
            line = line.strip()
            parts = line.split()

            if line.startswith("# param"):
                current_param_type = "single_value"
                current_param = parts[2]
                if len(parts) == 5:
                    current_data = parts[4]
                else:
                    current_data = None

            elif line.startswith("param"):
                current_param_type = "data_frame"
                col_name = parts[1]
                data_frame_definitions = read_table_definition_file(utopia_table_definitions_path)
                cols = data_frame_definitions[col_name]
                current_data_frame_columns = cols
                current_data = pd.DataFrame(columns=cols)

            elif line.startswith("set"):
                current_param_type = "set"
                current_param = parts[1]
                current_data = []

            else:
                if ";" in set(parts):
                    current_data = {current_param: current_data}
                    data.append(current_data)
                    current_param_type = None
                    current_data = None
                    continue

                if current_param_type == "set":
                    current_data.append(parts[0])

                elif current_param_type == "data_frame":
                    test = dict(zip(current_data_frame_columns, parts))
                    current_data.loc[len(current_data)] = test

    return data

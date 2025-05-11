import os
import pandas as pd
import logging

# ---- LOGGING SETUP ----
logging.basicConfig(level=logging.DEBUG)  # Set to DEBUG to capture more logs
logger = logging.getLogger(__name__)

# Get the root directory dynamically (going two levels up from the script's location)
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../..'))  # Going three levels up

# Now use the root directory to construct the path to 'data/input_data'
INPUT_DATA_FOLDER = os.path.join(ROOT_DIR, 'data', 'input_data')


def get_data_type(value):
    """
    Return the appropriate data type for a given value.
    """
    if isinstance(value, int):
        return 'INT'
    elif isinstance(value, float):
        return 'DECIMAL'
    elif isinstance(value, str):
        return 'NVARCHAR'
    elif isinstance(value, bool):
        return 'BIT'
    elif isinstance(value, pd.Timestamp):
        return 'DATETIME'
    else:
        return 'UNKNOWN'


def inspect_csv_data(country, table_name):
    """
    Read the CSV file for a specific country and table,
    then log the column names and their data types.
    """
    csv_file_path = os.path.join(INPUT_DATA_FOLDER, country, f"{table_name}.csv")

    # Debug log to show constructed file path
    logger.debug(f"Looking for file: {csv_file_path}")

    if not os.path.exists(csv_file_path):
        logger.warning(f"File not found: {csv_file_path}")
        return

    try:
        # Attempt to read the CSV file with different encodings
        try:
            df = pd.read_csv(csv_file_path, encoding='utf-8')
        except UnicodeDecodeError:
            logger.warning(f"UTF-8 decoding failed for {csv_file_path}, trying ISO-8859-1...")
            df = pd.read_csv(csv_file_path, encoding='ISO-8859-1')
        except Exception as e:
            logger.error(f"Error while reading CSV file: {csv_file_path}")
            logger.exception(e)
            return

        # Inspect the columns and their data types
        logger.info(f"Inspecting file: {csv_file_path}")
        logger.info(f"Columns found in {table_name} for {country}:")

        for column in df.columns:
            sample_value = df[column].iloc[0]  # Get the first value to determine the type
            data_type = get_data_type(sample_value)
            logger.info(f"Column: {column} | Data Type: {data_type}")

        # Log the total number of columns found
        logger.info(f"Total columns found in {table_name} for {country}: {len(df.columns)}")
        logger.info("-" * 50)

    except Exception as e:
        logger.error(f"Error while inspecting file: {csv_file_path}")
        logger.exception(e)


def inspect_all_csv_files():
    """
    Iterate over all countries and tables to inspect all .csv files.
    Skips the 'invalid' country folder.
    """
    # Get all country folders
    country_folders = [f for f in os.listdir(INPUT_DATA_FOLDER) if os.path.isdir(os.path.join(INPUT_DATA_FOLDER, f))]

    logger.debug(f"Found country folders: {country_folders}")  # Debugging log for country folders

    # Iterate over each country
    for country in country_folders:

        if country.lower() == "invalid":
            logger.info(f"Skipping 'invalid' country folder: {country}")
            continue
        elif country.lower() != "morocco":
            continue

        country_path = os.path.join(INPUT_DATA_FOLDER, country)

        # Get all CSV files in the country directory (corresponding to each table)
        csv_files = [f for f in os.listdir(country_path) if f.endswith('.csv')]

        logger.debug(f"Found CSV files for {country}: {csv_files}")  # Debugging log for CSV files

        # Iterate over each CSV file (table) and inspect
        for csv_file in csv_files:
            if csv_file != "co2_emission.csv":
                continue
            table_name = os.path.splitext(csv_file)[0]  # Remove the .csv extension to get the table name
            inspect_csv_data(country, table_name)


# ---- MAIN ----
def main():
    try:
        inspect_all_csv_files()
    except Exception as e:
        logger.error("An error occurred while inspecting CSV files.")
        logger.exception(e)


if __name__ == "__main__":
    main()

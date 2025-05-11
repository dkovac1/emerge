import logging
from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from urllib.parse import quote_plus
from backend.app.config.table_schemas import TABLE_SCHEMAS
from backend.app.config.initial_data import INITIAL_DATA
from sqlalchemy import inspect


# ---- DATABASE CONFIGURATION ----
DB_USERNAME = "emerge"
DB_PASSWORD = "brainit1234#"
DB_SERVER = "emerge-db-server.database.windows.net"  # e.g., localhost or 127.0.0.1 or db.example.com
DB_NAME = "emerge-db"

# ---- LOGGING SETUP ----
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def test_sqlalchemy_connection():
    try:
        engine = get_engine()
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            value = result.scalar()
            if value == 1:
                logger.info("SQLAlchemy connection successful!")
            else:
                logger.warning("Connection succeeded but returned unexpected result.")
    except SQLAlchemyError as e:
        logger.error("SQLAlchemy connection failed.")
        logger.exception(e)


def get_engine():
    user = quote_plus(DB_USERNAME)
    password = quote_plus(DB_PASSWORD)
    connection_string = (
        f"mssql+pyodbc://{user}:{password}@{DB_SERVER}/{DB_NAME}"
        "?driver=ODBC+Driver+18+for+SQL+Server"
        "&TrustServerCertificate=yes"
        "&Encrypt=no"
    )
    return create_engine(connection_string)

# def drop_all_tables(connection):
#     logger.info("🔧 Dropping all tables...")
#     drop_sql = """
#     DECLARE @sql NVARCHAR(MAX) = '';
#     SELECT @sql += 'DROP TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '];'
#     FROM INFORMATION_SCHEMA.TABLES
#     WHERE TABLE_TYPE = 'BASE TABLE';
#     EXEC sp_executesql @sql;
#     """
#     connection.execute(text(drop_sql))
#     logger.info("All tables dropped.")

def drop_all_tables(connection):
    logger.info("Dropping all foreign key constraints...")
    drop_fks_sql = """
    DECLARE @sql NVARCHAR(MAX) = '';

    SELECT @sql += 'ALTER TABLE [' + sch.name + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];'
    FROM sys.foreign_keys fk
    INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
    INNER JOIN sys.schemas sch ON t.schema_id = sch.schema_id;

    EXEC sp_executesql @sql;
    """

    logger.info("Dropping all tables...")
    drop_tables_sql = """
    DECLARE @sql NVARCHAR(MAX) = '';

    SELECT @sql += 'DROP TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '];'
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE';

    EXEC sp_executesql @sql;
    """

    try:
        connection.execute(text(drop_fks_sql))
        logger.info("Foreign key constraints dropped.")
        connection.execute(text(drop_tables_sql))
        logger.info("All tables dropped.")
    except SQLAlchemyError as e:
        logger.error("Failed to drop tables or constraints.")
        logger.exception(e)


def create_all_tables(connection):
    logger.info("Creating tables from schema...")
    for table_name, table_info in TABLE_SCHEMAS.items():
        columns = table_info['columns']
        columns_ddl = ', '.join([f"[{name}] {datatype}" for name, datatype in columns.items()])
        create_sql = f"CREATE TABLE [{table_name}] ({columns_ddl});"
        try:
            connection.execute(text(create_sql))
            logger.info(f"Created table: {table_name}")
        except Exception as e:
            logger.error(f"Failed to create table: {table_name}")
            logger.exception(e)

def populate_tables(connection, table_schemas):
    logger.info("Inserting initial data into tables...")

    inspector = inspect(connection)

    for table_name, rows in INITIAL_DATA.items():
        if not rows:
            logger.info(f"No data to insert for table: {table_name}")
            continue

        schema_columns = table_schemas.get(table_name, {}).get('columns', {})
        identity_columns = [
            col for col, col_def in schema_columns.items()
            if 'IDENTITY' in col_def.upper()
        ]

        insert_columns = list(rows[0].keys())
        placeholders = ', '.join([f":{col}" for col in insert_columns])
        insert_sql = f"INSERT INTO [{table_name}] ({', '.join(insert_columns)}) VALUES ({placeholders})"

        try:
            if identity_columns and any(col in insert_columns for col in identity_columns):
                connection.execute(text(f"SET IDENTITY_INSERT [{table_name}] ON"))
                logger.debug(f"IDENTITY_INSERT ON for table: {table_name}")

            connection.execute(text(insert_sql), rows)

            if identity_columns and any(col in insert_columns for col in identity_columns):
                connection.execute(text(f"SET IDENTITY_INSERT [{table_name}] OFF"))
                logger.debug(f"IDENTITY_INSERT OFF for table: {table_name}")

            logger.info(f"Inserted data into: {table_name}")

        except Exception as e:
            logger.error(f"Failed to insert data into: {table_name}")
            logger.exception(e)

# ---- MAIN ----
def main():
    try:
        engine = get_engine()
        with engine.begin() as connection:
            test_sqlalchemy_connection()
            drop_all_tables(connection)
            create_all_tables(connection)
            populate_tables(connection, TABLE_SCHEMAS)
    except SQLAlchemyError as e:
        logger.error("Database operation failed.")
        logger.exception(e)

if __name__ == "__main__":
    main()

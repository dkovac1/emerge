import pandas as pd
from sqlalchemy import create_engine, text
import os
from sshtunnel import SSHTunnelForwarder

path = os.path.relpath("emerge_postgres_key.pem")

SSH_HOST = '4.232.65.165'
SSH_USERNAME = 'emerge'
SSH_PEM_PATH = path
DB_HOST = 'localhost'
DB_PORT = 5432
LOCAL_PORT = 5000

DB_USER = 'postgres'
DB_NAME = 'postgres'


def truncate_table(engine, schema, table):
    with engine.connect() as conn:
        conn.execute(text(f"TRUNCATE TABLE {schema}.{table} RESTART IDENTITY CASCADE;"))
        conn.commit()


def start_ssh_tunnel():

    tunnel = SSHTunnelForwarder(
        (SSH_HOST, 22),
        ssh_username=SSH_USERNAME,
        ssh_pkey=SSH_PEM_PATH,
        remote_bind_address=(DB_HOST, DB_PORT),
        local_bind_address=('127.0.0.1', LOCAL_PORT)
    )

    tunnel.start()

    print("Tunnel established on local port:", tunnel.local_bind_port)

    return tunnel.local_bind_port


def create_db_connection():
    local_bind_port = start_ssh_tunnel()
    engine = create_engine(f"postgresql+psycopg2://{DB_USER}@{'127.0.0.1'}:{local_bind_port}/{DB_NAME}")
    return engine

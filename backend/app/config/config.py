import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # Flask settings
    SECRET_KEY = os.getenv('SECRET_KEY', 'your-secret-key-here')
    
    # Azure SQL Database settings
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'mssql+pyodbc://{username}:{password}@{server}:1433/{database}?driver=ODBC+Driver+18+for+SQL+Server&timeout=300&connect_timeout=300&encrypt=yes&trustservercertificate=yes&autocommit=true&applicationintent=readwrite&multiSubnetFailover=yes&packet size=32768&connection timeout=300&keepalive=1&keepaliveinterval=30')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # SQLAlchemy engine options
    SQLALCHEMY_ENGINE_OPTIONS = {
        'pool_pre_ping': True,
        'pool_recycle': 300,  # Recycle connections every 5 minutes
        'pool_timeout': 30,
        'pool_size': 1,  # Reduce pool size to 1 for initial setup
        'max_overflow': 0,  # No overflow connections
        'echo': True,  # Enable SQL query logging
        'execution_options': {
            'isolation_level': 'READ COMMITTED'
        }
    }
    
    # Database credentials
    DB_USERNAME = os.getenv('DB_USERNAME', '')
    DB_PASSWORD = os.getenv('DB_PASSWORD', '')
    DB_SERVER = os.getenv('DB_SERVER', '')
    DB_NAME = os.getenv('DB_NAME', '')
    
    # File paths
    BASE_DIR = os.path.abspath(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
    DATA_DIR = os.path.join(BASE_DIR, '..', 'data', 'input_files')
    
    @classmethod
    def get_database_url(cls):
        """Get the complete database URL with credentials"""
        return cls.SQLALCHEMY_DATABASE_URI.format(
            username=cls.DB_USERNAME,
            password=cls.DB_PASSWORD,
            server=cls.DB_SERVER,
            database=cls.DB_NAME
        ) 
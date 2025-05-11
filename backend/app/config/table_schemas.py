# Optimized table schema with relationships and normalization

# Country and Year dimensions
REFERENCE_SCHEMAS = {
    'country': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL UNIQUE'
        }
    },
    'year_dimension': {
        'columns': {
            'year': 'INT PRIMARY KEY',
            'is_leap_year': 'BIT',
            'notes': 'NVARCHAR(100)'
        }
    }
}

# Time dimension
TIME_DIMENSION_SCHEMAS = {
    'time_dimension': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'timestamp': 'DATETIME NOT NULL',
            'year': 'INT NOT NULL',
            'month': 'INT NOT NULL',
            'day': 'INT NOT NULL',
            'hour': 'INT NOT NULL',
            'day_of_week': 'INT NOT NULL',
            'is_weekend': 'BIT NOT NULL',
            'is_holiday': 'BIT NOT NULL'
        }
    }
}

# Lookup tables
LOOKUP_SCHEMAS = {
    'energy_source': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'is_renewable': 'BIT NOT NULL',
            'emission_factor': 'DECIMAL(10,4)',
            'unit': 'NVARCHAR(20) NOT NULL'
        }
    },
    'energy_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'category': 'NVARCHAR(50) NOT NULL'
        }
    },
    'cost_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'category': 'NVARCHAR(50) NOT NULL'
        }
    },
    'sector_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'category': 'NVARCHAR(50) NOT NULL'
        }
    },
    'technology_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'category': 'NVARCHAR(50) NOT NULL',
            'efficiency': 'DECIMAL(5,2)'
        }
    },
    'consumption_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'category': 'NVARCHAR(50) NOT NULL'
        }
    },
    'energy_flow_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'name': 'NVARCHAR(100) NOT NULL',
            'description': 'NVARCHAR(500)',
            'direction': 'NVARCHAR(20) NOT NULL'
        }
    },
    'population_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'type': 'NVARCHAR(50) NOT NULL UNIQUE'
        }
    },
    'electricity_flow_type': {
        'columns': {
            'id': 'INT PRIMARY KEY',
            'type': 'NVARCHAR(10) NOT NULL UNIQUE'
        }
    }
}

# Fact tables
FACT_SCHEMAS = {
    'access_to_electricity': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'percentage': 'DECIMAL(5,2) NOT NULL'
        }
    },
    'co2_emissions': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'emissions': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'electricity_flow': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'value': 'DECIMAL(10,2) NOT NULL',
            'type_id': 'INT NOT NULL REFERENCES electricity_flow_type(id)'
        }
    },
    'electricity_generation': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'energy_source_id': 'INT NOT NULL REFERENCES energy_source(id)',
            'value': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'energy_consumption': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'energy_source_id': 'INT NOT NULL REFERENCES energy_source(id)',
            'value': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'supply_cost': {
        'columns': {
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'energy_type_id': 'INT NOT NULL REFERENCES energy_type(id)',
            'total_installed_costs': 'DECIMAL(15,2) NOT NULL',
            'load_factor': 'DECIMAL(5,2) NOT NULL',
            'levelized_cost_of_energy': 'DECIMAL(5,2) NOT NULL'
        }
    },
    'fuel_price': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'ppd': 'DECIMAL(10,2) NOT NULL',
            'ppg': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'gdp': {
        'columns': {
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'gdp': 'DECIMAL(15,2) NOT NULL'
        }
    },
    'grid_topology': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'grid_element': 'NVARCHAR(100) NOT NULL',
            'vnom': 'DECIMAL(10,2) NOT NULL',
            'longitude': 'DECIMAL(10,6) NOT NULL',
            'latitude': 'DECIMAL(10,6) NOT NULL'
        }
    },
    'population': {
        'columns': {
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'type_id': 'INT NOT NULL REFERENCES population_type(id)'
        }
    },
    'resource_availability': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'energy_type_id': 'INT NOT NULL REFERENCES energy_type(id)',
            'value': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'energy_supply': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'year': 'INT NOT NULL REFERENCES year_dimension(year)',
            'value': 'DECIMAL(10,2) NOT NULL'
        }
    },
    'transformer': {
        'columns': {
            'country_id': 'INT NOT NULL REFERENCES country(id)',
            'grid_element_from': 'NVARCHAR(100) NOT NULL',
            'grid_element_to': 'NVARCHAR(100) NOT NULL',
            'x': 'DECIMAL(10,6) NOT NULL'
        }
    }
}

# Combine all schemas
TABLE_SCHEMAS = {**REFERENCE_SCHEMAS, **TIME_DIMENSION_SCHEMAS, **LOOKUP_SCHEMAS, **FACT_SCHEMAS}

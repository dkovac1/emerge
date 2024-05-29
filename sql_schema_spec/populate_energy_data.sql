-- Insert sample data into the countries table
INSERT INTO new_test.countries (country_code, country_name, region)
VALUES
    ('USA', 'United States of America', 'North America'),
    ('CAN', 'Canada', 'North America'),
    ('MEX', 'Mexico', 'North America');

INSERT INTO new_test.cities (city_name, county)
VALUES
    ('New York', 'New York County'),
    ('Los Angeles', 'Los Angeles County'),
    ('Toronto', 'Toronto County'),
    ('Mexico City', 'Mexico City County');

INSERT INTO new_test.locations (location_name, country_code, city_name, location_type, additional_details)
VALUES
    ('Location A', 'USA', 'New York', 'Generator', 'Located near the main grid'),
    ('Location B', 'USA', 'Los Angeles', 'Load Point', 'High load area in the west'),
    ('Location C', 'CAN', 'Toronto', 'Generator', 'Primary generator for eastern Canada'),
    ('Location D', 'MEX', 'Mexico City', 'Load Point', 'Central load point in Mexico City');

-- Insert sample data into the energy_sources table
INSERT INTO new_test.energy_sources (source_id, source_name)
VALUES
    (1, 'wind'),
    (2, 'solar'),
    (3, 'pv'),
    (4, 'coal'),
    (5, 'air'),
    (6, 'unknown');


-- Insert sample data into the energy_types table
INSERT INTO new_test.energy_types (energy_type_id, energy_type_name)
VALUES
    (1, 'thermal'),
    (2, 'electricity');


-- Insert sample data into the cost_type table
INSERT INTO new_test.cost_type (cost_type_id, cost_type_name)
VALUES
    (1, 'opex'),
    (2, 'capex'),
    (3, 'end-user'),
    (4, 'production'),
    (5, 'distribution'),
    (6, 'el_price_1'),
    (7, 'el_price_2'),
    (7, 'el_price_3');

-- Insert sample data into the sector_type table
INSERT INTO new_test.sector_type (sector_type_name)
VALUES
    ('industrial'),
    ('agricultural'),
    ('domestic'),
    ('transport');

-- Insert sample data into the technology_type table
INSERT INTO new_test.technology_type (technology_type_name)
VALUES
    ('electricity'),
    ('thermal');

-- Insert sample data into the energy_flow_type table
INSERT INTO new_test.energy_flow_type (energy_flow_type_name)
VALUES
    ('import'),
    ('export'),
    ('storage');
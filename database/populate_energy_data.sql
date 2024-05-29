-- Insert sample data into the countries table
INSERT INTO new_test.countries (country_code, country_name, region)
VALUES
    ('CRO', 'Croatia', 'Balkan'),
    ('AUS', 'Australia', 'Oceania');

INSERT INTO new_test.cities (city_name, county)
VALUES
    ('Zagreb', 'Grad Zagreb'),
    ('Sydney', 'New South Wales coast');

INSERT INTO new_test.locations (location_name, country_code, city_name, location_type, additional_details)
VALUES
    ('House in Zagreb', 'CRO', 'Zagreb', 'House', 'Example of greenadvise input data'),
    ('North side of Zagreb', 'CRO', 'Zagreb', 'Location region', 'Example of location region'),
    ('Electrical grid in Sydney', 'AUS', 'Sydney', 'Electrical grid', 'Example of circe input data');

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
    (8, 'el_price_3');

-- Insert sample data into the sector_type table
INSERT INTO new_test.sector_type (sector_type_name)
VALUES
    ('industrial'),
    ('agricultural'),
    ('domestic'),
    ('transport');

-- Insert sample data into the sector_type table
INSERT INTO new_test.consumption_type (consumption_type_name)
VALUES
    ('demand_09'),
    ('demand_15'),
    ('demand_27'),
    ('elec_demand_no_heat');

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
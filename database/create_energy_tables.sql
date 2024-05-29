select * from new_test.year_month_day_hour where year = 2005 and month = 3 and day = 10;

CREATE EXTENSION IF NOT EXISTS pgcrypto;


DROP TABLE IF EXISTS new_test.countries cascade;
CREATE TABLE new_test.countries (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100),
    region VARCHAR(100)
);


DROP TABLE IF EXISTS new_test.cities cascade;
CREATE TABLE new_test.cities (
    city_name VARCHAR(100) PRIMARY KEY,
    county VARCHAR(100)
);


DROP TABLE IF EXISTS new_test.locations cascade;
CREATE TABLE new_test.locations (
    location_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    location_name VARCHAR(100),
    country_code VARCHAR(3),
    city_name VARCHAR(100),
    location_type VARCHAR(100),  -- For example, 'Generator', 'Load Point', etc.
    additional_details TEXT,
    FOREIGN KEY (country_code) REFERENCES new_test.countries(country_code),
    FOREIGN KEY (city_name) REFERENCES new_test.cities(city_name)
);


DROP TABLE IF EXISTS new_test.energy_sources cascade;
CREATE TABLE new_test.energy_sources (
    source_id INT PRIMARY KEY,
    source_name VARCHAR(100) -- wind, solar, pv, coal, air, unknown...
);


DROP TABLE IF EXISTS new_test.energy_types cascade;
CREATE TABLE new_test.energy_types (
    energy_type_id INT PRIMARY KEY,
    energy_type_name VARCHAR(100) -- thermal, electricity ...
);

-- Drop and recreate Cost table
DROP TABLE IF EXISTS new_test.cost_type cascade;
CREATE TABLE new_test.cost_type (
    cost_type_id INT PRIMARY KEY,
    cost_type_name VARCHAR(100) -- opex, capex, end-user, production, distribution, el_price_1, el_price_2...
);

-- Drop and recreate Cost table
DROP TABLE IF EXISTS new_test.cost;
CREATE TABLE new_test.cost (
    cost_id INT PRIMARY KEY,
    cost_type VARCHAR(100),
    source_id INT,
    type_id INT,
    cost_type_id INT,
    time_stamp UUID,
    location_id UUID,
    FOREIGN KEY (source_id) REFERENCES new_test.energy_sources(source_id), -- wind, solar, hydro, biomass
    FOREIGN KEY (type_id) REFERENCES new_test.energy_types(energy_type_id), -- electricity, thermal
    FOREIGN KEY (cost_type_id) REFERENCES new_test.cost_type(cost_type_id), -- opex, capex, end-user, production, distribution, el_price_1, el_price_2...
    FOREIGN KEY (location_id) REFERENCES new_test.locations(location_id), -- location
    FOREIGN KEY (time_stamp) REFERENCES new_test.year_month_day_hour(uuid) -- timestamp
);



DROP TABLE IF EXISTS new_test.resource_availability;
CREATE TABLE new_test.resource_availability (
    resource_availability_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    source_id INT,
    availability_type VARCHAR(100),
    time_stamp UUID,
    FOREIGN KEY (source_id) REFERENCES new_test.energy_sources(source_id),
    FOREIGN KEY (time_stamp) REFERENCES new_test.year_month_day_hour(uuid) -- timestamp
);


DROP TABLE IF EXISTS new_test.sector_type cascade;
CREATE TABLE new_test.sector_type (
    sector_type_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sector_type_name VARCHAR(100) -- industrial, agricultural, domestic, transport
);

DROP TABLE IF EXISTS new_test.technology_type cascade;
CREATE TABLE new_test.technology_type (
    technology_type_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    technology_type_name VARCHAR(100)
);


DROP TABLE IF EXISTS new_test.consumption; -- demand
CREATE TABLE new_test.consumption (
    consumption_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    consumption_amount DECIMAL,
    technology_type_id UUID,
    sector_type_id UUID,
    time_stamp UUID,
    location_id UUID,
    source_id INT,
    FOREIGN KEY (technology_type_id) REFERENCES new_test.technology_type(technology_type_id),
    FOREIGN KEY (sector_type_id) REFERENCES new_test.sector_type(sector_type_id),
    FOREIGN KEY (time_stamp) REFERENCES new_test.year_month_day_hour(uuid),
    FOREIGN KEY (location_id) REFERENCES new_test.locations(location_id),
    FOREIGN KEY (source_id) REFERENCES new_test.energy_sources(source_id)
);


DROP TABLE IF EXISTS new_test.generation;
CREATE TABLE new_test.generation (
    generation_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    generation_amount DECIMAL,
    technology_type_id UUID,
    time_stamp UUID,
    location_id UUID,
    source_id INT,
    FOREIGN KEY (technology_type_id) REFERENCES new_test.technology_type(technology_type_id),
    FOREIGN KEY (time_stamp) REFERENCES new_test.year_month_day_hour(uuid),
    FOREIGN KEY (location_id) REFERENCES new_test.locations(location_id),
    FOREIGN KEY (source_id) REFERENCES new_test.energy_sources(source_id)
);


DROP TABLE IF EXISTS new_test.energy_flow_type;
CREATE TABLE new_test.energy_flow_type (
    energy_flow_type_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    energy_flow_type_name VARCHAR(100)  -- import, export, storage
);


DROP TABLE IF EXISTS new_test.energy_flow;
CREATE TABLE new_test.energy_flow (
    energy_flow_id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    energy_flow_amount DECIMAL,
    technology_type_id UUID,
    energy_flow_type VARCHAR(100),
    time_stamp UUID,
    location_id UUID,
    energy_flow_type_id UUID, -- import, export, storage
    source_id INT,
    FOREIGN KEY (technology_type_id) REFERENCES new_test.technology_type(technology_type_id),
    FOREIGN KEY (time_stamp) REFERENCES new_test.year_month_day_hour(uuid),
    FOREIGN KEY (energy_flow_type_id) REFERENCES new_test.energy_flow_type(energy_flow_type_id),
    FOREIGN KEY (location_id) REFERENCES new_test.locations(location_id),
    FOREIGN KEY (source_id) REFERENCES new_test.energy_sources(source_id)
);


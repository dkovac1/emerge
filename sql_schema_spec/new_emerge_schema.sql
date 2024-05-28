-- Create the schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS new_emerge;

-- Name: time_dimension ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.time_dimension cascade;
CREATE TABLE new_emerge.time_dimension (
    time_id INT PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    hour INT
);

-- Name: countries ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.countries cascade;
CREATE TABLE new_emerge.countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100),
    region VARCHAR(100)
);

-- Name: locations ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.locations cascade;
CREATE TABLE new_emerge.locations (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(255),
    country_id INT,
    location_type VARCHAR(100),  -- For example, 'Generator', 'Load Point', etc.
    additional_details TEXT,
    FOREIGN KEY (country_id) REFERENCES new_emerge.countries(country_id)
);

-- Name: demand_types ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.demand_types cascade;
CREATE TABLE new_emerge.demand_types (
    demand_type_id INT PRIMARY KEY,
    type_name VARCHAR(100),
    description TEXT
);

-- Name: electricity_demand ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.electricity_demand;
CREATE TABLE new_emerge.electricity_demand (
    record_id SERIAL PRIMARY KEY,
    time_id INT,
    location_id INT,
    demand_type_id INT,
    demand_amount DECIMAL,
    FOREIGN KEY (time_id) REFERENCES new_emerge.time_dimension(time_id),
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (demand_type_id) REFERENCES new_emerge.demand_types(demand_type_id)
);

-- Name: pricing_type ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.pricing_type cascade;
CREATE TABLE new_emerge.pricing_type (
    pricing_type_id INT PRIMARY KEY,
    pricing_type_name VARCHAR(100),
    description TEXT
);

-- Name: pricing_type ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.electricity_pricing;
CREATE TABLE new_emerge.electricity_pricing (
    pricing_id SERIAL PRIMARY KEY,
    time_id INT,
    country_id INT,
    pricing_type_id INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (time_id) REFERENCES new_emerge.time_dimension(time_id),
    FOREIGN KEY (country_id) REFERENCES new_emerge.countries(country_id),
    FOREIGN KEY (pricing_type_id) REFERENCES new_emerge.pricing_type(pricing_type_id)
);

-- Name: pv_generation_type ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.pv_generation_type cascade;
CREATE TABLE new_emerge.pv_generation_type (
    pv_generation_type_id INT PRIMARY KEY,
    pv_generation_type_name VARCHAR(100),
    description TEXT
);

-- Name: pv_generation ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.pv_generation;
CREATE TABLE new_emerge.pv_generation (
    pv_record_id SERIAL PRIMARY KEY,
    time_id INT,
    pv_generation_type_id INT,
    generation_kwh DECIMAL,
    FOREIGN KEY (time_id) REFERENCES new_emerge.time_dimension(time_id),
    FOREIGN KEY (pv_generation_type_id) REFERENCES new_emerge.pv_generation_type(pv_generation_type_id)
);

-- Name: buses ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.buses cascade;
CREATE TABLE new_emerge.buses (
    bus_id VARCHAR(100) PRIMARY KEY,
    substation VARCHAR(100),
    is_slack BOOLEAN,
    is_active BOOLEAN,
    v_nom DECIMAL,
    v_min DECIMAL,
    v_max DECIMAL,
    z_f DECIMAL,
    x DECIMAL,
    y DECIMAL,
    h DECIMAL,
    w DECIMAL,
    area INT,
    zone INT,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id)
);


-- Name: pv_generation_type ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.branch_type cascade;
CREATE TABLE new_emerge.branch_type (
    branch_type_name VARCHAR(100) PRIMARY KEY,
    description VARCHAR(100)
);


-- Name: branches ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.branches;
CREATE TABLE new_emerge.branches (
    branch_id SERIAL PRIMARY KEY,
    branch_type VARCHAR(100),
    name VARCHAR(100),
    bus_from VARCHAR(100),
    bus_to VARCHAR(100),
    rate_mva DECIMAL,
    is_active BOOLEAN,
    mttf DECIMAL,
    mttr DECIMAL,
    r DECIMAL,
    x DECIMAL,
    b DECIMAL,
    g DECIMAL,
    tap_module INT,
    angle INT,
    FOREIGN KEY (bus_from) REFERENCES new_emerge.buses(bus_id),
    FOREIGN KEY (bus_from) REFERENCES new_emerge.buses(bus_id),
    FOREIGN KEY (branch_type) REFERENCES new_emerge.branch_type(branch_type_name)
);


-- Name: generators ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.generators;
CREATE TABLE new_emerge.generators (
    generator_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    is_controlled BOOLEAN,
    enabled_dispatch BOOLEAN,
    active_power_mw DECIMAL,
    power_factor DECIMAL,
    v_set DECIMAL,
    s_nom_mva DECIMAL,
    q_min DECIMAL,
    q_max DECIMAL,
    p_min DECIMAL,
    p_max DECIMAL,
    cost INT,
    mttf DECIMAL,
    mttr DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_emerge.buses(bus_id)
);

-- Name: loads ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.loads;
CREATE TABLE new_emerge.loads (
    load_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    active_power_mw DECIMAL,
    reactive_power_mvar DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_emerge.buses(bus_id)
);

-- Name: shunts ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.shunts;
CREATE TABLE new_emerge.shunts (
    shunt_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    is_controlled BOOLEAN,
    is_active BOOLEAN,
    g DECIMAL,
    b DECIMAL,
    b_min DECIMAL,
    b_max DECIMAL,
    v_set DECIMAL,
    y DECIMAL,
    mttf DECIMAL,
    mttr DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_emerge.buses(bus_id)
);

-- Name: static_generators ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.static_generators;
CREATE TABLE new_emerge.static_generators (
    StaticGenID INT PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    active_power_mw DECIMAL,
    reactive_power_mvar DECIMAL,
    s DECIMAL,
    mttf DECIMAL,
    mttr DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_emerge.buses(bus_id)
);

-- Name: transformers ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_emerge.transformers;
CREATE TABLE new_emerge.transformers (
    transformer_id INT PRIMARY KEY,
    name VARCHAR(100),
    bus_from INT,
    bus_to INT,
    rate_mva DECIMAL,
    hv DECIMAL,
    lv DECIMAL,
    sn DECIMAL,
    r DECIMAL,
    x DECIMAL,
    g DECIMAL,
    b DECIMAL,
    FOREIGN KEY (bus_from) REFERENCES new_emerge.Buses(bus_id),
    FOREIGN KEY (bus_to) REFERENCES new_emerge.Buses(bus_id)
);

-- Drop and recreate Transformers3W table within the emerge_1 schema
DROP TABLE IF EXISTS new_emerge.transformers_3w;
CREATE TABLE new_emerge.transformers_3w (
    transformer_3w_id INT PRIMARY KEY,
    Name VARCHAR(100),
    bus_1 INT,
    bus_2 INT,
    bus_3 INT,
    v_1 DECIMAL(10, 2),
    v_2 DECIMAL(10, 2),
    v_3 DECIMAL(10, 2),
    r_12 DECIMAL(10, 2),
    r_23 DECIMAL(10, 2),
    r_31 DECIMAL(10, 2),
    x_12 DECIMAL(10, 2),
    x_23 DECIMAL(10, 2),
    x_31 DECIMAL(10, 2),
    rate_12 DECIMAL(10, 2),
    rate_23 DECIMAL(10, 2),
    rate_31 DECIMAL(10, 2),
    FOREIGN KEY (bus_1) REFERENCES new_emerge.buses(bus_id),
    FOREIGN KEY (bus_2) REFERENCES new_emerge.buses(bus_id),
    FOREIGN KEY (bus_3) REFERENCES new_emerge.buses(bus_id)
);


-- Dimension table for DAYTYPE
DROP TABLE IF EXISTS new_emerge.day_type;
CREATE TABLE new_emerge.day_type (
    day_type_id INT PRIMARY KEY,
    description VARCHAR(100)
);

-- Dimension table for EMISSION
DROP TABLE IF EXISTS new_emerge.emission cascade;
CREATE TABLE new_emerge.emission (
    emission_id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Dimension table for FUEL
DROP TABLE IF EXISTS new_emerge.fuel cascade;
CREATE TABLE new_emerge.fuel (
    fuel_id INT PRIMARY KEY,
    type VARCHAR(50)
);

-- Dimension table for DAILYTIMEBRACKET
DROP TABLE IF EXISTS new_emerge.daily_time_bracket;
CREATE TABLE new_emerge.daily_time_bracket (
    daily_time_bracket_id INT PRIMARY KEY,
    description VARCHAR(100)
);

-- Dimension table for SEASON
DROP TABLE IF EXISTS new_emerge.season cascade;
CREATE TABLE new_emerge.season (
    season_id INT PRIMARY KEY,
    description VARCHAR(100)
);

-- Dimension table for TIMESLICE
DROP TABLE IF EXISTS new_emerge.time_slice cascade;
CREATE TABLE new_emerge.time_slice (
    time_slice_id INT PRIMARY KEY,
    name VARCHAR(50)
);

-- Dimension table for mode_of_operation
DROP TABLE IF EXISTS new_emerge.mode_of_operation cascade;
CREATE TABLE new_emerge.mode_of_operation (
    mode_of_operation_id INT PRIMARY KEY,
    description VARCHAR(100)
);

-- Dimension table for STORAGE
DROP TABLE IF EXISTS new_emerge.storage cascade;
CREATE TABLE new_emerge.storage (
    storage_id INT PRIMARY KEY,
    type VARCHAR(50)
);

-- Dimension table for technology
DROP TABLE IF EXISTS new_emerge.technology cascade;
CREATE TABLE new_emerge.technology (
    technology_id INT PRIMARY KEY,
    code VARCHAR(50)
);

-- Dimension table for year
DROP TABLE IF EXISTS new_emerge.year cascade;
CREATE TABLE new_emerge.year (
    year_id INT PRIMARY KEY,
    Year INT
);

-- Fact tables ----------------------------------------------------------------------

-- Fact table for capacity_to_activity_unit
DROP TABLE IF EXISTS new_emerge.capacity_to_activity_unit cascade;
CREATE TABLE new_emerge.capacity_to_activity_unit (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id)
);

-- Fact table for conversion_ld
DROP TABLE IF EXISTS new_emerge.conversion_ld cascade;
CREATE TABLE new_emerge.conversion_ld (
    id INT PRIMARY KEY,
    time_slice_id INT,
    mode_of_operation_id INT,
    value FLOAT,
    FOREIGN KEY (time_slice_id) REFERENCES new_emerge.time_slice(time_slice_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id)
);

DROP TABLE IF EXISTS new_emerge.conversion_lh cascade;
CREATE TABLE new_emerge.conversion_lh (
    id INT PRIMARY KEY,
    time_slice_id INT,
    mode_of_operation_id INT,
    value FLOAT,
    FOREIGN KEY (time_slice_id) REFERENCES new_emerge.time_slice(time_slice_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id)
);

DROP TABLE IF EXISTS new_emerge.conversion_ls cascade;
CREATE TABLE new_emerge.conversion_ls (
    id INT PRIMARY KEY,
    season_id INT,
    mode_of_operation_id INT,
    Value FLOAT,
    FOREIGN KEY (season_id) REFERENCES new_emerge.season(season_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id)
);


-- Fact table for operational_life
DROP TABLE IF EXISTS new_emerge.operational_life cascade;
CREATE TABLE new_emerge.operational_life (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    value INT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id)
);

-- Example: Fact table for technology_from_storage
DROP TABLE IF EXISTS new_emerge.technology_from_storage cascade;
CREATE TABLE new_emerge.technology_from_storage (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    storage_id INT,
    mode_of_operation_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (storage_id) REFERENCES new_emerge.storage(storage_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id)
);

-- Example: Fact table for TechnologyFromStorage
DROP TABLE IF EXISTS new_emerge.technology_to_storage cascade;
CREATE TABLE new_emerge.technology_to_storage (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    storage_id INT,
    mode_of_operation_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (storage_id) REFERENCES new_emerge.storage(storage_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id)
);


-- Fact table for accumulated_annual_demand
DROP TABLE IF EXISTS new_emerge.accumulated_annual_demand cascade;
CREATE TABLE new_emerge.accumulated_annual_demand (
    id INT PRIMARY KEY,
    location_id INT,
    fuel_id INT,
    year_id INT,
    Value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);


-- Fact table for availability_factor
DROP TABLE IF EXISTS new_emerge.availability_factor cascade;
CREATE TABLE new_emerge.availability_factor (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for capacity_factor
DROP TABLE IF EXISTS new_emerge.capacity_factor cascade;
CREATE TABLE new_emerge.capacity_factor (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    time_slice_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (time_slice_id) REFERENCES new_emerge.time_slice(time_slice_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for capital_cost
DROP TABLE IF EXISTS new_emerge.capital_cost cascade;
CREATE TABLE new_emerge.capital_cost (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for emission_activity_ratio
DROP TABLE IF EXISTS new_emerge.emission_activity_ratio cascade;
CREATE TABLE new_emerge.emission_activity_ratio (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    emission_id INT,
    mode_of_operation_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (emission_id) REFERENCES new_emerge.emission(emission_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for EmissionsPenalty
DROP TABLE IF EXISTS new_emerge.emissions_penalty cascade;
CREATE TABLE new_emerge.emissions_penalty (
    id INT PRIMARY KEY,
    location_id INT,
    emission_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (emission_id) REFERENCES new_emerge.emission(emission_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for FixedCost
DROP TABLE IF EXISTS new_emerge.fixed_cost cascade;
CREATE TABLE new_emerge.fixed_cost (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for InputActivityRatio
DROP TABLE IF EXISTS new_emerge.input_activity_ratio cascade;
CREATE TABLE new_emerge.input_activity_ratio (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    fuel_id INT,
    mode_of_operation_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for OutputActivityRatio
DROP TABLE IF EXISTS new_emerge.output_activity_ratio cascade;
CREATE TABLE new_emerge.output_activity_ratio (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    fuel_id INT,
    mode_of_operation_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for reserve_margin
DROP TABLE IF EXISTS new_emerge.reserve_margin cascade;
CREATE TABLE new_emerge.reserve_margin (
    id INT PRIMARY KEY,
    location_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for reserve_margin_tag_fuel
DROP TABLE IF EXISTS new_emerge.reserve_margin_tag_fuel cascade;
CREATE TABLE new_emerge.reserve_margin_tag_fuel (
    id INT PRIMARY KEY,
    location_id INT,
    fuel_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for ReserveMarginTagTechnology
DROP TABLE IF EXISTS new_emerge.reserve_margin_tag_technology cascade;
CREATE TABLE new_emerge.reserve_margin_tag_technology (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for ResidualCapacity
DROP TABLE IF EXISTS new_emerge.residual_capacity cascade;
CREATE TABLE new_emerge.residual_capacity (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    Value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for SpecifiedAnnualDemand
DROP TABLE IF EXISTS new_emerge.specified_annual_demand cascade;
CREATE TABLE new_emerge.specified_annual_demand (
    id INT PRIMARY KEY,
    location_id INT,
    fuel_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for specified_demand_profile
DROP TABLE IF EXISTS new_emerge.specified_demand_profile cascade;
CREATE TABLE new_emerge.specified_demand_profile (
    id INT PRIMARY KEY,
    location_id INT,
    fuel_id INT,
    time_slice_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (fuel_id) REFERENCES new_emerge.fuel(fuel_id),
    FOREIGN KEY (time_slice_id) REFERENCES new_emerge.time_slice(time_slice_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for TotalAnnualMaxCapacity
DROP TABLE IF EXISTS new_emerge.total_annual_max_capacity cascade;
CREATE TABLE new_emerge.total_annual_max_capacity (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for total_annual_min_capacity
DROP TABLE IF EXISTS new_emerge.total_annual_min_capacity cascade;
CREATE TABLE new_emerge.total_annual_min_capacity (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id) ,
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for variable_cost
DROP TABLE IF EXISTS new_emerge.variable_cost cascade;
CREATE TABLE new_emerge.variable_cost (
    id INT PRIMARY KEY,
    location_id INT,
    technology_id INT,
    mode_of_operation_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (location_id) REFERENCES new_emerge.locations(location_id),
    FOREIGN KEY (technology_id) REFERENCES new_emerge.technology(technology_id),
    FOREIGN KEY (mode_of_operation_id) REFERENCES new_emerge.mode_of_operation(mode_of_operation_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);

-- Fact table for year_split
DROP TABLE IF EXISTS new_emerge.year_split cascade;
CREATE TABLE new_emerge.year_split (
    id INT PRIMARY KEY,
    time_slice_id INT,
    year_id INT,
    value FLOAT,
    FOREIGN KEY (time_slice_id) REFERENCES new_emerge.time_slice(time_slice_id),
    FOREIGN KEY (year_id) REFERENCES new_emerge.year(year_id)
);


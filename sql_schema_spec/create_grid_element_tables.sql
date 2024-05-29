-- Name: buses ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.buses cascade;
CREATE TABLE new_test.buses (
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
    location_id UUID,
    FOREIGN KEY (location_id) REFERENCES new_test.locations(location_id)
);


-- Name: pv_generation_type ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.branch_type cascade;
CREATE TABLE new_test.branch_type (
    branch_type_name VARCHAR(100) PRIMARY KEY,
    description VARCHAR(100)
);


-- Name: branches ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.branches;
CREATE TABLE new_test.branches (
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
    FOREIGN KEY (bus_from) REFERENCES new_test.buses(bus_id),
    FOREIGN KEY (bus_from) REFERENCES new_test.buses(bus_id),
    FOREIGN KEY (branch_type) REFERENCES new_test.branch_type(branch_type_name)
);


-- Name: generators ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.generators;
CREATE TABLE new_test.generators (
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
    FOREIGN KEY (bus_id) REFERENCES new_test.buses(bus_id)
);

-- Name: loads ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.loads;
CREATE TABLE new_test.loads (
    load_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    active_power_mw DECIMAL,
    reactive_power_mvar DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_test.buses(bus_id)
);

-- Name: shunts ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.shunts;
CREATE TABLE new_test.shunts (
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
    FOREIGN KEY (bus_id) REFERENCES new_test.buses(bus_id)
);

-- Name: static_generators ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.static_generators;
CREATE TABLE new_test.static_generators (
    StaticGenID INT PRIMARY KEY,
    name VARCHAR(100),
    bus_id VARCHAR(100),
    active_power_mw DECIMAL,
    reactive_power_mvar DECIMAL,
    s DECIMAL,
    mttf DECIMAL,
    mttr DECIMAL,
    FOREIGN KEY (bus_id) REFERENCES new_test.buses(bus_id)
);

-- Name: transformers ; Type: TABLE; Schema: new_emerge; Owner: postgres
DROP TABLE IF EXISTS new_test.transformers;
CREATE TABLE new_test.transformers (
    transformer_id INT PRIMARY KEY,
    name VARCHAR(100),
    bus_from VARCHAR(100),
    bus_to VARCHAR(100),
    rate_mva DECIMAL,
    hv DECIMAL,
    lv DECIMAL,
    sn DECIMAL,
    r DECIMAL,
    x DECIMAL,
    g DECIMAL,
    b DECIMAL,
    FOREIGN KEY (bus_from) REFERENCES new_test.Buses(bus_id),
    FOREIGN KEY (bus_to) REFERENCES new_test.Buses(bus_id)
);

-- Drop and recreate Transformers3W table within the emerge_1 schema
DROP TABLE IF EXISTS new_test.transformers_3w;
CREATE TABLE new_test.transformers_3w (
    transformer_3w_id INT PRIMARY KEY,
    Name VARCHAR(100),
    bus_1 VARCHAR(100),
    bus_2 VARCHAR(100),
    bus_3 VARCHAR(100),
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
    FOREIGN KEY (bus_1) REFERENCES new_test.buses(bus_id),
    FOREIGN KEY (bus_2) REFERENCES new_test.buses(bus_id),
    FOREIGN KEY (bus_3) REFERENCES new_test.buses(bus_id)
);
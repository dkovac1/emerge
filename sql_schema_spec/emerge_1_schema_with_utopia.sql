-- Create the schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS emerge_1;

-- Drop and recreate TimeDimension table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.TimeDimension;
CREATE TABLE emerge_1.TimeDimension (
    TimeID INT PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    Hour INT
);

-- Drop and recreate Countries table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Countries;
CREATE TABLE emerge_1.Countries (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100),
    Region VARCHAR(100)
);

-- Drop and recreate Locations table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Locations;
CREATE TABLE emerge_1.Locations (
    LocationID INT PRIMARY KEY,
    LocationName VARCHAR(255),
    CountryID INT,
    LocationType VARCHAR(100),  -- For example, 'Generator', 'Load Point', etc.
    AdditionalDetails TEXT,
    FOREIGN KEY (CountryID) REFERENCES emerge_1.Countries(CountryID)
);

-- Drop and recreate DemandTypes table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.DemandTypes;
CREATE TABLE emerge_1.DemandTypes (
    DemandTypeID INT PRIMARY KEY,
    TypeName VARCHAR(100),
    Description TEXT
);

-- Drop and recreate ElectricityDemand table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.ElectricityDemand;
CREATE TABLE emerge_1.ElectricityDemand (
    RecordID INT PRIMARY KEY,
    TimeID INT,
    LocationID INT,
    DemandTypeID INT,
    DemandAmount DECIMAL,
    FOREIGN KEY (TimeID) REFERENCES emerge_1.TimeDimension(TimeID),
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (DemandTypeID) REFERENCES emerge_1.DemandTypes(DemandTypeID)
);

-- Drop and recreate PricingType table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.PricingType;
CREATE TABLE emerge_1.PricingType (
    PricingTypeID INT PRIMARY KEY,
    PricingTypeName VARCHAR(100),
    Description TEXT
);

-- Drop and recreate ElectricityPricing table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.ElectricityPricing;
CREATE TABLE emerge_1.ElectricityPricing (
    PricingID INT PRIMARY KEY,
    TimeID INT,
    CountryID INT,
    PricingTypeID INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (TimeID) REFERENCES emerge_1.TimeDimension(TimeID),
    FOREIGN KEY (CountryID) REFERENCES emerge_1.Countries(CountryID),
    FOREIGN KEY (PricingTypeID) REFERENCES emerge_1.PricingType(PricingTypeID)
);

-- Drop and recreate PVGeneration table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.PVGeneration;
CREATE TABLE emerge_1.PVGeneration (
    PVRecordID INT PRIMARY KEY,
    TimeID INT,
    PVType VARCHAR(50),
    GenerationKWh DECIMAL,
    FOREIGN KEY (TimeID) REFERENCES emerge_1.TimeDimension(TimeID)
);

-- Drop and recreate Buses table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Buses;
CREATE TABLE emerge_1.Buses (
    BusID INT PRIMARY KEY,
    Name VARCHAR(100),
    IsSlack BOOLEAN,
    Vnom DECIMAL,
    LocationID INT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID)
);

-- Drop and recreate Branches table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Branches;
CREATE TABLE emerge_1.Branches (
    BranchID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusFrom INT,
    BusTo INT,
    RateMVA DECIMAL,
    R DECIMAL,
    X DECIMAL,
    B DECIMAL,
    G DECIMAL,
    FOREIGN KEY (BusFrom) REFERENCES emerge_1.Buses(BusID),
    FOREIGN KEY (BusTo) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate Generators table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Generators;
CREATE TABLE emerge_1.Generators (
    GeneratorID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusID INT,
    IsControlled BOOLEAN,
    ActivePowerMW DECIMAL,
    PowerFactor DECIMAL,
    Vset DECIMAL,
    SnomMVA DECIMAL,
    Qmin DECIMAL,
    Qmax DECIMAL,
    Pmin DECIMAL,
    Pmax DECIMAL,
    FOREIGN KEY (BusID) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate Loads table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Loads;
CREATE TABLE emerge_1.Loads (
    LoadID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusID INT,
    ActivePowerMW DECIMAL,
    ReactivePowerMVAr DECIMAL,
    FOREIGN KEY (BusID) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate Shunts table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Shunts;
CREATE TABLE emerge_1.Shunts (
    ShuntID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusID INT,
    IsControlled BOOLEAN,
    G DECIMAL,
    B DECIMAL,
    Bmin DECIMAL,
    Bmax DECIMAL,
    Vset DECIMAL,
    FOREIGN KEY (BusID) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate StaticGenerators table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.StaticGenerators;
CREATE TABLE emerge_1.StaticGenerators (
    StaticGenID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusID INT,
    ActivePowerMW DECIMAL,
    ReactivePowerMVAr DECIMAL,
    FOREIGN KEY (BusID) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate Transformers table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Transformers;
CREATE TABLE emerge_1.Transformers (
    TransformerID INT PRIMARY KEY,
    Name VARCHAR(100),
    BusFrom INT,
    BusTo INT,
    RateMVA DECIMAL,
    HV DECIMAL,
    LV DECIMAL,
    Sn DECIMAL,
    R DECIMAL,
    X DECIMAL,
    G DECIMAL,
    B DECIMAL,
    FOREIGN KEY (BusFrom) REFERENCES emerge_1.Buses(BusID),
    FOREIGN KEY (BusTo) REFERENCES emerge_1.Buses(BusID)
);

-- Drop and recreate Transformers3W table within the emerge_1 schema
DROP TABLE IF EXISTS emerge_1.Transformers3W;
CREATE TABLE emerge_1.Transformers3W (
    Transformer3WID INT PRIMARY KEY,
    Name VARCHAR(100),
    Bus1 INT,
    Bus2 INT,
    Bus3 INT,
    V1 DECIMAL(10, 2),
    V2 DECIMAL(10, 2),
    V3 DECIMAL(10, 2),
    R12 DECIMAL(10, 2),
    R23 DECIMAL(10, 2),
    R31 DECIMAL(10, 2),
    X12 DECIMAL(10, 2),
    X23 DECIMAL(10, 2),
    X31 DECIMAL(10, 2),
    Rate12 DECIMAL(10, 2),
    Rate23 DECIMAL(10, 2),
    Rate31 DECIMAL(10, 2),
    FOREIGN KEY (Bus1) REFERENCES emerge_1.Buses(BusID),
    FOREIGN KEY (Bus2) REFERENCES emerge_1.Buses(BusID),
    FOREIGN KEY (Bus3) REFERENCES emerge_1.Buses(BusID)
);


-- Dimension table for DAYTYPE
CREATE TABLE emerge_1.DAYTYPE (
    DayTypeID INT PRIMARY KEY,
    Description VARCHAR(100)
);

-- Dimension table for EMISSION
CREATE TABLE emerge_1.EMISSION (
    EmissionID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- Dimension table for FUEL
CREATE TABLE emerge_1.FUEL (
    FuelID INT PRIMARY KEY,
    Type VARCHAR(50)
);

-- Dimension table for DAILYTIMEBRACKET
CREATE TABLE emerge_1.DAILYTIMEBRACKET (
    DailyTimeBracketID INT PRIMARY KEY,
    Description VARCHAR(100)
);

-- Dimension table for SEASON
CREATE TABLE emerge_1.SEASON (
    SeasonID INT PRIMARY KEY,
    Description VARCHAR(100)
);

-- Dimension table for TIMESLICE
CREATE TABLE emerge_1.TIMESLICE (
    TimeSliceID INT PRIMARY KEY,
    Name VARCHAR(50)
);

-- Dimension table for MODE_OF_OPERATION
CREATE TABLE emerge_1.MODE_OF_OPERATION (
    ModeOfOperationID INT PRIMARY KEY,
    Description VARCHAR(100)
);

-- Dimension table for STORAGE
CREATE TABLE emerge_1.STORAGE (
    StorageID INT PRIMARY KEY,
    Type VARCHAR(50)
);

-- Dimension table for TECHNOLOGY
CREATE TABLE emerge_1.TECHNOLOGY (
    TechnologyID INT PRIMARY KEY,
    Code VARCHAR(50)
);

-- Dimension table for YEAR
CREATE TABLE emerge_1.YEAR (
    YearID INT PRIMARY KEY,
    Year INT
);

-- Fact tables ----------------------------------------------------------------------

-- Fact table for CapacityToActivityUnit
CREATE TABLE emerge_1.CapacityToActivityUnit (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID)
);

-- Fact table for Conversion
CREATE TABLE emerge_1.Conversionld (
    ID INT PRIMARY KEY,
    TimeSliceID INT,
    ModeOfOperationID INT,
    Value FLOAT,
    FOREIGN KEY (TimeSliceID) REFERENCES emerge_1.TIMESLICE(TimeSliceID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID)
);


CREATE TABLE emerge_1.Conversionlh (
    ID INT PRIMARY KEY,
    TimeSliceID INT,
    ModeOfOperationID INT,
    Value FLOAT,
    FOREIGN KEY (TimeSliceID) REFERENCES emerge_1.TIMESLICE(TimeSliceID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID)
);

CREATE TABLE emerge_1.Conversionls (
    ID INT PRIMARY KEY,
    SeasonID INT,
    ModeOfOperationID INT,
    Value FLOAT,
    FOREIGN KEY (SeasonID) REFERENCES emerge_1.SEASON(SeasonID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID)
);


-- Fact table for OperationalLife
CREATE TABLE emerge_1.OperationalLife (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    Value INT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID)
);

-- Example: Fact table for TechnologyFromStorage
CREATE TABLE emerge_1.TechnologyFromStorage (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    StorageID INT,
    ModeOfOperationID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (StorageID) REFERENCES emerge_1.STORAGE(StorageID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID)
);

-- Example: Fact table for TechnologyFromStorage
CREATE TABLE emerge_1.TechnologyToStorage (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    StorageID INT,
    ModeOfOperationID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (StorageID) REFERENCES emerge_1.STORAGE(StorageID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID)
);


-- Fact table for AccumulatedAnnualDemand
CREATE TABLE emerge_1.AccumulatedAnnualDemand (
    ID INT PRIMARY KEY,
    LocationID INT,
    FuelID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);


-- Fact table for AvailabilityFactor
CREATE TABLE emerge_1.AvailabilityFactor (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for CapacityFactor
CREATE TABLE emerge_1.CapacityFactor (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    TimeSliceID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (TimeSliceID) REFERENCES emerge_1.TIMESLICE(TimeSliceID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for CapitalCost
CREATE TABLE emerge_1.CapitalCost (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for EmissionActivityRatio
CREATE TABLE emerge_1.EmissionActivityRatio (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    EmissionID INT,
    ModeOfOperationID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (EmissionID) REFERENCES emerge_1.EMISSION(EmissionID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for EmissionsPenalty
CREATE TABLE emerge_1.EmissionsPenalty (
    ID INT PRIMARY KEY,
    LocationID INT,
    EmissionID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (EmissionID) REFERENCES emerge_1.EMISSION(EmissionID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for FixedCost
CREATE TABLE emerge_1.FixedCost (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for InputActivityRatio
CREATE TABLE emerge_1.InputActivityRatio (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    FuelID INT,
    ModeOfOperationID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for OutputActivityRatio
CREATE TABLE emerge_1.OutputActivityRatio (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    FuelID INT,
    ModeOfOperationID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for ReserveMargin
CREATE TABLE emerge_1.ReserveMargin (
    ID INT PRIMARY KEY,
    LocationID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for ReserveMarginTagFuel
CREATE TABLE emerge_1.ReserveMarginTagFuel (
    ID INT PRIMARY KEY,
    LocationID INT,
    FuelID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for ReserveMarginTagTechnology
CREATE TABLE emerge_1.ReserveMarginTagTechnology (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for ResidualCapacity
CREATE TABLE emerge_1.ResidualCapacity (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for SpecifiedAnnualDemand
CREATE TABLE emerge_1.SpecifiedAnnualDemand (
    ID INT PRIMARY KEY,
    LocationID INT,
    FuelID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for SpecifiedDemandProfile
CREATE TABLE emerge_1.SpecifiedDemandProfile (
    ID INT PRIMARY KEY,
    LocationID INT,
    FuelID INT,
    TimeSliceID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (FuelID) REFERENCES emerge_1.FUEL(FuelID),
    FOREIGN KEY (TimeSliceID) REFERENCES emerge_1.TIMESLICE(TimeSliceID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for TotalAnnualMaxCapacity
CREATE TABLE emerge_1.TotalAnnualMaxCapacity (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for TotalAnnualMinCapacity
CREATE TABLE emerge_1.TotalAnnualMinCapacity (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for VariableCost
CREATE TABLE emerge_1.VariableCost (
    ID INT PRIMARY KEY,
    LocationID INT,
    TechnologyID INT,
    ModeOfOperationID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (LocationID) REFERENCES emerge_1.Locations(LocationID),
    FOREIGN KEY (TechnologyID) REFERENCES emerge_1.TECHNOLOGY(TechnologyID),
    FOREIGN KEY (ModeOfOperationID) REFERENCES emerge_1.MODE_OF_OPERATION(ModeOfOperationID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

-- Fact table for YearSplit
CREATE TABLE emerge_1.YearSplit (
    ID INT PRIMARY KEY,
    TimeSliceID INT,
    YearID INT,
    Value FLOAT,
    FOREIGN KEY (TimeSliceID) REFERENCES emerge_1.TIMESLICE(TimeSliceID),
    FOREIGN KEY (YearID) REFERENCES emerge_1.YEAR(YearID)
);

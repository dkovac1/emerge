create schema if not exists new_test;

CREATE EXTENSION IF NOT EXISTS pgcrypto;


DROP TABLE IF EXISTS new_test.years cascade;
CREATE TABLE new_test.years (
    year INTEGER PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid() NOT NULL
);

INSERT INTO new_test.years (year)
SELECT year
FROM generate_series(2000, 2010) AS year;

DROP TABLE IF EXISTS new_test.months cascade;
CREATE TABLE new_test.months (
    month INTEGER PRIMARY KEY,
    month_name VARCHAR(20) NOT NULL,
    uuid UUID DEFAULT gen_random_uuid() NOT NULL
);


DROP TABLE IF EXISTS new_test.months cascade;
CREATE TABLE new_test.months (
    month INTEGER PRIMARY KEY,
    month_name VARCHAR(20) NOT NULL,
    uuid UUID DEFAULT gen_random_uuid() NOT NULL
);

INSERT INTO new_test.months (month, month_name)
VALUES
    (1, 'January'),
    (2, 'February'),
    (3, 'March'),
    (4, 'April'),
    (5, 'May'),
    (6, 'June'),
    (7, 'July'),
    (8, 'August'),
    (9, 'September'),
    (10, 'October'),
    (11, 'November'),
    (12, 'December');

DROP TABLE IF EXISTS new_test.days cascade;
CREATE TABLE new_test.days (
    day INTEGER PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid() NOT NULL
);

INSERT INTO new_test.days (day)
SELECT day
FROM generate_series(1, 31) AS day;


DROP TABLE IF EXISTS new_test.hours cascade;
CREATE TABLE new_test.hours (
    hour INTEGER PRIMARY KEY,
    uuid UUID DEFAULT gen_random_uuid() NOT NULL
);

INSERT INTO new_test.hours (hour)
SELECT hour
FROM generate_series(0, 23) AS hour;


-- Create the year_month_day_hour table
DROP TABLE IF EXISTS new_test.year_month_day_hour;
CREATE TABLE new_test.year_month_day_hour (
    uuid UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    day INTEGER NOT NULL,
    hour INTEGER NOT NULL,
    FOREIGN KEY (year) REFERENCES new_test.years (year),
    FOREIGN KEY (month) REFERENCES new_test.months (month),
    FOREIGN KEY (day) REFERENCES new_test.days (day),
    FOREIGN KEY (hour) REFERENCES new_test.hours (hour)
);

-- Create the hours_in_year table
DROP TABLE IF EXISTS new_test.hours_in_year;
CREATE TABLE new_test.hours_in_year (
    uuid UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    year INTEGER NOT NULL,
    hour_of_year INTEGER NOT NULL,
    FOREIGN KEY (year) REFERENCES new_test.years (year),
    UNIQUE (year, hour_of_year)
);


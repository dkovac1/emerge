CREATE EXTENSION IF NOT EXISTS plpgsql;

-- Function to check for leap year
CREATE OR REPLACE FUNCTION is_leap_year(year INTEGER) RETURNS BOOLEAN AS $$
BEGIN
    RETURN (year % 4 = 0 AND year % 100 <> 0) OR (year % 400 = 0);
END;
$$ LANGUAGE plpgsql;


-- Populate the year_month_day_hour table
DO $$
DECLARE
    y INTEGER;
    m INTEGER;
    d INTEGER;
    h INTEGER;
BEGIN
    FOR y IN (SELECT year FROM new_test.years) LOOP
        FOR m IN (SELECT month FROM new_test.months) LOOP
            IF m = 2 THEN
                IF is_leap_year(y) THEN
                    FOR d IN 1..29 LOOP
                        FOR h IN 0..23 LOOP
                            INSERT INTO new_test.year_month_day_hour (year, month, day, hour)
                            VALUES (y, m, d, h)
                            ON CONFLICT DO NOTHING;
                        END LOOP;
                    END LOOP;
                ELSE
                    FOR d IN 1..28 LOOP
                        FOR h IN 0..23 LOOP
                            INSERT INTO new_test.year_month_day_hour (year, month, day, hour)
                            VALUES (y, m, d, h)
                            ON CONFLICT DO NOTHING;
                        END LOOP;
                    END LOOP;
                END IF;
            ELSIF m IN (4, 6, 9, 11) THEN
                FOR d IN 1..30 LOOP
                    FOR h IN 0..23 LOOP
                        INSERT INTO new_test.year_month_day_hour (year, month, day, hour)
                        VALUES (y, m, d, h)
                        ON CONFLICT DO NOTHING;
                    END LOOP;
                END LOOP;
            ELSE
                FOR d IN 1..31 LOOP
                    FOR h IN 0..23 LOOP
                        INSERT INTO new_test.year_month_day_hour (year, month, day, hour)
                        VALUES (y, m, d, h)
                        ON CONFLICT DO NOTHING;
                    END LOOP;
                END LOOP;
            END IF;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- Populate the hours_in_year table (take into account leap years)
DO $$
DECLARE
    y INTEGER;
    h INTEGER;
BEGIN
    FOR y IN (SELECT year FROM new_test.years) LOOP
        FOR h IN 0..((SELECT CASE WHEN is_leap_year(y) THEN 8784 ELSE 8760 END)) - 1 LOOP
            INSERT INTO new_test.hours_in_year (year, hour_of_year)
            VALUES (y, h)
            ON CONFLICT DO NOTHING;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



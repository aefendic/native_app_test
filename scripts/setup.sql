-- ==========================================
-- This script runs when the app is installed 
-- ==========================================

-- Create role and schema contained within the application only (does not create the role in your account)

CREATE APPLICATION ROLE app_public;
CREATE SCHEMA IF NOT EXISTS weather;
GRANT USAGE ON SCHEMA weather TO APPLICATION ROLE app_public;

CREATE OR ALTER VERSIONED SCHEMA versioned_schema;
GRANT USAGE ON SCHEMA versioned_schema TO APPLICATION ROLE app_public;

-- Create UDF (if using imports=() need to use a versioned schema)
create PROCEDURE versioned_schema.WEATHER()
returns TABLE (DATE DATE, TEMP BIGINT)
language python
runtime_version = '3.8'
packages = ('snowflake-snowpark-python', 'requests', 'pandas')
imports = ('/python/weather.py')
handler = 'weather.get_daily_weather';

GRANT USAGE ON PROCEDURE versioned_schema.weather() TO APPLICATION ROLE app_public;

-- streamlit object
CREATE STREAMLIT versioned_schema.hello_snowflake_streamlit
  FROM '/streamlit'
  MAIN_FILE = '/display_weather.py';
GRANT USAGE ON STREAMLIT versioned_schema.hello_snowflake_streamlit TO APPLICATION ROLE app_public;


-- Callback Stored Procedure for the External Access Integraion reference
-- CREATE PROCEDURE versioned_schema.REGISTER_SINGLE_REFERENCE(ref_name STRING, operation STRING, ref_or_alias STRING)
--   RETURNS STRING
--   LANGUAGE SQL
--   AS $$
--     BEGIN
--       CASE (operation)
--         WHEN 'ADD' THEN
--           SELECT SYSTEM$SET_REFERENCE(:ref_name, :ref_or_alias);
--         WHEN 'REMOVE' THEN
--           SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
--         WHEN 'CLEAR' THEN
--           SELECT SYSTEM$REMOVE_REFERENCE(:ref_name);
--       ELSE
--         RETURN 'unknown operation: ' || operation;
--       END CASE;
--       RETURN NULL;
--     END;
--   $$;

-- GRANT USAGE ON PROCEDURE versioned_schema.REGISTER_SINGLE_REFERENCE(STRING, STRING, STRING)
--   TO APPLICATION ROLE app_public;
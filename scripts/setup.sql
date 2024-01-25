-- ==========================================
-- This script runs when the app is installed 
-- ==========================================

-- Create role and schema contained within the application only (does not create the role in your account)

CREATE APPLICATION ROLE app_public;
CREATE SCHEMA IF NOT EXISTS weather;
GRANT ALL ON SCHEMA weather TO APPLICATION ROLE app_public;

CREATE OR ALTER VERSIONED SCHEMA versioned_schema;
GRANT USAGE ON SCHEMA versioned_schema TO APPLICATION ROLE app_public;

-- Create UDF (if using imports=() need to use a versioned schema)
create PROCEDURE versioned_schema.WEATHER()
-- returns TABLE (DATE DATE, TEMP BIGINT)
returns string
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

CREATE OR REPLACE PROCEDURE versioned_schema.init_app(config variant)
  RETURNS string
  LANGUAGE python
  runtime_version = '3.8'
  packages = ('snowflake-snowpark-python', 'requests')
  imports = ('/python/init_app.py')
  handler = 'init_app.init_app';

GRANT USAGE ON PROCEDURE versioned_schema.init_app(variant) TO APPLICATION ROLE app_public;
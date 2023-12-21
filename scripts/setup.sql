-- Create role and schema contained within the application only (does not create the role in your account)
CREATE APPLICATION ROLE app_public;
CREATE SCHEMA IF NOT EXISTS core;
GRANT USAGE ON SCHEMA core TO APPLICATION ROLE app_public;


CREATE OR REPLACE PROCEDURE CORE.WEATHER()
  RETURNS TABLE (DATE DATE, TEMP BIGINT)
  LANGUAGE PYTHON
  EXECUTE AS OWNER
  RUNTIME_VERSION = "3.9"
  IMPORTS = ('/python/weather.py')
  HANDLER='hello_python.main';

GRANT USAGE ON PROCEDURE core.weather() TO APPLICATION ROLE app_public;



from snowflake.snowpark import Session

def init_app(session: Session, config) -> str:
  """
    Initializes function API endpoints with access to the secret and API integration.

    Args:
      session (Session): An active session object for authentication and communication.
      config (Any): The configuration settings for the connector.

    Returns:
      str: A status message indicating the result of the provisioning process.
   """
  secret_name = config['secret_name']
  external_access_integration_name = config['external_access_integration_name']

  alter_function_sql = f'''
    ALTER PROCEDURE versioned_schema.WEATHER() SET 
    SECRETS = ('token' = {secret_name}) 
    EXTERNAL_ACCESS_INTEGRATIONS = ({external_access_integration_name})'''
  
  session.sql(alter_function_sql).collect()

  return 'Hex Native App initialized'
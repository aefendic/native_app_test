# sprocs can only take in one function
def get_daily_weather(session):
    import requests
    import pandas as pd
    from datetime import datetime
    from snowflake.snowpark.context import get_active_session

    api_key = '8b52bac71e9f6d61ca801afc28e03874'
    lat = 0
    long = 0
    units = "metric"
    # OpenWeatherMap API endpoint for daily forecast
    endpoint = f"https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lat}&appid={api_key}&units={units}"

    # Make the API request
    response = requests.get(endpoint)

    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()

        # Extract relevant information for each day
        today_date = datetime.now().date()
        temperature = data["main"]["temp"]

        # Create a DataFrame from the collected data and write to snowflake
        df = pd.DataFrame({'date': [today_date], 'temp': [temperature]})
        session = get_active_session()
        session.write_pandas(df, 'daily_weather', schema='weather', auto_create_table=True, table_type="") # appends data if table exists
        return "success"
    else:
        print(f"Status code {response.status_code}")
        print(f"Error details: {response.text}")
        return None

# send the written data to snowflakes billing system



    
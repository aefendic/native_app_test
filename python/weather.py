# reach out to the weather api
import requests
import pandas as pd
from datetime import datetime
from snowflake.snowpark.context import get_active_session

api_key = '8b52bac71e9f6d61ca801afc28e03874'
lat = 0
long = 0
units = "metric"

def main():
    weather_data = get_daily_weather(api_key, 0, 0, units)
    if weather_data is not None:
        print(weather_data)
        # write_to_snowflake_table(weather_data)

def get_daily_weather(api_key, lat, long, units):
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

        # Create a DataFrame from the collected data
        df = pd.DataFrame({'date': [today_date], 'temp': [temperature]})
        return df

    else:
        print(f"Status code {response.status_code}")
        print(f"Error details: {response.text}")
        return None

def write_to_snowflake_table(df):
    session = get_active_session()
    session.write_pandas(df, 'daily_weather', auto_create_table=True, table_type="") # appends data if table exists

# send the written data to snowflakes billing system

if __name__ == "__main__":
    # Call the main function when the script is run
    main()



    
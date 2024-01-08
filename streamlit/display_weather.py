# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Write directly to the app
st.title("This is a test Native App Dashboard")
st.write(
   """The following data simulates what a Hex billing dashboard would look like.
   """
)

# Get the current credentials
session = get_active_session()

# call the stored procedure to get weather data
button_pressed = st.button("Press me")
if button_pressed:
    test = session.call('versioned_schema.WEATHER')
    #  Create an example data frame
    data_frame = session.sql("SELECT * FROM weather.daily_weather;")

    # Execute the query and convert it into a Pandas data frame
    queried_data = data_frame.to_pandas()

    # Display the Pandas data frame as a Streamlit data frame.
    st.dataframe(queried_data, use_container_width=True)
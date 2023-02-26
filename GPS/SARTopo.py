import requests
import time

# Define your call sign, user ID, latitude, and longitude
call_sign = "BostonUniversity"
user_id = "13"

# Define the file path of the text file that contains latitude and longitude
file_path = 'Stuvi_to_Photonics.txt'

    # Read latitude and longitude from the text file
# Open the file
with open(file_path, 'r') as f:
    # Read the first line
    line = f.readline().strip()

    while line:
        # Extract latitude and longitude from the line
        lat, lon = line.split(',')[:2]

        # Construct the API endpoint URL
        url = f"https://caltopo.com/api/v1/position/report/{call_sign}?id={user_id}&lat={lat}&lng={lon}"

        # Send the position report to the API endpoint
        response = requests.get(url)

        # Print the response status code and content
        print(f"Response status code: {response.status_code}")
        print(f"Response content: {response.content}")

        # Read the next line
        line = f.readline().strip()

        # Wait for 1 seconds before sending the next request
        time.sleep(1)

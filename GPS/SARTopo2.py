import threading
import time
import requests

def send_reports(call_sign, user_id, file_path):
    # Open the file
    with open(file_path, 'r') as f:
        next(f)
        # Read starting second line
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

            # Wait for 1 second before sending the next request
            time.sleep(1)

# Define your call signs, user IDs, and file paths
call_sign_1 = input("Enter call sign 1: ")
user_id_1 = input("Enter user ID 1: ")
file_path_1 = input("Enter file path 1: ")

call_sign_2 = input("Enter call sign 2: ")
user_id_2 = input("Enter user ID 2: ")
file_path_2 = input("Enter file path 2: ")

# Create threads for sending reports to each URL
thread_1 = threading.Thread(target=send_reports, args=(call_sign_1, user_id_1, file_path_1))
thread_2 = threading.Thread(target=send_reports, args=(call_sign_2, user_id_2, file_path_2))

# Start both threads
thread_1.start()
thread_2.start()

# Wait for both threads to finish
thread_1.join()
thread_2.join()

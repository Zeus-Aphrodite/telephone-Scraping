import traceback
import mechanicalsoup as mp
import time
from datetime import datetime
import requests



def check_key(api_key, username) -> bool:
    try:
        search_url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        params = {
            'query': 'test',  # Use a simple query for testing purposes
            'key': api_key
        }
        
        response = requests.get(search_url, params=params)
        
        if response.status_code != 200:
            return { "truth":False, "api_key": api_key , "username": username,  "status": "Error, Check network, the Api key  or try again later" }

        data = response.json()
        
        # Check for error_message in the response
        if 'error_message' in data:
            return { "truth":False, "api_key": api_key , "username": username, "status": "Error, Check network, the Api key  or try again later" }
        
    
        return  { "truth":True, "api_key": api_key  , "username": username, "status": "Successfully Saved Api key"  }

    except Exception as e:
        return { "truth":False, "api_key": api_key , "username": username, "status": "Error, Check network, the Api key  or try again later" }
    






class TrackNumber:
    
    def __init__(self, api_key: str):
        self.browser = None
        self.api_key = api_key
    

    def is_google_maps_api_key_valid(self) -> bool:
        search_url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        params = {
            'query': 'test',  # Use a simple query for testing purposes
            'key': self.api_key
        }
        
        response = requests.get(search_url, params=params)       
        if response.status_code != 200:
            return False

        data = response.json()
        
        # Check for error_message in the response
        if 'error_message' in data:
            return False
        
        return True


    def track_number(self, number):
        if self.is_google_maps_api_key_valid():
            try:      
                task = self.get_place_details(number)
                return task
            except Exception as e:
                print("Network or login Error Exeption")
                print(str(e))
                traceback.print_exc()
                return {"truth": False,  "status": "Unsuccessful, Check network, the api key or try again later",}
                    
        else:
            print("Network or login Error not connect")
            return {"truth": False, "status": "Error, Check network, the api key or try again later"}

    def track_numbers(self, numbers):
        if self.is_google_maps_api_key_valid():
            try:      
                for number in numbers:
                    task = self.get_place_details(number)
                    yield task                
            except Exception as e:
                print("Network or login Error Exeption")
                print(str(e))
                yield {"truth": False, "status": "Unsuccessful, Check network, the login details or try again later"}
                return 
            
        else:
            print("Network or login Error not connect")
            yield {"truth": False, "status": "Error, Check network, the login details or try again later"}
            return
        yield {"truth": False, "status": "successful, Tracking Finished"}
        return
    

    def get_place_details(self, query: str) -> dict:
        # Define the endpoint URL
        search_url = f"https://maps.googleapis.com/maps/api/place/textsearch/json"
        
        # Define the parameters
        params = {
            'query': query,
            'key': self.api_key
        }
        
        # Make the request
        response = requests.get(search_url, params=params)
        results = response.json().get('results')
        
        if results:
            place_id = results[0]['place_id']
            details_url = f"https://maps.googleapis.com/maps/api/place/details/json"
            details_params = {
                'place_id': place_id,
                'key': self.api_key,
                'fields': 'name,rating,formatted_phone_number,formatted_address,opening_hours,review'
            }
            details_response = requests.get(details_url, params=details_params)
            details =  details_response.json().get('result')

            if details:
                working_hours = str()
                rest_days =str()
              
                print(f"Name: {details.get('name')}")
                print(f"Rating: {details.get('rating')}")
                print(f"Phone: {details.get('formatted_phone_number')}")
                print(f"Address: {details.get('formatted_address')}")
                if 'opening_hours' in details:
                    print("Opening Hours:")
                    
                    for day in details['opening_hours']['weekday_text']:
                        if "Closed" in day:
                            rest_days += "\n" + day
                        else: 
                            working_hours += "\n" + day
                        
                        print(day)
                if 'reviews' in details:
                    print("Reviews:", len(details['reviews']))
                result = { "working_hours" : working_hours if 'opening_hours' in details else "None", "rest_days" : rest_days if len(rest_days) > 0 else "None", "reviews" : str(len(details['reviews'])) if 'reviews' in details else "None", "formatted_address" : details.get('formatted_address') if 'formatted_address' in details else "None", "rating": details.get('rating') if 'rating' in details else "None", "name" : details.get('name') if 'name' in details else "None" , 'TrackOn': str(datetime.now().strftime("%A, %B %d %Y %I:%M%p"))}
            else:
                print(f"No details found for {query}\n")
                result = { "working_hours" :  "None", "rest_days" :  "None", "reviews" :  "None", "formatted_address" :  "None", "rating":  "None", "name" :  "None", 'TrackOn': str(datetime.now().strftime("%A, %B %d %Y %I:%M%p")) }
        
            done = {'truth' : True , 'number': query}
            return {**result , **done}
        return {'truth' : False , 'number': query}









# if __name__ == "__main__":
    # API_KEY = 'AIzaSyCrsPuSjHfNY-TdEt9RyJR73UuYUDQu6Ek'
    # # start = time.perf_counter()
    # # tracking_numbers = ['0942392338', '0942268020', '0942270380', '0942271919','0942260030']


    # tracker = TrackNumber(API_KEY)
   


    # # for result in tracker.track_numbers(tracking_numbers):
    # #     print(result)

    # # finish = time.perf_counter()
    # # print(finish - start)
    
    # result = tracker.track_number('0942392338')
    # print(result)  



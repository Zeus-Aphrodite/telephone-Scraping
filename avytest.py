# from datetime import datetime
import json
import sqlite3
import time

import concurrent.futures

# # Define the function that will be executed with different arguments
# def my_function(argument):
#     # Your function logic here
#     result = f"Result for argument {argument}"
#     time.sleep(1)
#     return result

# # Create a list of arguments
# start = time.perf_counter()
# arguments = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# # Create a thread pool with a maximum of 5 threads
# max_threads = 5
# with concurrent.futures.ThreadPoolExecutor(max_threads) as executor:
#     # Submit the function for each argument in the list
#     futures = {executor.submit(my_function, arg): arg for arg in arguments}

#     # Wait for all futures to complete
#     concurrent.futures.wait(futures)

# # Get the results from the completed futures
# results = [future.result() for future in futures]

# # Now you have the results of the function for all arguments
# for arg, result in zip(arguments, results):
#     print(f"Argument {arg}: {result}")

# finish = time.perf_counter()

# print(finish-start, "sec")

# conn = sqlite3.connect("general.db")
# conn.execute('''CREATE TABLE IF NOT EXISTS formats
#             (id INTEGER PRIMARY KEY,
#              formatName  TEXT NOT NULL,
#              cols TEXT NOT NULL);''')
# conn.commit()
# conn.close()

# print("Done")
# acctNo = "99910501"
# username = "tojugbele"
# password = "rse-ng1"

# conn = sqlite3.connect("general.db")
# cursor = conn.cursor()
# # conn.execute("INSERT INTO formats (formatName, cols ) VALUES (?, ?)", ("Default", json.dumps(["SN", "waybill", "Pod", "PodDate", "Delivered", "lastScanStatus"]),))
# strList = json.dumps(['SN', 'waybill', 'Pod', 'PodDate', 'Delivered', 'LastScanStatus'])
# cursor.execute(f"UPDATE formats SET cols = '{strList}' WHERE formatName = 'Default'")
# conn.commit()
# conn.close()

# print(datetime.now().strftime("%m/%d/%Y %H:%M:%S"))


# # 
# print([1,2,3,4,5,6,7][::-1])

# ken = [1,2,3,4,5,6,7]
# result = []
# for num in range(1, len(ken) + 1):
#     result.append(ken[len(ken) - num])

# print(result)



scrapeData = """'RecipientName': browser.page.find('input', class_='GeneralTextBox', id='txtRecipientName').get("value"),
        'PickupCapturedBy': browser.page.find('input', class_='GeneralTextBox', id='txtOperator').get("value"),
        'AcctNo': browser.page.find('input', class_='GeneralTextBox', id='txtAcctNo').get("value"),
        'PickupDate': browser.page.find('input', class_='SmallLenghtTextBox', id='txtDate').get("value"),
        'SenderName': browser.page.find('input', class_='GeneralTextBox', id='txtSenderName').get("value"),
        'SenderAddress': browser.page.find('textarea', id='txtSenderAddress').text.strip(),
        'RecipientAddress': browser.page.find('textarea', id='txtRecipientAddress').text.strip(),
        'AcctName': browser.page.find('input', class_='GeneralTextBox', id='txtSenderNameR').get("value"),
        'RecipientGsm': browser.page.find('input', class_='GeneralTextBox', id='txtRecipientGsm').get("value"),
        'SenderGsm': browser.page.find('input', class_='GeneralTextBox', id='txtSenderGsm').get("value"),
        'RecipientEmail': browser.page.find('input', class_='GeneralTextBox', id='txtRecipientEmail').get("value"),
        'SenderEmail': browser.page.find('input', class_='GeneralTextBox', id='txtSenderEmail').get("value"),
        'Origin': browser.page.find('input', class_='GeneralTextBox', id='txtOrigin').get("value"),
        'ServiceGroup': browser.page.find('input', class_='GeneralTextBox', id='txtServiceGroup').get("value"),
        'Destination': browser.page.find('input', class_='GeneralTextBox', id='txtDestination').get("value"),
        'Weight': browser.page.find('input', class_='GeneralTextBox', id='txtWeight').get("value"),
        'Pieces': browser.page.find('input', class_='GeneralTextBox', id='txtPieces').get("value"),
        'Description': browser.page.find('textarea', id='txtDescription').text.strip(),
        'DeliveryTown': pickup_information.find_all('td')[3].text.strip(),
        'ContentType': checker[-1][4],
        'LastScanStatus': checker[0][1],
        'LastScanStatusDate': checker[0][2],
        'LastScanStatusBy': checker[0][-1],
        'Pod': seeker[-1][1],
        'PodDate': seeker[-1][2],
        'PodCaptureBy': seeker[-1][-1],
        'Delivered': seeker[-1][1] not in dexes,"""

# print([ i[:i.find(':')].strip()[1:-1] for i in scrapeData.splitlines()])
# model= [ 'SN', 'waybill', 'RecipientName', 'PickupCapturedBy', 'AcctNo', 'PickupDate', 'SenderName', 'SenderAddress', 'RecipientAddress', 'AcctName', 'RecipientGsm', 'SenderGsm', 'Origin', 'ServiceGroup', 'Destination', 'Weight', 'Pieces', 'Description', 'DeliveryTown', 'ContentType', 'LastScanStatus', 'LastScanStatusDate', 'LastScanStatusBy', 'LastScanStation', 'Pod', 'PodDate', 'PodCaptureBy', 'Delivered']

# for i in model:
#     print(f'''
#   ListElelment{{
#           key : "{i}"
#           value : " "
#   }}
# ''')  
# 

text = """


            ListElement {
                key : "SN"
                value : "1"
            }


            ListElement {
                key : "waybill"
                value : "999991234567"
                checked: true
            }


            ListElement {
                key : "RecipientName"
                value : "ADEBAYO EZEKIEL"
                checked: false
            }


            ListElement {
                key : "PickupCapturedBy"
                value : "wemmy"
                checked: false
            }


            ListElement {
                key : "AcctNo"
                value : "2109063632"
                checked: false
            }


            ListElement {
                key : "PickupDate"
                value : "9/20/23 12:36PM"
                checked: false
            }


            ListElement {
                key : "SenderName"
                value : "Ayobami wemimo"
                checked: false
            }


            ListElement {
                key : "SenderAddress"
                value : "2b lalupon, ikoyi"
                 checked: false
            }


            ListElement {
                key : "RecipientAddress"
                checked: false
                value : "14, chris madueke, lekki"
            }


            ListElement {
                key : "AcctName"
                checked: false
                value : "Wemmyneat tech."
            }


            ListElement {
                key : "RecipientGsm"
                checked: false
                value : "08081991843"
            }


            ListElement {
                key : "SenderGsm"
                checked: false
                value : "08144958443"
            }


            ListElement {
                key : "Origin"
                checked: false
                value : "ISL"
            }


            ListElement {
                key : "ServiceGroup"
                checked: false
                value : "I/A"
            }


            ListElement {
                key : "Destination"
                checked: false
                value : "ISL"
            }


            ListElement {
                key : "Weight"
                checked: false
                value : "3.0"
            }


            ListElement {
                key : "Pieces"
                checked: false
                value : "1"
            }


            ListElement {
                key : "Description"
                checked: false
                value : " document: proof of ownership"
            }


            ListElement {
                key : "DeliveryTown"
                checked: false
                value : "DOC"
            }


            ListElement {
                key : "ContentType"
                checked: false
                value : "DOCUMENT"
            }


            ListElement {
                key : "LastScanStatus"
                checked: false
                value : "With Delivery Courier"
            }


            ListElement {
                key : "LastScanStatusDate"
                checked: false
                value : "9/25/23 10:05AM"
            }


            ListElement {
                key : "LastScanStatusBy"
                checked: false
                value : "ISL203"
            }


            ListElement {
                key : "LastScanStation"
                checked: false
                value : "ISL"
            }


            ListElement {
                key : "Pod"
                checked: false
                value : "ESTHER ADEBAYO"
            }


            ListElement {
                key : "PodDate"
                checked: false
                value : "9/25/23 10:05AM"
            }


            ListElement {
                key : "PodCaptureBy"
                checked: false
                value : "ISL203"
            }


            ListElement {
                key : "Delivered"
                checked: false
                value : "TRUE/FALSE"
            }


        
""" 
# word = str()
# for i in text.split("}"):
#     para = i.strip().splitlines()[1:]
#     for key in para:
#         word += key[key.find(":") +1:] + "\n"
# word = word.replace("false", "")
# word = word.replace("true", "")
# word = word.replace("\n", "")
# # print(word)
# for i in word.splitlines():
#     print(i)

array = [1,2,3,4,5]
    
print(array[1:])
    

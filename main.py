import pandas as pd
import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
from bs4 import BeautifulSoup
import requests
import re
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from fake_useragent import UserAgent
import random
import pandas as pd
import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
from bs4 import BeautifulSoup
import requests
import re
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from fake_useragent import UserAgent
import random
from tabulate import tabulate
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from selenium.webdriver.common.proxy import Proxy, ProxyType
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.remote.webelement import WebElement
import re


window = tk.Tk()
window.title("Phone Number Search")
window.geometry("1200x600")

dataframe = None

def import_phone_numbers(file_path):
    global dataframe
    if file_path.endswith('.csv'):
        dataframe = pd.read_csv(file_path, header=None, na_filter=False)
        column_count = len(dataframe.columns)
        if column_count < 4:
            for i in range(column_count, 4):
                dataframe[i] = ""
        dataframe.to_csv(file_path, index=False, header=False)  # Update the CSV file
        dataframe.rename(columns={0: 'Phone Number', 1: 'Business Hours', 2: 'Rest Day', 3: 'Review'}, inplace=True)
        dataframe['Phone Number'] = dataframe['Phone Number'].astype(str).str.split('.').str[0]
        dataframe['Phone Number'] = dataframe['Phone Number'].apply(lambda x: '0' + str(x))
        dataframe['Business Hours'] = dataframe['Business Hours'].astype(str)
        dataframe['Rest Day'] = dataframe['Rest Day'].astype(str)
        dataframe['Review'] = dataframe['Review'].astype(str)
    elif file_path.endswith('.xlsx'):
        dataframe = pd.read_excel(file_path, header=None, na_filter=False)
        column_count = len(dataframe.columns)
        if column_count < 4:
            for i in range(column_count, 4):
                dataframe[i] = ""
        dataframe.to_excel(file_path, index=False, header=False)  # Update the Excel file
        dataframe.rename(columns={0: 'Phone Number', 1: 'Business Hours', 2: 'Rest Day', 3: 'Review'}, inplace=True)
        dataframe['Phone Number'] = dataframe['Phone Number'].astype(str).str.split('.').str[0]
        dataframe['Phone Number'] = dataframe['Phone Number'].apply(lambda x: '0' + str(x))
        dataframe['Business Hours'] = dataframe['Business Hours'].astype(str)
        dataframe['Rest Day'] = dataframe['Rest Day'].astype(str)
        dataframe['Review'] = dataframe['Review'].astype(str)
    else:
        raise ValueError("Invalid file format. Only CSV (.csv) files are supported.")
    return dataframe

def check_for_date(index,html_str):
  DATE_LEN = 5
  #5 chars in time string
  unprocessed_str = html_str[index:index+DATE_LEN]
  if(len(unprocessed_str) != DATE_LEN):
    return ""
   
  int_str = unprocessed_str[:2]+ unprocessed_str[2+1:]
  if(unprocessed_str[2] == ':'):
    for integer in int_str:
      try:
        int(integer)
      except:
        return ""
  return unprocessed_str
  pass

def perform_google_search(phone_numbers):
    results = {}
    for i, number in enumerate(phone_numbers['Phone Number']):
        # if i % 40 == 0 and i > 0:  # Every 40 requests
        #     time.sleep(60)  # Sleep for 60 seconds
        query = f"{number}"
        business_hours = None
        days_of_week = None
        reviews = None
                
        # Bypass Google Captcha
        options = Options()
        ua = UserAgent()

        # Change the user agent on each request
        options.add_argument(f'user-agent={ua.random}')

        driver = webdriver.Chrome(options=options)
        driver.set_window_size(1000, 800)
        driver.implicitly_wait(10)
        
        driver.get(f"https://www.google.com/search?q={query}")
        time.sleep(15)

        # Check if the current URL contains 'google.com'
        if 'google.com/sorry' in driver.current_url:
            # Force replace the current URL to the search query URL
            driver.get(f"https://www.google.com/search?q={query}")
            time.sleep(15)

        try:
            span = driver.find_element(By.CSS_SELECTOR, 'span.BTP3Ac')
            span.click()
        except NoSuchElementException:
            span = None

        try:
            svg = driver.find_element(By.CSS_SELECTOR, 'svg.ab65Ie')
            y = svg.location['y']
            window_height = driver.execute_script('return window.innerHeight')
            scroll_height = y - window_height / 2
            driver.execute_script(f"window.scrollTo(0, {scroll_height})")
            time.sleep(3)
            svg.click()
        except NoSuchElementException:
            svg = None


        if span:
            table = driver.find_element(By.CSS_SELECTOR, 'table.WgFkxc')
            tbody = table.find_element(By.TAG_NAME, 'tbody')
            tr_elements = tbody.find_elements(By.TAG_NAME, 'tr')
            
            a = driver.find_element(By.CSS_SELECTOR, 'a[jsaction="FNFY6c"]')
            span = a.find_element(By.TAG_NAME, 'span')

            span_text = span.text.split(" ")
            review_text = span_text[1].split(" ")
            start = review_text[0].find('（') + 1
            end = review_text[0].find('）')
            reviews = review_text[0][start:end]

            for tr in tr_elements:
                row = tr.text.splitlines()
                if len(row) > 1:  # Check if 'row' has at least two
                    hours = row[2]
                    if(re.search(r'\d', hours)):
                        if(re.search(r',', hours)):
                            business_hours = hours
                            break
                        else:
                            business_hours = hours
                            break

            for tr in tr_elements:
                row = tr.text.splitlines()
                print(len(row))
                print(row)
                if len(row) > 2:  # Check if 'row' has at least three elements
                    days = row[2]
                    print(days)
                    if not re.search(r'\d', days):  # Check if 'hours' does not contain any digits
                        days_of_week = row[0]
                        break
                else:
                    print("Else")
                    item = row[0]
                    if ' ' in item:  # Check if the first item contains a space
                        split_items = item.split(' ')
                        if len(split_items) > 1:  # Check if there are at least two items after splitting
                            second_item = split_items[1]
                            if not re.search(r'\d', second_item):  # Check if 'hours' does not contain any digits
                                days_of_week = second_item
                                break

            results[number] = {
                'Business Hours': business_hours,
                'Rest Day': days_of_week,
                'Review': reviews
            }

        elif svg:
            table = driver.find_element(By.CSS_SELECTOR, 'table.ADwNpc')
            tr_elements = table.find_elements(By.TAG_NAME, 'tr')
            span = driver.find_element(By.CSS_SELECTOR, 'span.RDApEe.YrbPuc')
            reviews = span.text.strip("()")

            for tr in tr_elements:
                row = tr.text.splitlines()
                if len(row) > 1:  # Check if 'row' has at least two
                    hours = row[2]
                    if(re.search(r'\d', hours)):
                        if(re.search(r',', hours)):
                            business_hours = hours
                            break
                        else:
                            business_hours = hours
                            break

            for tr in tr_elements:
                row = tr.text.splitlines()
                print(len(row))
                print(row)
                if len(row) > 2:  # Check if 'row' has at least three elements
                    days = row[2]
                    print(days)
                    if not re.search(r'\d', days):  # Check if 'hours' does not contain any digits
                        days_of_week = row[0]
                        break
                else:
                    print("Else")
                    item = row[0]
                    if ' ' in item:  # Check if the first item contains a space
                        split_items = item.split(' ')
                        if len(split_items) > 1:  # Check if there are at least two items after splitting
                            second_item = split_items[1]
                            if not re.search(r'\d', second_item):  # Check if 'hours' does not contain any digits
                                days_of_week = second_item
                                break

            results[number] = {
                'Business Hours': business_hours,
                'Rest Day': days_of_week,
                'Review': reviews
            }
        else:
            days_of_week = "Not Available"
            business_hours = "Not Available"
            reviews = "0"
            print("Not available")

            results[number] = {
                'Business Hours': business_hours,
                'Rest Day': days_of_week,
                'Review': reviews
            }
        time.sleep(random.randint(5, 15))
    return results

def export_results(results, file_path):
    data = pd.read_csv(file_path)
    data[['Business Hours', 'Rest Day']] = data['Phone Number'].map(results)
    data.to_csv(file_path, index=False)

def update_csv(results, file_path):
    global dataframe
    if file_path.endswith('.csv'):
        for number in dataframe['Phone Number']:
            values = results.get(number, {'Business Hours': '', 'Rest Day': '', 'Review': ''})
            dataframe.loc[dataframe['Phone Number'] == number, 'Business Hours'] = values['Business Hours']
            dataframe.loc[dataframe['Phone Number'] == number, 'Rest Day'] = values['Rest Day']
            dataframe.loc[dataframe['Phone Number'] == number, 'Review'] = values['Review']
        dataframe.to_csv(file_path, index=False, header=False)
    elif file_path.endswith('.xlsx'):
        for number in dataframe['Phone Number']:
            values = results.get(number, {'Business Hours': '', 'Rest Day': '', 'Review': ''})
            dataframe.loc[dataframe['Phone Number'] == number, 'Business Hours'] = values['Business Hours']
            dataframe.loc[dataframe['Phone Number'] == number, 'Rest Day'] = values['Rest Day']
            dataframe.loc[dataframe['Phone Number'] == number, 'Review'] = values['Review']
        dataframe.to_excel(file_path, index=False, header=False)

def select_file():
    file_path = filedialog.askopenfilename(filetypes=[("CSV Files", "*.csv"), ("XLSX Files", "*.xlsx")])
    file_entry.delete(0, tk.END)
    file_entry.insert(0, file_path)
    import_phone_numbers(file_path)
    display_data()

def display_data():
    global dataframe
    table.delete('1.0', tk.END)
    table.insert(tk.END, tabulate(dataframe, headers='keys', tablefmt='plain'))

def perform_search():
    if dataframe is None:
        search_single_number()
    else:
        file_path = file_entry.get()
        if not file_path:
            messagebox.showerror("Error", "Please select a file.")
            return
        try:
            phone_numbers = import_phone_numbers(file_path)
            search_results = perform_google_search(phone_numbers)
            update_csv(search_results, file_path)
            display_data()
            messagebox.showinfo("Success", "Search completed and results added to the CSV.")
        
        except Exception as e:
            print(e)
            messagebox.showerror("Error", str(e))

def search_single_number():
    number = file_entry.get()
    
    if not number:
        messagebox.showerror("Error", "Please enter a phone number.")
        return
    
    try:
        phone_numbers = pd.DataFrame({'Phone Number': [number]})
        search_results = perform_google_search(phone_numbers)
        messagebox.showinfo("Success", "Search completed.")
        output_file = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV Files", "*.csv")])
        export_results(search_results, output_file)
        messagebox.showinfo("Success", "Search completed and results exported.")
    except Exception as e:
        messagebox.showerror("Error", str(e))


file_label = tk.Label(window, text="Select File:")
file_label.pack()

file_entry = tk.Entry(window, width=120)
file_entry.pack()

file_button = tk.Button(window, text="Import CSV or XLSX", command=select_file)
file_button.pack()

search_button = tk.Button(window, text="Perform Search", command=perform_search)
search_button.pack()

table_frame = tk.Frame(window)
table_frame.pack()

table_label = tk.Label(table_frame, text="Table Data:")
table_label.pack()

table = tk.Text(table_frame, height=10, width=100)
table.pack()

window.mainloop()


import time
import mechanicalsoup
from Dexes import dexes


def login_and_create_session():
    print("Logging in")
    start = time.perf_counter()
    browser = mechanicalsoup.StatefulBrowser()

    # Set the URL of the login page and open it
    login_url = 'https://web.redstarplc.com:8445/Login.aspx'  # Replace with the actual login URL
    browser.open(login_url)

    # Fill in the login form (modify these lines according to the website's form fields)
    form = browser.select_form()
    browser['txtAccountNo'] = '99910501'
    browser['txtUserID'] = 'tojugbele'
    browser['txtPassword'] = 'rse-ng1'

    submit = browser.page.find('input', class_='btn btn-primary btn-block btn-flat bg-blue')
    form.choose_submit(submit)

    # Submit the form to log in
    browser.submit_selected()
    finish = time.perf_counter()
    print("Logging finish in :", finish - start)

    return browser


def scrape_tracking_number(browser, tracking_number):
    print("tracking: ", tracking_number)

    start = time.perf_counter()

    browser.select_form()
    form = browser.select_form('form[action="./AwbTrackerNew.aspx"]')
    browser['ctl00$ContentPlaceHolder1$txtSearchBox'] = tracking_number
    form.choose_submit('ctl00$ContentPlaceHolder1$BtnViewD')
    browser.get_current_page()
    response = browser.submit_selected()
    pickup_information = browser.page.find('table',
                                           class_='table table-bordered table-striped dataTable',
                                           id='ContentPlaceHolder1_GridPickup')
    last_scan = browser.page.find('table', class_='table table-bordered table-striped dataTable',
                                  id='ContentPlaceHolder1_GridScan')
    pod = browser.page.find('table', class_='table table-bordered table-striped dataTable',
                            id='ContentPlaceHolder1_GridPod')
    browser.open("https://web.redstarplc.com:8445/Scans-Manifest/AwbTrackerDet.aspx?")
    browser.select_form('form[action="./AwbTrackerDet.aspx"]')
    checker = [[i.text.strip() for i in row.find_all('td')] for row in last_scan.find_all('tr')[1:]]
    seeker = [[i.text.strip() for i in row.find_all('td')] for row in pod.find_all('tr')[1:]]

    scrapeData = {
        'RecipientName': browser.page.find('input', class_='GeneralTextBox', id='txtRecipientName').get("value"),
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
        'Delivered': seeker[-1][1] not in dexes,
    }


    finish = time.perf_counter()
    print("finish trackining :", tracking_number, finish - start)

    return scrapeData


def scrape_tracking_numbers(browser, tracking_numbers):
    browser.get_current_page()
    browser.follow_link("Scans-Manifest/AwbTrackerNew.aspx")
    results = []

    for tracking_number in tracking_numbers:
        browser.open("https://web.redstarplc.com:8445/Scans-Manifest/AwbTrackerNew.aspx")
        task = scrape_tracking_number(browser, tracking_number)
        results.append(task)

    # Print the results
    for result in results:
        print(result)


def main():
    # Login and create a session
    browser = login_and_create_session()

    # List of tracking numbers to scrape
    tracking_numbers = [999998802324, 999998802325, 999998802326, 999998802327, 999998802328, 999998802329,
                        999998802351, 999998802352, 999998802353, 999998802354, 999998802355, 999998802356,
                        999998802357, 999998802358, 999998802359, 999998802360,
                        999998802330, 999998802331, 999998802332, 999998802333, ]

    tracking_numbers = [999998744910, 999998641843]
    # Scrape tracking data and store it
    scrape_tracking_numbers(browser, tracking_numbers)

    # Close the browser and session
    browser.close()

    # Print or store the scraped data as needed
    # for tracking_number, data, status in scraped_data:
    #     print(f"Tracking Number: {tracking_number}")
    #     print(f"Scraped Data: {data} and {status}")


if __name__ == '__main__':
    start = time.perf_counter()
    main()
    finish = time.perf_counter()
    print(finish - start)



    #KEEP FOR ME INCASE
    """

    def track_shipments(self, tracking_numbers):
        if self.connect():
            try:      
                for tracking_number in tracking_numbers:
                    self.browser.open("https://web.redstarplc.com:8445/Scans-Manifest/AwbTrackerNew.aspx")
                    task = self.track(tracking_number)
                    yield task
            except Exception as e:
                print("Network or login Error Exeption")
                print(str(e))
        else:
            print("Network or login Error not connect")
            pass # Emit something
    """

from sqlalchemy.orm import declarative_base
from sqlalchemy import Boolean, Column, Integer, String, create_engine
from datetime import datetime, timedelta


Base1 = declarative_base()
Base2 = declarative_base()
Base3 = declarative_base()
Base4 = declarative_base()

class TrackModel(Base1):
    __tablename__ = 'track_table'

    id = Column(Integer, primary_key=True)
    working_hours = Column(String)
    reviews = Column(String)
    formatted_address = Column(String)
    rating= Column(String)
    name = Column(String)
    SN= Column(Integer)
    truth= Column(Boolean)
    number= Column(String)
    TrackOn= Column(String)

    # Add more columns here...


class HistoryModel(Base2):
    __tablename__ = 'history'

    id = Column(Integer, primary_key=True)
    mode = Column(String)
    address= Column(String)
    completed= Column(Boolean)
    total= Column(Integer) 
    progress= Column(Integer) 
    name= Column(String) 
    timestamp = Column(String)
    last_updated= Column(String) 
    number = Column(String) 



class LoginModel(Base3):
    __tablename__ = 'logins'

    id = Column(Integer, primary_key=True)
    api_key = Column(String)
    username = Column(String)
    timestamp = Column(String)
   

class FormatModel(Base4):
    __tablename__ = 'formats'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    cols = Column(String)


   


def categorize_date(date_str):
    today = datetime.now().date()
    yesterday = today - timedelta(days=1)
    earlier_this_week = today - timedelta(days=today.weekday())
    
    # Calculate the date one week ago
    one_week_ago = today - timedelta(weeks=1)
    
    # Calculate the start of the current year
    start_of_year = today.replace(month=1, day=1)
    
    # Calculate the start of the previous year
    start_of_last_year = (today - timedelta(days=1)).replace(year=today.year-1, month=1, day=1)
    
    # Calculate the start of the current month
    start_of_month = today.replace(day=1)
    
    # Calculate the start of the previous month
    if start_of_month.month == 1:
        start_of_last_month = start_of_month.replace(year=start_of_month.year-1, month=12)
    else:
        start_of_last_month = start_of_month.replace(month=start_of_month.month-1)
    
    # Define the format string for the input date format
    input_format = "%A, %B %d %Y %I:%M%p" 
    
    date = datetime.strptime(date_str, input_format).date()

    if date == today:
        return 'Today'
    elif date == yesterday:
        return 'Yesterday'
    elif date >= earlier_this_week:
        return 'Earlier this week'
    elif date >= one_week_ago:
        return 'Last week'        
    elif date >= start_of_month:
        return 'This month'
    elif date >= start_of_last_month:
        return 'Last month'
    elif date >= start_of_year:        
        return 'Earlier this year'
    elif date >= start_of_last_year:
        return 'Last year' 
    else:
        return 'Long time ago'

# engine = create_engine('sqlite:///general.db')

# HistoryModel.metadata.create_all(engine)

# print("Done")

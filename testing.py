from datetime import datetime, timedelta

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
    input_format = '%A, %B %d %Y %I:%M%p'
    
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





# Example usage:
date_str = 'Saturday, May 28 2022 05:44AM'
category = categorize_date(date_str)
print(f'This date is categorized as: {category}')

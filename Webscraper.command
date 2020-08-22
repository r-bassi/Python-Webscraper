#!/Users/r-bassi/Documents/GitHub/Python-Webscraper/env/bin/python

from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup
import subprocess


# Makes an http get request, returns HTML/XML text if possible, else returns None.
def simple_get(url):
    try:
        with closing(get(url, stream=True)) as resp:
            if is_good_response(resp):
                return resp.content
            else:
                return None

    except RequestException as e:
        log_error('Error during requests to {0} : {1}'.format(url, str(e)))
        return None


# Returns true if response is in HTML, else false.
def is_good_response(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)


# Prints errors
def log_error(e):
    print(e)


# Downloads page of quotes and returns the main page quotes.
def get_quotes():
    url = 'http://quotes.toscrape.com/'
    response = simple_get(url)

    if response is not None:
        html = BeautifulSoup(response, 'html.parser')
        quotes = html.find_all('span', class_='text')
        for quotes in quotes:
            print(quotes.text, end='\n' * 2)
    else:
        # Raise an exception if we failed to get any data from the url
        raise Exception('Error retrieving contents at {}'.format(url))

get_quotes()
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium import webdriver
import pandas as pd
import os
from selenium.webdriver.firefox.options import Options
options = FirefoxOptions()
options.add_argument("--headless")
CURR_DIR = os.path.dirname(os.path.realpath(__file__))

url = 'file://'+CURR_DIR+'/report.html#totals'
print(url)
driver = webdriver.Firefox(options=options)
driver.get(url)

# --- get table ---

all_tables = pd.read_html(driver.page_source, attrs={'id': 'test-details'})
df = all_tables[0]
df.to_excel("report.xlsx")
# --- show it ---
#df['Name'][1]
#count=len(df['× Tags'])
#print(count)

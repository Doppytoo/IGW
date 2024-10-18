from selenium import webdriver
from datetime import datetime


start = datetime.now()

options = webdriver.FirefoxOptions()
options.add_argument("--headless")
# options.add_experimental_option("excludeSwitches", ["enable-logging"])
driver = webdriver.Firefox(options=options)

print(datetime.now() - start)

for i in range(60):
    driver.get("https://www.google.com")
    #! Use Navigation Timing  API to calculate the timings that matter the most
    navigation_start = driver.execute_script(
        "return window.performance.timing.navigationStart"
    )
    response_start = driver.execute_script(
        "return window.performance.timing.responseStart"
    )
    dom_complete = driver.execute_script("return window.performance.timing.domComplete")

    #! Calculate the performance
    backend_performance = response_start - navigation_start
    frontend_performance = dom_complete - response_start

    print("Back End: %s" % backend_performance)
    print("Front End: %s" % frontend_performance)

print(datetime.now() - start)

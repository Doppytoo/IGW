import requests
from time import time

start = time()
requests.get("https://academy.dpomipk.ru/probe")
end = time()

print(end - start)

response = requests.get(
    "http://10.10.10.245:9090/api/v1/query?query=probe_duration_seconds"
)
response.raise_for_status()

data = response.json()["data"]["result"]

results = {site["metric"]["instance"]: float(site["value"][1]) for site in data}

print(results["https://academy.dpomipk.ru"])

import os
import json
import pandas as pd

# Current working directory
cwd = os.getcwd()
print(f"Current working directory: {cwd}")

# JSON file path
json_file = os.path.join(cwd, "complexes.json")

# Read JSON file
try:
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print("❌ complexes.json file not found")
    exit()

complexes = []
venues = []

for comp in data.get("complexes", []):
    complex_id = comp.get("id")
    complexes.append({
        "complex_id": complex_id,
        "complex_name": comp.get("name")
    })

    for venue in comp.get("venues", []):
        venues.append({
            "venue_id": venue.get("id"),
            "venue_name": venue.get("name"),
            "city_name": venue.get("city_name"),
            "country_name": venue.get("country_name"),
            "country_code": venue.get("country_code"),
            "timezone": venue.get("timezone"),
            "complex_id": complex_id
        })

# Save CSV files
pd.DataFrame(complexes).to_csv("complexes.csv", index=False)
pd.DataFrame(venues).to_csv("venues.csv", index=False)

print("✅ Complexes and Venues data extracted successfully")
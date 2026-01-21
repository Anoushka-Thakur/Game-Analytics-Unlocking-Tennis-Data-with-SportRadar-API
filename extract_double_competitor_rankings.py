import os
import json
import pandas as pd

# Check current directory
cwd = os.getcwd()
print(f"Current working directory: {cwd}")

json_file = os.path.join(cwd, "double_competitor_rankings.json")

try:
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print("❌ double_competitor_rankings.json file not found")
    exit()

rankings_data = []

for item in data.get("rankings", []):
    competitor = item.get("competitor", {})
    rankings_data.append({
        "competitor_id": competitor.get("id"),
        "name": competitor.get("name"),
        "country": competitor.get("country"),
        "country_code": competitor.get("country_code"),
        "abbreviation": competitor.get("abbreviation"),
        "rank": item.get("rank"),
        "points": item.get("points")
    })

output_csv = os.path.join(cwd, "double_competitor_rankings.csv")
pd.DataFrame(rankings_data).to_csv(output_csv, index=False)

print("✅ Doubles competitor rankings extracted successfully")
print(f"CSV file created: {output_csv}")
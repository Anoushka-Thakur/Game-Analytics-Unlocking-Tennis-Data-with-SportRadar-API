import os
import pandas as pd
import json

# Current working directory check karo
cwd = os.getcwd()
print(f"Current working directory: {cwd}")

# JSON file ka path (same folder me hai)
json_file = os.path.join(cwd, "competitions.json")

# JSON file read karo
try:
    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)
except FileNotFoundError:
    print(f"❌ Error: '{json_file}' file nahi mili. Check karo ke JSON file correct folder me hai.")
    exit()

# Data extract karna
competitions = []
categories = []

for comp in data.get("competitions", []):
    category = comp.get("category", {})
    categories.append({
        "category_id": category.get("id"),
        "category_name": category.get("name")
    })
    competitions.append({
        "competition_id": comp.get("id"),
        "competition_name": comp.get("name"),
        "parent_id": comp.get("parent_id"),
        "type": comp.get("type"),
        "gender": comp.get("gender"),
        "category_id": category.get("id")
    })

# CSV me save karo
categories_csv = os.path.join(cwd, "categories.csv")
competitions_csv = os.path.join(cwd, "competitions.csv")

pd.DataFrame(categories).to_csv(categories_csv, index=False)
pd.DataFrame(competitions).to_csv(competitions_csv, index=False)

print(f"✅ Data successfully extracted!")
print(f"Categories CSV: {categories_csv}")
print(f"Competitions CSV: {competitions_csv}")
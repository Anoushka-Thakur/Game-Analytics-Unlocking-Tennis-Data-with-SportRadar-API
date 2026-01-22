#  Tennis Analytics System: A Data-Driven Dashboard

### Overview

Tennis Insights is a sports data analytics project that extracts, structures, and analyzes professional tennis data sourced from the SportRadar Tennis API. The project transforms raw JSON responses into structured CSV datasets suitable for SQL analysis and interactive visualization using Streamlit.

### Key Objectives

Convert complex tennis API data into analysis-ready tabular format
Design a relational data structure for competitions, venues, and rankings
Enable analytical insights through SQL and dashboard visualization

### Data & Files

JSON files: Raw API-style responses
competitions.json, complexes.json, double_competitor_rankings.json

CSV files: Processed, SQL-ready datasets
categories.csv, competitions.csv, complexes.csv, venues.csv, double_competitor_rankings.csv

### Data Extraction

Python scripts are used to parse and flatten nested JSON data:
extract_competitions.py
extract_complex.py
extract_double_competitor_rankings.py

Each script converts raw data into structured CSV files.

### Analytics & Dashboard

SQL queries support competition analysis, venue distribution, and ranking insights
A Streamlit dashboard (developed separately) provides interactive filters, metrics, and leaderboards

### Tech Stack
Layer      	        Technology
Database   	        SQLite3
Backend   	        Python
Data Formats	      CSV, JSON
Version Control   	Git & GitHub
IDE                 VS Code

### Note
API access may vary based on key permissions. Data processing follows SportRadar’s documented response structure.# Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API


### Streamlit Application

Built an interactive Streamlit dashboard connected to SQLite.

Features Implemented

### Homepage KPIs:

1. Total competitors

2. Countries represented

3. Best / top rankings

### Interactive tables:

1. Leaderboards

2. Country‑wise analysis

### Filters & search:

1. Search competitors by name

2. Rank‑based filtering

### Tennis-data-insights-app
[![Streamlit App](https://game-analytics-unlocking-tennis-data-with-sportsradar-api.streamlit.app)

### Project Screenshots

### Dashboard Overview
![Dashboard](screenshot/Screenshot%20(507).png)

### Data Analysis
![Analysis](screenshot/Screenshot%20(519).png)

### Project Members

#### Kumari Akanksha

1. Data extraction

2. Data sourcing and preprocessing

#### Anoushka Thakur

1. SQL queries and analytics

2. Streamlit application development

#### Sanjeev Raj T

1. Project documentation

2. README and report preparation


### How to Run the Project

1. Clone the Repository
git clone https://github.com/Anoushka-Thakur/Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API.git
cd Game-Analytics-Unlocking-Tennis-Data-with-SportRadar-API

2. Run Data Extraction Scripts
python extract_competitions.py
python extract_complex.py
python extract_double_competitor_rankings.py

3. Load CSVs into SQL Database
Import the generated CSV files into MySQL or PostgreSQL for analysis.

4. Launch Streamlit App
streamlit run app.py

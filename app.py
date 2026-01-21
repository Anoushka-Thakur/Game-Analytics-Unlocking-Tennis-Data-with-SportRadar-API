import streamlit as st
import pandas as pd
import pyodbc
import matplotlib.pyplot as plt

# ----------------------------
# SQL Server Connection
# ----------------------------

def get_connection():
    return pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=localhost;"
        "DATABASE=master;"
        "Trusted_Connection=yes;"
    )

# ----------------------------
# Page Config
# ----------------------------

st.set_page_config(page_title="Tennis Analytics Dashboard", layout="wide")
st.title("🎾 Tennis Game Analytics Dashboard")

conn = get_connection()

st.markdown(
    """
    <style>
    /* Background image */
    .stApp {
        background-image: url("https://in.pinterest.com/pin/19914423347483652/.jpg");
        background-size: cover;
        background-repeat: no-repeat;
        background-attachment: fixed;
    }

    /* Headings and subheaders */
    h1, h2, h3, h4, h5, h6, .css-1v3fvcr, .css-1d391kg, .css-18ni7ap {
        color: black !important;
        font-weight: bold;
    }

    /* SQL code blocks */
    .stCodeBlock, pre {
        color: black !important;
        background-color: rgba(255,255,255,0.85) !important;
        border-radius: 5px;
    }

    /* KPI cards */
    .stMetric {
        background-color: black !important;
        color: yellow !important;
        border-radius: 10px;
        padding: 10px;
    }

    /* Tables: slightly transparent */
    .stDataFrame div.row_widget.stDataFrame div {
        background-color: rgba(255,255,255,0.85);
        border-radius: 5px;
    }

    /* Buttons */
    button.stButton {
        background-color: rgba(255, 255, 0, 0.85);
        color: black;
        font-weight: bold;
    }
    </style>
    """,
    unsafe_allow_html=True
)
# ==================================================
# 1️⃣ HOMEPAGE DASHBOARD – SUMMARY STATISTICS
# ==================================================

st.header("📊 Homepage Dashboard")


kpi_query = """
SELECT 
    COUNT(DISTINCT c.competitor_id) AS total_competitors,
    COUNT(DISTINCT c.country) AS total_countries,
    MAX(r.points) AS highest_points
FROM dbo.competitors c
JOIN dbo.competitor_rankings r
ON c.competitor_id = r.competitor_id;
"""

kpi_df = pd.read_sql(kpi_query, conn)

col1, col2, col3 = st.columns(3)
col1.metric("Total Competitors", kpi_df.loc[0, 'total_competitors'])
col2.metric("Countries Represented", kpi_df.loc[0, 'total_countries'])
col3.metric("Highest Points", kpi_df.loc[0, 'highest_points'])

# ==================================================
# 2️⃣ SEARCH & FILTER COMPETITORS
# ==================================================

st.header("🔍 Search & Filter Competitors")

# Filters
countries = pd.read_sql("SELECT DISTINCT country FROM dbo.competitors", conn)['country']
selected_country = st.selectbox("Filter by Country", ["All"] + list(countries))

rank_min, rank_max = st.slider("Rank Range", 1, 200, (1, 50))
points_threshold = st.number_input("Minimum Points", min_value=0, value=0)
search_name = st.text_input("Search Competitor by Name")

filter_query = f"""
SELECT c.name, c.country, r.rank, r.points
FROM dbo.competitors c
JOIN dbo.competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE r.rank BETWEEN {rank_min} AND {rank_max}
AND r.points >= {points_threshold}
"""

if selected_country != "All":
    filter_query += f" AND c.country = '{selected_country}'"

if search_name:
    filter_query += f" AND c.name LIKE '%{search_name}%'"

filtered_df = pd.read_sql(filter_query, conn)
st.dataframe(filtered_df, use_container_width=True)

# ==================================================
# 3️⃣ COMPETITOR DETAILS VIEWER
# ==================================================

st.header("👤 Competitor Details Viewer")

competitor_list = pd.read_sql("SELECT name FROM dbo.competitors ORDER BY name", conn)['name']
selected_competitor = st.selectbox("Select a Competitor", competitor_list)

if selected_competitor:
    details_query = f"""
SELECT c.name,
       c.country,
       r.rank,
       r.points
FROM dbo.competitors c
JOIN dbo.competitor_rankings r
ON c.competitor_id = r.competitor_id
WHERE c.name = '{selected_competitor}';
"""


    details_df = pd.read_sql(details_query, conn)
    st.table(details_df)

# ==================================================
# 4️⃣ COUNTRY-WISE ANALYSIS
# ==================================================

st.header("🌍 Country-Wise Analysis")

country_analysis_query = """
SELECT c.country,
       COUNT(*) AS total_competitors,
       AVG(r.points) AS avg_points
FROM dbo.competitors c
JOIN dbo.competitor_rankings r
ON c.competitor_id = r.competitor_id
GROUP BY c.country
ORDER BY total_competitors DESC;
"""

country_df = pd.read_sql(country_analysis_query, conn)
st.dataframe(country_df, use_container_width=True)

# ==================================================
# 5️⃣ LEADERBOARDS
# ==================================================

st.header("🏆 Leaderboards")

col1, col2 = st.columns(2)

with col1:
    st.subheader("Top Ranked Competitors")
    top_ranked_query = """
    SELECT c.name, c.country, r.rank, r.points
    FROM dbo.competitors c
    JOIN dbo.competitor_rankings r
    ON c.competitor_id = r.competitor_id
    ORDER BY r.rank ASC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
    """
    st.dataframe(pd.read_sql(top_ranked_query, conn), use_container_width=True)

with col2:
    st.subheader("Highest Points Competitors")
    highest_points_query = """
    SELECT c.name, c.country, r.rank, r.points
    FROM dbo.competitors c
    JOIN dbo.competitor_rankings r
    ON c.competitor_id = r.competitor_id
    ORDER BY r.points DESC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
    """
    st.dataframe(pd.read_sql(highest_points_query, conn), use_container_width=True)

conn.close()

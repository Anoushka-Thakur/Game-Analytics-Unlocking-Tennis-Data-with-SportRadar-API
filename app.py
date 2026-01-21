
import streamlit as st
import pandas as pd
import sqlite3
import matplotlib.pyplot as plt

# ------------------------------------
# DATABASE CONNECTION (SQLite)
# ------------------------------------
@st.cache_resource
def get_connection():
    conn = sqlite3.connect("tennis.db", check_same_thread=False)
    return conn

conn = get_connection()

st.set_page_config(page_title="🎾 Tennis Analytics Dashboard", layout="wide")
st.markdown(
    """
    <style>
    /* Background image */
    .stApp {
        background-image: url("https://images.unsplash.com/photo-1505666287802-931dc83948e8");
        background-size: cover;
        background-repeat: no-repeat;
        background-attachment: fixed;
    }

    /* Headings */
    h1, h2, h3, h4, h5, h6 {
        color: black !important;
        font-weight: bold;
    }

    /* Code blocks */
    pre {
        color: black !important;
        background-color: rgba(255,255,255,0.85) !important;
        border-radius: 6px;
        padding: 10px;
    }

    /* KPI cards */
    div[data-testid="metric-container"] {
        background-color: black;
        color: yellow;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
    }

    /* Tables */
    .stDataFrame {
        background-color: rgba(255,255,255,0.85);
        border-radius: 8px;
    }

    /* Buttons */
    button {
        background-color: rgba(255, 255, 0, 0.85) !important;
        color: black !important;
        font-weight: bold !important;
        border-radius: 6px;
    }
    </style>
    """,
    unsafe_allow_html=True
)
# ------------------------------------
# APP TITLE
st.title("🎾 Tennis Analytics System")

# ------------------------------------
# SIDEBAR NAVIGATION
# ------------------------------------
menu = st.sidebar.radio(
    "Navigation",
    [
        "Homepage Dashboard",
        "Search & Filter Competitors",
        "Competitor Details",
        "Country Analysis",
        "Leaderboards"
    ]
)

# ------------------------------------
# 1. HOMEPAGE DASHBOARD
# ------------------------------------
if menu == "Homepage Dashboard":
    st.subheader("📊 Key Metrics")

    col1, col2, col3 = st.columns(3)

    total_competitors = pd.read_sql(
        "SELECT COUNT(*) AS cnt FROM competitors", conn
    )["cnt"][0]

    total_countries = pd.read_sql(
        "SELECT COUNT(DISTINCT country) AS cnt FROM competitors", conn
    )["cnt"][0]

    highest_points = pd.read_sql(
        "SELECT MAX(score) AS max_score FROM competitor_rankings", conn
    )["max_score"][0]

    col1.metric("Total Competitors", total_competitors)
    col2.metric("Countries Represented", total_countries)
    col3.metric("Highest Points", highest_points)

# ------------------------------------
# 2. SEARCH & FILTER COMPETITORS
# ------------------------------------
elif menu == "Search & Filter Competitors":
    st.subheader("🔍 Search & Filter Competitors")

    name = st.text_input("Search by competitor name")
    min_points = st.slider("Minimum Points", 0, 20000, 0)

    query = """
        SELECT
            c.name,
            c.country,
            r.rank,
            r.score
        FROM competitors c
        JOIN competitor_rankings r
            ON c.competitor_id = r.competitor_id
        WHERE c.name LIKE ?
          AND r.score >= ?
        ORDER BY r.rank
    """

    df = pd.read_sql(query, conn, params=[f"%{name}%", min_points])
    st.dataframe(df, use_container_width=True)

# ------------------------------------
# 3. COMPETITOR DETAILS VIEWER
# ------------------------------------
elif menu == "Competitor Details":
    st.subheader("👤 Competitor Details")

    competitors = pd.read_sql(
        "SELECT name FROM competitors ORDER BY name",
        conn
    )

    selected = st.selectbox(
        "Select Competitor",
        competitors["name"]
    )

    details_query = '''
    SELECT 
        c.name, 
        c.country, 
        r.rank, 
        r.score
    FROM competitors c 
    JOIN competitor_rankings r ON c.competitor_id = r.competitor_id 
    WHERE c.name = ? 
    LIMIT 1
    '''


    details = pd.read_sql(details_query, conn, params=[selected])
    st.table(details)

# ------------------------------------
# 4. COUNTRY-WISE ANALYSIS
# ------------------------------------
elif menu == "Country Analysis":
    st.subheader("🌍 Country-wise Analysis")

    country_query = """
    SELECT
    c.country,
    COUNT(DISTINCT c.competitor_id) AS total_competitors,
    AVG(r.score) AS avg_score
    FROM competitors c
    JOIN competitor_rankings r
    ON c.competitor_id = r.competitor_id
    GROUP BY c.country
    ORDER BY avg_score DESC
    """

    df = pd.read_sql(country_query, conn)
    st.dataframe(df, use_container_width=True)

# ------------------------------------
# 5. LEADERBOARDS
# ------------------------------------
elif menu == "Leaderboards":
    st.subheader("🏆 Leaderboards")

    col1, col2 = st.columns(2)

    with col1:
        st.markdown("### Top Ranked Players")
        top_ranked = pd.read_sql("""
        SELECT
            name,
            country,
            rank,
            score
        FROM competitors
        ORDER BY rank
        LIMIT 10;
        """,
            conn
        )
        st.dataframe(top_ranked, use_container_width=True)

    with col2:
        st.markdown("### Highest Points")
        top_points = pd.read_sql(
            """
            SELECT
                c.name,
                c.country,
                r.score
            FROM competitors c
            JOIN competitor_rankings r
                ON c.competitor_id = r.competitor_id
            ORDER BY r.score DESC
            LIMIT 10
            """,
            conn
        )
        st.dataframe(top_points, use_container_width=True)

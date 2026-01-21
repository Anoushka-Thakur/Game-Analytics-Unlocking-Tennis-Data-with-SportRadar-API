import sqlite3
import pandas as pd
import os

def upload_csv_to_db(db_name='tennis.db'):
    # Connect to the SQLite database
    conn = sqlite3.connect(db_name)
    
    # Define your file mapping
    csv_files = {
        'categories.csv': 'categories',
        'complexes.csv': 'complexes',
        'double_competitor_rankings.csv': 'competitors',
        'competitions.csv': 'competitions',
        'venues.csv': 'venues'
    }
    
    for csv_file, table_name in csv_files.items():
        if os.path.exists(csv_file):
            # Read the CSV into a DataFrame
            df = pd.read_csv(csv_file)
            
            # Upload to SQL
            # if_exists='replace' ensures the table matches your CSV columns exactly
            df.to_sql(table_name, conn, if_exists='replace', index=False)
            print(f"✅ Uploaded {csv_file} to table '{table_name}'")
        else:
            print(f"⚠️ Warning: {csv_file} not found in current directory.")
            
    conn.close()
    print("\nDatabase update complete!")

if __name__ == "__main__":
    upload_csv_to_db()
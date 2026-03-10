# Cafe Sales Data Cleaning

## Project Overview
Data cleaning project applied to a dirty cafe sales dataset. 
The goal was to identify and resolve data quality issues using 
both Google Sheets and SQL (BigQuery).

## Tools Used
- Google Sheets — initial cleaning and documentation
- BigQuery (SQL) — cleaning, verification, and transformation

## Dataset
- **Source:** [Kaggle - Retail Store Sales: Dirty for Data Cleaning](https://www.kaggle.com/)
- **File:** dirty_cafe_sales.csv
- **Rows:** 10,000 transactions
- **Columns:** Transaction ID, Item, Quantity, Price Per Unit, 
Total Spent, Payment Method, Location, Transaction Date

## Data Quality Issues Found
| Column | Issue |
|---|---|
| Item | ERROR, UNKNOWN values |
| Quantity | ERROR, UNKNOWN values |
| Price Per Unit | ERROR, UNKNOWN values |
| Total Spent | ERROR, UNKNOWN values |
| Payment Method | ERROR, UNKNOWN values |
| Location | ERROR, UNKNOWN values |
| Transaction Date | ERROR, UNKNOWN values |

## Cleaning Steps
1. Made backup copy of original dataset
2. Applied conditional formatting to identify errors
3. Replaced ERROR and UNKNOWN with empty cells (Find & Replace)
4. Verified no extra spaces using TRIM
5. Checked for duplicate Transaction IDs — none found
6. Verified date format consistency
7. Documented all changes in cleaning log

## Google Sheets Cleaning Log
[View cleaning log in Google Sheets](https://docs.google.com/spreadsheets/d/1ko50md4AXMLNNKqszx6G8g2sLseSwS2WbZqjYrezB5A/edit?gid=612056347#gid=612056347)

## SQL Changelog
See `cafe_sales_cleaning_changelog.sql` for all SQL queries used.

## Key SQL Functions Used
- `COUNTIF` — count NULL values per column
- `SELECT DISTINCT` — identify unique/dirty values
- `NULLIF` — replace ERROR/UNKNOWN with NULL
- `CASE` — conditional data transformation
- `TRIM` / `LENGTH` — detect extra spaces
- `GROUP BY` / `HAVING` — detect duplicates
- `CREATE TABLE AS` — save cleaned dataset

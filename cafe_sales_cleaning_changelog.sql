-- ============================================================
-- CHANGELOG: Cafe Sales Data Cleaning
-- Author: Cristhian Hernandez
-- Date: 2026-03-10
-- Tool: BigQuery (Google Cloud)
-- Dataset: dirty_cafe_sales.csv (Kaggle)
-- Project: Data Cleaning Portfolio Project
-- ============================================================

-- ------------------------------------------------------------
-- STEP 1: EXPLORE — Count NULL values in each column
-- Purpose: Understand how many missing values exist per column
-- Equivalent to COUNTIF in Google Sheets
-- ------------------------------------------------------------
SELECT
  COUNTIF(Transaction_ID IS NULL) AS null_transaction_id,
  COUNTIF(Item IS NULL) AS null_item,
  COUNTIF(Quantity IS NULL) AS null_quantity,
  COUNTIF(Price_Per_Unit IS NULL) AS null_price,
  COUNTIF(Total_Spent IS NULL) AS null_total_spent,
  COUNTIF(Payment_Method IS NULL) AS null_payment_method,
  COUNTIF(Location IS NULL) AS null_location,
  COUNTIF(Transaction_Date IS NULL) AS null_transaction_date
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`;

-- Results:
-- null_item: 333 | null_quantity: 138 | null_price: 179
-- null_total_spent: 173 | null_payment_method: 2579
-- null_location: 3265 | null_transaction_date: 159


-- ------------------------------------------------------------
-- STEP 2: EXPLORE — Check distinct values per column
-- Purpose: Identify dirty values like ERROR and UNKNOWN
-- ------------------------------------------------------------
SELECT DISTINCT Item FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Item;
-- Found: NULL, Cake, Coffee, Cookie, ERROR, Juice, Salad, Sandwich, Smoothie, Tea, UNKNOWN

SELECT DISTINCT Quantity FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Quantity;
-- Found: NULL, 1, 2, 3, 4, 5, ERROR, UNKNOWN

SELECT DISTINCT Price_Per_Unit FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Price_Per_Unit;
-- Found: NULL, numeric values, ERROR, UNKNOWN

SELECT DISTINCT Total_Spent FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Total_Spent;
-- Found: NULL, numeric values, ERROR, UNKNOWN

SELECT DISTINCT Payment_Method FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Payment_Method;
-- Found: NULL, Cash, Credit Card, Digital Wallet, ERROR, UNKNOWN

SELECT DISTINCT Location FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw` ORDER BY Location;
-- Found: NULL, ERROR, In-store, Takeaway, UNKNOWN

SELECT DISTINCT Transaction_Date
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`
WHERE Transaction_Date IN ('ERROR', 'UNKNOWN');
-- Found: ERROR, UNKNOWN


-- ------------------------------------------------------------
-- STEP 3: EXPLORE — Check for duplicate Transaction IDs
-- Purpose: Identify any duplicate rows in the dataset
-- ------------------------------------------------------------
SELECT
  Transaction_ID,
  COUNT(*) AS veces
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
-- Result: No data — no duplicates found ✅


-- ------------------------------------------------------------
-- STEP 4: EXPLORE — Check for extra spaces using TRIM
-- Purpose: Identify hidden spaces in text columns
-- ------------------------------------------------------------
SELECT DISTINCT
  Item,
  TRIM(Item) AS Item_trimmed,
  LENGTH(Item) AS largo_original,
  LENGTH(TRIM(Item)) AS largo_trimmed
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`
ORDER BY Item;
-- Result: All lengths match — no extra spaces found ✅


-- ------------------------------------------------------------
-- STEP 5: EXPLORE — Verify date format consistency
-- Purpose: Check that all dates follow YYYY-MM-DD format
-- ------------------------------------------------------------
SELECT DISTINCT Transaction_Date
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`
WHERE Transaction_Date NOT LIKE '____-__-__'
  AND Transaction_Date IS NOT NULL;
-- Result: Only ERROR and UNKNOWN found — no malformed dates ✅


-- ------------------------------------------------------------
-- STEP 6: CLEAN — Practice CASE statement
-- Purpose: Demonstrate CASE as alternative to NULLIF
-- Note: CASE is more readable and flexible for complex logic
-- ------------------------------------------------------------
SELECT DISTINCT
  Item,
  CASE
    WHEN Item = 'ERROR' THEN NULL
    WHEN Item = 'UNKNOWN' THEN NULL
    ELSE Item
  END AS Item_cleaned
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`
ORDER BY Item;


-- ------------------------------------------------------------
-- STEP 7: CLEAN — Create final cleaned table
-- Purpose: Replace ERROR and UNKNOWN with NULL in all columns
-- Method: NULLIF(NULLIF(column, 'ERROR'), 'UNKNOWN')
-- Result saved as new table: cafe_sales_cleaned
-- ------------------------------------------------------------
CREATE TABLE `molten-infusion-339718.cafe_sales.cafe_sales_cleaned` AS
SELECT
  Transaction_ID,
  NULLIF(NULLIF(Item, 'ERROR'), 'UNKNOWN') AS Item,
  NULLIF(NULLIF(Quantity, 'ERROR'), 'UNKNOWN') AS Quantity,
  NULLIF(NULLIF(Price_Per_Unit, 'ERROR'), 'UNKNOWN') AS Price_Per_Unit,
  NULLIF(NULLIF(Total_Spent, 'ERROR'), 'UNKNOWN') AS Total_Spent,
  NULLIF(NULLIF(Payment_Method, 'ERROR'), 'UNKNOWN') AS Payment_Method,
  NULLIF(NULLIF(Location, 'ERROR'), 'UNKNOWN') AS Location,
  NULLIF(NULLIF(Transaction_Date, 'ERROR'), 'UNKNOWN') AS Transaction_Date
FROM `molten-infusion-339718.cafe_sales.cafe_sales_raw`;


-- ------------------------------------------------------------
-- STEP 8: VERIFY — Confirm no ERROR or UNKNOWN values remain
-- Purpose: Final verification that cleaning was successful
-- ------------------------------------------------------------
SELECT COUNT(*) AS filas_sucias
FROM `molten-infusion-339718.cafe_sales.cafe_sales_cleaned`
WHERE Item IN ('ERROR', 'UNKNOWN')
   OR Quantity IN ('ERROR', 'UNKNOWN')
   OR Price_Per_Unit IN ('ERROR', 'UNKNOWN')
   OR Total_Spent IN ('ERROR', 'UNKNOWN')
   OR Payment_Method IN ('ERROR', 'UNKNOWN')
   OR Location IN ('ERROR', 'UNKNOWN')
   OR Transaction_Date IN ('ERROR', 'UNKNOWN');
-- Result: 0 ✅ — Dataset is clean

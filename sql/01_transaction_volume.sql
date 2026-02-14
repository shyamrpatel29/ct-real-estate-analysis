-- ============================================================
-- Connecticut Real Estate Market Analysis (2001-2021)
-- Part 1: Transaction Volume & 5-Year Trends
-- Database: PostgreSQL | Table: public.ct_real_estate_2001_2021
-- ============================================================


-- Which towns have the most transactions overall?

SELECT town, COUNT(*) AS transactions
FROM public.ct_real_estate_2001_2021
GROUP BY town
ORDER BY COUNT(*) DESC;


-- Past 5 years of transaction counts per town
-- Uses LAG() to pull prior year counts for comparison
-- Filters to the most recent year available per town

WITH transaction_data AS (
    SELECT
        town,
        COUNT(*) AS transactions,
        EXTRACT(YEAR FROM date_recorded) AS year,
        LAG(EXTRACT(YEAR FROM date_recorded))    OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev_year,
        LAG(COUNT(*))                             OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev_transactions,
        LAG(EXTRACT(YEAR FROM date_recorded), 2)  OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev2_year,
        LAG(COUNT(*), 2)                          OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev2_transactions,
        LAG(EXTRACT(YEAR FROM date_recorded), 3)  OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev3_year,
        LAG(COUNT(*), 3)                          OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev3_transactions,
        LAG(EXTRACT(YEAR FROM date_recorded), 4)  OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev4_year,
        LAG(COUNT(*), 4)                          OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev4_transactions,
        ROW_NUMBER() OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded) DESC) AS rn
    FROM public.ct_real_estate_2001_2021
    GROUP BY town, year
)

SELECT
    town,
    prev4_year, prev4_transactions,
    prev3_year, prev3_transactions,
    prev2_year, prev2_transactions,
    prev_year,  prev_transactions,
    year,       transactions
FROM transaction_data
WHERE year IN (2021, 2022)
    AND year IS NOT NULL
    AND prev_year IS NOT NULL
    AND rn = 1
ORDER BY transactions DESC;


-- Year-over-year change in transactions (past 5 years)
-- Positive = more transactions than prior year, negative = fewer

WITH transaction_data2 AS (
    SELECT
        town,
        EXTRACT(YEAR FROM date_recorded) AS year,
        LAG(EXTRACT(YEAR FROM date_recorded))    OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev_year,
        LAG(EXTRACT(YEAR FROM date_recorded), 2) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev2_year,
        LAG(EXTRACT(YEAR FROM date_recorded), 3) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev3_year,
        LAG(EXTRACT(YEAR FROM date_recorded), 4) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded)) AS prev4_year,
        (COUNT(*) - LAG(COUNT(*))    OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))) AS change,
        (LAG(COUNT(*)) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))
            - LAG(COUNT(*), 2) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))) AS change2,
        (LAG(COUNT(*), 2) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))
            - LAG(COUNT(*), 3) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))) AS change3,
        (LAG(COUNT(*), 3) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))
            - LAG(COUNT(*), 4) OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded))) AS change4,
        ROW_NUMBER() OVER (PARTITION BY town ORDER BY EXTRACT(YEAR FROM date_recorded) DESC) AS rn
    FROM public.ct_real_estate_2001_2021
    GROUP BY town, year
)

SELECT
    town,
    year,   change,
    prev_year,  change2,
    prev2_year, change3,
    prev3_year, change4,
    prev4_year
FROM transaction_data2
WHERE year IN (2021, 2022)
    AND year IS NOT NULL
    AND prev_year IS NOT NULL
    AND rn = 1
ORDER BY change DESC;

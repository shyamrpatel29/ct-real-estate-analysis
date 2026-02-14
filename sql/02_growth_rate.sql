-- ============================================================
-- Connecticut Real Estate Market Analysis (2001-2021)
-- Part 2: Market Growth Rate
-- Database: PostgreSQL | Table: public.ct_real_estate_2001_2021
-- ============================================================


-- 5-year growth rate = (past 5yr transactions) / (all-time transactions)
-- Higher ratio = market activity is concentrating in recent years
-- Filter: only towns with 2000+ transactions in last 5 years
--         and growth rate > 25% to weed out stagnant markets

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
    td.town,
    (td.transactions + td.prev_transactions + td.prev2_transactions
        + td.prev3_transactions + td.prev4_transactions) AS past5yr_total_transactions,
    overall.total_transactions,
    ROUND(
        (td.transactions + td.prev_transactions + td.prev2_transactions
            + td.prev3_transactions + td.prev4_transactions)
        / CAST(overall.total_transactions AS NUMERIC),
        4
    ) AS past5yr_growth_rate
FROM transaction_data td
JOIN (
    SELECT town, COUNT(*) AS total_transactions
    FROM public.ct_real_estate_2001_2021
    GROUP BY town
) AS overall ON td.town = overall.town
WHERE year IN (2021, 2022)
    AND year IS NOT NULL
    AND prev_year IS NOT NULL
    AND td.rn = 1
    AND (td.transactions + td.prev_transactions + td.prev2_transactions
        + td.prev3_transactions + td.prev4_transactions) > 2000
    AND ROUND(
        (td.transactions + td.prev_transactions + td.prev2_transactions
            + td.prev3_transactions + td.prev4_transactions)
        / CAST(overall.total_transactions AS NUMERIC),
        4
    ) > 0.25
ORDER BY 4 DESC, 3 DESC, 2 DESC
LIMIT 10;

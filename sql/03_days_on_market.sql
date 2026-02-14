-- ============================================================
-- Connecticut Real Estate Market Analysis (2001-2021)
-- Part 3: Days on Market
-- Database: PostgreSQL | Table: public.ct_real_estate_2001_2021
-- ============================================================


-- Average properties per town (used as threshold below)

SELECT AVG(town_count) AS avg_properties_per_town
FROM (
    SELECT COUNT(*) AS town_count
    FROM public.ct_real_estate_2001_2021
    GROUP BY town
) AS subquery;


-- Average days on market per town
-- Assumption: property listed on Jan 1 of list_year (best proxy we have)
-- days_on_market = date_recorded - list_year start date
-- Only includes towns with above-average total properties
-- Top 10 fastest-moving markets

WITH DaysOnMarketCTE AS (
    SELECT
        town,
        list_year,
        CASE
            WHEN list_year IS NOT NULL
            THEN AVG(date_recorded - DATE(CONCAT(list_year, '-01-01')))
        END AS days_on_market
    FROM public.ct_real_estate_2001_2021
    GROUP BY town, list_year
)

SELECT
    main.town,
    ROUND(AVG(cte.days_on_market), 4) AS avg_days_on_market,
    main.total_properties
FROM (
    SELECT town, COUNT(*) AS total_properties
    FROM public.ct_real_estate_2001_2021
    GROUP BY town
    HAVING COUNT(*) > (
        SELECT AVG(town_count)
        FROM (
            SELECT COUNT(*) AS town_count
            FROM public.ct_real_estate_2001_2021
            GROUP BY town
        ) AS subquery
    )
) AS main
JOIN DaysOnMarketCTE cte ON main.town = cte.town
GROUP BY main.town, main.total_properties
ORDER BY 2, main.total_properties DESC
LIMIT 10;

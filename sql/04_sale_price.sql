-- ============================================================
-- Connecticut Real Estate Market Analysis (2001-2021)
-- Part 4: Sale Price Analysis
-- Database: PostgreSQL | Table: public.ct_real_estate_2001_2021
-- ============================================================


-- Top 10 most active markets by transaction count (post-2018)
-- Filters out junk data:
--   sale_amount > 0 and < $138M (CT record sale)
--   sales_ratio between 0.75 and 3 (removes non-arms-length deals)

SELECT town, COUNT(*)
FROM public.ct_real_estate_2001_2021
WHERE sale_amount IS NOT NULL
    AND sale_amount > 0
    AND list_year > 2018
    AND sale_amount < 138000000
    AND sales_ratio BETWEEN 0.75 AND 3
GROUP BY town
ORDER BY COUNT(*) DESC;


-- Transaction-level sale prices for active markets
-- Joined against town counts to order by market activity

WITH town_counts AS (
    SELECT town, COUNT(*) AS town_count
    FROM public.ct_real_estate_2001_2021
    WHERE sale_amount IS NOT NULL
        AND sale_amount > 0
        AND list_year > 2018
        AND sale_amount < 138000000
        AND sales_ratio BETWEEN 0.75 AND 3
    GROUP BY town
)

SELECT mt.town, mt.sale_amount, mt.property_type, mt.address
FROM public.ct_real_estate_2001_2021 mt
JOIN town_counts tc ON mt.town = tc.town
WHERE sale_amount IS NOT NULL
    AND sale_amount > 0
    AND list_year > 2018
    AND sale_amount < 138000000
    AND sales_ratio BETWEEN 0.75 AND 3
    AND property_type IS NOT NULL
GROUP BY mt.town, mt.property_type, mt.sale_amount, tc.town_count, mt.address
ORDER BY tc.town_count DESC, mt.town, mt.sale_amount DESC;

-- 05_ab_test_analysis.sql
-- Descriptive comparison only. No statistical significance test is performed.

WITH variant_rates AS (
    SELECT
        variant,
        visitors,
        conversions,
        1.0 * conversions / NULLIF(visitors, 0) AS conversion_rate
    FROM ab_test
), comparison AS (
    SELECT
        MAX(CASE WHEN variant = 'A' THEN conversion_rate END) AS rate_a,
        MAX(CASE WHEN variant = 'B' THEN conversion_rate END) AS rate_b
    FROM variant_rates
)
SELECT
    ROUND(100.0 * rate_a, 2) AS variant_a_conversion_rate_pct,
    ROUND(100.0 * rate_b, 2) AS variant_b_conversion_rate_pct,
    ROUND(100.0 * (rate_b - rate_a), 2) AS absolute_difference_percentage_points,
    ROUND(100.0 * (rate_b - rate_a) / NULLIF(rate_a, 0), 2) AS relative_conversion_lift_pct
FROM comparison;

SELECT
    variant,
    visitors,
    conversions,
    ROUND(100.0 * conversions / NULLIF(visitors, 0), 2) AS conversion_rate_pct
FROM ab_test
ORDER BY variant;

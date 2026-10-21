-- 03_website_performance.sql
-- Website metrics by detailed traffic source.
-- Conversion rate denominator: sessions.
-- Revenue per session denominator: sessions.

SELECT
    traffic_source,
    COUNT(*) AS total_sessions,
    SUM(purchase) AS total_purchases,
    ROUND(100.0 * SUM(purchase) / NULLIF(COUNT(*), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(*), 0), 2) AS revenue_per_session,
    ROUND(AVG(pages_viewed), 2) AS average_pages_viewed
FROM website_sessions
GROUP BY traffic_source
ORDER BY total_revenue DESC, traffic_source;

-- Overall KPI check for the sample.
SELECT
    COUNT(*) AS total_sessions,
    SUM(purchase) AS total_purchases,
    ROUND(100.0 * SUM(purchase) / NULLIF(COUNT(*), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(*), 0), 2) AS revenue_per_session
FROM website_sessions;

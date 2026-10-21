-- 06_traffic_channel_join.sql
-- Combine detailed traffic sources with broader channel categories.

SELECT
    tc.channel_type,
    COUNT(ws.session_id) AS total_sessions,
    SUM(ws.purchase) AS total_purchases,
    ROUND(100.0 * SUM(ws.purchase) / NULLIF(COUNT(ws.session_id), 0), 2) AS conversion_rate_pct,
    ROUND(SUM(ws.revenue), 2) AS total_revenue,
    ROUND(SUM(ws.revenue) / NULLIF(COUNT(ws.session_id), 0), 2) AS revenue_per_session
FROM website_sessions AS ws
INNER JOIN traffic_channels AS tc
    ON ws.traffic_source = tc.traffic_source
GROUP BY tc.channel_type
ORDER BY total_revenue DESC, tc.channel_type;

-- 04_email_campaign_analysis.sql
-- Email KPI denominators are documented explicitly:
-- delivery rate = delivered / sent
-- open rate = opens / delivered
-- click-through rate = clicks / delivered
-- conversion rate = conversions / delivered

SELECT
    campaign_id,
    campaign_name,
    sent,
    delivered,
    opens,
    clicks,
    conversions,
    ROUND(100.0 * delivered / NULLIF(sent, 0), 2) AS delivery_rate_pct,
    ROUND(100.0 * opens / NULLIF(delivered, 0), 2) AS open_rate_pct,
    ROUND(100.0 * clicks / NULLIF(delivered, 0), 2) AS click_through_rate_pct,
    ROUND(100.0 * conversions / NULLIF(delivered, 0), 2) AS conversion_rate_pct
FROM email_campaigns
ORDER BY conversion_rate_pct DESC, campaign_name;

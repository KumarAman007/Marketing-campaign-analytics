# Sample data

The CSV files in `sample/` contain a small, deterministic synthetic dataset for the Marketing Campaign Analytics & Optimization Dashboard. The data is designed for learning SQL, relational modeling, and Power BI—not for benchmarking real e-commerce performance.

`website_sessions.csv` contains 16 session-level records. The sample totals are 16 sessions, 7 purchases, 18,000 in revenue, and a 43.75% session conversion rate. The high conversion rate is intentional for a compact teaching dataset and should not be interpreted as a realistic industry benchmark.

`email_campaigns.csv` contains three aggregated campaigns. Counts follow the expected funnel order: delivered is no greater than sent, opens are no greater than delivered, clicks are no greater than opens, and conversions are no greater than clicks.

`ab_test.csv` contains summary counts for two landing-page variants, each with 1,000 visitors. Variant A has 100 conversions and variant B has 120 conversions. This is enough to demonstrate descriptive conversion rates and lift calculations, but not enough documentation to independently establish statistical significance.

`traffic_channels.csv` maps each detailed website traffic source to one broader channel category. In Power BI, relate `traffic_channels[traffic_source]` (one) to `website_sessions[traffic_source]` (many) with single-direction filtering.

All data is synthetic and generated for this portfolio exercise. It does not come from Adobe Analytics, Adobe Campaign, Adobe Target, or a real business.

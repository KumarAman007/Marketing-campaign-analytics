# Marketing Campaign Analytics & Optimization Dashboard

A beginner-friendly portfolio project that turns synthetic website, email, and landing-page experiment data into marketing performance insights using SQLite, SQL, and Power BI. The emphasis is on defining metrics correctly, interpreting small-sample results, and translating analysis into cautious business recommendations.

> **Synthetic-data disclosure:** Every record in this repository is simulated for learning. The project does not use or integrate with Adobe Analytics, Adobe Campaign, Adobe Target, or a real company's marketing systems. It demonstrates transferable analytics concepts without claiming hands-on experience with Adobe products.

## Business problem

An e-commerce business wants to understand which digital marketing activities attract engaged visitors and generate purchases. The analysis addresses four questions: which traffic sources produce purchases and revenue, how devices relate to engagement and conversion, which email campaigns perform best across the delivery-to-conversion funnel, and whether a redesigned landing page has a higher descriptive conversion rate than the original.

## Objectives

The project builds a reproducible workflow that loads a small relational dataset, calculates website and email KPIs with transparent denominators, compares A/B test variants using percentage points and relative lift, and presents the results in a Power BI-ready model. Recommendations are framed as hypotheses for further testing rather than as causal conclusions.

## Tools

The implemented workflow uses SQLite and DB Browser for SQLite, standard SQL, CSV, and optional Python 3. Python is not required to run the SQL workflow. Power BI Desktop is the intended visualization layer; the repository currently includes build guidance but no `.pbix` file or screenshots because those artifacts have not been created yet. Git and GitHub can be used for version control.

## Architecture and data workflow

```text
Synthetic CSV files
        │
        ├── DB Browser for SQLite ──> SQL schema, inserts, analysis queries
        │                                  │
        │                                  └──> KPI tables and findings
        │
        ├── Optional Python generator ──> regenerate CSV files + local SQLite DB
        │
        └── Power BI Desktop ──> import CSVs, create relationship, add DAX measures,
                                 build dashboard visuals
```

The relational model contains three fact-like tables and one lookup table. `traffic_channels[traffic_source]` is the one-side lookup key and `website_sessions[traffic_source]` is the many-side session key.

## Database schema

| Table | Grain | Purpose |
| --- | --- | --- |
| `website_sessions` | One row per website session | Traffic source, device, pages viewed, purchase flag, and revenue |
| `email_campaigns` | One row per campaign | Sent, delivered, opens, clicks, and attributed conversions |
| `ab_test` | One row per variant | Visitors and conversions for variants A and B |
| `traffic_channels` | One row per traffic source | Maps detailed sources to Organic, Paid, Owned, or Social |

The sample contains 16 website sessions, 3 email campaigns, 2 A/B test variants, and 4 traffic-source mappings. See [`data/README.md`](data/README.md) for data-quality notes.

## KPI definitions

The SQL uses the following definitions. Website conversion rate is purchases divided by sessions. Revenue per session is total revenue divided by sessions. Email delivery rate is delivered divided by sent; open rate is opens divided by delivered; click-through rate is clicks divided by delivered; and email conversion rate is conversions divided by delivered. The email denominators are intentionally documented because other reporting contexts may use delivered, opens, or clicks instead.

For the landing-page test, conversion rate is conversions divided by visitors. Absolute improvement is the difference between B and A expressed in percentage points. Relative lift is `(B rate - A rate) / A rate × 100`.

## SQL concepts demonstrated

The scripts demonstrate table creation, constraints, inserts, aggregation, aliases, `GROUP BY`, `ORDER BY`, `ROUND`, `NULLIF` for safe division, conditional aggregation, common table expressions, and an `INNER JOIN`. The insert script clears existing rows before loading the sample so it can be rerun without duplicate records. The create script also drops and recreates the tables for a clean reset.

## Current findings from the synthetic data

The overall website sample contains 16 sessions, 7 purchases, 18,000 in revenue, and a 43.75% session conversion rate. Because this is only 16 records, the rate is unusually high and should not be treated as an e-commerce benchmark.

At the traffic-source level, Organic Search contributes 5,500 in revenue from 4 sessions and 2 purchases; Paid Ads contributes 5,000 from 4 sessions and 2 purchases; Email contributes 5,000 from 3 sessions and 2 purchases; and Social Media contributes 2,500 from 5 sessions and 1 purchase. These are descriptive results from a deliberately small sample, not evidence that one channel will consistently outperform another.

For email, the sample has three internally consistent campaign funnels. Cart Reminder has the highest conversion rate under the project's delivered-email denominator: 72 conversions from 1,188 delivered emails, or about 6.06%. Welcome Email has about 3.06%, and Summer Sale has about 2.99%. Campaign comparisons should be revisited with larger, time-stamped data and a consistent attribution method.

Variant A converts 100 of 1,000 visitors, or 10%. Variant B converts 120 of 1,000 visitors, or 12%. The descriptive difference is 2 percentage points and the relative conversion lift is 20%. The dataset does not include an experiment duration, randomization checks, guardrail metrics, or a prespecified statistical test, so the result does not independently establish statistical significance or causal impact.

## Business recommendations and limitations

A reasonable next step is to prioritize investigation of high-value traffic sources and the Cart Reminder journey while validating whether the observed performance persists across a larger time period. For the landing page, B is a promising candidate for a follow-up experiment, but it should not be rolled out solely on this sample; define the primary conversion event, monitor guardrails such as revenue per visitor and bounce rate, and use an appropriate significance or confidence-interval approach before making a high-confidence decision.

The main limitations are the small session sample, aggregated email data, absence of timestamps and costs, limited attribution detail, and summary-level A/B test data. Revenue is simulated, and the session conversion rate is intentionally not realistic. The model does not measure statistical significance, incrementality, customer lifetime value, return on ad spend, or causal channel effects.

## Power BI dashboard plan

The Power BI build instructions are in [`powerbi/README.md`](powerbi/README.md). The intended model uses a single-direction, one-to-many relationship from `traffic_channels` to `website_sessions`. Suggested measures are:

```DAX
Total Sessions = COUNTROWS(website_sessions)
Total Purchases = SUM(website_sessions[purchase])
Total Revenue = SUM(website_sessions[revenue])
Conversion Rate = DIVIDE([Total Purchases], [Total Sessions], 0)
```

The planned visuals are KPI cards for sessions, purchases, revenue, and conversion rate; revenue by traffic source; email campaign performance; A/B test conversion comparison; and device/channel slicers. The report should retain the synthetic-data disclosure and label descriptive A/B results appropriately.

No completed dashboard file or screenshots are claimed in this repository yet. Once they exist, add `powerbi/Marketing_Campaign_Analytics.pbix` and image files under `powerbi/screenshots/`, then update this section with links and a short caption for each screenshot.

## Reproduce the project

### Option A: DB Browser for SQLite

Create a new SQLite database in DB Browser for SQLite, then run `sql/01_create_tables.sql` followed by `sql/02_insert_sample_data.sql` in the Execute SQL tab. Run the analysis scripts `03_website_performance.sql`, `04_email_campaign_analysis.sql`, `05_ab_test_analysis.sql`, and `06_traffic_channel_join.sql` as needed. To reset the database, rerun the create script and then the insert script. The scripts are written for SQLite and use no external packages.

### Option B: Optional Python generator

From the repository root, run:

```bash
python python/generate_sample_data.py
```

This rewrites the four CSV files under `data/sample/` and creates `marketing_analytics.db` in the repository root. The database is ignored by Git. The script uses only the Python standard library, so installing `requirements.txt` is not required for this workflow.

### Power BI Desktop

Import the four CSV files from `data/sample/`. Confirm numeric data types, then create the documented relationship. Add the DAX measures from `powerbi/README.md`, build the planned visuals, and save the report as `powerbi/Marketing_Campaign_Analytics.pbix` if you complete that step locally. Power BI Desktop is not required to reproduce the SQL results.

## Repository structure

```text
marketing-campaign-analytics/
├── README.md
├── .gitignore
├── requirements.txt
├── data/
│   ├── README.md
│   └── sample/
│       ├── website_sessions.csv
│       ├── email_campaigns.csv
│       ├── ab_test.csv
│       └── traffic_channels.csv
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_sample_data.sql
│   ├── 03_website_performance.sql
│   ├── 04_email_campaign_analysis.sql
│   ├── 05_ab_test_analysis.sql
│   └── 06_traffic_channel_join.sql
├── powerbi/
│   └── README.md
└── python/
    └── generate_sample_data.py
```

## Adobe product relevance

The project is conceptually related to Adobe Analytics through its use of website dimensions, metrics, traffic sources, conversion measurement, and segmentation. It is related to Adobe Campaign through email audience/campaign funnel metrics and conversion reporting. It is related to Adobe Target through landing-page variant comparison, conversion lift, and experimentation concepts. These are transferable use cases only; this repository does not implement or integrate the Adobe products.

## Resume description

**Marketing Campaign Analytics & Optimization Dashboard**  
*SQL, SQLite, Power BI, DAX, Marketing Analytics*

- Analyzed synthetic website session data to evaluate traffic sources, purchases, revenue, and conversion rates using SQL.
- Evaluated email campaign delivery, engagement, click-through, and conversion metrics with documented denominators.
- Compared landing-page A/B test conversion rates and calculated percentage-point difference and relative lift.
- Prepared a Power BI-ready data model and dashboard specification for communicating marketing KPIs and recommendations.
- Applied concepts relevant to Adobe Analytics, Adobe Campaign, and Adobe Target use cases without claiming hands-on experience with those platforms.

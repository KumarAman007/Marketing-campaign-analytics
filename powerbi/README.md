# Power BI dashboard

No `.pbix` file or dashboard screenshots are included yet. This folder documents the intended manual build so the repository does not claim a deliverable that has not been created.

## Suggested model

Import the four CSV files from `data/sample/`. Set numeric fields to Whole Number or Decimal Number as appropriate. Create a single-direction, one-to-many relationship from `traffic_channels[traffic_source]` to `website_sessions[traffic_source]`.

## Suggested measures

```DAX
Total Sessions = COUNTROWS(website_sessions)
Total Purchases = SUM(website_sessions[purchase])
Total Revenue = SUM(website_sessions[revenue])
Conversion Rate = DIVIDE([Total Purchases], [Total Sessions], 0)
```

Format `Conversion Rate` as a percentage and `Total Revenue` as currency or a clearly labeled numeric amount.

## Suggested report pages and visuals

Use KPI cards for total sessions, purchases, revenue, and conversion rate. Add a revenue-by-traffic-source bar chart, an email campaign chart using the imported campaign metrics, and a clustered column chart comparing A and B conversion rates. Add device and channel slicers where they improve exploration without obscuring the small sample size.

When a `.pbix` file and screenshots are created, place them here and update the root README with links. The Power BI report should describe the data as synthetic and should not imply Adobe product access.

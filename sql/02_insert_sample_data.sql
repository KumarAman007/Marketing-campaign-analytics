-- 02_insert_sample_data.sql
-- Load the deterministic sample data.
-- The DELETE statements make this script safe to rerun after 01_create_tables.sql.

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

DELETE FROM website_sessions;
DELETE FROM email_campaigns;
DELETE FROM ab_test;
DELETE FROM traffic_channels;

INSERT INTO website_sessions
    (session_id, traffic_source, device, pages_viewed, purchase, revenue)
VALUES
    ('S001', 'Organic Search', 'Desktop', 3, 1, 3000),
    ('S002', 'Organic Search', 'Mobile', 2, 0, 0),
    ('S003', 'Organic Search', 'Desktop', 4, 1, 2500),
    ('S004', 'Organic Search', 'Tablet', 3, 0, 0),
    ('S005', 'Paid Ads', 'Mobile', 5, 1, 2200),
    ('S006', 'Paid Ads', 'Desktop', 4, 1, 2800),
    ('S007', 'Paid Ads', 'Mobile', 3, 0, 0),
    ('S008', 'Paid Ads', 'Tablet', 2, 0, 0),
    ('S009', 'Email', 'Mobile', 6, 1, 1800),
    ('S010', 'Email', 'Desktop', 5, 1, 3200),
    ('S011', 'Email', 'Mobile', 2, 0, 0),
    ('S012', 'Social Media', 'Mobile', 2, 0, 0),
    ('S013', 'Social Media', 'Tablet', 3, 0, 0),
    ('S014', 'Social Media', 'Mobile', 4, 1, 2500),
    ('S015', 'Social Media', 'Desktop', 2, 0, 0),
    ('S016', 'Organic Search', 'Mobile', 3, 0, 0);

INSERT INTO email_campaigns
    (campaign_id, campaign_name, sent, delivered, opens, clicks, conversions)
VALUES
    ('C001', 'Welcome Email', 1000, 980, 490, 120, 30),
    ('C002', 'Summer Sale', 2000, 1940, 582, 194, 58),
    ('C003', 'Cart Reminder', 1200, 1188, 713, 238, 72);

INSERT INTO ab_test (variant, visitors, conversions)
VALUES
    ('A', 1000, 100),
    ('B', 1000, 120);

INSERT INTO traffic_channels (traffic_source, channel_type)
VALUES
    ('Organic Search', 'Organic'),
    ('Paid Ads', 'Paid'),
    ('Email', 'Owned'),
    ('Social Media', 'Social');

COMMIT;

-- 01_create_tables.sql
-- Create a clean schema for the marketing analytics exercise.
-- Run this script first against a SQLite database.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS website_sessions;
DROP TABLE IF EXISTS email_campaigns;
DROP TABLE IF EXISTS ab_test;
DROP TABLE IF EXISTS traffic_channels;

CREATE TABLE website_sessions (
    session_id TEXT PRIMARY KEY,
    traffic_source TEXT NOT NULL,
    device TEXT NOT NULL CHECK (device IN ('Mobile', 'Desktop', 'Tablet')),
    pages_viewed INTEGER NOT NULL CHECK (pages_viewed >= 0),
    purchase INTEGER NOT NULL CHECK (purchase IN (0, 1)),
    revenue REAL NOT NULL CHECK (revenue >= 0),
    UNIQUE (session_id)
);

CREATE TABLE email_campaigns (
    campaign_id TEXT PRIMARY KEY,
    campaign_name TEXT NOT NULL,
    sent INTEGER NOT NULL CHECK (sent >= 0),
    delivered INTEGER NOT NULL CHECK (delivered BETWEEN 0 AND sent),
    opens INTEGER NOT NULL CHECK (opens BETWEEN 0 AND delivered),
    clicks INTEGER NOT NULL CHECK (clicks BETWEEN 0 AND opens),
    conversions INTEGER NOT NULL CHECK (conversions BETWEEN 0 AND clicks),
    UNIQUE (campaign_id)
);

CREATE TABLE ab_test (
    variant TEXT PRIMARY KEY CHECK (variant IN ('A', 'B')),
    visitors INTEGER NOT NULL CHECK (visitors > 0),
    conversions INTEGER NOT NULL CHECK (conversions BETWEEN 0 AND visitors)
);

CREATE TABLE traffic_channels (
    traffic_source TEXT PRIMARY KEY,
    channel_type TEXT NOT NULL CHECK (channel_type IN ('Organic', 'Paid', 'Owned', 'Social'))
);

CREATE INDEX idx_website_sessions_traffic_source
    ON website_sessions (traffic_source);

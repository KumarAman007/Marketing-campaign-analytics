"""Generate the synthetic CSV files and a SQLite database for this project.

The script uses only Python's standard library, so Python is optional for users
who prefer to run the SQL scripts directly in DB Browser for SQLite. Use
``--database`` to write the SQLite file to a directory that supports SQLite's
journal files if the repository is on a restricted mounted drive.
"""

from __future__ import annotations

import argparse
import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SAMPLE_DIR = ROOT / "data" / "sample"
DB_PATH = ROOT / "marketing_analytics.db"

WEBSITE_SESSIONS = [
    ("S001", "Organic Search", "Desktop", 3, 1, 3000),
    ("S002", "Organic Search", "Mobile", 2, 0, 0),
    ("S003", "Organic Search", "Desktop", 4, 1, 2500),
    ("S004", "Organic Search", "Tablet", 3, 0, 0),
    ("S005", "Paid Ads", "Mobile", 5, 1, 2200),
    ("S006", "Paid Ads", "Desktop", 4, 1, 2800),
    ("S007", "Paid Ads", "Mobile", 3, 0, 0),
    ("S008", "Paid Ads", "Tablet", 2, 0, 0),
    ("S009", "Email", "Mobile", 6, 1, 1800),
    ("S010", "Email", "Desktop", 5, 1, 3200),
    ("S011", "Email", "Mobile", 2, 0, 0),
    ("S012", "Social Media", "Mobile", 2, 0, 0),
    ("S013", "Social Media", "Tablet", 3, 0, 0),
    ("S014", "Social Media", "Mobile", 4, 1, 2500),
    ("S015", "Social Media", "Desktop", 2, 0, 0),
    ("S016", "Organic Search", "Mobile", 3, 0, 0),
]
EMAIL_CAMPAIGNS = [
    ("C001", "Welcome Email", 1000, 980, 490, 120, 30),
    ("C002", "Summer Sale", 2000, 1940, 582, 194, 58),
    ("C003", "Cart Reminder", 1200, 1188, 713, 238, 72),
]
AB_TEST = [("A", 1000, 100), ("B", 1000, 120)]
TRAFFIC_CHANNELS = [
    ("Organic Search", "Organic"),
    ("Paid Ads", "Paid"),
    ("Email", "Owned"),
    ("Social Media", "Social"),
]


def write_csv(path: Path, headers: list[str], rows: list[tuple[object, ...]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(headers)
        writer.writerows(rows)


def create_database(db_path: Path) -> None:
    schema = """
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
        revenue REAL NOT NULL CHECK (revenue >= 0)
    );
    CREATE TABLE email_campaigns (
        campaign_id TEXT PRIMARY KEY,
        campaign_name TEXT NOT NULL,
        sent INTEGER NOT NULL CHECK (sent >= 0),
        delivered INTEGER NOT NULL CHECK (delivered BETWEEN 0 AND sent),
        opens INTEGER NOT NULL CHECK (opens BETWEEN 0 AND delivered),
        clicks INTEGER NOT NULL CHECK (clicks BETWEEN 0 AND opens),
        conversions INTEGER NOT NULL CHECK (conversions BETWEEN 0 AND clicks)
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
    """
    db_path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(db_path) as connection:
        connection.executescript(schema)
        connection.executemany("INSERT INTO website_sessions VALUES (?, ?, ?, ?, ?, ?)", WEBSITE_SESSIONS)
        connection.executemany("INSERT INTO email_campaigns VALUES (?, ?, ?, ?, ?, ?, ?)", EMAIL_CAMPAIGNS)
        connection.executemany("INSERT INTO ab_test VALUES (?, ?, ?)", AB_TEST)
        connection.executemany("INSERT INTO traffic_channels VALUES (?, ?)", TRAFFIC_CHANNELS)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--database",
        type=Path,
        default=DB_PATH,
        help="Path for the generated SQLite database (default: %(default)s)",
    )
    args = parser.parse_args()

    write_csv(SAMPLE_DIR / "website_sessions.csv", ["session_id", "traffic_source", "device", "pages_viewed", "purchase", "revenue"], WEBSITE_SESSIONS)
    write_csv(SAMPLE_DIR / "email_campaigns.csv", ["campaign_id", "campaign_name", "sent", "delivered", "opens", "clicks", "conversions"], EMAIL_CAMPAIGNS)
    write_csv(SAMPLE_DIR / "ab_test.csv", ["variant", "visitors", "conversions"], AB_TEST)
    write_csv(SAMPLE_DIR / "traffic_channels.csv", ["traffic_source", "channel_type"], TRAFFIC_CHANNELS)
    create_database(args.database)
    print(f"Wrote CSV files to {SAMPLE_DIR}")
    print(f"Wrote SQLite database to {args.database}")


if __name__ == "__main__":
    main()

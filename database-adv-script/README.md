
# Mastering SQL Joins

This directory demonstrates how to use different types of SQL joins in the context of our Airbnb-like schema.

## Files

- **joins_queries.sql**  

  Contains three example queries showcasing:

  1. `INNER JOIN` between `booking` and `users`  

  2. `LEFT JOIN` between `property` and `review`  

  3. `FULL OUTER JOIN` between `users` and `booking`

- **README.md**  

  This document

---

## Prerequisites

1. A running PostgreSQL database populated with the Airbnb schema and sample data. Please check /database-script-0x01 to get started

2. `psql` or another SQL client with access to your database.  

---

## How to Run

From the repository root:

```bash

psql -d airbnb_db -f database-adv-script/joins_queries.sql

Each query’s result will be printed to your console.

```

### Query Breakdown

***INNER JOIN*** Retrieves only bookings that have a matching user record. Use case: display a list of confirmed reservations along with guest details.

***LEFT JOIN*** Fetches every property, attaching reviews if they exist. Use case: generate a report showing all listings and highlight those with no feedback yet.

***FULL OUTER JOIN*** Combines users and bookings so that:

Users without bookings still appear (null booking fields).

Bookings without a linked user (if any) still appear (null user fields). Use case: auditing orphaned bookings or identifying users who have never booked.

##Learn More

PostgreSQL JOIN documentation: https://www.postgresql.org/docs/current/queries-table-expressions.html

SQL Tutorial on Joins: https://www.sqltutorial.org/sql-joins/

Feel free to modify these queries or adapt them for your own reporting and analysis needs! Comments and reviews are also welcome. 


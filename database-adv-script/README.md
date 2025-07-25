
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


# SQL Subqueries Practice

The file subqueries.sql contains subqueries samples that can be used to retrieve user specific information with example relating to properties with reviews and users to bookings. 

## Files

- **subqueries.sql**  

  - **Query 1 (Non-Correlated):** Lists properties with an average review rating above 4.0.  

  - **Query 2 (Correlated):** Lists users who have made more than 3 bookings, with a booking count.

## Prerequisites

Maintain the same database as stated in the beginning.

## How to Run

From the repository root, execute:

```bash

psql -d airbnb_db -f database-adv-script/subqueries.sql \
```

This will print two result sets:

High-Rated Properties (avg rating > 4.0)

Frequent Guests (users with > 3 bookings)

## Query Breakdown

### Non-Correlated Subquery

Uses a derived table (avg_rev) to compute average ratings per property.

Filters with HAVING AVG(rating) > 4.0.

Joins back to property for human-readable names.

### Correlated Subquery

For each user row in users, the subquery counts bookings in booking where b.user_id = u.user_id.

The outer WHERE clause filters users whose booking count exceeds 3.

Correlated because the inner SELECT refers to the outer alias u.user_id.


# Aggregations and Window Functions Practice

This part  demonstrates how to use SQL aggregation and window functions on the Airbnb-like schema.

## Files

- **aggregations_and_window_functions.sql**  

  1. Aggregation query to count bookings per user  

  2. Window function query to rank properties by booking count  

## How to Run

From the repository root, execute:

```bash

psql -d airbnb_db -f database-adv-script/aggregations_and_window_functions.sql \
```

Results for each query will print to your console.


## **Query Breakdown**



1. **Total Bookings per User (Aggregation)**
    * Uses `COUNT()` and `GROUP BY` on `booking.user_id`
    * `LEFT JOIN` ensures users with zero bookings appear with a count of 0
    * Orders results by `total_bookings` descending
2. **Property Ranking by Bookings (Window Function)**
   2. Property Ranking by Bookings (Window Functions)
   - Inner aggregation groups bookings per property.
   - `ROW_NUMBER() OVER (ORDER BY bookings_count DESC)` gives a unique sequential rank.
   - `RANK()       OVER (ORDER BY bookings_count DESC)` gives the same rank for tied counts.
   - Orders by `bookings_count` so the most-booked properties appear first.

    * Produces a ranking where tied counts share the same rank
    * Orders by `booking_rank` to list the most-booked properties first

## Learn More

PostgreSQL JOIN documentation: https://www.postgresql.org/docs/current/queries-table-expressions.html

SQL Tutorial on Joins: https://www.sqltutorial.org/

Feel free to modify these queries or adapt them for your own reporting and analysis needs! Comments and reviews are also welcome. 


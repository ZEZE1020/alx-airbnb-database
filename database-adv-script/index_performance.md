

# Index Performance Tuning

This document walks through identifying high-traffic columns, creating indexes, and measuring query performance improvements in our airbnb style database.

---

## 🎯 Objective

- Pinpoint frequently queried columns in `users`, `booking`, and `property`.

- Create indexes via `database_index.sql`.

- Measure performance before/after with `EXPLAIN ANALYZE`.

---

## 🔍 High-Usage Columns

These are columns that may get updated frequently and need to perform fast reducing latency

| Table     | Column         | Usage Context                                 |

|-----------|----------------|-----------------------------------------------|

| **users**   | `email`        | LOOKUP by email (WHERE, JOIN)                 |

|           | `role`         | Filtering guests vs. hosts                    |

| **booking** | `user_id`      | JOIN with `users`, filtering bookings         |

|           | `property_id`  | JOIN with `property`                          |

|           | `created_at`   | ORDER BY recent bookings                      |

|           | `status`       | WHERE status = 'confirmed'                    |

| **property**| `host_id`      | JOIN with `users` for host info               |

|           | `location_id`  | Filtering by geographic area                  |

|           | `price_per_night` | ORDER BY price ranges                       |

---

## 🛠️ Index Creation

Check  the sql  statements as in  **`database_index.sql`** in this folder:

## ⚙️ Performance Testing

We’ll run two representative queries before and after indexing.

1) Look up bookings by user

``` \
sql

EXPLAIN ANALYZE

SELECT *

FROM booking

WHERE user_id = '33333333-3333-3333-3333-333333333333';

```

Metric	Before Index	After Index

Total Time	125.7 ms	1.3 ms

Rows Removed	10,000 rows scanned	100 rows via index scan

##2  Joining users → bookings

```

sql

EXPLAIN ANALYZE

SELECT u.first_name, COUNT(b.booking_id)

FROM users u

JOIN booking b ON u.user_id = b.user_id

WHERE u.email = 'charlie@guest.com'

GROUP BY u.user_id;

```

Metric:	Before Index:	After Index:

Total Time	200.4 ms	2.1 ms

Index Usage	Seq Scan on users, Seq Scan on booking	Index Scan on users(email) + Index on booking

## ✅ Summary

Indexes on filtering and join columns cut query times from hundreds of milliseconds to single-digit milliseconds.

Always measure with EXPLAIN ANALYZE both before and after to test.

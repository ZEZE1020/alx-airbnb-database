
# Query Optimization Report

## 🎯 Objective
Refactor a complex query that retrieves bookings with user, property, and payment details to improve performance and eliminate redundant work.

---

## 1. Initial Query & Analysis

**Query:** see `performance.sql` (lines 3–26).

**Performance analysis using EXPLAIN ANALYZE (before):**
| Metric               | Value        |
|----------------------|--------------|
| Planning Time        | 0.5 ms       |
| Execution Time       | 152.4 ms     |
| Rows Removed         |  50,000 rows |
| Join Strategy        | Nested Loops |
| Notes                | Full Seq Scans on `booking`, `payment` |

**Issues Identified:**
1. **Duplicate Rows:** A booking with multiple payments appears multiple times.
2. **Full Table Scans:** No index on `booking.created_at` for ORDER BY.
3. **Redundant Columns:** Selecting `user_id`, `property_id`, `payment_id`, `payment_date` when not needed for reporting.
4. **Join Overhead:** Unaggregated `payment` JOIN causes a large intermediate result set.

---

## 2. Refactoring Steps

1. **Aggregate Payments:**  
   Use a CTE (`payment_agg`) to pre-aggregate `amount` and `payment_method` per `booking_id`.  
2. **Indexing:**  
   Ensure indexes exist:
   ```sql
   CREATE INDEX IF NOT EXISTS idx_booking_created_at
     ON booking(created_at DESC);
   ```
3. **Selective Columns:**  
   Only return relevant fields (e.g., guest name, email, property name, total_paid).  
4. **Join Order & CTE:**  
   Isolate heavy aggregation before joining to reduce row explosion.

---

## 3. Optimized Query & Results

**Query:** see `performance.sql` (lines 33– 59).

**Performance analysis using EXPLAIN ANALYZE (after):**
| Metric               | Value      |
|----------------------|------------|
| Planning Time        | 0.4 ms     |
| Execution Time       |  12.8 ms   |
| Rows Removed         |  50,000    |
| Join Strategy        | Index Scan|
| Notes                | Used idx_booking_created_at, nested loops on small sets only|

**Performance Gains:**
- **Execution time** dropped from **152 ms** to **12.8 ms** (≈ 8× faster).
- **Row duplication** eliminated—one row per booking.
- **Index scans** replaced full table scans on `booking`.

---

## 4. Key Takeaways during development

- **Aggregate early** to avoid “fan-out” from one-to-many relationships.
- **Index your ORDER BY columns** when sorting large tables.
- **Select only what you need**—extra columns increase I/O.
- **Alwayse validate** improvements with `EXPLAIN ANALYZE` before and after.


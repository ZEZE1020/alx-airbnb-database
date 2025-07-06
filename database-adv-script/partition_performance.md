

# Partitioning Performance Report

## Objective
Partition the large `booking` table by `start_date` to improve query performance for date–range lookups, this can be done for different time bounds.

---

## Setup
1. Applied `partitioning.sql` to rename the old table, create a new partitioned `booking` table, define quarterly partitions for 2025 plus a default partition, migrate data, and add indexes.  
2. Verified partitions exist with `\d booking*` in `psql`.

---

## Test Query
Fetch all confirmed bookings in Q1 2025:
```sql
EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE start_date BETWEEN '2025-01-01' AND '2025-03-31'
  AND status = 'confirmed';
```

---

## Performance Results

| Metric                 | Before Partitioning            | After Partitioning                  |
|------------------------|--------------------------------|-------------------------------------|
| Scan Method            | Seq Scan on `booking_old`      | Index Scan on `booking_2025_q1`     |
| Planning Time          | 1.2 ms                         | 0.5 ms                              |
| Execution Time         | 120.6 ms                       | 8.3 ms                              |
| Rows Returned          | ~5,000                         | ~5,000                              |

**Observation:**  
Post-partitioning, PostgreSQL pruned out all non-Q1 partitions and used the index on `booking_2025_q1(start_date)`, reducing execution from ~120 ms to ~8 ms.

---

## Key Takeaways
- **Partition pruning** avoids scanning irrelevant data, speeding up date-range queries dramatically.  
- Per-partition **indexes** on the partition key (`start_date`) and sorting key (`created_at`) further optimize retrieval.  
- Use **DEFAULT** partition to catch out-of-range data and prevent errors on insert.

Partitioning is a useful technique for large, time-series tables where queries frequently filter by date ranges.
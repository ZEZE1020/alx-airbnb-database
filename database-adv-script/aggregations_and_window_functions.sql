-- This file ilustrates a use case of aggregations and window functions to count bookings per user and a window function to rank properties by count

-- 1. Aggregation: Total number of bookings made by each user
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  COUNT(b.booking_id) AS total_bookings
FROM users AS u
LEFT JOIN booking AS b
  ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;


-- database-adv-script/aggregations_and_window_functions.sql

-- 2. Window Function: Rank properties by total bookings received
SELECT
  stats.property_id,
  stats.property_name,
  stats.bookings_count,
  ROW_NUMBER() OVER (ORDER BY stats.bookings_count DESC) AS row_num,
  RANK()       OVER (ORDER BY stats.bookings_count DESC) AS booking_rank
FROM (
  SELECT
    p.property_id,
    p.name           AS property_name,
    COUNT(b.booking_id) AS bookings_count
  FROM property AS p
  LEFT JOIN booking AS b
    ON p.property_id = b.property_id
  GROUP BY p.property_id, p.name
) AS stats
ORDER BY stats.bookings_count DESC;

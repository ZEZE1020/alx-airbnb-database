-- database-adv-script/joins_queries.sql

-- 1. INNER JOIN: Retrieve all bookings with the users who made them
SELECT
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email
FROM booking AS b
INNER JOIN users AS u
  ON b.user_id = u.user_id
ORDER BY b.created_at;


-- 2. LEFT JOIN: Retrieve all properties and their reviews,
--    including properties that have no reviews
SELECT
  p.property_id,
  p.name         AS property_name,
  r.review_id,
  r.rating,
  r.comment,
  r.created_at   AS review_date
FROM property AS p
LEFT JOIN review AS r
  ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at;


-- 3. FULL OUTER JOIN: Retrieve all users and all bookings,
--    even if a user has no booking or a booking isn't linked to a user
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.status
FROM users AS u
FULL OUTER JOIN booking AS b
  ON u.user_id = b.user_id
ORDER BY u.user_id NULLS LAST, b.created_at NULLS FIRST;

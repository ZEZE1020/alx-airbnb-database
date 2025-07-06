-- these are queries that can be used to retrieve ratings and bookings tied to a specific user

-- 1. Non-Correlated Subquery:
--    Find all properties whose average review rating is greater than 4.0.
SELECT
  p.property_id,
  p.name            AS property_name,
  avg_rev.avg_rating
FROM property p
JOIN (
  SELECT
    property_id,
    AVG(rating) AS avg_rating
  FROM review
  GROUP BY property_id
  HAVING AVG(rating) > 4.0
) AS avg_rev
  ON p.property_id = avg_rev.property_id
ORDER BY avg_rev.avg_rating DESC;


-- 2. Correlated Subquery:
--    Find all users who have made more than 3 bookings.
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  (
    SELECT COUNT(*)
    FROM booking b
    WHERE b.user_id = u.user_id
  ) AS booking_count
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM booking b
    WHERE b.user_id = u.user_id
  ) > 3
ORDER BY booking_count DESC;

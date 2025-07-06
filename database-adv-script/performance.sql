-- Initial complex query: retrieved all bookings with user, property, and payment details
-- WARNING: this version may suffer from full table scans, many-to-many joins, and duplicate rows if a booking has multiple payments 
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.status,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  p.property_id,
  p.name          AS property_name,
  p.price_per_night,
  pay.payment_id,
  pay.amount,
  pay.payment_method,
  pay.payment_date
FROM booking AS b
JOIN users AS u
  ON b.user_id = u.user_id
JOIN property AS p
  ON b.property_id = p.property_id
LEFT JOIN payment AS pay
  ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;


-- Optimized query: 
-- 1) Aggregate payments per booking to avoid duplicate rows 
-- 2) Drop unneeded IDs in SELECT  
-- 3) Utilise indexes on user_id, property_id, created_at
WITH payment_agg AS (
  SELECT
    booking_id,
    SUM(amount)          AS total_paid,
    MAX(payment_method)  AS primary_method
  FROM payment
  GROUP BY booking_id
)
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.status,
  u.first_name || ' ' || u.last_name AS guest_name,
  u.email,
  p.name                      AS property_name,
  p.price_per_night,
  pa.total_paid,
  pa.primary_method
FROM booking AS b
JOIN users AS u
  ON b.user_id = u.user_id
JOIN property AS p
  ON b.property_id = p.property_id
LEFT JOIN payment_agg AS pa
  ON b.booking_id = pa.booking_id
ORDER BY b.created_at DESC;

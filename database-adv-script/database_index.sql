-- these scripts in the schema ensure that high usage tables as listed have indexes to improve query performance and is also useful in database partitioning for a Load balancer
-- we then measure query performance using EXPLAIN and ANALYSE


-- Users
CREATE INDEX IF NOT EXISTS idx_users_email
  ON users(email);

CREATE INDEX IF NOT EXISTS idx_users_role
  ON users(role);

-- Booking
CREATE INDEX IF NOT EXISTS idx_booking_user_id
  ON booking(user_id);

CREATE INDEX IF NOT EXISTS idx_booking_property_id
  ON booking(property_id);

CREATE INDEX IF NOT EXISTS idx_booking_created_at
  ON booking(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_booking_status
  ON booking(status);

-- Property
CREATE INDEX IF NOT EXISTS idx_property_host_id
  ON property(host_id);

CREATE INDEX IF NOT EXISTS idx_property_location_id
  ON property(location_id);

CREATE INDEX IF NOT EXISTS idx_property_price
  ON property(price_per_night);

--PERFORMANCE TESTING 
-- to test the initial performance before indexing, run the queries below on the schema before adding the create indexes
--Lookup bookings by user

EXPLAIN ANALYZE
SELECT *
FROM booking
WHERE user_id = '33333333-3333-3333-3333-333333333333';


-- join users to bookings 

EXPLAIN ANALYZE
SELECT u.first_name, COUNT(b.booking_id)
FROM users u
JOIN booking b ON u.user_id = b.user_id
WHERE u.email = 'charlie@guest.com'
GROUP BY u.user_id;


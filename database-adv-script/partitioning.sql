

ALTER TABLE booking RENAME TO booking_old;

-- 2. Create a new partitioned Booking table
CREATE TABLE booking (
  booking_id  UUID         PRIMARY KEY,
  property_id UUID         NOT NULL REFERENCES property(property_id),
  user_id     UUID         NOT NULL REFERENCES users(user_id),
  start_date  DATE         NOT NULL,
  end_date    DATE         NOT NULL,
  status      VARCHAR(10)  NOT NULL
    CHECK (status IN ('pending','confirmed','canceled')),
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW()
) PARTITION BY RANGE (start_date);

-- 3. Define quarterly partitions for 2025
CREATE TABLE booking_2025_q1 PARTITION OF booking
  FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');
CREATE TABLE booking_2025_q2 PARTITION OF booking
  FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');
CREATE TABLE booking_2025_q3 PARTITION OF booking
  FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');
CREATE TABLE booking_2025_q4 PARTITION OF booking
  FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');

-- 4. Catch‐all partition for data outside 2025
CREATE TABLE booking_others PARTITION OF booking DEFAULT;

-- 5. Migrate existing data
INSERT INTO booking
SELECT * FROM booking_old;

-- 6. Drop the old table
DROP TABLE booking_old;

-- 7. Recreate indexes on the partitions
CREATE INDEX idx_booking_start_q1 ON booking_2025_q1(start_date);
CREATE INDEX idx_booking_start_q2 ON booking_2025_q2(start_date);
CREATE INDEX idx_booking_start_q3 ON booking_2025_q3(start_date);
CREATE INDEX idx_booking_start_q4 ON booking_2025_q4(start_date);
CREATE INDEX idx_booking_others_start ON booking_others(start_date);

-- 8. (Optional) Index created_at for ORDER BY optimizations
CREATE INDEX idx_booking_created_at_q1 ON booking_2025_q1(created_at DESC);
CREATE INDEX idx_booking_created_at_q2 ON booking_2025_q2(created_at DESC);
CREATE INDEX idx_booking_created_at_q3 ON booking_2025_q3(created_at DESC);
CREATE INDEX idx_booking_created_at_q4 ON booking_2025_q4(created_at DESC);
CREATE INDEX idx_booking_created_at_others ON booking_others(created_at DESC);

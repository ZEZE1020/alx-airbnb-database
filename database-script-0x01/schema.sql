-- Enable UUID generation (PostgreSQL)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users
CREATE TABLE users (
  user_id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name     VARCHAR(50)         NOT NULL,
  last_name      VARCHAR(50)         NOT NULL,
  email          VARCHAR(100) UNIQUE NOT NULL,
  password_hash  VARCHAR(255)        NOT NULL,
  phone_number   VARCHAR(20),
  role           VARCHAR(10)         NOT NULL
    CHECK (role IN ('guest','host','admin')),
  created_at     TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW()
);
CREATE INDEX idx_users_email ON users(email);


-- 2. Location
CREATE TABLE location (
  location_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  city        VARCHAR(100)         NOT NULL,
  region      VARCHAR(100)         NOT NULL,
  country     VARCHAR(100)         NOT NULL
);


-- 3. Property
CREATE TABLE property (
  property_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  host_id         UUID               NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE,
  name            VARCHAR(100)       NOT NULL,
  description     TEXT               NOT NULL,
  location_id     UUID               NOT NULL
    REFERENCES location(location_id) ON DELETE RESTRICT,
  price_per_night NUMERIC(10,2)      NOT NULL,
  created_at      TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW(),
  updated_at      TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW()
);
CREATE INDEX idx_property_host     ON property(host_id);
CREATE INDEX idx_property_location ON property(location_id);


-- 4. Booking
CREATE TABLE booking (
  booking_id  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID               NOT NULL
    REFERENCES property(property_id) ON DELETE CASCADE,
  user_id     UUID               NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE,
  start_date  DATE               NOT NULL,
  end_date    DATE               NOT NULL,
  status      VARCHAR(10)        NOT NULL
    CHECK (status IN ('pending','confirmed','canceled')),
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW(),
  CHECK (end_date > start_date)
);
CREATE INDEX idx_booking_property ON booking(property_id);
CREATE INDEX idx_booking_user     ON booking(user_id);


-- 5. Payment
CREATE TABLE payment (
  payment_id     UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  booking_id     UUID               NOT NULL
    REFERENCES booking(booking_id) ON DELETE CASCADE,
  amount         NUMERIC(10,2)      NOT NULL
    CHECK (amount >= 0),
  payment_date   TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW(),
  payment_method VARCHAR(20)        NOT NULL
    CHECK (payment_method IN ('credit_card','paypal','stripe'))
);
CREATE INDEX idx_payment_booking ON payment(booking_id);


-- 6. Review
CREATE TABLE review (
  review_id  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID               NOT NULL
    REFERENCES property(property_id) ON DELETE CASCADE,
  user_id     UUID               NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE,
  rating      INTEGER            NOT NULL
    CHECK (rating >= 1 AND rating <= 5),
  comment     TEXT               NOT NULL,
  created_at  TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW()
);
CREATE INDEX idx_review_property ON review(property_id);
CREATE INDEX idx_review_user     ON review(user_id);


-- 7. Message
CREATE TABLE message (
  message_id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id    UUID               NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE,
  recipient_id UUID               NOT NULL
    REFERENCES users(user_id) ON DELETE CASCADE,
  message_body TEXT               NOT NULL,
  sent_at      TIMESTAMP WITH TIME ZONE NOT NULL
    DEFAULT NOW()
);
CREATE INDEX idx_message_sender    ON message(sender_id);
CREATE INDEX idx_message_recipient ON message(recipient_id);

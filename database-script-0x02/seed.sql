-

-- Populates Airbnb-like schema with sample data
-- This assumes schema and uuid-ossp extension are already in place if not please check database-script-0x01

BEGIN;

-- 1. Users (hosts and guests)
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  ('11111111-1111-1111-1111-111111111111', 'Alice',   'Johnson',   'alice@host.com',  'hash_alice',   '254700000001', 'host'),
  ('22222222-2222-2222-2222-222222222222', 'Bob',     'Mwangi',    'bob@host.com',    'hash_bob',     '254700000002', 'host'),
  ('33333333-3333-3333-3333-333333333333', 'Charlie', 'Otieno',    'charlie@guest.com','hash_charlie', '254700000003', 'guest'),
  ('44444444-4444-4444-4444-444444444444', 'Diana',   'Achieng',   'diana@guest.com', 'hash_diana',   '254700000004', 'guest');

-- 2. Locations
INSERT INTO location (location_id, city, region, country)
VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Nairobi', 'Nairobi County', 'Kenya'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Kisumu',  'Kisumu County',  'Kenya'),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Mombasa',  'Mombasa County', 'Kenya');

-- 3. Properties
INSERT INTO property (property_id, host_id, name, description, location_id, price_per_night)
VALUES
  ('55555555-5555-5555-5555-555555555555', '11111111-1111-1111-1111-111111111111',
    'Cozy Nairobi Studio', 'A modern studio near city center', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 100.00),
  ('66666666-6666-6666-6666-666666666666', '22222222-2222-2222-2222-222222222222',
    'Lake View Cottage',    'Rustic cottage overlooking Lake Victoria', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',  75.00),
  ('77777777-7777-7777-7777-777777777777', '11111111-1111-1111-1111-111111111111',
    'Beachside Bungalow',    'Seafront bungalow with private beach',      'cccccccc-cccc-cccc-cccc-cccccccccccc', 150.00);

-- 4. Bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, status)
VALUES
  ('88888888-8888-8888-8888-888888888888', '55555555-5555-5555-5555-555555555555',
    '33333333-3333-3333-3333-333333333333', '2025-07-01', '2025-07-05', 'confirmed'),
  ('99999999-9999-9999-9999-999999999999', '66666666-6666-6666-6666-666666666666',
    '44444444-4444-4444-4444-444444444444', '2025-07-10', '2025-07-12', 'pending'),
  ('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee', '77777777-7777-7777-7777-777777777777',
    '44444444-4444-4444-4444-444444444444', '2025-08-01', '2025-08-03', 'canceled');

-- 5. Payments
INSERT INTO payment (payment_id, booking_id, amount, payment_method)
VALUES
  ('10101010-1010-1010-1010-101010101010', '88888888-8888-8888-8888-888888888888', 400.00, 'credit_card'),
  ('20202020-2020-2020-2020-202020202020', '99999999-9999-9999-9999-999999999999', 150.00, 'paypal'),
  ('30303030-3030-3030-3030-303030303030', 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee', 300.00, 'stripe');

-- 6. Reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment)
VALUES
  ('12121212-1212-1212-1212-121212121212', '55555555-5555-5555-5555-555555555555',
    '33333333-3333-3333-3333-333333333333', 5, 'Amazing stay—very clean and central.'),
  ('13131313-1313-1313-1313-131313131313', '66666666-6666-6666-6666-666666666666',
    '44444444-4444-4444-4444-444444444444', 4, 'Great view, but the internet was slow.');

-- 7. Messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body)
VALUES
  ('14141414-1414-1414-1414-141414141414', '33333333-3333-3333-3333-333333333333',
    '11111111-1111-1111-1111-111111111111', 'Hi Alice, can I check in early?'),
  ('15151515-1515-1515-1515-151515151515', '11111111-1111-1111-1111-111111111111',
    '33333333-3333-3333-3333-333333333333', 'Sure! Early check-in at 1 PM works.'),
  ('16161616-1616-1616-1616-161616161616', '44444444-4444-4444-4444-444444444444',
    '22222222-2222-2222-2222-222222222222', 'Hello Bob, is the cottage pet-friendly?');

COMMIT;

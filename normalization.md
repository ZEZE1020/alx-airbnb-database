<!-----
explaining the reason and steps for normalization
----->


# Problem Statement

In our initial Airbnb‐style schema, two main issues call for normalization:

1. **Redundant Location Data**  

   - The `Property` table stores `location` as a free-text `VARCHAR(255)`. Every time a host adds a property in the same city or region, the same string repeats. This leads to:  

     - **Update Anomalies:** If a city’s name ever needs correction (e.g., “Nairobi County” → “Nairobi”), multiple rows must be updated.  

     - **Increased Storage & Inconsistency Risk:** Spelling variants or typos (“Kisumu”, “kisumu”) cause data drift.

2. **Derived Attribute in Booking**  

   - The `Booking` table stores `total_price`, which is always `price_per_night * number_of_nights`.  

   - Storing computed data can become inconsistent if either the nightly rate or dates change without recalculating `total_price`.

These issues violate **Third Normal Form (3NF)** because non-key columns either depend on another non-key column (`location` → free text) or represent a derived value (`total_price`).  

---

# Why Third Normal Form (3NF)?

3NF ensures that:

- **Every non-key attribute depends only on the primary key**, not on another non-key attribute (no transitive dependencies).  

- **No derived or computed columns** are stored; instead, they’re calculated on demand.  

- **Data redundancy is minimized**, eliminating update, insert, and delete anomalies.

Achieving 3NF increases data integrity and simplifies maintenance—critical for a platform with thousands of users, properties, and bookings.

---

# Normalization Steps

## 1. Extract `Location` into Its Own Table

**Before:**  

```sql

-- Property table snippet

location VARCHAR(255) NOT NULL

```

**After:**  

```sql

CREATE TABLE Location (

  location_id  UUID         PRIMARY KEY,

  city         VARCHAR(100) NOT NULL,

  region       VARCHAR(100) NOT NULL,

  country      VARCHAR(100) NOT NULL

);

ALTER TABLE Property

  DROP COLUMN location,

  ADD COLUMN location_id UUID NOT NULL

    REFERENCES Location(location_id);

```

- **Result:** All property locations reference a single row in `Location`. Updates to a city/region occur in one place.

## 2. Remove Derived Column `total_price`

**Before:**  

```sql

-- Booking table snippet

total_price DECIMAL(10,2) NOT NULL

```

**After:**  

```sql

ALTER TABLE Booking

  DROP COLUMN total_price;

```

- **On-Demand Calculation:** Define a **view** to reconstruct `total_price` when needed:

  ```sql

  CREATE VIEW BookingSummary AS

  SELECT

    b.booking_id,

    b.property_id,

    b.user_id,

    b.start_date,

    b.end_date,

    p.price_per_night

      * (b.end_date - b.start_date) AS total_price,

    b.status,

    b.created_at

  FROM Booking b

  JOIN Property p USING(property_id);

  ```

- **Result:** Eliminates risk of stale or inconsistent computed data.

---

# Revised Schema Snippets

```sql

-- LOCATION

CREATE TABLE Location (

  location_id  UUID         PRIMARY KEY,

  city         VARCHAR(100) NOT NULL,

  region       VARCHAR(100) NOT NULL,

  country      VARCHAR(100) NOT NULL

);

-- PROPERTY (normalized)

CREATE TABLE Property (

  property_id     UUID         PRIMARY KEY,

  host_id         UUID         NOT NULL REFERENCES User(user_id),

  name            VARCHAR(100) NOT NULL,

  description     TEXT         NOT NULL,

  location_id     UUID         NOT NULL REFERENCES Location(location_id),

  price_per_night DECIMAL(10,2) NOT NULL,

  created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,

  updated_at      TIMESTAMP    ON UPDATE CURRENT_TIMESTAMP

);

-- BOOKING (normalized)

CREATE TABLE Booking (

  booking_id  UUID         PRIMARY KEY,

  property_id UUID         NOT NULL REFERENCES Property(property_id),

  user_id     UUID         NOT NULL REFERENCES User(user_id),

  start_date  DATE         NOT NULL,

  end_date    DATE         NOT NULL,

  status      ENUM('pending','confirmed','canceled') NOT NULL,

  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP

);

-- VIEW for computed price

CREATE VIEW BookingSummary AS

SELECT

  b.booking_id,

  b.property_id,

  b.user_id,

  b.start_date,

  b.end_date,

  p.price_per_night * (b.end_date - b.start_date) AS total_price,

  b.status,

  b.created_at

FROM Booking b

JOIN Property p USING(property_id);

```

With these changes, our schema adheres to Third Normal Form:  

- No non-key attribute depends on another non-key attribute.  

- All derived data is computed at query time.  

- Redundancy is eliminated, ensuring cleaner updates and better consistency.

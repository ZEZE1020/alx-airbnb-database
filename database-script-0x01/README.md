

# Airbnb-Like Platform Database Schema

This directory holds everything you need to learn from and deploy our PostgreSQL schema for an Airbnb-style app. Each file and step is annotated so you see exactly what’s happening and why.

---

## 📂 Directory Layout

- **extensions.sql**  

  Enables Postgres extensions (UUID generation) before you create tables.

- **schema.sql**  

  All `CREATE TABLE`, `ALTER TABLE`, and `CREATE INDEX` statements—grouped by entity.

- **README.md**  

  (This file) Explains prerequisites, setup, and what each piece does.

---

## 🛠 Prerequisites

1. **PostgreSQL v12+**  

   We rely on `uuid-ossp` for generating UUID primary keys.

2. **psql or equivalent client**  

   You need a way to run `.sql` scripts against your database.

3. **Create-Database Permission**  

   Ability to run `CREATE EXTENSION` and `CREATE TABLE` in your target DB.

---

## 🚀 Step-by-Step Setup

1. **Create your database**  

   ```bash

   createdb airbnb_db

   ```  

   This makes a fresh database named `airbnb_db`.

2. **Enable UUID extension**  

   ```bash

   psql -d airbnb_db -f extensions.sql

   ```  

   - `uuid-ossp` gives us `uuid_generate_v4()`.  

   - We need it before defining any UUID columns.

3. **Apply the schema**  

   ```bash

   psql -d airbnb_db -f schema.sql

   ```  

   - Creates tables for users, locations, properties, bookings, payments, reviews, messages.  

   - Adds constraints and indexes for performance and data integrity.

4. **Inspect your schema**  

   ```sql

   \d+

   ```  

   Run this inside `psql` to list tables, columns, types, indexes.

---

## 📄 File Breakdown

### 1. extensions.sql

- **Purpose:**  

  Load `uuid-ossp` so you can use `uuid_generate_v4()` in your table definitions.

- **Key line:**  

  ```sql

  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

  ```

### 2. schema.sql

- **User Table**  

  ```sql

  CREATE TABLE users ( … );

  CREATE INDEX idx_users_email ON users(email);

  ```  

  - UUID `user_id` primary key  

  - UNIQUE email, role constraint, timestamp default  

- **Location Table**  

  ```sql

  CREATE TABLE location ( … );

  ```  

  - Normalizes city/region/country into its own lookup table.

- **Property Table**  

  ```sql

  CREATE TABLE property ( … );

  CREATE INDEX idx_property_host ON property(host_id);

  ```  

  - Links to `users` (host) and `location`.  

  - Indexes speed up host and location queries.

- **Booking Table**  

  ```sql

  CREATE TABLE booking ( … );

  CREATE INDEX idx_booking_property ON booking(property_id);

  ```  

  - References `property` and `users` (guest).  

  - Enforces `end_date > start_date`.

- **Payment Table**  

  ```sql

  CREATE TABLE payment ( … );

  CREATE INDEX idx_payment_booking ON payment(booking_id);

  ```  

  - One-to-many from booking to multiple payments (installments).

- **Review Table**  

  ```sql

  CREATE TABLE review ( … );

  CREATE INDEX idx_review_property ON review(property_id);

  ```  

  - Guests rate properties 1–5 and leave comments.

- **Message Table**  

  ```sql

  CREATE TABLE message ( … );

  CREATE INDEX idx_message_sender ON message(sender_id);

  ```  

  - Users send messages to each other; separate indexes for sender/recipient.

---

## 🔍 Schema Highlights & Learning Points

- **UUID Primary Keys**  

  Universally unique, avoid collision in distributed environments.

- **Foreign Keys & CASCADE Rules**  

  Keep relationships strong and automatically clean up child rows when parents are removed.

- **CHECK Constraints**  

  Enforce data validity at the database level (e.g., rating between 1 and 5).

- **Timestamps & Defaults**  

  Capture creation times automatically with `DEFAULT NOW()`.

- **Indexes**  

  Speed up lookups on frequently queried columns (email, foreign keys).

---

## 🤝 Contributing

1. Fork this repo  

2. Create a branch: `feature/your-change`  

3. Make your updates (add comments, optimize indexes, etc.)  

4. Open a Pull Request with an explanation of your changes  

---




# Seed Data for Airbnb-Like Database

This directory contains `seed.sql`, a script that populates your PostgreSQL schema with realistic sample data.

## Contents

- **seed.sql** — SQL `INSERT` statements for:

  - Users (hosts & guests)

  - Locations

  - Properties

  - Bookings

  - Payments

  - Reviews

  - Messages

## Prerequisites

1. A running PostgreSQL database named `airbnb_db` (or your chosen name).

2. The schema applied (`extensions.sql` & `schema.sql` from previous steps).

3. The `uuid-ossp` extension enabled:

   ```bash

   psql -d airbnb_db -f extensions.sql

 \
## Running the Seed Script

From the repository root:

Bash

```

psql -d airbnb_db -f database-script-0x02/seed.sql

```

### This will insert sample users, properties, bookings, payments, reviews, and messages.

## Verifying the Data

After running, you can check the inserted rows:

```

sql

SELECT * FROM users;

SELECT * FROM location;

SELECT * FROM property;

SELECT * FROM booking;

SELECT * FROM payment;

SELECT * FROM review;

SELECT * FROM message;

```

***Each table should display multiple rows reflecting hosts, guests, and realistic interactions on the platform.***

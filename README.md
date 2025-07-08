
# alx-airbnb-database

A complete PostgreSQL schema, scripts, and performance tuning for an Airbnb-style application. This repo is organized into logical sections—from ERD to schema design, seeding, normalization, advanced queries, and ongoing performance monitoring. This is part of the ALX ProDev programme

---

## 🔗 Repository Structure

- **[ERD](./ERD/)**  
  Contains the draw.io file representing the Entity–Relationship Diagram for our Airbnb clone.

- **[database-script-0x01](./database-script-0x01/)**  
  Initial schema definition:  
  - `extensions.sql`  
  - `schema.sql`  
  - `README.md` (describes the tables, columns, constraints, and indexes)

- **[database-script-0x02](./database-script-0x02/)**  
  Seed data for development/testing:  
  - `seed.sql` (inserts realistic sample users, properties, bookings, payments, reviews, and messages)  
  - `README.md` (instructions on running the seed script)

- **[normalization.md](./normalization.md)**  
  Explanation of applying normalization principles (up to 3NF), identifying redundancies, and refactoring the schema.

- **[database-adv-script](./database-adv-script/)**  
  Advanced SQL and performance tuning:  
  - Query examples for joins, subqueries, aggregations, window functions  
  - `database_index.sql` (index creation)  
  - `performance.sql`, `partitioning.sql` (complex query refactors, table partitioning)  
  - `performance_monitoring.md`, `partition_performance.md`, and `optimization_report.md`  

- **README.md**  
  (You are here) Overview and navigation for the entire repository.

---

## 🚀 Getting Started

1. **Clone the repo**  
   ```bash
   git clone https://github.com/yourusername/alx-airbnb-database.git
   cd alx-airbnb-database
   ```

2. **Apply schema**  
   ```bash
   psql -d airbnb_db -f database-script-0x01/extensions.sql
   psql -d airbnb_db -f database-script-0x01/schema.sql
   ```

3. **Seed sample data**  
   ```bash
   psql -d airbnb_db -f database-script-0x02/seed.sql
   ```

4. **Explore advanced scripts**  
   ```bash
   psql -d airbnb_db -f database-adv-script/joins_queries.sql
   psql -d airbnb_db -f database-adv-script/subqueries.sql
   psql -d airbnb_db -f database-adv-script/aggregations_and_window_functions.sql
   psql -d airbnb_db -f database-adv-script/database_index.sql
   psql -d airbnb_db -f database-adv-script/performance.sql
   psql -d airbnb_db -f database-adv-script/partitioning.sql
   ```

5. **Read the reports**  
   - [`normalization.md`](./normalization.md)  
   - [`database-adv-script/optimization_report.md`](./database-adv-script/optimization_report.md)  
   - [`database-adv-script/partition_performance.md`](./database-adv-script/partition_performance.md)  
   - [`database-adv-script/performance_monitoring.md`](./database-adv-script/performance_monitoring.md)  

---

## 📚 Learning Outcomes

- Designing a normalized 3NF database schema  
- Generating and seeding realistic sample data  
- Writing and optimizing complex SQL queries (joins, subqueries, window functions)  
- Implementing indexes and table partitioning  
- Continuously monitoring and refining performance with `EXPLAIN ANALYZE`

---

## 🤝 Contributing

Contributions, issues, and improvements are welcome. Feel free to open a pull request or issue.


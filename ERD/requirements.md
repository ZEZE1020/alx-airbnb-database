

Airbnb Database Specification

Overview

This document outlines the database schema for an Airbnb-like platform, detailing entities, attributes, relationships, and best practices for documentation. The schema supports core functionalities such as user management, property listings, bookings, payments, reviews, and messaging. It is designed to ensure data integrity, scalability, and clarity for all stakeholders, including developers, database administrators, and analysts.

Entities and Attributes

User

Represents a platform user, who can be a guest, host, or admin.

user_id: UUID, Primary Key, Indexed

first_name: VARCHAR(50), NOT NULL

last_name: VARCHAR(50), NOT NULL

email: VARCHAR(100), UNIQUE, NOT NULL

password_hash: VARCHAR(255), NOT NULL

phone_number: VARCHAR(20), NULL

role: ENUM('guest', 'host', 'admin'), NOT NULL

created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Property

Represents a property listed on the platform, owned by a host.

property_id: UUID, Primary Key, Indexed

host_id: UUID, Foreign Key (references User.user_id), NOT NULL

name: VARCHAR(100), NOT NULL

description: TEXT, NOT NULL

location: VARCHAR(255), NOT NULL

price_per_night: DECIMAL(10,2), NOT NULL

created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

updated_at: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

Booking

Represents a reservation made by a guest for a property.

booking_id: UUID, Primary Key, Indexed

property_id: UUID, Foreign Key (references Property.property_id), NOT NULL

user_id: UUID, Foreign Key (references User.user_id), NOT NULL

start_date: DATE, NOT NULL

end_date: DATE, NOT NULL

total_price: DECIMAL(10,2), NOT NULL

status: ENUM('pending', 'confirmed', 'canceled'), NOT NULL

created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Payment

Represents a payment associated with a booking.

payment_id: UUID, Primary Key, Indexed

booking_id: UUID, Foreign Key (references Booking.booking_id), NOT NULL

amount: DECIMAL(10,2), NOT NULL

payment_date: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

payment_method: ENUM('credit_card', 'paypal', 'stripe'), NOT NULL

Review

Represents a review written by a guest for a property.

review_id: UUID, Primary Key, Indexed

property_id: UUID, Foreign Key (references Property.property_id), NOT NULL

user_id: UUID, Foreign Key (references User.user_id), NOT NULL

rating: INTEGER, CHECK (rating >= 1 AND rating &lt;= 5), NOT NULL

comment: TEXT, NOT NULL

created_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Message

Represents a message exchanged between users.

message_id: UUID, Primary Key, Indexed

sender_id: UUID, Foreign Key (references User.user_id), NOT NULL

recipient_id: UUID, Foreign Key (references User.user_id), NOT NULL

message_body: TEXT, NOT NULL

sent_at: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

Relationships

The following relationships define the interactions between entities:

User to Property (One-to-Many):

A User (role: 'host') can own multiple Properties.

Each Property is owned by exactly one User (via host_id).

User to Booking (One-to-Many):

A User (role: 'guest') can make multiple Bookings.

Each Booking is associated with exactly one User (via user_id).

Property to Booking (One-to-Many):

A Property can have multiple Bookings.

Each Booking is associated with exactly one Property (via property_id).

Booking to Payment (One-to-Many):

A Booking can have multiple Payments (e.g., partial or installment payments).

Each Payment is associated with exactly one Booking (via booking_id).

User to Review (One-to-Many):

A User (role: 'guest') can write multiple Reviews.

Each Review is written by exactly one User (via user_id).

Property to Review (One-to-Many):

A Property can have multiple Reviews.

Each Review is associated with exactly one Property (via property_id).

User to Message (Sender, One-to-Many):

A User can send multiple Messages.

Each Message has exactly one sender (via sender_id).

User to Message (Recipient, One-to-Many):

A User can receive multiple Messages.

Each Message has exactly one recipient (via recipient_id).

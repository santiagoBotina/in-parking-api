# InParking API Documentation
## Overview
InParking API is a RESTful service designed to manage parking lots and parking spaces efficiently. Built using Ruby on Rails, AWS, and PostgreSQL, it serves as the backend for both the InParking web UI and mobile applications.

## Features

- User Authentication: Secure login and registration for users.
- Parking Lot Management: Create, read, update, and delete parking lots.
- Parking Space Management: Manage individual parking spaces within lots.
- Booking System: Reserve and manage bookings for parking spaces.
- Payment Integration: Process payments for parking reservations.

## Getting Started
### Prerequisites
- Docker: Ensure Docker is installed on your machine. Download Docker
- Ruby: Version 3.0.0 or higher.
- Rails: Version 6.1 or higher.
- PostgreSQL: Version 12 or higher.

## Installation
Clone the Repository:

````
git clone https://github.com/santiagoBotina/in-parking-api.git
cd in-parking-api
````

## Install Dependencies:

````
bundle install
````

## Environment Variables
Create a .env file in the root directory and populate it with the variables located at the `.env.example` file.

## Database Setup

1. Run the following command first to start the database:

````
docker-compose --env-file .env up
````

2. Create and Migrate the Database:

````
rails db:create
rails db:migrate
````

3. Seed the Database (optional):

````
rails db:seed
Running the Application
````

## Start the Rails server:

````
rails server
````
The API will be accessible at http://localhost:3000.

## API Endpoints
### Authentication
- Register: POST /api/v1/register
- Login: POST /api/v1/login
- Parking Lots
  - List All Parking Lots: GET /api/v1/parking_lots
  - Create a Parking Lot: POST /api/v1/parking_lots
  - Retrieve a Parking Lot: GET /api/v1/parking_lots/:id
  - Update a Parking Lot: PUT /api/v1/parking_lots/:id
  - Delete a Parking Lot: DELETE /api/v1/parking_lots/:id

## Testing
To run the test suite:

```
bundle exec rspec
```
